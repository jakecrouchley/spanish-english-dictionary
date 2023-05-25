//
//  ConjugationParser.swift
//  Spanish Lookup
//
//  Created by Jake Crouchley on 21/05/2023.
//
import Foundation
import CoreData

struct DraftConjugationGroup {
    var infinitive: String
    var infinitive_english: String
    var gerund: String
    var past_participle: String
    var conjugations: [DraftConjugation]
}

struct DraftConjugation {
    var mood: String
    var tense: String
    var person: Int
    var type: String
    var conjugation: String
}

class ConjugationParser {
    
    enum Keys: Int, CaseIterable {
        case infinitive = 0, infinitive_english, mood, mood_english, tense, tense_english, verb_english, form_1s, form_2s, form_3s, form_1p, form_2p, form_3p, gerund, gerund_english, pastparticiple, pastparticiple_english
    }
    
    var delegate: ConjugationParserDelegate?
    
    func run() {
        let conjugationGroups = parse()
        for conjugationGroup in conjugationGroups {
            addConjugationGroup(draftConjugationGroup: conjugationGroup)
        }
        save()
    }
    
    func clearAll() {
        if let context = delegate?.container.viewContext {
            let conjugationDeleteRequest = NSBatchDeleteRequest(fetchRequest: Conjugation.fetchRequest())
            let conjugationGroupDeleteRequest = NSBatchDeleteRequest(fetchRequest: ConjugationGroup.fetchRequest())
            
            do {
                try context.execute(conjugationDeleteRequest)
                try context.execute(conjugationGroupDeleteRequest)
            } catch let error as NSError {
                print(error)
            }
        }
    }
    
    func addConjugationGroup(draftConjugationGroup: DraftConjugationGroup) {
        if let context = delegate?.container.viewContext {
            let conjugationGroup = ConjugationGroup(context: context)
            conjugationGroup.id = UUID()
            conjugationGroup.infinitive = draftConjugationGroup.infinitive
            conjugationGroup.infinitive_english = draftConjugationGroup.infinitive_english
            conjugationGroup.gerund = draftConjugationGroup.gerund
            conjugationGroup.past_participle = draftConjugationGroup.past_participle
            conjugationGroup.first_char = draftConjugationGroup.infinitive.first?.lowercased() ?? ""
            draftConjugationGroup.conjugations.forEach { draftConjugation in
                let conjugation = Conjugation(context: context)
                conjugation.id = UUID()
                conjugation.conjugation = draftConjugation.conjugation
                conjugation.mood = draftConjugation.mood
                conjugation.tense = draftConjugation.tense
                conjugation.person = Int32(draftConjugation.person)
                conjugation.type = draftConjugation.type
                conjugationGroup.addToConjugations(conjugation)
            }
        }
    }
    
    func save() {
        if let context = delegate?.container.viewContext {
            try? context.save()
        }
    }
    
    func parse() -> [DraftConjugationGroup] {
        var draftConjugationGroups: [DraftConjugationGroup] = []
        if let path = Bundle.main.path(forResource: "jehle_verb_database", ofType: "csv") {
            do {
                let url = URL(fileURLWithPath: path)
                let content = try String(contentsOf: url)
                let lines = content.components(separatedBy: "\n")
                let rawCols = lines.map{ $0.components(separatedBy: "\",\"") }
                let parsedResult = rawCols.map{ $0.map { $0.replacingOccurrences(of: "\"", with: "")} }
                parsedResult.forEach { row in
                    if (row.count == 17 && row[0] != "infinitive") {
                        let infinitive = row[Keys.infinitive.rawValue]
                        
                        var draftConjugations: [DraftConjugation] = []
                        
                        let mood_english = row[Keys.mood_english.rawValue]
                        let tense_english = row[Keys.tense_english.rawValue]
                        let form_1s = row[Keys.form_1s.rawValue]
                        let form_2s = row[Keys.form_2s.rawValue]
                        let form_3s = row[Keys.form_3s.rawValue]
                        let form_1p = row[Keys.form_1p.rawValue]
                        let form_2p = row[Keys.form_2p.rawValue]
                        let form_3p = row[Keys.form_3p.rawValue]
                        
                        let persons = [form_1s, form_2s, form_3s, form_1p, form_2p, form_3p]
                        
                        for type in ["singular", "plural"] {
                            for person in 1...3 {
                                let conjugation = type == "singular" ? persons[person - 1] : persons[person + 2]
                                
                                let draftConjugation = DraftConjugation(
                                    mood: mood_english,
                                    tense: tense_english,
                                    person: person,
                                    type: type,
                                    conjugation: conjugation
                                )
                                draftConjugations.append(draftConjugation)
                            }
                        }
                        
                        if let index = draftConjugationGroups.firstIndex(where: { $0.infinitive == infinitive}) {
                            draftConjugationGroups[index].conjugations.append(contentsOf: draftConjugations)
                        } else {
                            let infinitive_english = row[Keys.infinitive_english.rawValue]
                            let gerund = row[Keys.gerund.rawValue]
                            let past_participle = row[Keys.pastparticiple.rawValue]
                            
                            let draftConfigurationGroup = DraftConjugationGroup(
                                infinitive: infinitive,
                                infinitive_english: infinitive_english,
                                gerund: gerund,
                                past_participle: past_participle,
                                conjugations: draftConjugations
                            )
                            draftConjugationGroups.append(draftConfigurationGroup)
                        }
                    }
                }
                return draftConjugationGroups
            }
            catch {
                print(error)
            }
        }
        return []
    }
}

protocol ConjugationParserDelegate {
    var container: NSPersistentContainer { get }
}
