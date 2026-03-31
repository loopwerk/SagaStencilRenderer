// swift-tools-version:6.0

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
    .package(url: "https://github.com/loopwerk/Saga", from: "3.1.0"),
    .package(url: "https://github.com/stencilproject/Stencil", from: "0.14.0"),
  ],
  targets: [
    .target(
      name: "SagaStencilRenderer",
      dependencies: ["Saga", "Stencil"]
    ),
  ]
)
