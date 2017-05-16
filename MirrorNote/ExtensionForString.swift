//
//  ExtensionForString.swift
//  ShopManagerApp
//
//  Created by Gleb Kalachev on 19.02.17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import Foundation

extension String {
   
   //Достать символ
   subscript (number: Int) -> Character {
      return self[self.index(self.startIndex, offsetBy: number-1)]
   }
   
   //Достать сабстроку по номерам ячеек
   subscript (indexStart: Int,indexEnd: Int) -> String {
      if indexStart < indexEnd {
         return self.substring(with: self.index(indexStart)..<self.index(indexEnd+1))
      } else {
         if indexStart == indexEnd {
            return String(self[indexStart])
         } else {
            return self[indexEnd,indexStart]
         }
      }
   }
   
   //Достать индеск по его номеру
   func index(_ index: Int) -> Index {
      return self.index(self.startIndex, offsetBy: index-1)
   }
   
   
   
   //Удалить сабстроку по номерам ячеек
   @discardableResult mutating func removeSubstring(_ indexStart: Int,_ indexEnd: Int) -> String {
      if indexStart < indexEnd {
         let subString = self[indexStart,indexEnd]
         self.removeSubrange(self.index(indexStart)...self.index(indexEnd))
         return subString
      } else {
         if indexStart == indexEnd {
            let subString = String(self[indexStart])
            self.remove(indexStart)
            return subString
         } else {
            let subString = self[indexEnd,indexStart]
            self.removeSubrange(self.index(indexEnd)...self.index(indexStart))
            return subString
         }
      }
   }
   
   //Заменить сабстроку
   @discardableResult mutating func replaceSubstring(from start: Int, to end: Int, with replacement: String) -> String {
      
      let previousValue = self
      
      self.replaceSubrange(self.index(self.startIndex, offsetBy: start-1)...self.index(self.startIndex, offsetBy: end-1), with: replacement)
      
      return previousValue
      
   }
   
   
   
   //Достать префикс по его длине
   func getPrefixWithLength(_ lengthOfPrefix: Int) -> String {
      
      if lengthOfPrefix <= self.characters.count && lengthOfPrefix != 0 {
         return self.substring(with: self.startIndex..<self.index(self.startIndex, offsetBy: lengthOfPrefix))
      } else {
         
         if lengthOfPrefix <= 0 {
            //Если длина меньше либо равна нулю
            return ""
         } else {
            //Если длина префикса больше строки
            return self
         }
         
         
         //Ошибка
         //            fatalError("Can not exacute getPrefixWithLength, because lengthOfPrefix is larger than string")
         
      }
      
   }
   
   //Удалить префикс по его длине
   @discardableResult mutating func removePrefixWithLength(_ lengthOfPrefix: Int) -> String {
      if lengthOfPrefix <= self.characters.count && lengthOfPrefix != 0 {
         
         let prefix = self.getPrefixWithLength(lengthOfPrefix)
         self.removeSubrange(self.startIndex..<self.index(self.startIndex, offsetBy: lengthOfPrefix))
         return prefix
         
      } else {
         
         self = ""
         return ""
         
         //Ошибка
         //            fatalError("Can not exacute removePrefixWithLength, because lengthOfPrefix is larger than string")
         
      }
      
   }
   
   //Достать префикс по первому попавшемуся символу
   func getPrefixWithFirstFoundSymbol(_ symbol: Character) -> String {
      
      if self.contains(String(symbol)) {
         
         //Выявление префикса по данному символу
         
         //Та переменная, которую я верну
         var prefix : String = ""
         //Это номер данного символа. Сначала он равен номеру первого символа
         var findIndex : Int = 1
         
         while self[findIndex] != symbol {
            
            prefix += String(self[findIndex])
            
            findIndex += 1
            
         }
         
         return prefix
         
         
      } else {
         //Если строка не содержит данный символ
         fatalError("Can not execute getPostfixWithFirstFoundSymbol, because string doesn't contain symbol \"\(symbol)\"")
      }
      
   }
   
   //Удалить префикс по первому попавшемуся символу
   @discardableResult mutating func removePrefixWithFirstFoundSymbol(_ symbol: Character) -> String {
      
      if self.contains(String(symbol)) {
         
         //Выявление префикса по данному символу
         
         //Та переменная, которую я верну
         var prefix : String = ""
         //Это номер данного символа. Сначала он равен номеру первого символа
         var findIndex : Int = 1
         
         while self[findIndex] != symbol {
            
            prefix += String(self[findIndex])
            
            findIndex += 1
            
         }
         
         //Удаление
         self.removePrefixWithLength(findIndex-1)
         
         return prefix
         
         
      } else {
         //Если строка не содержит данный символ
         fatalError("Can not execute removePostfixWithFirstFoundSymbol, because string doesn't contain symbol \"\(symbol)\"")
      }
      
   }
   
   
   
   
   
   
   //Достать постфикс по его длине
   func getPostfixWithLength (_ lengthOfPostfix: Int) -> String {
      
      if lengthOfPostfix <= self.characters.count && lengthOfPostfix != 0 {
         return self.substring(with: self.index(self.endIndex, offsetBy: -lengthOfPostfix)..<self.endIndex)
      } else {
         
         if lengthOfPostfix > self.characters.count {
            return self
         } else {
            print("lengthOfPostfix = \(lengthOfPostfix); while self.length = \(self.characters.count)")
            
            return ""
         //Ошибка
//         fatalError("Can not exacute getPostfixWithLength, because smaller than zero")
         }
      }
      
   }
   
   //Удалить постфикс по его длине
   @discardableResult mutating func removePostfixWithLength (_ lengthOfPostfix: Int) -> String {
      
      if lengthOfPostfix <= self.characters.count && lengthOfPostfix != 0 {
         
         let postfix = self.getPostfixWithLength(lengthOfPostfix)
         self.removeSubrange(self.index(self.endIndex, offsetBy: -lengthOfPostfix)..<self.endIndex)
         return postfix
         
      } else {
         
         self = ""
         return ""
         
         //Ошибка
         //            fatalError("Can not exacute removePostfixWithLength, because lengthOfPostfix is larger than string")
      }
      
   }
   
   //Достать постфикс по первому попавшемуся символу
   func getPostfixWithFirstFoundSymbol (_ symbol: Character) -> String {
      
      if self.contains(String(symbol)) {
         
         //Выявление постфикса по данному символу
         
         //Та переменная, которую я верну
         var postfix : String = ""
         //Это номер данного символа в строке. Сначала он равен номеру последнего символа
         var findIndex : Int = self.characters.count
         
         while self[self.index(self.startIndex, offsetBy: findIndex-1)] != symbol {
            postfix = String(self[self.index(self.startIndex, offsetBy: findIndex-1)]) + postfix
            findIndex -= 1
         }
         
         return postfix
         
      } else {
         //Если строка не содержит данный символ
         fatalError("Can not execute getPostfixWithFirstFoundSymbol, because string doesn't contain symbol \"\(symbol)\"")
      }
      
   }
   
   //Удалить постфикс по первому попавшемуся символу
   @discardableResult mutating func removePostfixWithFirstFoundSymbol (_ symbol: Character) -> String {
      
      if self.contains(String(symbol)) {
         
         //Выявление постфикса по данному символу
         
         //Та переменная, которую я верну
         var postfix : String = ""
         //Это номер данного символа в строке. Сначала он равен номеру последнего символа
         var findIndex : Int = self.characters.count
         
         while self[self.index(self.startIndex, offsetBy: findIndex-1)] != symbol {
            postfix = String(self[self.index(self.startIndex, offsetBy: findIndex-1)]) + postfix
            findIndex -= 1
         }
         
         
         
         //Удаление
         self.removePostfixWithLength(self.characters.count-findIndex)
         
         //Вернуть постфикс
         return postfix
         
      } else {
         //Если строка не содержит данный символ
         fatalError("Can not execute removePostfixWithFirstFoundSymbol, because string doesn't contain symbol \"\(symbol)\"")
      }
      
   }
   
   //Вернуть количество цифр в строке
   func digitCount() -> Int {
      
      let digits: Set<Character> = ["1","2","3","4","5","6","7","8","9","0"]
      
      var count = 0
      
      for i in 1...self.characters.count {
         
         if digits.contains(self[i]) {
            count += 1
         }
         
      }
      return count
   }
   
   //Удалить по номеру ячейки
   mutating func remove(_ at: Int) {
      self.remove(at: self.index(self.startIndex, offsetBy: at-1))
   }
   
   //Достать первый символ
   func first () -> Character {
      return self[self.startIndex]
   }
   
   
   //Удалить первый символ и вернуть значение
   @discardableResult mutating func removeFirst() -> Character {
      return self.remove(at: self.startIndex)
   }
   
   //Достать последний символ
   func last () -> Character {
      return self[self.index(self.endIndex, offsetBy: -1)]
   }
   
   
   //Удалить последний символ и вернуть значение
   @discardableResult mutating func removeLast() -> Character {
      return self.remove(at: self.index(self.endIndex, offsetBy: -1))
   }
   
   //Вернуть количество символов в строке
   var length : Int {
      return self.characters.count
   }
   
   //Содержит ли строка только невидимые знаки
   var isInvisible: Bool {
      //Если хоть раз наткнется на несоответствие, то до второго return дело не дойтет
      for character in self.characters {
         if !["\n","\t","\r","\0"," "].contains(String(character)) {
            return false
         }
      }
      return true
   }
   
   //Вернуть строку одной строкой, т.е. без переносов 
   func singleLine() -> String {
      
      var result = self
      
      //Здесь мы удаляем все символы: \r \n \t \0
      let length = result.length
      
      for i in 0..<length {
         let index = length-i
         
         if ["\r","\n","\t","\0"].contains(String(result[index])) {
            result = result.replacingOccurrences(of: String(result[index]), with: " ")
         }
      }
      
      //Убираем лишние пробелы
      result = result.withoutExtraSpaces()
      
      return result
   }
   
   //Вернуть строку с удаленными лишними пробелами
   func withoutExtraSpaces() -> String {
      
      var result = self
      
      while result.contains("  ") {
         result = result.replacingOccurrences(of: "  ", with: " ")
      }
      return result
   }
   
   
   
   //Вернуть строку с разделением между словами только одним пробелом
//   func withoutAnyExtraSpace() -> String {
//      
//      var result = self
//      
//      result = result.formatingToSingleLine()
//      
//      //Теперь удаляем лишние пробелы
//      result = result.withoutExtraSpaces()
//      
//      return result
//   }
   
   
}
