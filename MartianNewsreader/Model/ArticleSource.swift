//
//  NewsFetcher.swift
//  MartiaNewsreader
//
//  Created by Peter Wu on 6/25/22.
//

import Foundation

// MARK: Dependencies
protocol ArticleProofReader {
    init()
    // Proof reading may be an asynchronous operation (could be services performed over network or a potentially long-running background operation)
    func proofRead(_ article: Article) async throws -> String
}

protocol ArticleServiceProvider {
    func fetchArticles() async throws -> Articles
}

protocol StorageProvider {
    associatedtype Key: Hashable
    associatedtype Value
    typealias Data = [Key: Value]
    func save(_ data: Data)
    func retrieveData(for key: Key)
}

// MARK: ViewModel
@MainActor
final class ArticleSource<
    ProofReader: ArticleProofReader,
    Storage: StorageProvider,
    ArticleService: ArticleServiceProvider
>: ObservableObject, Identifiable {
    
    @Published private(set) var articles: Articles = []
    @Published private(set) var bookmarkedArticles: Articles = []
    @Published private(set) var loadingState: LoadingState = .isLoading

    private let reader: ProofReader
    private let storage: Storage
    private let articleService: ArticleService
    
    enum LoadingState {
        case isLoading
        case completeLoading
        case hasLoadingError(Error)
    }

        
    init(
        reader: ProofReader,
        articleService: ArticleService,
        storage: Storage
    ) {
        self.reader = reader
        self.articleService = articleService
        self.storage = storage
        
        Task {
            do {
                loadingState = .isLoading
                try await fetchArticles()
                loadingState = .completeLoading
            } catch {
                loadingState = .hasLoadingError(error)
            }
        }
    }
        
    func fetchArticles() async throws {
        
        let fetchedArticles = try await articleService.fetchArticles()
        
        articles = try await withThrowingTaskGroup(of: Article.self) { group in
            for article in fetchedArticles {
                group.addTask {
                    // Allows strong self capture because self won't outlive the scope of throwing task group closure
                    try await self.proofRead(article)
                }
            }
            
            return try await group.reduce(into: Articles()) { articles, loadedArticle in
                articles.append(loadedArticle)
            }
        }
        // TODO:  For each article, retrieve from storage and update bookmark data
    }
    
    private func proofRead(_ article: Article) async throws -> Article {
        return try await Article(
            title: article.title,
            images: article.images,
            body: reader.proofRead(article)
        )
    }
}

enum ArticleSourceError: Error, LocalizedError {
    case invalidArticleIndex
}

// MARK: User Actions
extension ArticleSource {
    func bookmarkButtonTapped(_ article: Article) throws {
        guard let index = articles.firstIndex(of: article) else {
            throw ArticleSourceError.invalidArticleIndex
        }
        articles[index].isBookmarked.toggle()
        // TODO: Implement saving bookmarked articles data store (which should be async operation on a database actor
        
        bookmarkedArticles = articles.filter { $0.isBookmarked }
    }
}

