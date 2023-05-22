//
//  ConjugationGroup+CoreDataProperties.swift
//  Spanish Lookup
//
//  Created by Jake Crouchley on 21/05/2023.
//
//

import Foundation
import CoreData

let ConjugationTypes = ["singular", "plural"]

public enum ConjugationMood: String, CaseIterable, Comparable, Hashable {
    case Indicative,
         Subjunctive,
         Imperative_Affirmative = "Imperative Affirmative",
         Imperative_Negative = "Imperative Negative"
    
    static var asArray: [ConjugationMood] {return self.allCases}

    func asInt() -> Int {
        return ConjugationMood.asArray.firstIndex(of: self)!
    }
    
    public static func < (lhs: ConjugationMood, rhs: ConjugationMood) -> Bool {
        return lhs.asInt() < rhs.asInt()
    }
}

public enum ConjugationTense: String, CaseIterable, Comparable, Hashable {
    case Present,
         Preterite,
         Imperfect,
         Conditional,
         Future
//         Present_Perfect = "Present Perfect",
//         Future_Perfect = "Future Perfect",
//         Past_Perfect = "Past Perfect",
//         Archaic_Preterite="Preterite (Archaic)",
//         Conditional_Perfect = "Conditional Perfect"
    
    static var asArray: [ConjugationTense] {return self.allCases}

    func asInt() -> Int {
        return ConjugationTense.asArray.firstIndex(of: self)!
    }
    
    public static func < (lhs: ConjugationTense, rhs: ConjugationTense) -> Bool {
        return lhs.asInt() < rhs.asInt()
    }
}

extension ConjugationGroup {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ConjugationGroup> {
        return NSFetchRequest<ConjugationGroup>(entityName: "ConjugationGroup")
    }

    @NSManaged public var gerund: String?
    @NSManaged public var past_participle: String?
    @NSManaged public var infinitive: String?
    @NSManaged public var infinitive_english: String?
    @NSManaged public var conjugations: NSSet?
    
    public var conjugationsByMoodAndTenseDict: [ConjugationMood: [ConjugationTense: [Conjugation]]] {
        var dict: [ConjugationMood: [ConjugationTense: [Conjugation]]] = [:]
        let conjugationSet = self.conjugations as? Set<Conjugation> ?? []
        
        // Convert to tuple array of moods and conjugations
        conjugationSet.forEach { conjugation in
            if let mood = ConjugationMood.init(rawValue: conjugation.mood!) {
                if let tense = ConjugationTense.init(rawValue: conjugation.tense!) {
                    let existingMoodIndex = dict.keys.firstIndex { $0 == mood }
                    if existingMoodIndex != nil {
                        let existingTenseIndex = dict[mood]!.keys.firstIndex { $0 == tense }
                        if existingTenseIndex != nil {
                            dict[mood]![tense]!.append(conjugation)
                        } else {
                            dict[mood]![tense] = [conjugation]
                        }
                    } else {
                        dict[mood] = [tense: [conjugation]]
                    }
                }
            }
        }
        return dict
    }
    
    public var conjugationsFlatArray: [Conjugation] {
        let dict = self.conjugationsByMoodAndTenseDict
        var conjugationArray: [Conjugation] = []
        ConjugationMood.allCases.forEach { mood in
            ConjugationTense.allCases.forEach { tense in
                if let conjugations: [Conjugation] = dict[mood]?[tense] {
                    let sortedConjugations = conjugations.sorted { conjugationA, conjugationB in
                        let aType = ConjugationTypes.firstIndex(of: conjugationA.type!)
                        let bType = ConjugationTypes.firstIndex(of: conjugationB.type!)
            
                        return (aType!, conjugationA.person) < (bType!, conjugationB.person)
                    }
                    conjugationArray.append(contentsOf: sortedConjugations)
                }
            }
        }
        return conjugationArray
    }
    
    public var conjugationsArray: [[[Conjugation]]] {
        let dict = self.conjugationsByMoodAndTenseDict
        var moods: [[[Conjugation]]] = []
        ConjugationMood.allCases.forEach { mood in
            var tenses: [[Conjugation]] = []
            ConjugationTense.allCases.forEach { tense in
                if let conjugations: [Conjugation] = dict[mood]?[tense] {
                    let sortedConjugations = conjugations.sorted { conjugationA, conjugationB in
                        let aType = ConjugationTypes.firstIndex(of: conjugationA.type!)
                        let bType = ConjugationTypes.firstIndex(of: conjugationB.type!)
            
                        return (aType!, conjugationA.person) < (bType!, conjugationB.person)
                    }
                    tenses.append(sortedConjugations)
                }
            }
            moods.append(tenses)
        }
        return moods
    }

}

// MARK: Generated accessors for conjugations
extension ConjugationGroup {

    @objc(addConjugationsObject:)
    @NSManaged public func addToConjugations(_ value: Conjugation)

    @objc(removeConjugationsObject:)
    @NSManaged public func removeFromConjugations(_ value: Conjugation)

    @objc(addConjugations:)
    @NSManaged public func addToConjugations(_ values: NSSet)

    @objc(removeConjugations:)
    @NSManaged public func removeFromConjugations(_ values: NSSet)

}
