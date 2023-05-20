//
//  DataController.swift
//  Spanish Lookup
//
//  Created by Jake Crouchley on 09/05/2023.
//

import CoreData
import Foundation

class WordsProvider: ObservableObject, DictParserDelegate {
    
    static let shared = WordsProvider()
    
    let container = NSPersistentContainer(name: "Model")
    var words: [[String: Any]] = []
    
    init(inMemory: Bool = false) {
        // Don't save information for future use if running in memory...
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
        // TODO: conditionally run these lines on first startup
        let dictParser = DictParser()
        dictParser.delegate = self
        clearAllWords()
        dictParser.parseEnToEsDict()
        dictParser.parseEsToEnDict()
        saveWords()
    }
    
    func clearAllWords() {
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: Word.fetchRequest())
        
        let managedObjectContext = container.viewContext
        do {
            try managedObjectContext.execute(deleteRequest)
        } catch let error as NSError {
            print(error)
        }
    }
    
    func addWord(word: DraftWord) {
        var newWord: [String: Any] = [:]
        newWord["id"] = UUID()
        newWord["source_word"] = word.source_word ?? ""
        newWord["definition"] = word.definition ?? ""
        newWord["details"] = word.details ?? ""
        newWord["source_lang"] = word.source_lang ?? ""
        newWord["first_char"] = String(word.source_word?.first ?? Character("")).lowercased()
        words.append(newWord)
    }
    
    func saveWords() {
        let managedObjectContext = container.viewContext
        let batchRequest = NSBatchInsertRequest(entity: Word.entity(), objects: words)
        let result = try? managedObjectContext.execute(batchRequest)
    }
    
}
