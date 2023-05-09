//
//  DictParser.swift
//  Spanish Lookup
//
//  Created by Jake Crouchley on 09/05/2023.
//

import Foundation

class DictParser: NSObject, XMLParserDelegate {
    
    var timestamp = 0
    
    func parserDidStartDocument(_ parser: XMLParser) {
        timestamp = Int(NSDate().timeIntervalSince1970 * 1000)
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        let difference = Int(NSDate().timeIntervalSince1970 * 1000) - timestamp
        print(difference)
    }
}
