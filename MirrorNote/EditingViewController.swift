//
//  EditingViewController.swift
//  MirrorNote
//
//  Created by Gleb Kalachev on 26.02.17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit

class EditingViewController: UIViewController, UITextViewDelegate, UINavigationControllerDelegate {
   
   @IBOutlet weak var textView: UITextView!
   @IBOutlet weak var theNavigationItem: UINavigationItem!
   @IBAction func refresh(_ sender: UIBarButtonItem) {
      
      print("ДО rightBarButtonItem = \(navigationItem.rightBarButtonItem)")
      navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneButtonPressed(_:))), animated: false)
      
   }
   
   
   var folderToContain: Folder!
   var editableNote: Note!
   
   var primalText: String!
   
   var isNewNote: Bool!
   
   var isDoneJustPressed: Bool!
   
   
   func doneButtonPressed(_ sender: UIBarButtonItem) {
      //Убираем клаву
      textView.resignFirstResponder()
      
      navigationItem.setRightBarButton(nil, animated: false)
      navigationItem.setRightBarButton(UIBarButtonItem(title: "хуй", style: .done, target: self, action: nil), animated: true)
      
   }
   
   
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      //Перенес все ииз viewDidLoad в viewWillApear
      
   }
   
   
   //Создадим метод, обновляющий frame у textView, принимающий notification в качевсте аргумента
   func updateTextView(notification: Notification) {
      
      //Добавим кнопку Done
      if textView.isFirstResponder {
         
          print("ДО rightBarButtonItem = \(navigationItem.rightBarButtonItem)")
         
         
         
         navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneButtonPressed(_:))), animated: true)
      } else {
         navigationItem.setRightBarButton(nil, animated: false)
      }
      
      
      
      //Сюда могут прийти только 2 сообщения: либо клава появится, либо исчезнет
      
      //Достанем всю информацию прикрепленную к notification
      let info = notification.userInfo!
      //Достанем значение из этого словаря под ключем UIKeyboardFrameEndUserInfoKey
      let keyboardFrameScreenCoodrinades = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
      
      //По-моему это на случай, если у меня горизонтальная ориентация
      let keyboardFrame = self.view.convert(keyboardFrameScreenCoodrinades, to: view.window)
      //Я с этой херотой еще разберусь...
      
      
      //
      if notification.name == Notification.Name.UIKeyboardWillShow {
         
         
         textView.contentInset = UIEdgeInsets.init(top: self.navigationController!.navigationBar.frame.size.height + 20, left: 0, bottom: keyboardFrame.height, right: 0)
         
      }
      
      textView.scrollRangeToVisible(textView.selectedRange)
      
   }
   
   
   
   func textViewDidEndEditing(_ textView: UITextView) {
//      print("textViewDidEndEditing method did execute")
   }
   
   //Постоянно перезаписываем content в editableNote, чтобы успеть сохранить данные
   func textViewDidChange(_ textView: UITextView) {
      editableNote.content = textView.text!
//      print("current content = \(editableNote.content!)")   
   }
   
   
   override func viewWillAppear(_ animated: Bool) {
      textView.isScrollEnabled = false
      
      
      textView.delegate = self
      
      primalText = editableNote.content!

      
      //Если мы создаем новую заметку, то textView сразу становится firstResponder
      if isNewNote! {
         textView.becomeFirstResponder()
      }
      
      textView.delegate = self
      
      primalText = editableNote.content!
      
      //В этой строчке мы говорим, чтобы класс EditingViewController исполнял свой метод updateTextView когда получал уведомление под статическим названием NSNotification.Name.UIKeyboardWillShow
      NotificationCenter.default.addObserver(self, selector: #selector(EditingViewController.updateTextView(notification:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
      
      //"Иполняй свой метод updateTextView когда приходит уведомление с именем UIKeyboardWillHide, т.е. клавиатура сейчас исчезнет"
      NotificationCenter.default.addObserver(self, selector: #selector(EditingViewController.updateTextView(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
      
      
      //Если мы переходим с существующей заметки, то не добавляем кнопку done (точнее, добавляем nil)
      if isNewNote! {
         navigationItem.setRightBarButton(UIBarButtonItem.init(title: nil, style: .done, target: nil, action: #selector(EditingViewController.updateTextView(notification:))), animated: false)
      } else {
         navigationItem.setRightBarButton(nil, animated: false)
      }
      
      //Загружать данные лучше во viewWillAppear
      textView.text = editableNote.content!
   }
   
   override func viewDidAppear(_ animated: Bool) {
      textView.isScrollEnabled = true
   }
   
   //При сворачивании viewController'a происходит сохранение
   override func viewWillDisappear(_ animated: Bool) {
      
      //Удаляем observer'ы перед уходом
      NotificationCenter.default.removeObserver(self)
      
      
      //Если поле пустое, то удаляем заметку
      guard textView.text != "" else {
         
         editableNote.folder = nil
         
         //сохрани контекст
         do {
            try context.save()
         } catch let error as NSError {
            print(error.localizedDescription)
         }
         
//         print("Пустое поле, заметка не сохранена")
         return
      }
      
      //Если данные до и после одинаковые, то ничего не сохраняем
      guard editableNote.content != primalText else {
         return
      }
      
      //Сохраняем данные. Проверяю isNewNote на всякий случай
      if isNewNote! {
         
         //editableNote.content уже записан с помощью делегата, остается только дата
         editableNote.dateOfCreation = Date() as NSDate
         
         //У нас есть непустой content, дата создания и folder для editableNote уже предопределена в prepare в NotesTableViewController
         do {
            try context.save()
         } catch let error as NSError {
            print(error.localizedDescription)
         }
         
      } else {
         
         editableNote.dateOfCreation = Date() as NSDate
         
         do {
            try context.save()
         } catch let error as NSError {
            print(error.localizedDescription)
         }
         
      }
      
   }
   
   
   
   deinit {
      NotificationCenter.default.removeObserver(self)
   }
   
   //Это чтобы прятать клаву, когда происходит касание вне textView
   //   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
   //      super.touchesBegan(touches, with: event)
   //      
   //      //непосредственно метод, скрывающий textView
   //      self.textView.resignFirstResponder()
   //   }
   
}
