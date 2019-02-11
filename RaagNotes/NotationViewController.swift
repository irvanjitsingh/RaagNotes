//
//  AddNotationViewController.swift
//  RaagNotes
//
//  Created by Irvanjit Singh on 2019-02-01.
//  Copyright © 2019 Irvanjit Singh. All rights reserved.
//

import UIKit
import os.log

class NotationViewController: UIViewController, UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, KeyboardDelegate {
    
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
    
    var notationKeyboard: Keyboard?
    
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
        
        notationKeyboard = Keyboard(frame: CGRect(x: 0, y: 0, width: 0, height: 260))
        notationKeyboard?.delegate = self
        inputTextField.delegate = self
        inputTextField.tag = TAG_INPUTFIELD
        inputTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        inputTextField.inputView = notationKeyboard
        editToolbar.isHidden = true
        editToolbar.layer.cornerRadius = 5
        getNotationData()
        setupViewResizerOnKeyboardShown()
    }
    
    func fetchData() {
        surListA = notation?.surListA ?? [""]
        surListB = notation?.surListB ?? [""]
        wordListA = notation?.wordListA ?? [""]
        wordListB = notation?.wordListB ?? [""]
        self.navigationItem.title = notation?.name
    }
    
    func fetchSampleData() {
        surListA = NotationTableViewController.sample1SursA
        surListB = NotationTableViewController.sample1SursB
        wordListA = NotationTableViewController.sample1WordsA
        wordListB = NotationTableViewController.sample1WordsB
        self.navigationItem.title = String(format: "%@%d", "Teentaal Bandish ", Int.random(in: 0 ... 10))
    }
    
    func getNotationData() {
        //if there is no index passed from previous TableVC
        // then this is a new shabad, enable edit mode
        editModeEnabled = (selectedNotationIndex == -1)
        if editModeEnabled {
            fetchSampleData()
        } else {
            fetchData()
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
        editTypeIsNotes = sender.selectedSegmentIndex == EDIT_MODE_NOTES
        inputTextField.text = ""
        inputTextField.resignFirstResponder()
        if (editTypeIsNotes) {
            inputTextField.inputView = notationKeyboard
        } else {
            inputTextField.inputView = nil
        }
        inputTextField.becomeFirstResponder()
        selectCellAtIndex(index: selectedIndex!)
    }
    
    @IBAction func noteSetChanged(_ sender: UISegmentedControl) {
        selectedNotationList = sender.selectedSegmentIndex
        switch selectedNotationList {
        case VIEW_MODE_ASTHAEE:
            surData = surListA
            wordData = wordListA
        case VIEW_MODE_ANTRAA_1:
            surData = surListB
            wordData = wordListB
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
    
    // required method for keyboard delegate protocol
    func keyWasTapped(character: String) {
        switch character {
        case "return":
            self.textFieldShouldReturn(inputTextField)
        case "ਖਾਲੀ":
            inputTextField.insertText(" ")
        case "⌫":
            inputTextField.deleteBackward()
        case "🅰":
            inputTextField.resignFirstResponder()
            inputTextField.inputView = nil
            inputTextField.becomeFirstResponder()
        case "̣⇧":
            inputTextField.insertText("̣")
        case "̇⇧":
            inputTextField.insertText("̇")
        default:
            inputTextField.insertText(character)
        }
    }
    
    func toggleEditMode(isEnabled: Bool) {
        collectionView.allowsSelection = isEnabled
        notationTextField.isHidden = !isEnabled
        saveButton.isEnabled = isEnabled
        editButton.isEnabled = !isEnabled
        if !isEnabled {
            editToolbar.isHidden = true
        } else {
            notationTextField.text = self.navigationItem.title
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
        if (editTypeIsNotes && inputTextField.inputView == nil) {
            inputTextField.resignFirstResponder()
            inputTextField.inputView = notationKeyboard
        }
        inputTextField.becomeFirstResponder()
    }
    
    func editNextNote() {
        deselectCellAtIndex(index: selectedIndex!)
        let nextIndex = (selectedIndex?.row)! + 1
        if (nextIndex < surData.count) {
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
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
//        let availableWidth = view.frame.width - paddingSpace
//        let widthPerItem = availableWidth / itemsPerRow
//        return CGSize(width: widthPerItem, height: widthPerItem)
//    }
    
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
        colorCell(cell: cell)
        if ((indexPath.row+1) % subRowCount == 0) {
            cell.subSeparator.backgroundColor = UIColor.black
        }
        if ((indexPath.row+1) % mainRowCount == 0) {
            cell.mainSeparator.backgroundColor = UIColor.lightGray
        }
        cell.backgroundColor = appDelegate.blueColor
        cell.layer.cornerRadius = 8
        
        let dashedBorder = CAShapeLayer()
        dashedBorder.strokeColor = UIColor.black.cgColor
        dashedBorder.lineWidth = 8
        dashedBorder.lineDashPattern = [2, 2]
        dashedBorder.frame = cell.bounds
        dashedBorder.fillColor = nil
        dashedBorder.path = UIBezierPath(rect: cell.bounds).cgPath
        if (editModeEnabled) {
            cell.layer.addSublayer(dashedBorder)
        } else {
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.borderWidth = 1
        }
        
        return cell
    }
    
    private func colorCell(cell: NotationCollectionViewCell) {
        switch cell.surLabel.text {
        case "Sa":
            cell.backgroundColor = appDelegate.blueColor
        default:
            break
        }
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
    
    func setupViewResizerOnKeyboardShown() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(NotationViewController.keyboardWillShowForResizing),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(NotationViewController.keyboardWillHideForResizing),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc func keyboardWillShowForResizing(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let window = self.view.window?.frame {
            // We're not just minusing the kb height from the view height because
            // the view could already have been resized for the keyboard before
            self.view.frame = CGRect(x: self.view.frame.origin.x,
                                     y: self.view.frame.origin.y,
                                     width: self.view.frame.width,
                                     height: window.origin.y + window.height - keyboardSize.height)
        } else {
            debugPrint("We're showing the keyboard and either the keyboard size or window is nil: panic widely.")
        }
    }
    
    @objc func keyboardWillHideForResizing(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let viewHeight = self.view.frame.height
            self.view.frame = CGRect(x: self.view.frame.origin.x,
                                     y: self.view.frame.origin.y,
                                     width: self.view.frame.width,
                                     height: viewHeight + keyboardSize.height)
        } else {
            debugPrint("We're about to hide the keyboard and the keyboard size is nil. Now is the rapture.")
        }
    }


}
