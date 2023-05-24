//
//  PrimaryView.swift
//  Spanish Lookup
//
//  Created by Jake Crouchley on 24/05/2023.
//

import SwiftUI

struct PrimaryView: View {
    @State private var selectedPage: SelectedPage = SelectedPage.dictionary
    
    var body: some View {
        Picker("Selected Page", selection: $selectedPage) {
            Text("Dictionary").tag(SelectedPage.dictionary)
            Text("Conjugations").tag(SelectedPage.conjugations)
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, 20)
        if (selectedPage == .dictionary) {
            WordListView()
                .navigationBarTitle("Spanish Lookup")
                .navigationBarTitleDisplayMode(.inline)
        } else {
            ConjugationListView()
                .navigationBarTitle("Spanish Lookup")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct PrimaryView_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryView()
    }
}
