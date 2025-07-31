import Foundation
import PathKit
import Saga
import SagaParsleyMarkdownReader
import SagaStencilRenderer
import Stencil

struct AppMetadata: Metadata {
  let url: URL?
  let images: [String]?
}

@main
struct Run {
  static func main() async throws {
    let saga = try Saga(input: "content", output: "deploy")
    defaultStencilEnvironment = Environment(loader: FileSystemLoader(paths: [saga.rootPath + "templates"]))

    try await saga
      // All markdown files within the "apps" subfolder will be parsed to html,
      // using AppMetadata as the Item's metadata type.
      .register(
        folder: "apps",
        metadata: AppMetadata.self,
        readers: [.parsleyMarkdownReader],
        writers: [.listWriter(stencil("apps.html"))]
      )

      // All the Markdown files will be parsed to html,
      // using the default EmptyMetadata as the Item's metadata type.
      .register(
        readers: [.parsleyMarkdownReader],
        writers: [.itemWriter(stencil("page.html"))]
      )

      // Run the steps we registered above
      .run()
      // All the remaining files that were not parsed to markdown, so for example images, raw html files and css,
      // are copied as-is to the output folder.
      .staticFiles()
  }
}
