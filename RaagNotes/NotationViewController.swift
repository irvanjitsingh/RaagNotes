//
//  AddNotationViewController.swift
//  RaagNotes
//
//  Created by Irvanjit Singh on 2019-02-01.
//  Copyright © 2019 Irvanjit Singh. All rights reserved.
//

import UIKit
import os.log

class NotationViewController: UIViewController, UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: Properties
    
    @IBOutlet weak var notationTextField: UITextField!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var editToolbar: UIView!
    @IBOutlet weak var editMode: UISegmentedControl!
    @IBOutlet weak var notationSet: UISegmentedControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!

    
    
    
    let TAG_NAMEFIELD = 1
    let TAG_INPUTFIELD = 2
    
    let EDIT_MODE_NOTES = 0
    let EDIT_MODE_GURBANI = 1
    
    let VIEW_MODE_ASTHAEE = 0
    let VIEW_MODE_ANTRAA_1 = 1
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // CollectionView
    var editModeEnabled = false
    var editTypeIsNotes = true
    var selectedNotationList: Int = 0
    var selectedIndex: IndexPath? = nil
    var itemsPerRow: CGFloat = 4
    var subRowCount: Int = 4
    var mainRowCount: Int = 16
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    let reuseIdentifier = "cell"
//    var surList = NSMutableArray()
//    var gurbaniList = NSMutableArray()
    
    
    //MARK: DATA VARIABLES
    
    var notation: Notation?
    var selectedNotationIndex: Int?
    var surListA: [String] = []
    var surListB: [String] = []
    var wordListA: [String] = []
    var wordListB: [String] = []
    var surData: [String] = []
    var wordData: [String] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        notationTextField.delegate = self
        notationTextField.tag = TAG_NAMEFIELD
        inputTextField.delegate = self
        inputTextField.tag = TAG_INPUTFIELD
        inputTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        editToolbar.isHidden = true
        editToolbar.layer.cornerRadius = 5
        getNotationData()
    }
    
    func createSampleData() {
        surListA = ["", "", "", "", "N", "D", "P", "P", "M", "G", "R", "S", "N", "R", "S", "S", "N", "N", "R", "R", "G", "-", "G", "P", "P", "M", "G", "N", "R", "S", "S", "G", "-", "M", "M", "P", "-", "P", "P", "N", "D", "N", "S", "N", "D", "P", "P", "-"]
        
        wordListA = ["ha","ra","ha","ra","si","ma","ro","hu","sa","an","ta","go","pa","aa","la","aa","ha","ra","ha","ra","si","ma","ro","hu","sa","an","ta","go","pa","aa","la","aa","ha","ra","ha","ra","si","ma","ro","hu","sa","an","ta","go","pa","aa","la","aa"]
        
        surListB = ["S", "R", "S", "S", "N", "D", "P", "P", "M", "G", "R", "S", "N", "R", "S", "S", "N", "N", "R", "R", "G", "-", "G", "P", "P", "M", "G", "N", "R", "S", "S", "G", "-", "M", "M", "P", "-", "P", "P", "N", "D", "N", "S", "N", "D", "P", "P", "-"]
        
        wordListB = ["ha","ra","ha","ra","si","ma","ro","hu","sa","an","ta","go","pa","aa","la","aa","ha","ra","ha","ra","si","ma","ro","hu","sa","an","ta","go","pa","aa","la","aa","ha","ra","ha","ra","si","ma","ro","hu","sa","an","ta","go","pa","aa","la","aa"]
    }
    
    func getNotationData() {
        if selectedNotationIndex == -1 {
            editModeEnabled = true
            createSampleData()
        } else {
            editModeEnabled = false
            surListA = notation?.surListA ?? [""]
            surListB = notation?.surListB ?? [""]
            wordListA = notation?.wordListA ?? [""]
            wordListB = notation?.wordListB ?? [""]
            self.navigationItem.title = notation?.name
        }
        surData = surListA
        wordData = wordListA
        toggleEditMode(isEnabled: editModeEnabled)
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
            editShabadName(tf: textField)
        } else if (textField.tag == TAG_INPUTFIELD) {
//            editNextNote()
        }
    }
    
    func editShabadName(tf: UITextField) {
        if (tf.text != "") {
            self.navigationItem.title = tf.text
        }
    }
    
    // MARK: Actions
    
    
    @IBAction func editButtonClicked(_ sender: UIBarButtonItem) {
        editModeEnabled = !editModeEnabled
        toggleEditMode(isEnabled: editModeEnabled)
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
        selectCellAtIndex(index: selectedIndex!)
    }
    
    @IBAction func noteSetChanged(_ sender: UISegmentedControl) {
        selectedNotationList = sender.selectedSegmentIndex
        switch selectedNotationList {
        case 0:
            //ASTHAEE SELECTED, SAVE ANTRAA FIRST
            surListB = surData
            wordListB = wordData
            
            //THEN LOAD ASTHAEE DATA
            surData = surListA
            wordData = wordListA
        case 1:
            //ANTRAA SELECTED, SAVE ASTHAEE FIRST
            surListA = surData
            wordListB = wordData
            
            //THEN LOAD ANTRAA DATA
            surData = surListB
            wordData = wordListB
        case 2:
            break
        default:
            break
        }
        collectionView.reloadData()
    }
    
    @IBAction func removeNote(_ sender: UIButton) {
        if (!surData.isEmpty) {
            surData.remove(at: selectedIndex!.row)
        }
        if (!wordData.isEmpty) {
            wordData.remove(at: selectedIndex!.row)
        }
        collectionView.reloadData()
    }
    
    
    @IBAction func doneEditingNotes(_ sender: UIButton) {
        endEditingNotes()
        selectedIndex = nil
        inputTextField.resignFirstResponder()
        editToolbar.isHidden = true
        collectionView.reloadData()
    }
    
    func toggleEditMode(isEnabled: Bool) {
        collectionView.allowsSelection = isEnabled
        notationTextField.isHidden = !isEnabled
        saveButton.isEnabled = isEnabled
        editButton.isEnabled = !isEnabled
        if !isEnabled {
            editToolbar.isHidden = true
        }
        collectionView.reloadData()
    }
    
    func startEditingNotes() {
        // editing is not yet enabled
        let cell = collectionView.cellForItem(at: selectedIndex!) as! NotationCollectionViewCell
        var placeholder: String
        if (editTypeIsNotes) {
            placeholder = cell.surLabel.text ?? ""
        } else {
            placeholder = cell.gurbaniLabel.text ?? ""
        }
        inputTextField.text = placeholder
        inputTextField.becomeFirstResponder()
    }
    
    func editNextNote() {
        deselectCellAtIndex(index: selectedIndex!)
        let nextIndex = (selectedIndex?.row)! + 1
        if (nextIndex <= surData.count) {
            selectedIndex?.row = nextIndex
            collectionView.selectItem(at: selectedIndex, animated: true, scrollPosition: .top)
            selectCellAtIndex(index: selectedIndex!)
        } else {
            endEditingNotes()
        }
    }
    
    func editNoteAtIndex(indexPath: IndexPath) {
        let textToInsert = inputTextField.text ?? ""
        if (editTypeIsNotes) {
            surData[selectedIndex!.row] = textToInsert
            if (selectedNotationList == VIEW_MODE_ASTHAEE) {
                surListA[selectedIndex!.row] = textToInsert
            } else {
                surListB[selectedIndex!.row] = textToInsert
            }
        } else {
            wordData[selectedIndex!.row] = textToInsert
            if (selectedNotationList == VIEW_MODE_ASTHAEE) {
                wordListA[selectedIndex!.row] = textToInsert
            } else {
                wordListB[selectedIndex!.row] = textToInsert
            }
        }
        collectionView.reloadItems(at: [selectedIndex!])
//        selectCellAtIndex(index: indexPath)
    }
    
    func endEditingNotes() {
        inputTextField.text = ""
        inputTextField.resignFirstResponder()
        selectedIndex = nil
    }
    
    func exitEditMode() {
        editToolbar.isHidden = true
    }
    
    func selectCellAtIndex(index: IndexPath) {
        let cell = collectionView.cellForItem(at: index)
        cell?.backgroundColor = UIColor.gray
        if (selectedIndex == nil) {
            self.editToolbar.isHidden = false
        }
        selectedIndex = index
        startEditingNotes()
    }
    
    func deselectCellAtIndex(index: IndexPath) {
        let cell = collectionView.cellForItem(at: index)
        cell?.backgroundColor = appDelegate.blueColor
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.surData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! NotationCollectionViewCell
        
        cell.surLabel.text = self.surData[indexPath.item]
        cell.surLabel.textColor = UIColor.white
        cell.gurbaniLabel.text = self.wordData[indexPath.item]
        cell.gurbaniLabel.textColor = UIColor.white
        cell.mainSeparator.backgroundColor = UIColor.clear
        cell.subSeparator.backgroundColor = UIColor.clear
        if (cell.surLabel.text == "") {
            cell.alpha = 0.4
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        // save currently visible edited data
        if (notationTextField.text != "" && !(notationTextField.text?.isEmpty ?? true)) {
            self.navigationItem.title = notationTextField.text
        }
        let name = self.navigationItem.title ?? "New Bandish"
        notation = Notation(name: name, surListA: surListA, surListB: surListB, wordListA: wordListA, wordListB: wordListB)!
    }

}
