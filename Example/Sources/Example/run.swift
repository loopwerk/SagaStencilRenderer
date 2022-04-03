import Foundation
import Saga
import PathKit
import SagaParsleyMarkdownReader
import SagaStencilRenderer
import Stencil

// SiteMetadata is given to every template.
// You can put whatever you want in here, as long as it's Decodable.
struct SiteMetadata: Metadata {
  let url: URL
  let name: String
}

let siteMetadata = SiteMetadata(
  url: URL(string: "http://www.example.com")!,
  name: "Example website"
)

@main
struct Run {
  static func main() async throws {
    let saga = try Saga(input: "content", output: "deploy", siteMetadata: siteMetadata)

    try await saga
      // All the Markdown files will be parsed to html,
      // using the default EmptyMetadata as the Item's metadata type.
      .register(
        metadata: EmptyMetadata.self,
        readers: [.parsleyMarkdownReader()],
        itemWriteMode: .keepAsFile,
        writers: [
          .itemWriter(stencil("page.html", environment: getEnvironment(root: saga.rootPath)))
        ]
      )

      // Run the steps we registered above
      .run()

      // All the remaining files that were not parsed to markdown, so for example images, raw html files and css,
      // are copied as-is to the output folder.
      .staticFiles()
  }
}

func getEnvironment(root: Path) -> Environment {
  Environment(loader: FileSystemLoader(paths: [root + "templates"]))
}
