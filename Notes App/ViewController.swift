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
    
    var notesFetchedResultController: NSFetchedResultsController<Note>!
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
    
    @IBAction func saveButtonWasPressed(_ sender: UIBarButtonItem) {
        if noteNameLabel.text == "" || noteNameLabel.text == "NOTE NAME" || noteDescriptionLabel.text == "" || noteDescriptionLabel.text == "Note Description....." {
            let alertController = UIAlertController(title: "Missing Information", message: "You let one or more fields empty. Please make sure that all fields are filled", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            
            alertController.addAction(okAction)
            
            self.present(alertController,animated: true, completion: nil)
        }else{
            if (isExisting == false) {
                let noteName = noteNameLabel.text
                let noteDiscription = noteDescriptionLabel.text
                
                if let moc  = managedObjectContext{
                    let note = Note(context: moc)
                    
                    let imagedata = UIImage()
                    if let data = imagedata.jpegData(compressionQuality: 0.75){
                        note.noteImage = data as Data
                    }
                    
                    note.noteName  = noteName
                    note.noteDescription = noteDiscription
                    
                    saveCoreData {
                        let ispresentingInAddNoteMode = self.presentingViewController is UINavigationController
                        
                        if ispresentingInAddNoteMode{
                            self.dismiss(animated: true, completion: nil)
                        }else{
                            self.navigationController!.popViewController(animated: true)
                        }
                    }
                }
            }
            else if (isExisting == true){
                let note = self.note
                
                let managedObject = note
                managedObject!.setValue(noteNameLabel.text, forKey: "noteName")
                managedObject!.setValue(noteDescriptionLabel.text, forKey: "noteDescription")
                
                let imagedata = UIImage()
                if let data = imagedata.jpegData(compressionQuality: 0.75){
                    managedObject!.setValue(data, forKey: "noteImage")
                }
                do{
                    try context.save()
                    
                    let ispresentingInAddNoteMode = self.presentingViewController is UINavigationController
                    
                    if ispresentingInAddNoteMode{
                        self.dismiss(animated: true, completion: nil)
                    }else{
                        self.navigationController!.popViewController(animated: true)
                    }
                }
                catch{
                    print("failed to update saved note")
                }
            }
        }
    }

    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        let ispresentingInAddNoteMode = self.presentingViewController is UINavigationController
        
        if ispresentingInAddNoteMode{
            self.dismiss(animated: true, completion: nil)
        }else{
            self.navigationController!.popViewController(animated: true)
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n"){
            textView.resignFirstResponder()
        }
        return false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(textView.text == "Note Description....."){
            textView.text =  ""
        }
    }
        
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            self.noteImage.image = image
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension UITextField{
    func setBottomBorder(){
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor(red: 245.0/255.0, green: 79.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
        
    }
}



