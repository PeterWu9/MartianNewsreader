// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

struct Article: Codable, Identifiable, Hashable {
    static func == (lhs: Article, rhs: Article) -> Bool {
        lhs.id == rhs.id
    }
    
    // TODO: Investigate ways to create stable identity out of server object without inherent IDs
    var id: String {
        title + body
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
    
    let title: String
    let images: [ArticleImage]
    let body: String
}

// MARK: - Image
struct ArticleImage: Codable {
    let topImage: Bool
    let url: String
    let width, height: Int

    enum CodingKeys: String, CodingKey {
        case topImage = "top_image"
        case url, width, height
    }
}

typealias Articles = [Article]
