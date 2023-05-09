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
        parseDict()
    }
    
    func parseDict() {
        if let path = Bundle.main.path(forResource: "en-es", ofType: "xml") {
            do {
                let url = URL(fileURLWithPath: path)
                let xmlData = try Data(contentsOf: url)
                print(xmlData.count)
                let xmlParser = XMLParser(data: xmlData)
                let dictParser = DictParser()
                xmlParser.delegate = dictParser
                xmlParser.parse()
            } catch let error {
                // Handle error here
                print(error)
            }
        } else {
            print("File not found")
        }

    }
    
    func saveWord() {
        let managedObjectContext = container.viewContext
        let word = Word(context: managedObjectContext)
        word.source_word = "Pregenerated"
        try? managedObjectContext.save()
    }
}
