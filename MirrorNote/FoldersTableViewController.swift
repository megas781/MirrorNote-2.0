//
//  FoldersTableViewController.swift
//  MirrorNote
//
//  Created by Gleb Kalachev on 26.02.17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit
import CoreData

var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

class FoldersTableViewController: UITableViewController, UITextFieldDelegate {
   
   @IBAction func refresh(_ sender: UIBarButtonItem) {
      
      print("current count = \(navigationController?.toolbar.items?.count)")
      
   }
   
   
   @IBAction func addNewFolder(_ sender: UIBarButtonItem) {
      
        
      if ac.actions.count < 2 {
         //Переопределим кнопку create
         create = UIAlertAction(title: "Create", style: .default, handler: { (action) in
            let newFolder = Folder(context: context)
            
            newFolder.name = ac.textFields!.first!.text!
            newFolder.dateOfCreation = Date() as NSDate
            //Всегда при объявлении объявляй .notes как [], чтобы не было nil. Это может пригодиться
            newFolder.notes = []
            
            self.folderList.append(newFolder)
            
            do {
               try context.save()
               try self.folderFetchController.performFetch()
               ac.textFields!.first!.text = ""
            } catch let error as NSError {
               print("Не удалось сохранить данные: \(error.localizedDescription)")
            }
            
            self.tableView.reloadData()
            
            create.isEnabled = false
         })
         
         create.isEnabled = false
         
         ac.addAction(create)
      }
      
      
      self.present(ac, animated: true, completion: nil)
      
   }
   
   var folderFetchRequest: NSFetchRequest<Folder>! = Folder.fetchRequest()
   
   var folderFetchController: NSFetchedResultsController<Folder>!
   
   var folderList: [Folder]! = []
   
   
   //Это на всякий случай
   var noteFetchController: NSFetchedResultsController<Note>!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      print("count = \(navigationController?.toolbar.items?.count)")
      
      //Важное
      tableView.tableFooterView = UIView(frame: .zero)
      //Добавляем лишь однажды
      ac.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
      //Лишь однажды добавляем textField
      ac.addTextField { (textField) in
         textField.keyboardType = .default
         textField.placeholder = "Folder name"
         textField.delegate = self
      }
      
      //Смотрим: если хранилище с папками пустое, то создаем новую папку под названием "Default folder"
      do {
         folderFetchRequest.sortDescriptors = []
         folderFetchController = NSFetchedResultsController(fetchRequest: folderFetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
         try folderFetchController.performFetch()
         folderList = folderFetchController.fetchedObjects
         //Если хранилище пустое, то...
         if folderList.isEmpty {
            
            let defaultFolder = Folder(context: context)
            
            defaultFolder.name = "Default Folder"
            defaultFolder.dateOfCreation = Date() as NSDate
            defaultFolder.notes = []
            
            folderList.append(defaultFolder)
            
            //Создана дефолтная папка, добавлена в folderList, значит теперь сохраняем контект
            do {
               try context.save()
            } catch let error as NSError {
               print("Не удалось сохранить данные: \(error.localizedDescription)")
            }
            
            try folderFetchController.performFetch()
            
         } else {
            // do nothing
            print("Успешное извлеение данных из хранилища")
         }
         
      } catch let error as NSError {
         print("Не удалось получить данные о папках: \(error.localizedDescription)")
      }
      
//      //Тестовые заметки
//      let m = Note(context: context)
//      m.content = "testFirst Тестовый текст для первой заметки"
//      m.dateOfCreation = Date() as NSDate
//      let n = Note(context: context)
//      n.content = "testSecond Тестовый текст для второй заметки"
//      n.dateOfCreation = Date() as NSDate
//      
//      //ДОбавляем, но не в базу данных, т.е. no save
//      folderList.first!.addToNotes(m)
//      folderList.first!.addToNotes(n)
      
   }
   
   override func viewWillAppear(_ animated: Bool) {
      
      do {
         try folderFetchController.performFetch()
         folderList = folderFetchController.fetchedObjects!
         //Осторожно, перенес "tableView.reloadData()", чтобы пользователь успел увидеть, откуда он вернулся
         
         //Для красивого растворения выделения
         if tableView.indexPathForSelectedRow != nil {
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true) 
         }
         
      } catch let error as NSError {
         print(error.localizedDescription)
      }
   }
   
   override func viewDidAppear(_ animated: Bool) {
      tableView.reloadData()
   }
   
   override func numberOfSections(in tableView: UITableView) -> Int {
      return 1
   }
   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      // #warning Incomplete implementation, return the number of rows
      return folderList.count
   }
   
   override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
      if (tableView.cellForRow(at: indexPath) as? FoldersTableViewCell)?.nameOfFolderLabel.text != "Default Folder" {
         return true
      } else {
         return false
      }
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FoldersTableViewCell
      
      let info = folderList[indexPath.row]
      
      cell.folder = info
      
      
      
      return cell
   }
   
   
   
   /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
   
   /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
    // Delete the row from the data source
    tableView.deleteRows(at: [indexPath], with: .fade)
    } else if editingStyle == .insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }    
    }
    */
   
   /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
    
    }
    */
   
   
   
   
    // MARK: - Navigation
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
      switch segue.identifier! {
      case "fromFolderToNotes":
         
         let dvc = segue.destination as! NotesTableViewController
         
         dvc.folder = folderFetchController.object(at: tableView.indexPathForSelectedRow!)
         
         
      default:
         break
      }
      
      
   }
   
   
   
   override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
      
      let remove = UITableViewRowAction(style: .destructive, title: "Remove") { (action, indexPath) in
         
         
         
         if (tableView.cellForRow(at: indexPath) as! FoldersTableViewCell).nameOfFolderLabel.text != "Default Folder" {
            
            do {
               
               //Если в папке есть заметки, то спрашиваем, как удалить
               if self.folderList[indexPath.row].notes!.count > 0 {
                  
                  let ac = UIAlertController(title: "Delet Folder?", message: "If you delete the folder only, its notes will move to the Default folder. Any subfolders will also be deleted.", preferredStyle: .alert)
                  
                  //Удалить всё: Папку и заметки в ней
                  let deleteFolderAndNotesButton = UIAlertAction(title: "Delete Folder and Notes", style: .default, handler: { (action) in
                     
                     do {
                        context.delete(self.folderList.remove(at: indexPath.row))
                        try context.save()
                        tableView.deleteRows(at: [indexPath], with: .fade)
                        tableView.reloadData()
                     } catch let error as NSError  {
                        print(error.localizedDescription)
                     }
                     
                  })
                  
                  let deleteFolderOnlyButton = UIAlertAction(title: "Delete Folder Only", style: .default, handler: { (action) in
                     
                     do {
                        
                        
                        self.folderList[0].notes = self.folderList[0].notes!.addingObjects(from: self.folderList[indexPath.row].notes!.sortedArray(using: [])) as NSSet
                        
                        
                        context.delete(self.folderList[indexPath.row])
                        try context.save()
                        self.folderList.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                        
                        tableView.reloadData()
                        
                     } catch let error as NSError {
                        print(error.localizedDescription)
                     }
                     
                     
                     
                  })
                  
                  let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                     
                  })
                  
                  ac.addAction(deleteFolderAndNotesButton)
                  ac.addAction(deleteFolderOnlyButton)
                  ac.addAction(cancel)
                  
                  self.present(ac, animated: true, completion: nil)
                  
                  
               } else {
                  
                  //Здесь мы знаем, что папка пустая
                  
                  do {
                     context.delete(self.folderList.remove(at: indexPath.row))
                     try context.save()
                     tableView.deleteRows(at: [indexPath], with: .fade)
                     tableView.reloadData()
                  } catch let error as NSError  {
                     print(error.localizedDescription)
                  }
                  
               }
               
            }
            
            
         } else {
            
            print("не удаляется")
         }
         
         
      }
      
      if (tableView.cellForRow(at: indexPath) as! FoldersTableViewCell).nameOfFolderLabel.text != "Default Folder" {
         
         
         
         return [remove]
         
      } else {
         
//         return []
         
         return []
         
      }
      
      
   }
   
   func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      
      if range.length > 1 && string == "" && textField.text!.characters.count <= range.length || textField.text!.characters.count == 1 && string == "" {
         
         create.isEnabled = false
      } else {
         
         create.isEnabled = true
      }
      
      return true
      
   }
}

//Кнопка create для создания папки. Сделал fileprivate и объявил вне класса, чтобы метод делегата textField видел свойство create.isEnabled
fileprivate var create = UIAlertAction()
fileprivate let ac = UIAlertController(title: "New Folder", message: "Type the name of folder", preferredStyle: .alert)
