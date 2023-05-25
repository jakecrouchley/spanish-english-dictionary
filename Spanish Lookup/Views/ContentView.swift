//
//  ContentView.swift
//  Spanish Lookup
//
//  Created by Jake Crouchley on 05/05/2023.
//

import SwiftUI
import CoreData

enum SelectedPage: String {
    case dictionary, conjugations
}

struct ContentView: View {
    @State private var isLoading = true
    
    var body: some View {
        NavigationStack {
            if (isLoading) {
                LoadingView()
            } else {
                PrimaryView()
            }
        }
        .task {
            let userHasInitialised = UserDefaults.standard.bool(forKey: "hasInitialised")
            print("User has initialised: \(userHasInitialised)")
            if (!userHasInitialised) {
                isLoading = true
                let start = Date()
                WordsProvider.shared.loadWords()
                let end = Date()
                print("took \(end.timeIntervalSince(start))")
                UserDefaults.standard.set(true, forKey: "hasInitialised")
            }
            isLoading = false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, WordsProvider.preview.container.viewContext)
    }
}
