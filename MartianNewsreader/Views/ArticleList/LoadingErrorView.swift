//
//  LoadingErrorView.swift
//  MartianNewsreader
//
//  Created by Peter Wu on 6/29/22.
//

import SwiftUI

struct LoadingErrorView: View {
    let error: Error
    
    var body: some View {
        Text("Unable to complete loading operation due to the following error: \(error.localizedDescription)")
    }
}

struct LoadingErrorView_Previews: PreviewProvider {
    static let error = NSError(domain: "Error loading view", code: 0)
    static var previews: some View {
        LoadingErrorView(error: error)
    }
}
