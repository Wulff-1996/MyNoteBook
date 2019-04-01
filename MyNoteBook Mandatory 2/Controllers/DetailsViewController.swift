//
//  DetailsViewController.swift
//  MyNoteBook Mandatory 2
//
//  Created by Jakob Wulff on 22/02/2019.
//  Copyright © 2019 Jakob Wulff. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var currentIndex: Int!
    var note: Note!
    
    @IBOutlet weak var noteTextField: UITextView!
   
    @IBOutlet weak var editBtn: UIBarButtonItem!
    
    @IBOutlet weak var headlineTextField: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //  check if currentIndex is out of range
        // if not, then load the text to be presented in the textView
        // if it is , present some error message in the textView(not required)
        
        if currentIndex == -1{
            fatalError("currentIndex = -1, index out of bounds")
        }
        else{
            note = global.notes[currentIndex]
        }
        
        headlineTextField.text = note.headline
        noteTextField.text = note.note
        
        headlineTextField.isEditable = false
        noteTextField.isEditable = false
        
        editBtn.title = "Edit"
        
    }
    
    @IBAction func rightButtonTapped(_ sender: Any) {
        if(editBtn.title == "Edit")
        {
            headlineTextField.isEditable = true
            noteTextField.isEditable = true
            
            noteTextField.becomeFirstResponder()
            editBtn.title = "Save"
        }
        else{
            //  remove the old note
            global.deleteNote(note: self.note)
            
            //  save the updated note
            let updatedNote = Note(headline: headlineTextField.text!, note: noteTextField.text!)
            global.saveNewNote(note: updatedNote)
            global.notes[currentIndex] = updatedNote
            
            self.navigationController?.popViewController(animated: true)
        }
    }
}
