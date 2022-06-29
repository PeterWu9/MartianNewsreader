//
//  ArticlesService.swift
//  MartiaNewsreader
//
//  Created by Peter Wu on 6/28/22.
//

import Foundation

final class ArticleService: ArticleServiceProvider {
    static let baseURLString = "https://s1.nyt.com/ios-newsreader/candidates/test/articles.json"
    
    private let networkManager = NetworkManager.shared

    func fetchArticles() async throws -> Articles {
        // Create network request
        let url = URL(string: Self.baseURLString)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethods.get.description
        
        // Make network request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard
            let statusCode = (response as? HTTPURLResponse)?.statusCode,
            (200..<300).contains(statusCode)
        else {
            throw NetworkError.invalidNetworkResponse
        }
        
        // Decode network data
        let articles = try decoder.decode(Articles.self, from: data)
        return articles
    }
    
    
        
    // TODO:  Refactor to Network Manager layer
    private let decoder = JSONDecoder()

    enum HTTPMethods: String {
        case get
        var description: String {
            return self.rawValue.uppercased()
        }
    }
}
