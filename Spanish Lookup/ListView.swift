//
//  ListView.swift
//  Spanish Lookup
//
//  Created by Jake Crouchley on 05/05/2023.
//

import SwiftUI

struct ListView: View {
    var text = "Hello World!"
    var list = [
        "Hello",
        "World"
    ]
    
    var body: some View {
        Text("Hello")
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
