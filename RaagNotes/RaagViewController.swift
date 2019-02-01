//
//  RaagViewController.swift
//  RaagNotes


import UIKit

class RaagViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var thaatLabel: UILabel!
    @IBOutlet weak var jaatiLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var vadiLabel: UILabel!
    @IBOutlet weak var samvadiLabel: UILabel!
    @IBOutlet weak var vivadiLabel: UILabel!
    @IBOutlet weak var arohLabel: UILabel!
    @IBOutlet weak var avrohLabel: UILabel!
    @IBOutlet weak var surLabel: UILabel!
    @IBOutlet weak var mainSurLabel: UILabel!
    
    var raag: Raag!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let raag = raag {
//        }
        nameLabel.text = raag.name
        thaatLabel.text = raag.thaat
        jaatiLabel.text = raag.jaati
        timeLabel.text = raag.time
        vadiLabel.text = raag.vadi
        samvadiLabel.text = raag.samvadi
        vivadiLabel.text = raag.vivadi
        arohLabel.text = raag.aroh
        avrohLabel.text = raag.avroh
        surLabel.text = raag.sur
        mainSurLabel.text = raag.mainSur
        
        // Do any additional setup after loading the view, typically from a nib.
    }


}

