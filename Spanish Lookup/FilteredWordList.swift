//
//  WordList.swift
//  Spanish Lookup
//
//  Created by Jake Crouchley on 12/05/2023.
//

import SwiftUI
import CoreData

struct FilteredWordList: View {
//    @SectionedFetchRequest
//    private var words: SectionedFetchResults<String?, Word>
//
//    @State var searchTerm: String {
//      didSet {
//          print(searchText)
//          WordFetchController.shared.searchText = searchTerm
//          WordFetchController.shared.performFetch()
//      }
//    }
//    var searchText: Binding<String> {
//        Binding {
//            searchTerm
//        } set: { newValue in
//            searchTerm = newValue
//        }
//    }
//    @Binding var searchQuery: String
    
//    @Binding var searchTerm: String
//
//    @Binding var searchQuery: String
    
    @StateObject var wordFetchController = WordFetchController.shared
    
    @State private var visibleCells: [Word] = []
    
    @State var firstIndex = 0
    @State var lastIndex = 0
    
    
    func cellDidAppear(word: Word, index: Int) {
        print((wordFetchController.words.count - firstIndex))
        if (index > (wordFetchController.words.count - 3)) {
            print("Fetch more after")
            wordFetchController.nextPage()
        }
        if (index < firstIndex + 3) {
            print("Fetch more before")
        }
        // if cell appeared and is less than firstIndex + (lastIndex - firstIndex) / 2
        //  update firstIndex to index
        // if cell appeared and is greater than firstIndex + (lastIndex - firstIndex) / 2
        //  update lastIndex to index
        let halfwayIndex = firstIndex + (lastIndex - firstIndex) / 2
        if (index < halfwayIndex) {
            firstIndex = index
        }
        if (index > halfwayIndex) {
            lastIndex = index
        }
        print("first: \(firstIndex)")
        print("last: \(lastIndex)")
    }
    
    func cellDidDisappear(word: Word, index: Int) {
        // if cell disappeared and is less than firstIndex + (lastIndex - firstIndex) / 2
        //  update firstIndex to index + 1
        // if cell disappeared and is greater than firstIndex + (lastIndex - firstIndex) / 2
        //  update lastIndex to index - 1
        let halfwayIndex = firstIndex + (lastIndex - firstIndex) / 2
        if (index < halfwayIndex) {
            firstIndex = index
        }
        if (index > halfwayIndex) {
            lastIndex = index
        }
        print("first: \(firstIndex)")
        print("last: \(lastIndex)")
    }
    
    var body: some View {
//        List(words) { section in
//            Section(header: Text(section.id ?? "")) {
//                ForEach(section) {word in
//                    WordRow(word: word).onAppear(perform: {
//                        cellDidAppear(word: word)
//                    })
//                }
//            }
//        }
        List {
            ForEach(wordFetchController.words.indices, id: \.self) {index in
                WordRow(word: wordFetchController.words[index])
                    .onAppear(perform: {
                        cellDidAppear(word: wordFetchController.words[index], index: index)
                    })
                    .onDisappear {
                        cellDidDisappear(word: wordFetchController.words[index], index: index)
                    }
            }
        }
        .listStyle(.plain)
        .padding(.zero)
    }
}
