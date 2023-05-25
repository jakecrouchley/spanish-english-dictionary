//
//  Spanish_LookupApp.swift
//  Spanish Lookup
//
//  Created by Jake Crouchley on 05/05/2023.
//

import SwiftUI
import CoreData

@main
struct Spanish_LookupApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, WordsProvider.shared.container.viewContext)
        }
    }
}
