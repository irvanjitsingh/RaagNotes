//
//  Raag.swift
//  RaagNotes
//
//  Copyright © 2019 Irvanjit Singh. All rights reserved.
//

import UIKit
import os.log

typealias PListDictionary = [String: AnyObject]

protocol PlistKey: RawRepresentable {}

protocol PlistValue {}

struct Raag {
    var name: String
    var aroh: String
    var avroh: String
    var sur: String
    var thaat: String
    var jaati: String
    var time: String
    var vadi: String
    var samvadi: String
    var vivadi: String
    var mainSur: String
    var trackA: String
    var trackB: String
}

extension Bool: PlistValue {}
extension String: PlistValue {}
extension Int: PlistValue {}
extension Date: PlistValue {}
extension Data: PlistValue {}
extension Dictionary: PlistValue {}
extension Array: PlistValue {}

extension Dictionary where Value: AnyObject {
    func value<V: PlistValue, K: PlistKey>(forKey key: K) -> V where K.RawValue == String {
        return self[key.rawValue as! Key] as! V
    }
}

extension Raag {
    private enum Keys: String, PlistKey {
        case name
        case aroh
        case avroh
        case sur
        case thaat
        case jaati
        case time
        case vadi
        case samvadi
        case vivadi
        case mainSur
        case trackA
        case trackB
    }
    
    init(plist: PListDictionary) {
        name = plist.value(forKey: Keys.name)
        aroh = plist.value(forKey: Keys.aroh)
        avroh = plist.value(forKey: Keys.avroh)
        sur = plist.value(forKey: Keys.sur)
        thaat = plist.value(forKey: Keys.thaat)
        jaati = plist.value(forKey: Keys.jaati)
        time = plist.value(forKey: Keys.time)
        vadi = plist.value(forKey: Keys.vadi)
        samvadi = plist.value(forKey: Keys.samvadi)
        vivadi = plist.value(forKey: Keys.vivadi)
        mainSur = plist.value(forKey: Keys.mainSur)
        trackA = plist.value(forKey: Keys.trackA)
        trackB = plist.value(forKey: Keys.trackB)
    }
}
