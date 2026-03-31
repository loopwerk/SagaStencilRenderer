# SagaStencilRenderer
A renderer for [Saga](https://github.com/loopwerk/Saga) that uses [Stencil](https://github.com/stencilproject/Stencil) to turn a RenderingContext into a String.

It comes with a free function named `stencil` which takes an HTML template and a Stencil `Environment`, and returns a function that goes from `RenderingContext` to `String`, which can then be plugged into Saga's writers.

## Example
Package.swift

``` swift
// swift-tools-version:6.0

import PackageDescription

let package = Package(
  name: "Example",
  platforms: [
    .macOS(.v14)
  ],
  dependencies: [
    .package(url: "https://github.com/loopwerk/SagaParsleyMarkdownReader", from: "1.0.0"),
    .package(url: "https://github.com/loopwerk/SagaStencilRenderer", from: "1.0.0")
  ],
  targets: [
    .target(
      name: "Example",
      dependencies: [
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
import SagaPathKit
import SagaParsleyMarkdownReader
import SagaStencilRenderer
import Stencil

let saga = try Saga(input: "content", output: "deploy")
defaultStencilEnvironment = Environment(loader: FileSystemLoader(paths: [Path(saga.rootPath.string) + "templates"]))

try await saga
  // All the Markdown files will be parsed to html.
  .register(
    readers: [.parsleyMarkdownReader],
    writers: [
      .itemWriter(stencil("page.html"))
    ]
  )

  // Run the steps we registered above
  .run()
```

Please check out the [Example app](https://github.com/loopwerk/SagaStencilRenderer/tree/main/Example) to play around.


## Extending the Stencil Environment
You can extend the `Environment` with your own tags and filters, see the [official Stencil docs](https://stencil.fuller.li/en/latest/custom-template-tags-and-filters.html).

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
