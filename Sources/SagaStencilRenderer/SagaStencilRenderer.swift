import Saga
import Stencil

public var defaultStencilEnvironment = Environment()

public func stencil(_ template: String, environment: Environment? = nil) -> ((RenderingContext) throws -> String) {
  return { context in
    let env = environment ?? defaultStencilEnvironment
    return try env.renderTemplate(name: template, context: context.asDictionary())
  }
}

// Since Stencil expects to be given an [String: Any] dictionary instead of a proper object,
// we're adding an `asDictionary` method to Saga's three rendering contexts.
public protocol RenderingContext {
  func asDictionary() -> [String: Any]
}

extension ItemRenderingContext: RenderingContext {
  public func asDictionary() -> [String: Any] {
    return [
      "item": item,
      "items": items,
      "allItems": allItems,
    ]
  }
}

extension ItemsRenderingContext: RenderingContext {
  public func asDictionary() -> [String: Any] {
    return [
      "items": items,
      "allItems": allItems,
      "paginator": paginator as Any,
      "outputPath": outputPath,
    ]
  }
}

extension PartitionedRenderingContext: RenderingContext {
  public func asDictionary() -> [String: Any] {
    return [
      "key": key,
      "items": items,
      "allItems": allItems,
      "paginator": paginator as Any,
      "outputPath": outputPath,
    ]
  }
}
