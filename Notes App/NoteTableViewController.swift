//
//  NoteTableViewController.swift
//  Notes App
//
//  Created by Mohamed Elbassiouny on 8/1/19.
//  Copyright © 2019 Mohamed Elbassiouny. All rights reserved.
//

import UIKit
import CoreData
class NoteTableViewController: UITableViewController {
    
    var notes = [Note]()
    var manageObjectContext : NSManagedObjectContext{
        return(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = UIColor(red: 245.0/255.0 , green: 245.0/255.0 , blue: 245.0/255.0 , alpha: 1.0 )

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        returnNotes()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteTableViewCell", for: indexPath)
        let note : Note = notes[indexPath.row]
        cell.configerCell(note: note)
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        tableView.reloadData()
    }

    func returnNotes(){
        manageObjectContext.perform {
            self.fetchNotesFromCoreData{ (notes) in
                if let notes = notes{
                    self.notes = notes
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func fetchNotesFromCoreData(completion: @escaping([Note]) -> Void) {
        manageObjectContext.perform {
            var notes = [Note]()
            let request : NSFetchRequest<Note> = Note.fetchRequest()
            
            do{
                notes = try self.manageObjectContext.fetch(request)
                completion(notes)
            }catch{
                print("sorry we cant load data :\(error.localizedDescription)")
            }
            
        }
    }

   

}
