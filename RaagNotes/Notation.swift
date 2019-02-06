//
//  Notation.swift
//  RaagNotes
//
//  Created by Irvanjit Singh on 2019-02-05.
//  Copyright © 2019 Irvanjit Singh. All rights reserved.
//

import UIKit

class Notation {
    
    //MARK: Properties
    
    var name: String
    var surListA: [String]
    var surListB: [String]
    var wordListA: [String]
    var wordListB: [String]
    
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
    
}
