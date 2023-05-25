//
//  AboutView.swift
//  Spanish Lookup
//
//  Created by Jake Crouchley on 24/05/2023.
//

import SwiftUI

struct AboutView: View {
    
    private let images = (1...30).map { String(format: "LoadingImage%0d", $0) }.map { Image($0).resizable() }
    
    @State private var rotation = 0.0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading) {
                Text("Offline Spanish Dictionary")
                    .font(.headline)
                    .fontWeight(.bold)
                Text("A super basic offline Spanish dictionary of words and conjugations.")
                    .font(.subheadline)
                    .padding(.top, 1)
            }
            HStack {
                AnimatingImage(images: images)
                    .frame(width: 40, height: 40)
                    .rotationEffect(Angle(degrees: rotation))
                    .onTapGesture {
                        rotation += 360
                    }
                    .animation(.interactiveSpring(response: 0.2, dampingFraction: 0.4), value: rotation)
            }
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                alignment: .center
            )
            VStack(alignment: .center) {
                Text("Jake Crouchley")
                Link("crouchley.nz", destination: URL(string: "https://crouchley.nz")!)
            }
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                alignment: .center
            )
            .font(.subheadline)
            Spacer()
            VStack(alignment: .leading, spacing: 8) {
                Text("Made using:")
                VStack(alignment: .leading, spacing: 8) {
                    Text("https://github.com/mananoreboton/en-es-en-Dic")
                    Text("https://github.com/ghidinelli/fred-jehle-spanish-verbs")
                    Text("https://github.com/lipis/flag-icons")
                }
            }
            .font(.caption)
        }
        .padding(16)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
