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
                .navigationBarTitle("Dictionary")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: AboutView()) {
                            Label("About", systemImage: "info.circle")

                        }
                    }
                }
        } else {
            ConjugationListView()
                .navigationBarTitle("Conjugations")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: AboutView()) {
                            Label("About", systemImage: "info.circle")

                        }
                    }
                }
        }
    }
}

struct PrimaryView_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryView()
    }
}
