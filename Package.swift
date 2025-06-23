// swift-tools-version:5.5

import PackageDescription

let package = Package(
  name: "SagaStencilRenderer",
  platforms: [
    .macOS(.v12),
  ],
  products: [
    .library(
      name: "SagaStencilRenderer",
      targets: ["SagaStencilRenderer"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/loopwerk/Saga", from: "2.0.3"),
    .package(url: "https://github.com/stencilproject/Stencil", from: "0.14.0"),
  ],
  targets: [
    .target(
      name: "SagaStencilRenderer",
      dependencies: ["Saga", "Stencil"]
    ),
  ]
)
