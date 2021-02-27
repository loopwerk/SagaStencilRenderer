// swift-tools-version:5.2

import PackageDescription

let package = Package(
  name: "SagaStencilRenderer",
  products: [
    .library(
      name: "SagaStencilRenderer",
      targets: ["SagaStencilRenderer"]),
  ],
  dependencies: [
    .package(url: "https://github.com/loopwerk/PathKit", from: "1.1.0"),
    .package(url: "https://github.com/loopwerk/Saga", from: "0.18.0"),
    .package(url: "https://github.com/stencilproject/Stencil", from: "0.14.0"),
  ],
  targets: [
    .target(
      name: "SagaStencilRenderer",
      dependencies: ["PathKit", "Saga", "Stencil"]
    ),
  ]
)
