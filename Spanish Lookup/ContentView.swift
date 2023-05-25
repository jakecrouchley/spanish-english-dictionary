//
//  ContentView.swift
//  Spanish Lookup
//
//  Created by Jake Crouchley on 05/05/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @SectionedFetchRequest
    private var words: SectionedFetchResults<String?, Word>

    @Environment(\.managedObjectContext) var managedObjectContext: NSManagedObjectContext
    
    @State private var searchTerm: String = ""
    @FocusState private var searchFieldIsFocused: Bool
    
    let nsSortDescriptors = [NSSortDescriptor(key: "first_char", ascending: true), NSSortDescriptor(key: "source_word", ascending: true)]
    
    var searchQuery: Binding<String> {
        Binding {
            searchTerm
        } set: { newValue in
            searchTerm = newValue

            guard !newValue.isEmpty else {
                let config = words
                config.nsPredicate = nil
                config.nsSortDescriptors = nsSortDescriptors
                return
            }
            
            let config = words
            config.nsPredicate = NSPredicate(
            format: "source_word contains[cd] %@",
            newValue)
            config.sortDescriptors = [SortDescriptor(\.source_word, order: .reverse)]
        }
    }
    
    init() {
        let request: NSFetchRequest<Word> = Word.fetchRequest()
        request.sortDescriptors = nsSortDescriptors
        request.fetchLimit = 10
        _words = SectionedFetchRequest(fetchRequest: request, sectionIdentifier: \.first_char)
    }


    var body: some View {
        NavigationStack {
            List(words) { section in
                Section(header: Text(section.id ?? "")) {
                    ForEach(section) {word in
                        WordRow(word: word).onAppear(perform: {
                            print("\(word.source_word ?? "") appeared")
                        })
                    }
                }
            }
            .listStyle(.plain)
            .padding(.zero)
        }.searchable(text: searchQuery, placement: .navigationBarDrawer(displayMode: .always))
            .textInputAutocapitalization(.never)
            .padding(.zero)
            
    }
}