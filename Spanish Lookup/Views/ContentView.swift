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
    
    @State private var selectedPage: SelectedPage = SelectedPage.dictionary
    
    @State private var searchTerm = ""
    
    var body: some View {
        NavigationStack {
            Picker("Selected Page", selection: $selectedPage) {
                Text("Dictionary").tag(SelectedPage.dictionary)
                Text("Conjugations").tag(SelectedPage.conjugations)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 20)
            if (selectedPage == .dictionary) {
                WordListView()
            } else {
                ConjugationListView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, WordsProvider.preview.container.viewContext)
    }
}
