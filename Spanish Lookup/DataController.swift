//
//  DataController.swift
//  Spanish Lookup
//
//  Created by Jake Crouchley on 09/05/2023.
//

import CoreData
import Foundation

class DataController: ObservableObject, DictParserDelegate {
    
    static let shared = DataController()
    
    let container = NSPersistentContainer(name: "Model")
    var words: [[String: Any]] = []
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
        // TODO: conditionally run these lines on first startup
//        clearAllWords()
//        parseEnToEsDict()
//        parseEsToEnDict()
//        saveWords()
    }
    
    func parseEnToEsDict() {
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
    
    func parseEsToEnDict() {
        if let path = Bundle.main.path(forResource: "es-en", ofType: "xml") {
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
        print(result)
    }
    
}
