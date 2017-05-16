//
//  NotesTableViewController.swift
//  MirrorNote
//
//  Created by Gleb Kalachev on 26.02.17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit
import CoreData
class NotesTableViewController: UITableViewController, UISearchBarDelegate,UISearchControllerDelegate, UISearchResultsUpdating {
   
   //Средняя кнопка в toolBar
   @IBOutlet weak var buttonLabel: UIBarButtonItem!
   //Левая кнопка в toolBar
//   @IBOutlet weak var leftToolBarButton: UIBarButtonItem!
   
   
   

   var searchController: UISearchController! = UISearchController.init(searchResultsController: nil)
   var searchBar: UISearchBar!
   
   
   
   var folder : Folder!
   var noteList: [Note] = []
   var filteredNoteList : [Note] = []
   
   var notesFetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
   var notesFetchController: NSFetchedResultsController<Note>!
   
   var editButtonPressed = false
   
//   var checkboxSelectorBefore : Selector!
   
   
   override func viewDidLoad() {
      
      //Назначаем кнопки toolBar'a
      //Слева пока что ничего быть не должно
      print("count of items in toolbar = \(navigationController?.toolbar.items?.count)")
      
      
      
      //Справа переход к созданию новой заметки
      
      
      
      
      tableView.tableFooterView = UIView(frame: .zero)
      
      
      //Блок, отвечающий за инициализацию searchBar
      do {
         searchController.searchResultsUpdater = self
         searchController.delegate = self
         searchController.dimsBackgroundDuringPresentation = false
         
         //Глобальная переменная!
         definesPresentationContext = true
         
         searchBar = searchController.searchBar
         searchBar.delegate = self
         searchBar.barTintColor = #colorLiteral(red: 0, green: 0.9999863505, blue: 0.9041742682, alpha: 1)
         searchBar.searchBarStyle = .prominent
         //      searchBar.clipsToBounds = true
         //      searchBar.layer.borderWidth = 0
         //      searchBar.layer.borderColor = UIColor.clear.cgColor
         
         tableView.tableHeaderView = searchBar
      }
      
      
      //Раз и навсегда инициализируем наш notesFetchController
      notesFetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "dateOfCreation", ascending: false)]
      
      notesFetchRequest.predicate = NSPredicate(format: "folder = %@", folder)
      
      notesFetchController = NSFetchedResultsController(fetchRequest: notesFetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
      
      
      
   }
   
   
   override func viewWillAppear(_ animated: Bool) {
      
      print("count = \(navigationController?.toolbar.items?.count)")
            
      //Здесь перезагружаем данные (Или загружаем, если в первый раз   здесь)
      do {
         
         try notesFetchController.performFetch()
         noteList = notesFetchController.fetchedObjects!
         //Я убрал "tableView.reloadData()" в viewDidAppear, чтобы пользователь успел увидеть, что произошло с заметками
         
         //Обновляем надпись снизу
         switch noteList.count {
         case 0:
            buttonLabel.title = "No Notes"
         case 1:
            buttonLabel.title = "1 Note"
         default:
            buttonLabel.title = String(noteList.count) + " Notes"
         }
         
         
      } catch let error as NSError {
         print(error.localizedDescription)
         print("ОШИББББББКА")
      }
      
      if tableView.indexPathForSelectedRow != nil {
         tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
      }
      
      if searchController.isActive {
         tableView.contentOffset = CGPoint(x: 0, y: tableView.contentOffset.y - 0 /*searchBar.frame.height*/)
      } else {
      tableView.setContentOffset(CGPoint.init(x: 0, y: self.searchController.searchBar.frame.height), animated: true)
      }
      
   }
   
   override func viewDidAppear(_ animated: Bool) {
      
      tableView.reloadData()
   }
   
   override func viewWillDisappear(_ animated: Bool) {

      
   }
   
   //Опустим content на размер searchBar'a
   func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
      
//      tableView.setContentOffset(.init(x: 0, y: 100), animated: true)
      
   }
   
   
   
   // MARK: - Table view data source
   
   override func numberOfSections(in tableView: UITableView) -> Int {
      // #warning Incomplete implementation, return the number of sections
      return 1
   }
   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
      
      
      if searchController.isActive && searchController.searchBar.text != "" {
         return filteredNoteList.count
      } else {
         return noteList.count
      }
   }
   
   //Когда возвращать заметку из фильтр-массива, а когда из обычного в метод cellForRowAt indexPath
   func properNote(at index: Int) -> Note {
      
      if searchController.isActive && searchBar.text != "" {
         
         return filteredNoteList[index]
      } else {
         
         return noteList[index]
      }
   }
   
   override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
      return true
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NotesTableViewCell
      
      cell.theViewController = self
      
      cell.note = properNote(at: indexPath.row)
      
      return cell
   }
   
   func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      
   }
   
   func updateSearchResults(for searchController: UISearchController) {
      let result = searchController.searchBar.text!
      
      filteredNoteList = noteList.filter({ (note) -> Bool in
         return note.content!.singleLine().lowercased().contains(result.lowercased())
      })
      
      tableView.reloadData()
      
   }
   
   
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
      switch segue.identifier! {
      case "FromSelectedCellToEditing":
         
         let dvc = segue.destination as! EditingViewController
         
         dvc.folderToContain = self.folder
         //test
//         dvc.editableNote = noteList[tableView.indexPathForSelectedRow!.row]
         dvc.editableNote = properNote(at: tableView.indexPathForSelectedRow!.row)
         
         dvc.isNewNote = false
         
      case "createNewNote":
         
         let dvc = segue.destination as! EditingViewController
         dvc.folderToContain = self.folder
         
         let noteToDeliver = Note(context: context)
         noteToDeliver.content = ""
         //Добавлю эту дату, которую нужно будет заменить, просто для того, чтобы не было nil
         noteToDeliver.dateOfCreation = Date() as NSDate
         noteToDeliver.folder = dvc.folderToContain
         dvc.editableNote = noteToDeliver
         
         dvc.isNewNote = true
         
         
      case "moveNoteSegue":
         
         //Здесь подгрузим папки
         
         //MoveNoteTableViewController
         let dvc = (segue.destination as! UINavigationController).topViewController as! MoveNoteTableViewController
         
         do {
            dvc.folderList = try context.fetch(dvc.fetchRequset)
         } catch let error as NSError {
            print(error.localizedDescription)
         }
         
      default:
         break
      }
      
      
   }
   
   @IBAction func backToNotes (segue: UIStoryboardSegue) {
      
   }
   
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      if tableView.isEditing {
         
      } else {
         performSegue(withIdentifier: "FromSelectedCellToEditing", sender: self)
      }
   }
   
   
    // MARK: - Navigation
    
   override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
      
      let delete = UITableViewRowAction(style: .destructive, title: "Remove") { (action, indexPath) in
         
         do {
            
            context.delete(self.noteList.remove(at: indexPath.row))
            try context.save()
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            //Обновляем надпись снизу
            switch self.noteList.count {
            case 0:
               self.buttonLabel.title = "No Notes"
            case 1:
               self.buttonLabel.title = "1 Note"
            default:
               self.buttonLabel.title = String(self.noteList.count) + " Notes"
            }
            
            tableView.reloadData()
            
         } catch let error as NSError {
            print(error.localizedDescription)
            print("ОШИББББББКА")
         }
         
         
      }
      
      let move = UITableViewRowAction(style: .normal, title: "Move") { (action, indexPath) in
         
         self.performSegue(withIdentifier: "moveNoteSegue", sender: self)
         
//         self.performSegue(withIdentifier: "moveNoteSegue", sender: self)
         
      }
      
      return [delete, move]
   }
   
}

