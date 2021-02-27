# SagaStencilRenderer
A renderer for [Saga](https://github.com/loopwerk/Saga) that uses [Stencil](https://github.com/stencilproject/Stencil) to turn a RenderingContext into a String.

It comes with a free function named `stencil` which takes an HTML template and a Stencil `Environment`, and returns a function that goes from `RenderingContext` to `String`, which can then be plugged into Saga's writers.

## Example
Package.swift

``` swift
// swift-tools-version:5.2

import PackageDescription

let package = Package(
  name: "Example",
  platforms: [
    .macOS(.v10_15)
  ],
  dependencies: [
    .package(url: "https://github.com/loopwerk/Saga", from: "0.19.0"),
    .package(url: "https://github.com/loopwerk/SagaParsleyMarkdownReader", from: "0.4.0"),
    .package(url: "https://github.com/loopwerk/SagaStencilRenderer", from: "0.1.0")
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

let saga = try Saga(input: "content", siteMetadata: EmptyMetadata())

try saga.register(
    metadata: EmptyMetadata.self,
    readers: [.parsleyMarkdownReader()],
    itemWriteMode: .keepAsFile,
    writers: [
      .itemWriter(stencil("page.html", environment: getEnvironment(root: saga.rootPath)))
    ]
  )
  .run()
  .staticFiles()

func getEnvironment(root: Path) -> Environment {
  Environment(loader: FileSystemLoader(paths: [root + "templates"]))
}
```

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