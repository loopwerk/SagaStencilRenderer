// swift-tools-version:5.5

import PackageDescription

let package = Package(
  name: "Example",
  platforms: [
    .macOS(.v12),
  ],
  dependencies: [
    .package(path: "../"),
    .package(name: "Saga", url: "https://github.com/loopwerk/Saga.git", from: "2.0.3"),
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
