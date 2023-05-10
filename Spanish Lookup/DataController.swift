//
//  DataController.swift
//  Spanish Lookup
//
//  Created by Jake Crouchley on 09/05/2023.
//

import CoreData
import Foundation

class DataController: ObservableObject, DictParserDelegate {
    let container = NSPersistentContainer(name: "Model")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
//        clearAllWords()
//        parseDict()
    }
    
    func parseDict() {
        if let path = Bundle.main.path(forResource: "en-es", ofType: "xml") {
            do {
                let url = URL(fileURLWithPath: path)
                let xmlData = try Data(contentsOf: url)
                print(xmlData.count)
                let xmlParser = XMLParser(data: xmlData)
                let dictParser = DictParser()
                dictParser.delegate = self
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
    
    func clearAllWords() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Word")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        let managedObjectContext = container.viewContext
        do {
            try managedObjectContext.execute(deleteRequest)
        } catch let error as NSError {
            print(error)
        }
    }
    
    func saveWord(word: DraftWord) {
        let managedObjectContext = container.viewContext
        let newWord = Word(context: managedObjectContext)
        newWord.id = UUID()
        newWord.source_word = word.source_word ?? ""
        newWord.definition = word.definition ?? ""
        newWord.details = word.details ?? ""
        newWord.source_lang = word.source_lang ?? ""
        try? managedObjectContext.save()
    }
    
}
