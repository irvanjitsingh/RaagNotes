//
//  Notation.swift
//  RaagNotes
//
//  Created by Irvanjit Singh on 2019-02-05.
//  Copyright © 2019 Irvanjit Singh. All rights reserved.
//

import UIKit
import os.log

class Notation: NSObject, NSCoding {
    
    //MARK: Properties
    
    var name: String
    var surListA: [String]
    var surListB: [String]
    var wordListA: [String]
    var wordListB: [String]
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("notations")
    
    //MARK: Types
    
    struct PropertyKey {
        static let name = "name"
        static let surListA = "surListA"
        static let surListB = "surListB"
        static let wordListA = "wordListA"
        static let wordListB = "wordListB"
    }
    
    init?(name: String, surListA: [String], surListB: [String], wordListA: [String], wordListB: [String]) {
        
        guard !name.isEmpty else {
            return nil
        }
        
        self.name = name
        self.surListA = surListA
        self.surListB = surListB
        self.wordListA = wordListA
        self.wordListB = wordListB
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(surListA, forKey: PropertyKey.surListA)
        aCoder.encode(surListB, forKey: PropertyKey.surListB)
        aCoder.encode(wordListA, forKey: PropertyKey.wordListA)
        aCoder.encode(wordListB, forKey: PropertyKey.wordListB)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Notation object.", log: OSLog.default, type: .debug)
            return nil
        }
        let surListA = aDecoder.decodeObject(forKey: PropertyKey.surListA) as? [String]
        let surListB = aDecoder.decodeObject(forKey: PropertyKey.surListB) as? [String]
        let wordListA = aDecoder.decodeObject(forKey: PropertyKey.wordListA) as? [String]
        let wordListB = aDecoder.decodeObject(forKey: PropertyKey.wordListB) as? [String]
        
        self.init(name: name, surListA: surListA ?? [], surListB: surListB ?? [], wordListA: wordListA ?? [], wordListB: wordListB ?? [])
    }    
}
