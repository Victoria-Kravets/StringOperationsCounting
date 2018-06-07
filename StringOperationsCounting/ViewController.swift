//
//  ViewController.swift
//  StringOperationsCounting
//
//  Created by Victoria Kravets on 07.06.2018.
//  Copyright © 2018 Victoria Kravets. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: -
    // MARK: Properties
    
    @IBOutlet weak var firstTextField: UITextField?
    @IBOutlet weak var secondTextField: UITextField?
    @IBOutlet weak var resultLabel: UILabel?

    var result = ""
    var array1 = [String]()
    var array2 = [String]()
    var state = true
    
    // MARK: -
    // MARK: Actions
    
    @IBAction func calculateOperations(_ sender: UIButton) {
        let str1 = self.firstTextField?.text
        let str2 = self.secondTextField?.text
        str1.do { str1 in
            str2.do { self.findLongestStr(str1: str1, str2: $0) }
        }
        
        self.clearTextField()
        self.resultLabel?.text = self.findOperation()
        self.result = ""
    }

    // MARK: -
    // MARK: Private
    
    private func findLongestStr(str1: String, str2: String) {
        if  str1.count > str2.count {
            self.transformArrayWithState(array1: &self.array2, array2: &self.array1, state: false)
        } else {
            self.transformArrayWithState(array1: &self.array1, array2: &self.array2, state: true)
        }
    }

    private func transformArrayWithState( array1: inout [String], array2: inout [String], state: Bool) {
        self.firstTextField?.text.do { array1 = self.turnStringToArray(str: $0) }
        self.secondTextField?.text.do { array2 = self.turnStringToArray(str: $0) }
        self.state = state
    }
    
    private func clearTextField() {
        self.firstTextField?.text = ""
        self.secondTextField?.text = ""
    }
    
    private func turnStringToArray(str: String) -> [String] {
        var array = [String]()
        for char in str {
            array.append(String(char))
        }
        
        return array
    }

    private func findKeyCharacters() -> [String] {
        var keyCharacters = [String]()
        var step = 0
        
        for i in 0...self.array1.count - 1 {
            for j in step...self.array2.count - 1 {
                if self.array1[i] == self.array2[j] {
                    keyCharacters.append(self.array1[i])
                    break
                }
            }
            
            step += 1
        }
        
        return keyCharacters
    }
    
    private func findOperationCaseZiro() {
            if self.array1.count > self.array2.count {
                let diff = self.array1.count - self.array2.count
                for _ in 1...diff {
                    self.addChar("d")
                }
                
                for _ in 1...self.array2.count {
                    self.addChar("s")
                }
                
            } else if self.array1.count < self.array2.count {
                let diff = self.array2.count - self.array1.count
                for _ in 1...self.array1.count {
                    self.addChar("s")
                }
                
                for _ in 1...diff {
                    self.addChar("i")
                }
                
            } else {
                for _ in 1...self.array1.count {
                    self.addChar("s")
                }
            }
    }
     private func findOperation() -> String {
        let keyCharacters = self.findKeyCharacters()
        
        if keyCharacters.count == 0 {
            self.findOperationCaseZiro()
        } else {
            var countKeyChar = 0
            var x = 0
            var y = 0
            
            for _ in 0...self.array1.count - 1 {
                if countKeyChar == keyCharacters.count {
                    for _ in 1...x {
                        self.addChar("s")
                    }
                    
                    for _ in 1...y - x {
                       self.addChar("d")
                    }
                    
                    return result
                } else {
                    if self.array1[x] == keyCharacters[countKeyChar] && self.array2[y] == keyCharacters[countKeyChar] {
                        countKeyChar += 1
                    } else if self.array1[x] == keyCharacters[countKeyChar] {
                        for j in y...self.array2.count-1 {
                            if self.array2[j] == keyCharacters[countKeyChar] {
                                countKeyChar += 1
                                break
                            }
                            
                            if state {
                                self.addChar("i")
                            } else {
                                self.addChar("d")
                            }
                            
                            y += 1
                        }
                    } else if self.array2[y] == keyCharacters[countKeyChar] {
                        
                    } else {
                        self.addChar("s")
                    }
                    
                    x += 1
                    y += 1
                }
            }
            
            self.caseSurplusChar(usedChar: y, allChar: self.array2)
        }
        
        return result
    }
    
    private func caseSurplusChar(usedChar: Int, allChar: [String]) {
        if usedChar < allChar.count {
            for _ in 1...allChar.count - usedChar {
                self.addChar("d")
            }
        }
    }
    private func addChar(_ char: Character) {
        self.result.append(char)
    }
}
