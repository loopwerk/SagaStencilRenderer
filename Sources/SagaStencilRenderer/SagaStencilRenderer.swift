import Saga
import Stencil

nonisolated(unsafe) public var defaultStencilEnvironment: Environment?

public func stencil(_ template: String, environment: Environment? = nil) -> (@Sendable (DictRenderingContext) throws -> String) {
  nonisolated(unsafe) let environment = environment ?? defaultStencilEnvironment
  return { @Sendable context in
    guard let environment else {
      fatalError("No Stencil Environment provided. Either pass one to stencil() or set defaultStencilEnvironment first.")
    }
    return try environment.renderTemplate(name: template, context: context.asDictionary())
  }
}
