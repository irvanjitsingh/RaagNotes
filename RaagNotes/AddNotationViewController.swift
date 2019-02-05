//
//  AddNotationViewController.swift
//  RaagNotes
//
//  Created by Irvanjit Singh on 2019-02-01.
//  Copyright © 2019 Irvanjit Singh. All rights reserved.
//

import UIKit

class AddNotationViewController: UIViewController, UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: Properties
    
    @IBOutlet weak var notationTextField: UITextField!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var notationLabel: UILabel!
    @IBOutlet weak var inputToolbar: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var editMode: UISegmentedControl!
    @IBOutlet weak var notationSet: UISegmentedControl!
    
    let TAG_NAMEFIELD = 1
    let TAG_INPUTFIELD = 2
    let EDIT_MODE_NOTES = 0
    let EDIT_MODE_GURBANI = 1
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // CollectionView
    var editTypeIsNotes = true
    var selectedIndex: IndexPath? = nil
    var itemsPerRow: CGFloat = 4
    var subRowCount: Int = 4
    var mainRowCount: Int = 16
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    let reuseIdentifier = "cell"
//    var surList = NSMutableArray()
//    var gurbaniList = NSMutableArray()
    var surList = ["", "", "", "", "N", "D", "P", "P", "M", "G", "R", "S", "N", "R", "S", "S", "N", "N", "R", "R", "G", "-", "G", "P", "P", "M", "G", "N", "R", "S", "S", "G", "-", "M", "M", "P", "-", "P", "P", "N", "D", "N", "S", "N", "D", "P", "P", "-"]

    var gurbaniList = ["ha","ra","ha","ra","si","ma","ro","hu","sa","an","ta","go","pa","aa","la","aa","ha","ra","ha","ra","si","ma","ro","hu","sa","an","ta","go","pa","aa","la","aa","ha","ra","ha","ra","si","ma","ro","hu","sa","an","ta","go","pa","aa","la","aa"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        notationTextField.delegate = self
        notationTextField.tag = TAG_NAMEFIELD
        inputTextField.delegate = self
        inputTextField.tag = TAG_INPUTFIELD
        inputTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        inputToolbar.isHidden = true
        getNotationData()
    }
    
    func getNotationData() {
        break
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //hide keyboard
        if (textField.tag == TAG_INPUTFIELD) {
            editNextNote()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        editNoteAtIndex(indexPath: selectedIndex!)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.tag == TAG_NAMEFIELD) {
            notationLabel.text = notationTextField.text
        } else if (textField.tag == TAG_INPUTFIELD) {
//            editNextNote()
        }
    }
    
    // MARK: Actions
    
    @IBAction func setNotationLabelText(_ sender: UIButton) {
        notationLabel.text = notationTextField.text
    }
    
    @IBAction func finishEditingNotes(_ sender: UIButton) {
    }
    
    @IBAction func editTypeChanged(_ sender: UISegmentedControl) {
        inputTextField.text = ""
        inputTextField.resignFirstResponder()
        if (sender.selectedSegmentIndex == EDIT_MODE_NOTES) {
            editTypeIsNotes = true
            inputTextField.keyboardType = .numberPad
        } else {
            editTypeIsNotes = false
            inputTextField.keyboardType = .alphabet
        }
        inputTextField.becomeFirstResponder()
    }
    
    @IBAction func noteSetChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            surList = ["S", "R", "G", "M"]
            gurbaniList = ["S", "R", "G", "M"]
        case 1:
            surList = ["M", "D", "N", "S"]
            gurbaniList = ["S", "R", "G", "M"]
        case 2:
            surList = ["S", "-", "-", "-"]
            gurbaniList = ["S", "R", "G", "M"]
        default:
            break
        }
        collectionView.reloadData()
    }
    
    @IBAction func removeNote(_ sender: UIButton) {
        if (!surList.isEmpty) {
            surList.remove(at: selectedIndex!.row)
        }
        if (!gurbaniList.isEmpty) {
            gurbaniList.remove(at: selectedIndex!.row)
        }
        collectionView.reloadData()
    }
    
    
    @IBAction func doneEditingNotes(_ sender: UIButton) {
        endEditingNotes()
        selectedIndex = nil
        inputTextField.resignFirstResponder()
        inputToolbar.isHidden = true
    }
    
    func enableEditMode() {
        inputToolbar.isHidden = false
    }
    
    func startEditingNotes() {
        // editing is not yet enabled
        inputTextField.becomeFirstResponder()
        inputTextField.text = ""
    }
    
    func editNextNote() {
        deselectCellAtIndex(index: selectedIndex!)
        let nextIndex = (selectedIndex?.row)! + 1
        selectedIndex?.row = nextIndex
        collectionView.selectItem(at: selectedIndex, animated: true, scrollPosition: .top)
        selectCellAtIndex(index: selectedIndex!)
    }
    
    func editNoteAtIndex(indexPath: IndexPath) {
        if (editTypeIsNotes) {
            surList[selectedIndex!.row] = inputTextField.text ?? ""
        } else {
            gurbaniList[selectedIndex!.row] = inputTextField.text ?? ""
        }
        collectionView.reloadItems(at: [selectedIndex!])
    }
    
    func endEditingNotes() {
        inputTextField.text = ""
        inputTextField.resignFirstResponder()
        selectedIndex = nil
    }
    
    func exitEditMode() {
        inputToolbar.isHidden = true
    }
    
    func selectCellAtIndex(index: IndexPath) {
        let cell = collectionView.cellForItem(at: index)
        cell?.backgroundColor = UIColor.gray
        if (selectedIndex == nil) {
            enableEditMode()
        }
        selectedIndex = index
        startEditingNotes()
    }
    
    func deselectCellAtIndex(index: IndexPath) {
        let cell = collectionView.cellForItem(at: index)
        cell?.backgroundColor = appDelegate.blueColor
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.surList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! NotationCollectionViewCell
        
        cell.surLabel.text = self.surList[indexPath.item]
        cell.surLabel.textColor = UIColor.white
        cell.gurbaniLabel.text = self.gurbaniList[indexPath.item]
        cell.gurbaniLabel.textColor = UIColor.white
        cell.mainSeparator.backgroundColor = UIColor.clear
        cell.subSeparator.backgroundColor = UIColor.clear
        if (cell.gurbaniLabel.text == "") {
            cell.alpha = 0.7
        } else {
            cell.alpha = 1
        }
        if ((indexPath.row+1) % subRowCount == 0) {
            cell.subSeparator.backgroundColor = UIColor.black
        }
        if ((indexPath.row+1) % mainRowCount == 0) {
            cell.mainSeparator.backgroundColor = UIColor.lightGray
        }
        cell.backgroundColor = appDelegate.blueColor
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectCellAtIndex(index: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        deselectCellAtIndex(index: indexPath)
    }

//    var sampleDataCount = mainRowCount*5
//    func populateSampleData() {
//        for i in (0 ..< sampleDataCount) {
//            surList.append("--")
//            gurbaniList.append("--")
//        }
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
