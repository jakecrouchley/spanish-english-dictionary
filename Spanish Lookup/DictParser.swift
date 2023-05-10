//
//  DictParser.swift
//  Spanish Lookup
//
//  Created by Jake Crouchley on 09/05/2023.
//

import Foundation


struct DraftWord {
    var source_word: String?
    var source_lang: String?
    var definition: String?
    var details: String?
}

class DictParser: NSObject, XMLParserDelegate {
    
    var delegate: DictParserDelegate?
    
    let alphabet = "abcdefghijklmnopqrstuvwxyz"
    
    var timestamp = 0
    var sectionCount = 0
    var accumText = ""
    
    var startingLetter = ""
    
    var draftWord: DraftWord?
    var sourceLang = ""
    
    func parserDidStartDocument(_ parser: XMLParser) {
        timestamp = Int(NSDate().timeIntervalSince1970 * 1000)
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        let difference = Int(NSDate().timeIntervalSince1970 * 1000) - timestamp
        print(difference)
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        switch elementName {
        case "dic":
            sourceLang = attributeDict["from"] ?? "en"
            break
        case "l":
            // New section
            let index = alphabet.index(alphabet.startIndex, offsetBy: sectionCount)
            startingLetter = String(alphabet[index])
            sectionCount += 1
            break
        case "w":
            // New word
            draftWord = DraftWord()
            break
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        let fullText = accumText.trimmingCharacters(in: .whitespacesAndNewlines)
        switch elementName {
        case "c":
            draftWord?.source_word = fullText
            break
        case "d":
            draftWord?.definition = fullText
            break
        case "t":
            draftWord?.details = fullText
            break
        case "w":
            // New word
            draftWord?.source_lang = sourceLang
            if let newWord = draftWord {
                delegate?.addWord(word: newWord)
            } else {
                print("Could not save word: \(String(describing: draftWord))")
            }
            break
        default:
            break
        }
        accumText = ""
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        accumText = accumText + string
    }
}

protocol DictParserDelegate {
    func addWord(word: DraftWord) -> Void
}
