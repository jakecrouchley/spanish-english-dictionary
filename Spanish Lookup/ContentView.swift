//
//  ContentView.swift
//  Spanish Lookup
//
//  Created by Jake Crouchley on 05/05/2023.
//

import SwiftUI

struct ContentView: View {
//    @FetchRequest(sortDescriptors: [SortDescriptor(\.source_word)]) var words: FetchedResults<Word>
    
    @SectionedFetchRequest(
        sectionIdentifier: \.first_char,
        sortDescriptors: [SortDescriptor(\.first_char), SortDescriptor(\.source_word)],
        animation: .default)
    private var words: SectionedFetchResults<String?, Word>
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var searchTerm: String = ""
    @FocusState private var searchFieldIsFocused: Bool
    
    var searchQuery: Binding<String> {
      Binding {
        // 1
        searchTerm
      } set: { newValue in
        // 2
        searchTerm = newValue
        
        // 3
        guard !newValue.isEmpty else {
          words.nsPredicate = nil
          return
        }

        // 4
        words.nsPredicate = NSPredicate(
          format: "source_word contains[cd] %@",
          newValue)
      }
    }


    var body: some View {
        NavigationStack {
            List(words) { section in
                Section(header: Text(section.id ?? "")) {
                    ForEach(section) {word in
                        WordRow(word: word)
                    }
                }
            }
            .listStyle(.plain)
        }.searchable(text: searchQuery, placement: .navigationBarDrawer(displayMode: .always))
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
    }
}

struct WordRow: View {
    var word: Word

    var body: some View {
        NavigationLink {
            WordDetailView(word: word)
        } label: {
            HStack {
                Image(word.source_lang == "en" ? "en_flag" : "es_flag").resizable()
                    .frame(
                        width: 32,
                        height: 32,
                        alignment: .topLeading
                    )
                VStack(alignment: .leading, spacing: 3) {
                    Text(word.source_word ?? "")
                        .foregroundColor(.primary)
                        .font(.headline)
                    Text(word.definition ?? "")
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                        .lineLimit(1)
                    Text(word.details ?? "")
                        .foregroundColor(.secondary)
                        .font(.subheadline.italic())
                        .lineLimit(1)
                }
            }
        }
    }
}

struct WordDetailView: View {
    var word: Word
    
    var body: some View {
        HStack (alignment: .top) {
            VStack(alignment: .leading) {
                Text(word.definition ?? "")
                    .font(.subheadline)
                Text(word.details ?? "")
                    .font(.subheadline.italic())
                Spacer()
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .navigationTitle(word.source_word ?? "")
    }
}
