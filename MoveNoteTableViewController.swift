//
//  MoveNoteTableViewController.swift
//  MirrorNote
//
//  Created by Gleb Kalachev on 3/18/17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit
import CoreData

class MoveNoteTableViewController: UITableViewController {
   
   @IBAction func cancel(_ sender: UIBarButtonItem) {}
   
   
   let fetchRequset: NSFetchRequest<Folder> = Folder.fetchRequest()
   var folderList: [Folder]!
   
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      
      
   }
   
   // MARK: - Table view data source
   
   override func numberOfSections(in tableView: UITableView) -> Int {
      // #warning Incomplete implementation, return the number of sections
      return 1
   }
   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      // #warning Incomplete implementation, return the number of rows
      return folderList.count
   }
   
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FoldersTableViewCell
      
      let info = folderList[indexPath.row]
      
      cell.folder = info
      
      //Деактивируем Default Folder
      if cell.nameOfFolderLabel.text == "Default Folder" {
         cell.nameOfFolderLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
         cell.quantityOfElementsInFolderLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
      }
      
      return cell
   }
   
   
    
   
}
