//
//  ConjugationRowView.swift
//  Spanish Lookup
//
//  Created by Jake Crouchley on 22/05/2023.
//

import SwiftUI

struct ConjugationRowView: View {
    
    var searchTerm: String
    @State var conjugationGroup: ConjugationGroup
    @State var matchingConjugation: Conjugation?
    
    func getMatchingConjugations(searchTerm: String, conjugations: [Conjugation]) -> [Conjugation] {
        return conjugations.filter { conjugation in
            return conjugation.conjugation?.starts(with: searchTerm.lowercased()) ?? false
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(conjugationGroup.infinitive ?? "")
            Text(conjugationGroup.infinitive_english ?? "")
                .font(.subheadline)
                .italic()
            if (searchTerm != "" && matchingConjugation != nil) {
                HStack {
                    Text(matchingConjugation?.conjugation ?? "")
                    Text("(\(matchingConjugation?.mood ?? "") \(matchingConjugation?.tense ?? ""))")
                }
                .font(.caption)
                .padding(.top, 4)
            }
        }
        .onAppear(perform: {
            matchingConjugation = getMatchingConjugations(searchTerm: searchTerm, conjugations: conjugationGroup.conjugationsFlatArray).first
        })
        .onChange(of: searchTerm) { newValue in
            matchingConjugation = getMatchingConjugations(searchTerm: newValue, conjugations: conjugationGroup.conjugationsFlatArray).first
        }
    }
}

struct ConjugationRowView_Previews: PreviewProvider {
    let example = ConjugationGroup.example
    static var previews: some View {
        ConjugationRowView(searchTerm: "cur", conjugationGroup: ConjugationGroup.example)
    }
}
