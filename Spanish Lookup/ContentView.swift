//
//  ContentView.swift
//  Spanish Lookup
//
//  Created by Jake Crouchley on 05/05/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext: NSManagedObjectContext
    
    @FocusState private var searchFieldIsFocused: Bool
    
    @State private var searchQuery: String = ""
    @StateObject var wordFetchController = WordFetchController.shared

    var body: some View {
        NavigationStack {
            FilteredWordList()
        }.searchable(text: $wordFetchController.searchText, placement: .navigationBarDrawer(displayMode: .always))
            .textInputAutocapitalization(.never)
            .padding(.zero)
            .onChange(of: wordFetchController.searchText) { newValue in
                wordFetchController.performFetch()
            }
            
    }
}
