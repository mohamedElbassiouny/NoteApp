 //
//  NoteTableViewCell.swift
//  Notes App
//
//  Created by Mohamed Elbassiouny on 8/1/19.
//  Copyright © 2019 Mohamed Elbassiouny. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var noteNameLabel: UILabel!
    @IBOutlet weak var noteDescriptionLabel: UILabel!
    @IBOutlet weak var noteImageView: UIImageView!
     
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        shadowView.layer.shadowColor =  UIColor(red: 0/255.0 , green: 0/255.0 , blue: 0/255.0 , alpha: 1.0 ).cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0.75, height: 0.75)
        shadowView.layer.shadowRadius = 1.5
        shadowView.layer.shadowOpacity = 0.2
        shadowView.layer.cornerRadius = 2
        
        noteImageView.layer.cornerRadius = 2
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func configerCell(note: Note ) {
        self.noteNameLabel.text = note.noteName?.uppercased()
        self.noteDescriptionLabel.text = note.noteDescription
        self.noteImageView.image = UIImage(data: note.noteImage! as Data)
    }
}
