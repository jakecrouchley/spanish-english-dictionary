//
//  ConjugationListView.swift
//  Spanish Lookup
//
//  Created by Jake Crouchley on 21/05/2023.
//

import SwiftUI
import CoreData

struct ConjugationListView: View {
    @SectionedFetchRequest
    private var conjugationGroups: SectionedFetchResults<String?, ConjugationGroup>
    
    let nsSortDescriptors = [NSSortDescriptor(key: "first_char", ascending: true), NSSortDescriptor(key: "infinitive", ascending: true)]
    
    @State var searchTerm: String = ""
    
    init() {
        let request: NSFetchRequest<ConjugationGroup> = ConjugationGroup.fetchRequest()
        request.predicate = nil
        request.sortDescriptors = nsSortDescriptors
        _conjugationGroups = SectionedFetchRequest(fetchRequest: request, sectionIdentifier: \.first_char)
    }
    
    func resetSearch() {
        if (searchTerm != "") {
            searchTerm = ""
        }
        let config = conjugationGroups
        config.nsSortDescriptors = nsSortDescriptors
        config.nsPredicate = nil
    }
    
    func beginsWithSearch(searchTerm: String) {
        let config = conjugationGroups
        config.nsSortDescriptors = [NSSortDescriptor(key: "infinitive", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))]
        config.nsPredicate = NSPredicate(format: "SUBQUERY(conjugations, $c, $c.conjugation BEGINSWITH[cd] %@).@count > 1 || infinitive BEGINSWITH[cd] %@", searchTerm, searchTerm)
    }
    
    var body: some View {
        ScrollViewReader { scrollViewReader in
            List(conjugationGroups) { section in
                Section(header: Text(section.id ?? "")) {
                    ForEach(section, id: \.infinitive) {conjugationGroup in
                        NavigationLink {
                            ConjugationDetailView(conjugationGroup: conjugationGroup)
                        } label: {
                            ConjugationRowView(searchTerm: searchTerm, conjugationGroup: conjugationGroup)
                        }
                    }
                }
            }
            .listStyle(.plain)
            .padding(.zero)
            .id(UUID())
            .onChange(of: searchTerm) { newValue in
                if (searchTerm == "") {
                    resetSearch()
                } else {
                    beginsWithSearch(searchTerm: searchTerm)
                }
            }
            .searchable(text: $searchTerm, placement: .navigationBarDrawer(displayMode: .always))
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled(true)
        }
        .padding(.zero)
    }
}

struct ConjugationListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ConjugationListView().environment(\.managedObjectContext, WordsProvider.shared.container.viewContext)
        }
    }
}
