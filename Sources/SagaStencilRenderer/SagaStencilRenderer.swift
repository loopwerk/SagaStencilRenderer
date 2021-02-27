import Stencil
import Saga

public func stencil(_ template: String, environment: Environment) -> ((RenderingContext) throws -> String) {
  return { context in
    return try environment.renderTemplate(name: template, context: context.asDictionary())
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
      "siteMetadata": siteMetadata,
    ]
  }
}

extension ItemsRenderingContext: RenderingContext {
  public func asDictionary() -> [String: Any] {
    return [
      "items": items,
      "allItems": allItems,
      "siteMetadata": siteMetadata,
      "paginator": paginator as Any,
    ]
  }
}

extension PartitionedRenderingContext: RenderingContext {
  public func asDictionary() -> [String: Any] {
    return [
      "key": key,
      "items": items,
      "allItems": allItems,
      "siteMetadata": siteMetadata,
      "paginator": paginator as Any,
    ]
  }
}
