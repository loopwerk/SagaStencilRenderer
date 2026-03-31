import Saga
import Stencil

nonisolated(unsafe) public var defaultStencilEnvironment = Environment()

public func stencil(_ template: String, environment: Environment? = nil) -> (@Sendable (DictRenderingContext) throws -> String) {
  nonisolated(unsafe) let environment = environment
  return { @Sendable context in
    let env = environment ?? defaultStencilEnvironment
    return try env.renderTemplate(name: template, context: context.asDictionary())
  }
}
