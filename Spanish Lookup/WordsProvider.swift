//
//  DataController.swift
//  Spanish Lookup
//
//  Created by Jake Crouchley on 09/05/2023.
//

import CoreData
import Foundation

struct DraftWord {
    var source_word: String?
    var source_lang: String?
    var definition: String?
    var details: String?
}

class WordsProvider: ObservableObject, DictParserDelegate, ConjugationParserDelegate {
    
    static let shared = WordsProvider()
    
    static let preview: WordsProvider = {
        let wordsProvider = WordsProvider(inMemory: true)
        let context = wordsProvider.container.viewContext
        let exampleWord = Word(context: context)
        exampleWord.source_word = "apple"
        exampleWord.definition = "manzana"
        exampleWord.source_lang = "en"
        exampleWord.details = "{noun} a round fruit"
        exampleWord.first_char = "a"
        
        
        let exampleConjugationGroup = ConjugationGroup(context: context)
        exampleConjugationGroup.infinitive = "abandonar"
        exampleConjugationGroup.infinitive_english = "To abandon"
        exampleConjugationGroup.gerund = "abandonando"
        exampleConjugationGroup.past_participle = "abandonado"
        exampleConjugationGroup.first_char = "a"
        
        let exampleConjugation = Conjugation(context: context)
        exampleConjugation.type = "singular"
        exampleConjugation.mood = "Indicative"
        exampleConjugation.tense = "Present"
        exampleConjugation.conjugation = "abandono"
        
        try? context.save()
        return wordsProvider
    }()
    
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
        if (!inMemory) {
//            clearAllWords()
//
//            let dictParser = DictParser()
//            dictParser.delegate = self
//            dictParser.run()
//
//
//
//            saveWords(words: words)
            
//            let conjugationParser = ConjugationParser()
//            conjugationParser.delegate = self
//            conjugationParser.clearAll()
//            conjugationParser.run()
        }
    }
    
    func fetchIDForWord(startingWith searchTerm: String) -> UUID? {
        let fetchRequest: NSFetchRequest<Word> = Word.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "source_word", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))]
        fetchRequest.predicate = NSPredicate(format: "source_word BEGINSWITH[cd] %@", searchTerm)
        
        let results = try? container.viewContext.fetch(fetchRequest)
        
        return results?.first?.id
    }
    
    func fetchWords(startingWith searchTerm: String) -> [Word] {
        let fetchRequest: NSFetchRequest<Word> = Word.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "source_word", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))]
        fetchRequest.predicate = NSPredicate(format: "source_word BEGINSWITH[cd] %@", searchTerm)
        
        let results = try? container.viewContext.fetch(fetchRequest)
        
        return results ?? []
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
    
    func saveWords(words: [[String:Any]]) {
        let managedObjectContext = container.viewContext
        let batchRequest = NSBatchInsertRequest(entity: Word.entity(), objects: words)
        let _ = try? managedObjectContext.execute(batchRequest)
    }
    
}
