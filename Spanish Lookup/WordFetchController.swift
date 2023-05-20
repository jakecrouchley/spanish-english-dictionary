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
    
    @Published var searchText: String = ""
    
    static var shared = WordFetchController()
    
    var fetchedResultsController: NSFetchedResultsController<Word>
    
    override init() {
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: WordFetchConfig.shared.getFetchRequest(withSearchText: "", fetchLimit: WordFetchConfig.fetchLimit), managedObjectContext: DataController.shared.container.viewContext, sectionNameKeyPath: "first_char", cacheName: nil)
        super.init()
        
        self.fetchedResultsController.delegate = self
        performFetch()
    }
    
    func performFetch(fetchOffset: Int = 0) {
        let request = WordFetchConfig.shared.getFetchRequest(withSearchText: searchText, fetchLimit: WordFetchConfig.fetchLimit, fetchOffset: fetchOffset)
        fetchedResultsController.fetchRequest.predicate = request.predicate
        try? fetchedResultsController.performFetch()
        words = fetchedResultsController.fetchedObjects ?? []
        print("Updated words")
    }
    
    func nextPage() {
        let pageCount = words.count / WordFetchConfig.fetchLimit
        let request = WordFetchConfig.shared.getFetchRequest(withSearchText: searchText, fetchLimit: WordFetchConfig.fetchLimit, fetchOffset: pageCount * WordFetchConfig.fetchLimit)
        fetchedResultsController.fetchRequest.predicate = request.predicate
        try? fetchedResultsController.performFetch()
        words.append(contentsOf: fetchedResultsController.fetchedObjects ?? [])
    }
    
    func clearLastPage() {
        words.remove(at: 0)
        print("clear last page")
    }
}
