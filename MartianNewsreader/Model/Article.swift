import Foundation

struct Article: Codable, Hashable, Identifiable {
    let title: String
    let images: [ArticleImage]
    let body: String
    var isBookmarked = false
    
    // In the absence of a server/database-generated ID, an article's identity is determined by its title and top image's URL
    var id: String {
        title + (topImage?.urlString ?? "")
    }
    
    private enum CodingKeys : String, CodingKey {
        case title, images, body
    }
}

// MARK: Convenience Accessor/Sample
extension Article {
    var topImage: ArticleImage? {
        images.first { $0.topImage }
    }
}

extension Article {
    static var sample: Article {
        .init(
            title: "Curiosity turns 100 today",
            images: [ArticleImage.sample],
            body: """
                    The NASA Mars rover that was successfully dispatched to Mars in 2012 has turned 100 today.
                    Curiosity's mission was to explore Martian climate and geology, and to determine if Mars could ever support life.
                    Curiosity was the first rover to make the significant discovery of
                  """
        )
    }
}


// MARK: - Image
struct ArticleImage: Codable, Hashable, Identifiable {
    let topImage: Bool
    let urlString: String
    let width, height: Int
    
    var id: String {
        "\(width) + \(height)" + urlString
    }
    
    enum CodingKeys: String, CodingKey {
        case topImage = "top_image"
        case urlString = "url"
        case width, height
    }
}

extension ArticleImage {
    static var sample: ArticleImage {
        .init(
            topImage: true,
            urlString: "https://s1.nyt.com/ios-newsreader/candidates/images/img3.jpg",
            width: 480,
            height: 262
        )
    }
    
    var url: URL? {
        URL(string: urlString)
    }
}

