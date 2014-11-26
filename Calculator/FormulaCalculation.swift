//
//  FormulaCaculation.swift
//  Calculator
//
//  Created by 任琦磊 on 14/11/5.
//  Copyright (c) 2014年 任琦磊. All rights reserved.
//

import Foundation

class FormulaCalculation {
    
    var isPaintedEggshell = false
    
    func calculating(formulaString: String) -> String {
        
        // 彩蛋1 -- 圣诞节
        if formulaString == "12.25" {
            isPaintedEggshell = true
            return "🎅 Merry Xmas! 🎉"
        }
        // 彩蛋2 -- 庞佳玉生日
        if formulaString == "4.28" {
            isPaintedEggshell = true
            return "💝 Happy Birthday, Honey!"
        }
        // 彩蛋3 -- 任琦磊生日
        if formulaString == "6.25" {
            isPaintedEggshell = true
            return "Happy Birthday, Randy!"
        }
        // 彩蛋4 -- 董蕾生日
        if formulaString == "11.29" {
            isPaintedEggshell = true
            return "Your gift: 💊"
        }
        
        // rock wrong
        if !isNumberExisted(formulaString) {
            return "Error"
        }
        // calculating
        let answer = RPNCalculating(formulaString)
        
        return answer
    }
    
    func RPNCalculating(formulaString: String) -> String {
        
        let RPNString = RPNGeneration(formulaString)
        var numberStack = [Double]()
        
//        println("RPNString Count: \(RPNString.count)")
//        if RPNString.count == 0 {
//            return "Error"
//        }
        for string in RPNString {
            switch string {
                case "+":
                    if numberStack.count >= 2 {
                        let temp = numberStack[numberStack.count-2] + numberStack[numberStack.count-1]
                        numberStack.removeAtIndex(numberStack.count-1)
                        numberStack.removeAtIndex(numberStack.count-1)
                        numberStack += [temp]
                    }
                    else {
                        return "Error"
                    }
                case "-":
                    if numberStack.count >= 2 {
                        let temp = numberStack[numberStack.count-2] - numberStack[numberStack.count-1]
                        numberStack.removeAtIndex(numberStack.count-1)
                        numberStack.removeAtIndex(numberStack.count-1)
                        numberStack += [temp]
                    }
                    else {
                        return "Error"
                    }
                case "×":
                    if numberStack.count >= 2 {
                        let temp = numberStack[numberStack.count-2] * numberStack[numberStack.count-1]
                        numberStack.removeAtIndex(numberStack.count-1)
                        numberStack.removeAtIndex(numberStack.count-1)
                        numberStack += [temp]
                    }
                    else {
                        return "Error"
                    }
                case "÷":
                    if numberStack.count >= 2 {
                        let temp = numberStack[numberStack.count-2] / numberStack[numberStack.count-1]
                        numberStack.removeAtIndex(numberStack.count-1)
                        numberStack.removeAtIndex(numberStack.count-1)
                        numberStack += [temp]
                    }
                    else {
                        return "Error"
                    }
                default:
                    numberStack += [(string as NSString).doubleValue]
            }
        }
        
        return OptimizingAnswer(numberStack[0])
    }
    
    func RPNGeneration(formulaString: String) -> [String] {
        
        var originStack = [String]() // 存储去掉空串的数组
        var operatorStack = [String]() // 存储符号
        var calculatingStack = [String]() // 按逆波兰式存储串
        var temp = "" // 临时存储
        
        // start: 将formulaString转换为符号，数字单独存放的String数组
        for var i=0; i<countElements(formulaString); i++ {
            var tempCharacter = formulaString[advance(formulaString.startIndex, i)]
            switch tempCharacter {
                case "(", ")", "+", "×", "÷":
                    if temp != "" {
                        originStack += [temp]
                    }
                    originStack += [String(tempCharacter)]
                    temp = ""
                case "-":
                    if formulaString[advance(formulaString.startIndex, i-1)] == "×" || formulaString[advance(formulaString.startIndex, i-1)] == "÷" {
                        temp += String(tempCharacter)
                    }
                    else {
                        if temp != "" {
                            originStack += [temp]
                        }
                        originStack += [String(tempCharacter)]
                        temp = ""
                    }
                default:
                    temp += String(tempCharacter)
            }
        }
        // 将最好存在temp中的串置入originStack中
        if temp != "" {
            originStack += [temp]
        }
        // end
        
        // start: 将originStack转换为逆波兰式的数组
        // 将originStack中的内容从左往右读取
        for var originIndex=0; originIndex<originStack.count; originIndex++ {
            switch originStack[originIndex] {
                case "(":
                    operatorStack += ["("]
                case ")":
                    while operatorStack[operatorStack.count-1] != "(" {
                        calculatingStack += LastOneInStack(operatorStack)
                        operatorStack = RemoveOneInStack(operatorStack)
                    }
                    operatorStack = RemoveOneInStack(operatorStack) // 删除"("
                case "×", "÷":
                    if !operatorStack.isEmpty {
                        while operatorStack[operatorStack.count-1] != "(" && (operatorStack[operatorStack.count-1] == "×" || operatorStack[operatorStack.count-1] == "÷") {
                            calculatingStack += LastOneInStack(operatorStack)
                            operatorStack = RemoveOneInStack(operatorStack)
                            if operatorStack.isEmpty {
                                break
                            }
                        }
                        operatorStack += [originStack[originIndex]]
                    }
                    else {
                        operatorStack += [originStack[originIndex]]
                    }
                case "+", "-":
                    if !operatorStack.isEmpty {
                        while operatorStack[operatorStack.count-1] != "("  {
                            calculatingStack += LastOneInStack(operatorStack)
                            operatorStack = RemoveOneInStack(operatorStack)
                            if operatorStack.isEmpty {
                                break
                            }
                        }
                        operatorStack += [originStack[originIndex]]
                    }
                    else {
                        operatorStack += [originStack[originIndex]]
                    }
                default:
                    calculatingStack += [originStack[originIndex]]
            }
        }
        // 现在将operatorStack逐个弾出栈
        while !operatorStack.isEmpty {
            if calculatingStack[calculatingStack.count-1] != "(" {
                calculatingStack += LastOneInStack(operatorStack)
            }
            operatorStack = RemoveOneInStack(operatorStack)
        }
        // end
        for string in calculatingStack {
            print(string + "  ")
        }
        
        return calculatingStack
    }
    
    func LastOneInStack(stack: [String]) -> [String] {
        return [stack[stack.count-1]]
    }
    
    func RemoveOneInStack(stack: [String]) -> [String] {
        var temp = stack
        temp.removeAtIndex(temp.count-1)
        
        return temp
    }
    
    func OptimizingAnswer(answer: Double) -> String {
        var answerString = "\(answer)"
        
        while answerString[advance(answerString.startIndex, countElements(answerString)-1)] == "0" {
            answerString = answerString.substringToIndex(advance(answerString.startIndex, countElements(answerString)-1))
        }
        if answerString[advance(answerString.startIndex, countElements(answerString)-1)] == "." {
            answerString = answerString.substringToIndex(advance(answerString.startIndex, countElements(answerString)-1))
        }
        
        return answerString
    }
    
    // 判断算式中是否存在数字，若无任一数字出现，则直接返回false且提示Error结束计算
    func isNumberExisted(formulaString: String) -> Bool {
        for character in formulaString {
            switch character {
                case "1", "2", "3", "4", "5", "6", "7", "8", "9", "0":
                    return true
                default: continue
            }
        }
        
        return false
    }
}