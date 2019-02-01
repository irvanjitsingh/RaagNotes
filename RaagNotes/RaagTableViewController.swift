//
//  RaagTableViewController.swift
//  RaagNotes

import UIKit
import os.log

class RaagTableViewController: UITableViewController {
    
    var raags = [Raag]()
    
    var selectedRaag:Raag!
    
    let dataController = DataController()
    
    required init?(coder aDecoder: NSCoder) {
        raags = dataController.raags
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
//        loadSampleRaags()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return raags.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "RaagTableViewCell"
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RaagTableViewCell  else {
            fatalError("The dequeued cell is not an instance of RaagTableViewCell.")
        }
        let raag = raags[indexPath.row]
        cell.cellNameLabel.text = raag.name
        cell.cellThaatLabel.text = raag.thaat
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
        selectedRaag = raags[indexPath.row]
        performSegue(withIdentifier: "RaagDetail", sender: self)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }

    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
            case "RaagDetail":
                guard let raagVC = segue.destination as? RaagViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                
//                guard let selectedRaagCell = sender as? RaagTableViewCell else {
//                    fatalError("Unexpected sender: \(String(describing: sender))")
//                }
//
//                guard let indexPath = tableView.indexPath(for: selectedRaagCell) else {
//                    fatalError("The selected cell is not being displayed by the table")
//                }
//
//                let selected = raags[indexPath.row]
//                raagVC.raag = selected
//
                raagVC.raag = selectedRaag
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
//        if segue.identifier == "RaagDetail" {
//            let vc = segue.destination as! RaagViewController
//            vc.raag = selectedRaag
//        }
    }
    
    /*private func loadSampleRaags() {
        guard let raag1 = Raag(
            name: "Made Up Raag",
            aroh: "here's a long string representing an aroh",
            avroh: "another long string representing an aroh",
            sur: "play some notes, dont play others",
            thaat: "the raag is parentless",
            jaati: "something-something",
            time: "pick a random pehar",
            vadi: "this is the most important note",
            samvadi: "this is the second most important note",
            vivadi: "this note is banned",
            mainSur: "play this bandish for the raag",
            trackA: "url to hazoori raag bhai balbir singh recording",
            trackB: "url to dr gurnam singh recording"
            ) else {
                fatalError("Unable to instantiate raag1")
        }
        
        guard let raag2 = Raag(
            name: "Another Made Up Raag",
            aroh: "here's a long string representing an aroh",
            avroh: "another long string representing an aroh",
            sur: "play some notes, dont play others",
            thaat: "the raag is parentless",
            jaati: "something-something",
            time: "pick a random pehar",
            vadi: "this is the most important note",
            samvadi: "this is the second most important note",
            vivadi: "this note is banned",
            mainSur: "play this bandish for the raag",
            trackA: "url to hazoori raag bhai balbir singh recording",
            trackB: "url to dr gurnam singh recording"
            ) else {
                fatalError("Unable to instantiate raag1")
        }
        
        guard let raag3 = Raag(
            name: "Yet Another Made Up Raag",
            aroh: "here's a long string representing an aroh",
            avroh: "another long string representing an aroh",
            sur: "play some notes, dont play others",
            thaat: "the raag is parentless",
            jaati: "something-something",
            time: "pick a random pehar",
            vadi: "this is the most important note",
            samvadi: "this is the second most important note",
            vivadi: "this note is banned",
            mainSur: "play this bandish for the raag",
            trackA: "url to hazoori raag bhai balbir singh recording",
            trackB: "url to dr gurnam singh recording"
            ) else {
                fatalError("Unable to instantiate raag1")
        }
        
        raags += [raag1, raag2, raag3]
    }*/

}
