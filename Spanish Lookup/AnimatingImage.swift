//
//  AnimatingImage.swift
//  Spanish Lookup
//
//  Created by Jake Crouchley on 24/05/2023.
//

import SwiftUI

struct AnimatingImage: View {
    let images: [Image]

    @StateObject private var counter = Counter(interval: 0.05)
        
    var body: some View {
        images[counter.value % images.count]
    }
}

private class Counter: ObservableObject {
    private var timer: Timer?

    @Published var value: Int = 0
    
    init(interval: Double) {
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in self.value += 1 }
    }
}
