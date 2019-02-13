//
//  NotationTableViewController.swift
//  RaagNotes
//
//  Created by Irvanjit Singh on 2019-02-01.
//  Copyright © 2019 Irvanjit Singh. All rights reserved.
//

import UIKit
import os.log

class NotationTableViewController: UITableViewController {
    
    static let sample1SursA = ["N","D","N","Ṡ","N","D","P","P","M̍","G","R","S","Ṇ","R","S","S","Ṇ","Ṇ","R","R","G","_","G","G","P","P","M̍","G","Ṇ","R","S","S","G","_","M̍","M̍","P","_","P","P","N","D","N","S","N","D","P","P"]
    static let sample1SursB = ["P","_","P","P","M̍","G","M̍","P","Ṡ","Ṡ","Ṡ","Ṡ","N","Ṙ","Ṡ","Ṡ","N","Ṙ","Ġ","Ġ","Ṙ","Ṙ","Ṡ","Ṡ","N","D","N","Ṡ","N","D","P","P"]
    let sample2SursA = ["R","G","R","M","G","R","S","R","P","P","R","G","M","P","M","G","P","P","P","D","S","S","D","P","G","M","R","G","M","P","M","G"]
    let sample2SursB = ["P","P","P","P","N","D","N","N","Ṡ","Ṡ","Ṡ","Ṡ","Ṡ","Ṙ","Ṡ","Ṡ","N","N","N","N","Ṡ","Ṡ","D","P","G","M","R","G","M","P","M","G"]
    
    let sample3SursA = ["Ṡ","Ṡ","Ṡ","Ṡ","D","D","P","P","G","_","G","P","G","R","S","S","S","D","S","R","G","_","G","G","R","_","G","P","G","R","S","S"]
    let sample3SursB = ["G","_","G","G","P","P","D","D","Ṡ","Ṡ","Ṡ","Ṡ","D","Ṙ","Ṡ","Ṡ","Ġ","_","Ġ","Ġ","Ṙ","Ṙ","Ṡ","Ṡ","D","D","P","P","G","R","S","S"]
    
    static let sample1WordsA = ["Ha","Ra","Ha","Ra","Si","Ma","Ro","O","Sa","An","Ta","Go","Pa","A","La","A","Sa","A","Dh","Sa","Ang","Ga","Mi","La","Na","A","Ma","Dhi","Aa","Aa","Vo","Oh","Pu","U","Ra","Na","Ho","Oh","Eh","Ey","Gha","Aa","Aa","Aa","Aa","Aa","La","Aa"]
    static let sample1WordsB = ["Ja","Aa","Kai","Eh","Si","Ma","Ra","Na","Sa","Bha","Ku","Ch","Pa","Yi","Eh ","Eh","Bi","Ra","Thi","Ee","Gha","Aa","La","Na","Ja","Aa","Aa","Aa","Ee","Ee","Ee","Ee"]
    
    let sample2WordsA = ["Cha","Ra","Na","Ka","Ma","La","Pra","Bha","Ke","Ee","Ni","Ta","Dhi","Aa","Vo","Oh","Ka","Va","Na","Su","Ma","Ta","Ji","Ta","Pre","Ee","Ta","Ma","Pa","Aa","Vo","Oh"]

    let sample2WordsB = ["Ka","Va","Na","San","Jo","Oh","Ga","Mi","Lo","Oh","Pra","Bha","Aa","Pa","Ne","Eh","Pa","La","Pa","La","Ni","Ma","Kha","Sa","Da","Aa","Ha","Ra","Ja","Pa","Ne","Eh"]

    let sample3WordsA = ["Mo","He","Na","Bi","Sa","Aa","Ro","O","Mai","Ai","Ja","Na","Te","Ee","Ra","Aa","Ra","Aa","Ma","Go","Sai","I","Aa","Aa","Ji","I","Ke","Eh","Ji","Va","Na","Aa"]

    let sample3WordsB = ["Me","Ri","San","Gat","Po","Oh","Ch","So","Och","A","Di","Na","Ra","Aa","Ti","I","Me","Ra","Karm","Ku","Ti","La","Ta","Aa","Ja","Na","Ma","Ku","Bha","Aa","Ti","I"]

    
    var notations = [Notation]()
    var selectedNotationIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
//        self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        if let savedNotations = loadNotations() {
            notations += savedNotations
        } else {
            loadSampleNotations()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notations.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "NotationTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? NotationTableViewCell  else {
            fatalError("The dequeued cell is not an instance of NotationTableViewCell.")
        }
        let notation = notations[indexPath.row]
        cell.nameLabel.text = notation.name

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            notations.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveNotations()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }

    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
        selectedNotationIndex = indexPath.row
        performSegue(withIdentifier: "NotationDetail", sender: self)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let notationVC = segue.destination as? NotationViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        switch(segue.identifier ?? "") {
        case "NotationDetail":
            notationVC.notation = notations[selectedNotationIndex]
            notationVC.selectedNotationIndex = selectedNotationIndex
        case "NewNotation":
            notationVC.notation = nil
            notationVC.selectedNotationIndex = -1
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    // MARK: Actions
    
    @IBAction func unwindToNotationList(sender: UIStoryboardSegue) {
        let sourceViewController = sender.source as? NotationViewController
        let notation = sourceViewController!.notation
        let index = sourceViewController!.selectedNotationIndex
        if (index == -1) {
            // New notation created, add to list.
            let newIndexPath = IndexPath(row: notations.count, section: 0)
            notations.append(notation!)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        } else {
            notations[index!] = notation!
            tableView.reloadData()
        }
        saveNotations()
    }
    
    // MARK: Private methods
    
    private func saveNotations() {
//        let data = try NSKeyedArchiver.archivedData(withRootObject: notations, requiringSecureCoding: false)
//        try data.write(to: URL(string: "file://" + Notation.ArchiveURL.path)!)
        let success = NSKeyedArchiver.archiveRootObject(notations, toFile: Notation.ArchiveURL.path)
        if success {
            os_log("Notations saved", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save notations:", log: OSLog.default, type: .error)
        }
    }
    
    private func loadNotations() -> [Notation]? {
//        let rawdata = try Data(contentsOf: URL(string: "file://" + Notation.ArchiveURL.path)!)
//        data = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(rawdata) as! [Notation]? ?? []
        return NSKeyedUnarchiver.unarchiveObject(withFile: Notation.ArchiveURL.path) as? [Notation]
    }
    
    private func loadSampleNotations() {
        guard let notation1 = Notation(
            name: "Har Har Simarhu... (Yaman Kalyaan)",
            surListA: NotationTableViewController.sample1SursA,
            surListB: NotationTableViewController.sample1SursB,
            wordListA: NotationTableViewController.sample1WordsA,
            wordListB: NotationTableViewController.sample1WordsB)
            else {fatalError("Unable to instantiate notation1")}
        guard let notation2 = Notation(
            name: "Charan Kamal Prabh Ke... (Bilaval)",
            surListA: sample2SursA,
            surListB: sample2SursB,
            wordListA: sample2WordsA,
            wordListB: sample2WordsB)
            else {fatalError("Unable to instantiate notation1")}
        guard let notation3 = Notation(
            name: "Mohe Na Bisaaro... (Bhoopali)",
            surListA: sample3SursA,
            surListB: sample3SursB,
            wordListA: sample3WordsA,
            wordListB: sample3WordsB)
            else {fatalError("Unable to instantiate notation1")}
        
        notations += [notation1, notation2, notation3]
    }
 
}
