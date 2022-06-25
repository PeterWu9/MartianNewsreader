//
//  MartiaNewsreaderApp.swift
//  MartiaNewsreader
//
//  Created by Peter Wu on 6/25/22.
//

import SwiftUI

@main
struct MartiaNewsreaderApp: App {
    @StateObject var newsFetcher = NewsFetcher()
    
    var body: some Scene {
        WindowGroup {
            ArticlesListView()
                .environmentObject(newsFetcher)
        }
    }
}
