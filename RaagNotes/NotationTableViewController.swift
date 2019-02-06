//
//  NotationTableViewController.swift
//  RaagNotes
//
//  Created by Irvanjit Singh on 2019-02-01.
//  Copyright © 2019 Irvanjit Singh. All rights reserved.
//

import UIKit

class NotationTableViewController: UITableViewController {
    
    var notations = [Notation]()
    var selectedNotationIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
//        self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        loadSampleData()
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
//            for i in indexPath {
//                notations.remove(at: i)
//            }
            tableView.deleteRows(at: [indexPath], with: .fade)
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

    }
    
    // MARK: Private methods
    
    private func loadSampleData() {
        let sampleSursA = ["", "", "", "", "N", "D", "P", "P", "M", "G", "R", "S", "N", "R", "S", "S", "N", "N", "R", "R", "G", "-", "G", "P", "P", "M", "G", "N", "R", "S", "S", "G", "-", "M", "M", "P", "-", "P", "P", "N", "D", "N", "S", "N", "D", "P", "P", "-"]
        
        let sampleWordsA = ["ha","ra","ha","ra","si","ma","ro","hu","sa","an","ta","go","pa","aa","la","aa","ha","ra","ha","ra","si","ma","ro","hu","sa","an","ta","go","pa","aa","la","aa","ha","ra","ha","ra","si","ma","ro","hu","sa","an","ta","go","pa","aa","la","aa"]
        
        let sampleSursB = ["S", "R", "G", "M", "N", "D", "P", "P", "M", "G", "R", "S", "N", "R", "S", "S", "N", "N", "R", "R", "G", "-", "G", "P", "P", "M", "G", "N", "R", "S", "S", "G", "-", "M", "M", "P", "-", "P", "P", "N", "D", "N", "S", "N", "D", "P", "P", "-"]
        
        let sampleWordsB = ["Ha","Ra","Ha","Ra","si","ma","ro","hu","sa","an","ta","go","pa","aa","la","aa","ha","ra","ha","ra","si","ma","ro","hu","sa","an","ta","go","pa","aa","la","aa","ha","ra","ha","ra","si","ma","ro","hu","sa","an","ta","go","pa","aa","la","aa"]
        
        guard let notation1 = Notation(name: "Shabad 1", surListA: sampleSursA, surListB: sampleSursB, wordListA: sampleWordsA, wordListB: sampleWordsB) else {
            fatalError("Unable to instantiate meal1")
        }
        guard let notation2 = Notation(name: "Shabad 2", surListA: sampleSursA, surListB: sampleSursB, wordListA: sampleWordsA, wordListB: sampleWordsB) else {
            fatalError("Unable to instantiate meal1")
        }
        guard let notation3 = Notation(name: "Bandish 1", surListA: sampleSursA, surListB: sampleSursB, wordListA: sampleWordsA, wordListB: sampleWordsB) else {
            fatalError("Unable to instantiate meal1")
        }
        notations += [notation1, notation2, notation3]
    }
 
}
