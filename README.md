# SagaStencilRenderer
A renderer for [Saga](https://github.com/loopwerk/Saga) that uses [Stencil](https://github.com/stencilproject/Stencil) to turn a RenderingContext into a String.

It comes with a free function named `stencil` which takes an HTML template and a Stencil `Environment`, and returns a function that goes from `RenderingContext` to `String`, which can then be plugged into Saga's writers.

## Example
Package.swift

``` swift
// swift-tools-version:5.5

import PackageDescription

let package = Package(
  name: "Example",
  platforms: [
    .macOS(.v12)
  ],
  dependencies: [
    .package(url: "https://github.com/loopwerk/Saga", from: "1.0.0"),
    .package(url: "https://github.com/loopwerk/SagaParsleyMarkdownReader", from: "0.5.0"),
    .package(url: "https://github.com/loopwerk/SagaStencilRenderer", from: "0.4.0")
  ],
  targets: [
    .target(
      name: "Example",
      dependencies: [
        "Saga",
        "SagaParsleyMarkdownReader",
        "SagaStencilRenderer"
      ]
    ),
  ]
)
```

main.swift:

```swift
import Foundation
import Saga
import PathKit
import SagaParsleyMarkdownReader
import SagaStencilRenderer
import Stencil

// SiteMetadata is given to every template.
// You can put whatever you want in here, as long as it's Decodable.
struct SiteMetadata: Metadata {
  let url: URL
  let name: String
}

let siteMetadata = SiteMetadata(
  url: URL(string: "http://www.example.com")!,
  name: "Example website"
)

@main
struct Run {
  static func main() async throws {
    let saga = try Saga(input: "content", output: "deploy", siteMetadata: siteMetadata)

    try await saga
      // All the Markdown files will be parsed to html,
      // using the default EmptyMetadata as the Item's metadata type.
      .register(
        metadata: EmptyMetadata.self,
        readers: [.parsleyMarkdownReader()],
        itemWriteMode: .keepAsFile,
        writers: [
          .itemWriter(stencil("page.html", environment: getEnvironment(root: saga.rootPath)))
        ]
      )

      // Run the steps we registered above
      .run()

      // All the remaining files that were not parsed to markdown, so for example images, raw html files and css,
      // are copied as-is to the output folder.
      .staticFiles()
  }
}

func getEnvironment(root: Path) -> Environment {
  Environment(loader: FileSystemLoader(paths: [root + "templates"]))
}
```

Please check out the [Example app](https://github.com/loopwerk/SagaStencilRenderer/tree/main/Example) to play around.


## Extending the Stencil Environment
You can extend the `Environment` with your own tags and filters, see the [official Stencil docs](https://stencil.fuller.li/en/latest/custom-template-tags-and-filters.html). This is why you need to pass in an `Environment`, instead of SagaStencilRenderer creating one for you.

For example:

```swift
func getEnvironment(root: Path) -> Environment {
  let ext = Extension()
  
  ext.registerFilter("url") { (value: Any?) in
    guard let item = value as? AnyItem else {
      return ""
    }
    var url = "/" + item.relativeDestination.string
    if url.hasSuffix("/index.html") {
      url.removeLast(10)
    }
    return url
  }

  return Environment(loader: FileSystemLoader(paths: [root + "templates"]), extensions: [ext])
}
```
