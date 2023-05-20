//
//  WordListView.swift
//  Spanish Lookup
//
//  Created by Jake Crouchley on 20/05/2023.
//

import SwiftUI
import CoreData

struct WordListView: View {
    @SectionedFetchRequest
    private var words: SectionedFetchResults<String?, Word>
    
    @State private var searchTerm: String = ""
    @FocusState private var searchFieldIsFocused: Bool
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
            config.sortDescriptors = [SortDescriptor(\.source_word, order: .forward)]
        }
    }
    
    let nsSortDescriptors = [NSSortDescriptor(key: "first_char", ascending: true), NSSortDescriptor(key: "source_word", ascending: true)]
    
    init() {
        let request: NSFetchRequest<Word> = Word.fetchRequest()
        request.predicate = nil
        request.sortDescriptors = nsSortDescriptors
//        request.fetchLimit = 10
//        request.includesPropertyValues = false
        request.returnsObjectsAsFaults = false
        _words = SectionedFetchRequest(fetchRequest: request, sectionIdentifier: \.first_char)
    }

    var body: some View {
        List(words) { section in
            Section(header: Text(section.id ?? "")) {
                ForEach(section) {word in
                    WordRow(word: word)
                }
            }
        }
        .listStyle(.plain)
        .padding(.zero)
        .id(UUID())
        .searchable(text: searchQuery, placement: .navigationBarDrawer(displayMode: .always))
            .textInputAutocapitalization(.never)
            .padding(.zero)
    }
}

struct WordListView_Previews: PreviewProvider {
    static var previews: some View {
        WordListView().environment(\.managedObjectContext, WordsProvider.preview.container.viewContext)
    }
}
