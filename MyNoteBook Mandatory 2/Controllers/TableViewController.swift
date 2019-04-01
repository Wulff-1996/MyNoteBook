//
//  TableViewController.swift
//  MyNoteBook Mandatory 2
//
//  Created by Jakob Wulff on 19/02/2019.
//  Copyright © 2019 Jakob Wulff. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class Global {
    
    var notes = [Note]()
    var fstore : Firestore!
    
    func saveNewNote(note: Note){
        fstore.collection("users").document(Auth.auth().currentUser!.email!).setData([ "\(note.headline!)" : note.note! ], merge: true)
    }
    
    func loadNotes(tableView: UITableView){
        let docRef = fstore.collection("users").document(Auth.auth().currentUser!.email!)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dictionary = document.data()!
                
                for data in dictionary{
                    let note = Note(headline: data.key, note: data.value as! String)
                    
                    //  add if not already in list
                    if !self.notes.contains(note){
                         self.notes.append(note)
                    }
                }
                tableView.reloadData()
            }
            else {
                
                //  create a doc
                self.fstore.collection("users").document(Auth.auth().currentUser!.email!).setData(["First note" : "type your note here.."])
                self.loadNotes(tableView: tableView)
            }
        }
    }
    
    func reloadTableData(tableView: UITableView){
        tableView.reloadData()
    }
    
    func deleteNote(note: Note){
        fstore.collection("users").document(Auth.auth().currentUser!.email!).updateData([
            "\(note.headline!)": FieldValue.delete(),
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
    }
    
    func getNote(index: Int) -> Note{
        return notes[index]
    }
}

let global = Global()

class TableViewController: UITableViewController {
    
    //  references
    var fstore : Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fstore = Firestore.firestore()
        global.fstore = fstore
        
        global.loadNotes(tableView: self.tableView)

//        // Uncomment the following line to preserve selection between presentations
//        self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return global.notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Configure the cell...
        cell.textLabel!.text = "\(indexPath.row + 1): \(global.notes[indexPath.row].headline!)"
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let note : Note = global.getNote(index: indexPath.row)
            
            // Delete the row from the data source
            global.notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            global.deleteNote(note: note)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showDetails" {
            if let destination = segue.destination as? DetailsViewController {
                destination.currentIndex = tableView.indexPathForSelectedRow?.row ?? -1
            }
        }
    }
    
    //  show details when row tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetails", sender: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    @IBAction func doBtnSignout(_ sender: Any) {
        //  clear data
        global.notes = []
        
        do{
            try Auth.auth().signOut()
            performSegue(withIdentifier: "showSignin", sender: nil)
        }
        catch{}
    }
}
