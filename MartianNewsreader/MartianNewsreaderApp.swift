//
//  MartianNewsreaderApp.swift
//  MartianNewsreader
//
//  Created by Peter Wu on 6/25/22.
//

import SwiftUI

@main
struct MartianNewsreaderApp: App {
    @StateObject var newsFetcher = ArticleSource()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(newsFetcher)
        }
    }
}
