//
//  ViewController.swift
//  Notes App
//
//  Created by Mohamed Elbassiouny on 7/29/19.
//  Copyright © 2019 Mohamed Elbassiouny. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController ,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate{

    @IBOutlet weak var noteInfoView: UIView!
    @IBOutlet weak var noteImageView: UIView!
    @IBOutlet weak var noteNameLabel: UITextField!
    @IBOutlet weak var noteDescriptionLabel: UITextView!
    @IBOutlet weak var noteImage: UIImageView!
    
    var managedObjectContext: NSManagedObjectContext? {
        return(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    var notesFetchedResultController: NSFetchedResultsController<Note>
    var notes = [Note]()
    var note: Note?
    var isExisting = false
    var indexPath: Int?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let note = note {
            noteNameLabel.text = note.noteName
            noteDescriptionLabel.text = note.noteDescription
            noteImage.image = UIImage(data: note.noteImage! as Data)
        }
        
        if noteNameLabel.text != "" {
            isExisting = true
        }
        
        //delegate
        noteNameLabel.delegate = self
        noteDescriptionLabel.delegate = self
        
        //Styles
        noteInfoView.layer.shadowColor = UIColor(red: 0/255.0 , green: 0/255.0 , blue: 0/255.0 , alpha: 1.0 ).cgColor
        noteInfoView.layer.shadowOffset = CGSize(width: 0.75, height: 0.75)
        noteInfoView.layer.shadowRadius = 1.5
        noteInfoView.layer.shadowOpacity = 0.2
        noteInfoView.layer.cornerRadius = 2
        
        noteImageView.layer.shadowColor = UIColor(red: 0/255.0 , green: 0/255.0 , blue: 0/255.0 , alpha: 1.0 ).cgColor
        noteImageView.layer.shadowOffset = CGSize(width: 0.75, height: 0.75)
        noteImageView.layer.shadowRadius = 1.5
        noteImageView.layer.shadowOpacity = 0.2
        noteImageView.layer.cornerRadius = 2
        
        noteImage.layer.cornerRadius = 2
        
        noteNameLabel.setBottomBorder()
        
    }
    
    //corData
    func saveCoreData(completion: @escaping ()->Void) {
        managedObjectContext!.perform {
            do{
                try self.managedObjectContext?.save()
                completion()
                print("Note Saved")
            }
            catch let error {
                print("Coldn't save to core data\(error.localizedDescription )")
            }
        }
    }

    @IBAction func pickImageButtonWasPressed(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        
        let alertController = UIAlertController(title: "add an image", message: "choose from", preferredStyle: .actionSheet)
        
        let camerAction = UIAlertAction(title: "camera", style: .default) {(action) in
            pickerController.sourceType = .camera
            self.present(pickerController,animated: true, completion: nil)
        }
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) {(action) in
            pickerController.sourceType = .photoLibrary
            self.present(pickerController,animated: true, completion: nil)
        }
        
        let savePhotoAction = UIAlertAction(title: "save photo album", style: .default) {(action) in
            pickerController.sourceType = .savedPhotosAlbum
            self.present(pickerController,animated: true, completion: nil)
        }
         
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil )
        
        alertController.addAction(camerAction)
        alertController.addAction(photoLibraryAction)
        alertController.addAction(savePhotoAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
}


