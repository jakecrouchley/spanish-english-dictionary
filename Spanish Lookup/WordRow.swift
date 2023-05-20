//
//  WordRow.swift
//  Spanish Lookup
//
//  Created by Jake Crouchley on 12/05/2023.
//

import SwiftUI

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

//struct WordRow_Previews: PreviewProvider {
////    let word = DataController.shared.
//    
//    static var previews: some View {
//        WordRow(word: nil)
//    }
//}

