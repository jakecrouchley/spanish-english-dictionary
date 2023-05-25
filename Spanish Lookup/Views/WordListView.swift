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
    
    @State var searchTerm: String = ""
    
    @State private var topResult: Word?
    
    let nsSortDescriptors = [NSSortDescriptor(key: "first_char", ascending: true), NSSortDescriptor(key: "source_word", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))]
    
    init() {
        let request: NSFetchRequest<Word> = Word.fetchRequest()
        request.predicate = nil
        request.sortDescriptors = nsSortDescriptors
        _words = SectionedFetchRequest(fetchRequest: request, sectionIdentifier: \.first_char)
    }
    
    func resetSearch(callback: (() -> ())? = nil) {
        if (searchTerm != "") {
            searchTerm = ""
        }
        let config = words
        config.nsSortDescriptors = nsSortDescriptors
        config.nsPredicate = nil
        callback?()
    }
    
    func beginsWithSearch(searchTerm: String) {
        let config = words
        config.nsSortDescriptors = [NSSortDescriptor(key: "source_word", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))]
        config.nsPredicate = NSPredicate(format: "source_word BEGINSWITH[cd] %@", searchTerm)
        topResult = config.first?.first
    }

    var body: some View {
        ScrollViewReader { scrollViewReader in
            VStack {
                List(words) { section in
                    Section(header: Text(section.id ?? "")) {
                        ForEach(section, id: \.id) {word in
                            WordRow(word: word)
                        }
                    }
                }
                .listStyle(.plain)
                .padding(.zero)
                .id(UUID())
                .onChange(of: searchTerm) { newValue in
                    if (searchTerm == "") {
                        resetSearch()
                    } else {
                        beginsWithSearch(searchTerm: searchTerm)
                    }
                }
                .searchable(text: $searchTerm, placement: .navigationBarDrawer(displayMode: .always))
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .padding(.zero)
            }
            VStack {
                if (words.count == 0) {
                    List {
                        Text("No matching words found")
                    }
                }
            }
            .layoutPriority(.infinity)
        }
    }
}

struct WordListView_Previews: PreviewProvider {
    static var previews: some View {
        WordListView().environment(\.managedObjectContext, WordsProvider.preview.container.viewContext)
    }
}
