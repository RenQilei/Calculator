//
//  ViewController.swift
//  Calculator
//
//  Created by 任琦磊 on 14/10/24.
//  Copyright (c) 2014年 任琦磊. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var formulaString = ""
    var isCalculated = false // 标记是否完成一次计算，用于Clear按钮的判断
    var tempAnswerStore = "" // 临时存储计算结果，如果下一次计算为运算符则使用，否则忽略
    
    @IBOutlet var formulaLabel: UILabel!
    @IBOutlet var answerLabel: UILabel!
    
    @IBAction func ClickNumberButton(sender: UIButton) {
        isCalculated = false
        
        // 处理高位多个"0"的情况
        
        formulaString += sender.currentTitle!
        formulaLabel.text = formulaString
    }
    
    @IBAction func ClickOperatorButton(sender: UIButton) {
        isCalculated = false
        
        if formulaString.isEmpty && !tempAnswerStore.isEmpty {
            if tempAnswerStore[advance(tempAnswerStore.startIndex, 0)] == "-" {
                formulaString = "0" + tempAnswerStore
            }
            else {
                formulaString += tempAnswerStore
            }
        }
        let currentTitle = sender.currentTitle!
        // 修正formulaString
        formulaString = CorrectOperator(formulaString, currentOperator: currentTitle)
        formulaLabel.text = formulaString
    }
    
    @IBAction func ClickDecimalButton(sender: UIButton) {
        isCalculated = false
        
        // 输入值为'.'
        // 修正formulaString
        formulaString = CorrectDecimal(formulaString)
        formulaLabel.text = formulaString
    }
    
    @IBAction func ClickBracketButton(sender: UIButton) {
        isCalculated = false
        
        formulaString += sender.currentTitle!
        formulaLabel.text = formulaString
    }
    
    @IBAction func ClickEqualButton(sender: UIButton) {
        if !formulaString.isEmpty {
            // 处理小数点后零问题
            formulaString = CorrectZeroAfterDemical(formulaString)
            println(formulaString)
        
            // 处理括号问题
            formulaString = CorrectBracket(formulaString)
            println(formulaString)
        
            // 处理乘法省略"×"问题
            formulaString = AddMultiple(formulaString)
            println(formulaString)
        
            let finalFormula = formulaString
            formulaLabel.text = formulaString + "="
        
            // 删除“=”
            //let finalFormula = formulaString.substringToIndex(advance(formulaString.startIndex, countElements(formulaString)-1))
            // 计算结果
            let formulaCalculation = FormulaCalculation()
            let answer = formulaCalculation.calculating(finalFormula)
            isCalculated = true
        
            answerLabel.text = answer
            formulaString = ""
            if answer != "Error" && answer != "Inf" && !formulaCalculation.isPaintedEggshell {
                tempAnswerStore = answer
            }
            else {
                tempAnswerStore = ""
            }
        }
    }
    
    @IBAction func ClickDeleteButton(sender: UIButton) {
        if !formulaString.isEmpty {
            if isCalculated {
                formulaString = ""
                formulaLabel.text = formulaString
                answerLabel.text = "0"
            }
            else {
                formulaString = formulaString.substringToIndex(advance(formulaString.startIndex, countElements(formulaString)-1))
                formulaLabel.text = formulaString
            }
        }
        else {
            formulaLabel.text = formulaString
            answerLabel.text = "0"
        }
    }
    
    @IBAction func ClickAllDeleteButton(sender: UIButton) {
        isCalculated = false
        
        formulaString = ""
        tempAnswerStore = ""
        formulaLabel.text = formulaString
        answerLabel.text = "0"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formulaLabel.adjustsFontSizeToFitWidth = true
        answerLabel.adjustsFontSizeToFitWidth = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func CorrectOperator(currentFormulaString: String, currentOperator: String) -> String {
        if countElements(currentFormulaString)  == 0 {
            // formulaString为空，则仅允许输入'+'、'-'
            if currentOperator == "+" || currentOperator == "-" {
                return "0" + currentFormulaString + currentOperator
            }
        }
        else {
            // formulaString中的最后一个字符，若'('则只允许输入'+'、'-'，若'+'、'-'、'*'、'/'则拒绝输入
            let lastCharacter = LastCharacter(currentFormulaString)
            if (lastCharacter == "(") && (currentOperator == "+" || currentOperator == "-") {
                    return currentFormulaString + "0" + currentOperator
            }
            else if lastCharacter == "+" || lastCharacter == "-" || lastCharacter == "×" || lastCharacter == "÷" {
                return currentFormulaString
            }
        }
        
        return currentFormulaString + currentOperator
    }
    
    func CorrectDecimal(currentFormulaString: String) -> String {
        if countElements(currentFormulaString)  == 0 {
            return "0."
        }
        else {
            if HasDemical(currentFormulaString) {
                return currentFormulaString
            }
            else {
                let lastCharacter = LastCharacter(currentFormulaString)
                if lastCharacter == "." {
                    return currentFormulaString
                }
                else {
                    switch lastCharacter {
                        case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
                            return currentFormulaString + "."
                        default:
                            return currentFormulaString + "0."
                    }
                }
            }
        }
    }
    
    func AddMultiple(currentFormulaString: String) -> String {
        var correctFormulaString = ""
        
        for character in currentFormulaString {
            if correctFormulaString.isEmpty {
                correctFormulaString += String(character)
            }
            else {
                if LastCharacter(correctFormulaString) == ")" {
                    switch character {
                        case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "(":
                            correctFormulaString = correctFormulaString + "×" + String(character)
                        default:
                            correctFormulaString += String(character)
                    }
                }
                else {
                    if character == "(" {
                        switch LastCharacter(correctFormulaString) {
                            case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
                                correctFormulaString = correctFormulaString + "×" + String(character)
                            default:
                                correctFormulaString += String(character)
                        }
                    }
                    else {
                        correctFormulaString += String(character)
                    }
                }
            }
        }
        
        return correctFormulaString
    }
    
    func CorrectZeroAfterDemical(currentFormulaString: String) -> String {
        var correctFormulaString = ""
        
        for character in currentFormulaString {
            if correctFormulaString.isEmpty {
                correctFormulaString += String(character)
            }
            else {
                switch character {
                    case "(", ")", "+", "-", "×", "÷":
                        if LastCharacter(correctFormulaString) == "." {
                            correctFormulaString = correctFormulaString + "0" + String(character)
                        }
                        else {
                            correctFormulaString += String(character)
                        }
                    default:
                        correctFormulaString += String(character)
                }
            }
        }
        
        return correctFormulaString
    }
    
    func CorrectBracket(currentFormulaString: String) -> String {
        var leftBracket = 0
        var rightBracket = 0
        var correctFormulaString = currentFormulaString
        
        for character in currentFormulaString {
            if character == "(" {
                leftBracket++
            }
            if character == ")" {
                rightBracket++
                if leftBracket < rightBracket {
                    correctFormulaString = "(" + correctFormulaString
                    leftBracket++
                }
            }
        }
        if leftBracket > rightBracket {
            correctFormulaString = correctFormulaString + ")"
        }
        
        return correctFormulaString
    }
    
    //获得当前formulaString的最后一个字符
    func LastCharacter(currentFormulaString: String) -> Character {
        return currentFormulaString[advance(currentFormulaString.startIndex, countElements(currentFormulaString)-1)]
    }
    
    func HasDemical(currentFormulaString: String) -> Bool {
        var demicalAmount = 0
        for var i=countElements(currentFormulaString)-1; i>=0; i-- {
            switch currentFormulaString[advance(currentFormulaString.startIndex, i)] {
                case ".":
                    demicalAmount++
                case "+", "-", "×", "÷", "(", ")":
                    if demicalAmount==1 {
                        return true
                    }
                    else {
                        return false
                    }
                default:
                    continue
            }
        }
        // 无算数符号出现
        if demicalAmount==1 {
            return true
        }
        else {
            return false
        }
    }
    
}

