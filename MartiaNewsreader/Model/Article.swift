// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

struct Article: Codable {
    let title: String
    let images: [ArticleImage]
    let body: String
}

extension Article: Identifiable, Hashable {
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
}

extension Article {
    var topImage: ArticleImage? {
        images.first { $0.topImage }
    }
}

extension Article {
    static var sample: Article {
        .init(title: "Curiosity turns 100 today", images: [ArticleImage.sample], body: "The NASA Mars rover that was successfully dispatched to Mars in 2012 has turned 100 today.  Curiosity's mission was to explore Martian climate and geology, and to determine if Mars could ever support life.  Curiosity was the first rover to make the significant discovery of...")
    }
}

// MARK: - Image
struct ArticleImage: Codable {
    let topImage: Bool
    let urlString: String
    let width, height: Int

    enum CodingKeys: String, CodingKey {
        case topImage = "top_image"
        case urlString = "url"
        case width, height
    }
}

extension ArticleImage {
    static var sample: ArticleImage {
        .init(topImage: true, urlString: "https://s1.nyt.com/ios-newsreader/candidates/images/img2.jpg", width: 450, height: 284)
    }
    
    var url: URL? {
        URL(string: urlString)
    }
}

typealias Articles = [Article]
