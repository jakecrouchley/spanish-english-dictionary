//
//  Word+Example.swift
//  Spanish Lookup
//
//  Created by Jake Crouchley on 20/05/2023.
//
import CoreData

extension Word {
    static let example: Word = {
        let context = WordsProvider.preview.container.viewContext
        
        let fetchRequest: NSFetchRequest<Word> = Word.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        let results = try? context.fetch(fetchRequest)
        
        return (results?.first!)!
    }()
}
