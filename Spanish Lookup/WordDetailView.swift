//
//  WordDetailView.swift
//  Spanish Lookup
//
//  Created by Jake Crouchley on 12/05/2023.
//

import SwiftUI

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
