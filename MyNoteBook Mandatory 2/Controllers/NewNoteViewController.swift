//
//  NewNoteViewController.swift
//  MyNoteBook Mandatory 2
//
//  Created by Jakob Wulff on 22/02/2019.
//  Copyright © 2019 Jakob Wulff. All rights reserved.
//

import UIKit

class NewNoteViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var headlineLabel: UILabel!
    
    @IBOutlet weak var noteLabel: UILabel!
    var note: Note!
    var isSaved: BooleanLiteralType! = false
    
    @IBOutlet weak var headlineTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextView!
    
    @IBOutlet weak var savebtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        savebtn.isEnabled = false
        
        headlineTextField.addTarget(self, action : #selector(textFieldDidChange),              for : .editingChanged)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        headlineTextField.attributedPlaceholder = NSAttributedString(string: "type headline here...")
        
        
        
        headlineTextField.placeholder = "type Headline here..."
        headlineTextField.becomeFirstResponder()
        
        noteTextField.text = "type your note here..."
        noteTextField.textColor = UIColor.lightGray
        noteTextField.font = UIFont(name: "verdana", size: 13.0)
        noteTextField.returnKeyType = .done
        noteTextField.delegate = self
    }
    
    //MARK:- UITextViewDelegates
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if noteTextField.text == "type your note here..." {
            noteTextField.text = ""
            noteTextField.font = UIFont(name: "verdana", size: 18.0)
        }
        setSaveButtonActive()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            noteTextField.resignFirstResponder()
        }
        setSaveButtonActive()
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if noteTextField.text == "" {
            noteTextField.text = "type your note here..."
            noteTextField.textColor = UIColor.lightGray
            noteTextField.font = UIFont(name: "verdana", size: 13.0)
        }
        setSaveButtonActive()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }

    @IBAction func saveNote(_ sender: Any) {
        
        let note = Note(headline: headlineTextField.text!, note: noteTextField.text!)
        
        global.saveNewNote(note: note)
        global.notes.append(note)

        //  go back to the tableviw agian
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func textFieldDidChange() {
        setSaveButtonActive()
    }
    
    func setSaveButtonActive(){
        if ((headlineTextField.text!.count) > 0 &&
            noteTextField.text!.count > 0 &&
            noteTextField.text != "type your note here...")
        {
            savebtn.isEnabled = true
        }
        else{ savebtn.isEnabled = false}
    }
}
