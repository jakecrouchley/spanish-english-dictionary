//
//  DataController.swift
//  Spanish Lookup
//
//  Created by Jake Crouchley on 09/05/2023.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "Model")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
    
    func saveWord(word: Word) {
        let managedObjectContext = container.viewContext
        let word = Word(context: managedObjectContext)
        word.source_word = "Pregenerated"
        try? managedObjectContext.save()
    }
}
