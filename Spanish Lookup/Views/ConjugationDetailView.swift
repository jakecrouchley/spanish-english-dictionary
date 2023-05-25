//
//  ConjugationDetailView.swift
//  Spanish Lookup
//
//  Created by Jake Crouchley on 21/05/2023.
//

import SwiftUI
import CoreData

struct ConjugationDetailView: View {
    
    @StateObject var conjugationGroup: ConjugationGroup
    
    var body: some View {
        VStack {
            Text(conjugationGroup.infinitive_english ?? "")
                .font(.subheadline)
                .padding(.horizontal, 8)
                .padding(.top, 8)
            List {
                ForEach(conjugationGroup.conjugationsArray, id: \.self) {mood in
                    ForEach(mood, id: \.self) { tense in
                        Section(content: {
                            ForEach(tense, id: \.self) { conjugation in
                                HStack {
                                    Text(conjugation.conjugation != "" ? conjugation.conjugation ?? "-" : "-")
                                }
                            }
                        }, header: {
                            HStack {
                                Text("\(tense[0].tense!)")
                                Spacer()
                                Text("\(mood[0][0].mood!)")
                            }
                            .frame(maxWidth: .infinity)
                        })
                    }
                }
            }
        }
        .navigationTitle(Text(conjugationGroup.infinitive ?? ""))
    }
}

struct ConjugationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ConjugationDetailView(conjugationGroup: ConjugationGroup.example)
    }
}

extension ConjugationGroup {
    static let example: ConjugationGroup = {
        let context = WordsProvider.shared.container.viewContext
        let request: NSFetchRequest<ConjugationGroup> = ConjugationGroup.fetchRequest()
        let results = try? context.fetch(request)
        return (results?.first!)!
    }()
}
