//
//  WordFetchConfig.swift
//  Spanish Lookup
//
//  Created by Jake Crouchley on 12/05/2023.
//

import CoreData
import SwiftUI

struct WordFetchConfig {
    
    static var shared = WordFetchConfig()
    
    static var fetchLimit = 15
    
    let nsSortDescriptors = [NSSortDescriptor(key: "first_char", ascending: true), NSSortDescriptor(key: "source_word", ascending: true)]
    
    var request: NSFetchRequest<Word>
    
    init() {
        request = Word.fetchRequest()
    }
    
    func getFetchRequest(withSearchText searchText: String, fetchLimit: Int, fetchOffset: Int = 0) -> NSFetchRequest<Word> {
        let config = request
        config.sortDescriptors = nsSortDescriptors
        if searchText.isEmpty {
            config.predicate = nil
        } else {
            config.predicate = NSPredicate(format: "source_word contains[cd] %@", searchText)
        }
        config.fetchLimit = fetchLimit
        config.fetchOffset = fetchOffset
        return request
    }
}
