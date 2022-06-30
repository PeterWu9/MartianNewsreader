//
//  MartianNewsreaderApp.swift
//  MartianNewsreader
//
//  Created by Peter Wu on 6/25/22.
//

import SwiftUI

@main
struct MartianNewsreaderApp: App {
    @StateObject var newsFetcher = ArticleSource(
        reader: ProofReader(),
        articleService: ArticleService()
    )
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(newsFetcher)
        }
    }
}
