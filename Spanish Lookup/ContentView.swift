//
//  ContentView.swift
//  Spanish Lookup
//
//  Created by Jake Crouchley on 05/05/2023.
//

import SwiftUI

struct ContentView: View {
    @FetchRequest(sortDescriptors: []) var words: FetchedResults<Word>
    @Environment(\.managedObjectContext) var managedObjectContext

    var body: some View {
        VStack {
            List(words) { word in
                Text(word.source_word ?? "Unknown")
            }
            Button("Add") {
                let word = Word(context: managedObjectContext)
                word.source_word = "Abandonar"
                try? managedObjectContext.save()
            }
            Button("Clear") {
                managedObjectContext.delete(words[0])
                try? managedObjectContext.save()
            }
        }
    }
}
