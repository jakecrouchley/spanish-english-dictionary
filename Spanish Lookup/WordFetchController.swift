//
//  WordFetchController.swift
//  Spanish Lookup
//
//  Created by Jake Crouchley on 10/05/2023.
//

import Foundation
import CoreData

class WordFetchController: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    
    @Published var words: [Word] = []
    
    init(context: NSManagedObjectContext) {
        
    }
}
