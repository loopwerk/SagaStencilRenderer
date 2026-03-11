// swift-tools-version:6.0

import PackageDescription

let package = Package(
  name: "Example",
  platforms: [
    .macOS(.v14),
  ],
  dependencies: [
    .package(path: "../"),
    .package(url: "https://github.com/loopwerk/Saga", from: "2.21.0"),
    .package(url: "https://github.com/loopwerk/SagaParsleyMarkdownReader", from: "1.0.0"),
  ],
  targets: [
    .executableTarget(
      name: "Example",
      dependencies: [
        "Saga",
        "SagaParsleyMarkdownReader",
        "SagaStencilRenderer",
      ]
    ),
  ]
)
