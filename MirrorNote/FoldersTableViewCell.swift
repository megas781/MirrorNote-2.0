//
//  FoldersTableViewCell.swift
//  MirrorNote
//
//  Created by Gleb Kalachev on 26.02.17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit

class FoldersTableViewCell: UITableViewCell {
   @IBOutlet weak var nameOfFolderLabel: UILabel!
   @IBOutlet weak var quantityOfElementsInFolderLabel: UILabel!
   
   var folder : Folder! {
      willSet {
         nameOfFolderLabel.text = newValue.name
         quantityOfElementsInFolderLabel.text = String(newValue.notes!.count)
         if quantityOfElementsInFolderLabel.text! == "0" {
            quantityOfElementsInFolderLabel.text! = ""
         }
      }
   }
   
   override func awakeFromNib() {
      super.awakeFromNib()
      
   }
   
   override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
      
      
   }
   
}
