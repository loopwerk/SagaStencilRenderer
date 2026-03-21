// swift-tools-version:5.10

import PackageDescription

let package = Package(
  name: "SagaStencilRenderer",
  platforms: [
    .macOS(.v14),
  ],
  products: [
    .library(
      name: "SagaStencilRenderer",
      targets: ["SagaStencilRenderer"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/loopwerk/Saga", "2.0.3"..<"4.0.0"),
    .package(url: "https://github.com/stencilproject/Stencil", from: "0.14.0"),
  ],
  targets: [
    .target(
      name: "SagaStencilRenderer",
      dependencies: ["Saga", "Stencil"]
    ),
  ]
)
