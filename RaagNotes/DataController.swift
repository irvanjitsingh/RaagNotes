//
//  DataController.swift
//  RaagNotes

import UIKit

class DataController {
    let raags: [Raag]
    
    init() {
        let fileUrl = Bundle.main.url(forResource: "Raags", withExtension: "plist")!
        let raagsPlists = NSArray(contentsOf: fileUrl) as! [PListDictionary]
        raags = raagsPlists.map(Raag.init)
    }
}
