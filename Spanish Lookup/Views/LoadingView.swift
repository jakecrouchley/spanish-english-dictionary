//
//  LoadingVIew.swift
//  Spanish Lookup
//
//  Created by Jake Crouchley on 23/05/2023.
//

import SwiftUI

struct LoadingView: View {
    private let images = (1...30).map { String(format: "LoadingImage%0d", $0) }.map { Image($0).resizable() }
    
    @State private var rotation = 0.0

    var body: some View {
        VStack {
            AnimatingImage(images: images)
                .frame(width: 50, height: 50)
                .rotationEffect(Angle(degrees: rotation))
                .onTapGesture {
                    rotation += 180
                }
                .animation(.easeInOut(duration: 1), value: rotation)
            Text("Loading, please wait")
                .font(Font.custom("SourceSansPro-Bold", size: 18))
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
