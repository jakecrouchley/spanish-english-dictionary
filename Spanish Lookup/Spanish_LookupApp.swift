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
    @StateObject private var dataController = DataController()

    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
