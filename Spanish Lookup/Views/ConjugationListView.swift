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
    
    init() {
        let request: NSFetchRequest<ConjugationGroup> = ConjugationGroup.fetchRequest()
        request.predicate = nil
        request.sortDescriptors = nsSortDescriptors
//        request.fetchLimit = 10
//        request.includesPropertyValues = false
        request.returnsObjectsAsFaults = false
        _conjugationGroups = SectionedFetchRequest(fetchRequest: request, sectionIdentifier: \.first_char)
    }

    var body: some View {
        List(conjugationGroups) { section in
            Section(header: Text(section.id ?? "")) {
                ForEach(section) {conjugationGroup in
                    NavigationLink {
                        ConjugationDetailView(conjugationGroup: conjugationGroup)
                    } label: {
                        VStack {
                            Text(conjugationGroup.infinitive ?? "")
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
        .padding(.zero)
        .id(UUID())
    }
}

struct ConjugationListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ConjugationListView().environment(\.managedObjectContext, WordsProvider.shared.container.viewContext)
        }
    }
}
