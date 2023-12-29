//
//  math.swift
//  protein
//
//  Created by Tyler Hernandez on 9/16/23.
//

import Foundation

public struct Math {
    
    static func evaluateMathExpression(_ expression: String) -> Int {
        let expression = expression.replacingOccurrences(of: " ", with: "") // Remove any spaces in the expression
        
        if let result = evaluate(expression) {
            return Int(result)
        }
        
        return 0
    }

    private static func evaluate(_ expression: String) -> Double? {
        let expression = expression.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let result = evaluateParentheses(expression) {
            return result
        }
        
        return evaluateWithoutParentheses(expression)
    }

    private static func evaluateParentheses(_ expression: String) -> Double? {
        var expression = expression
        
        while let startIndex = expression.lastIndex(of: "(") {
            var endIndex: String.Index?
            var parenthesesCount = 0
            
            for (index, char) in expression.enumerated() {
                if char == "(" {
                    parenthesesCount += 1
                } else if char == ")" {
                    parenthesesCount -= 1
                    
                    if parenthesesCount == 0 {
                        endIndex = expression.index(expression.startIndex, offsetBy: index)
                        break
                    }
                }
            }
            
            if let endIndex = endIndex {
                let range = expression.index(after: startIndex)..<endIndex
                let subExpression = String(expression[range])
                if let subResult = evaluateWithoutParentheses(subExpression) {
                    expression.replaceSubrange(startIndex...endIndex, with: "\(subResult)")
                } else {
                    return nil
                }
            } else {
                return nil
            }
        }
        
        return evaluateWithoutParentheses(expression)
    }

    private static func evaluateWithoutParentheses(_ expression: String) -> Double? {
        let expression = expression.trimmingCharacters(in: .whitespacesAndNewlines)
        var numberString = ""
        var numbers: [Double] = []
        var operators: [Character] = []
        
        for char in expression {
            if char.isNumber || char == "." || (numberString.isEmpty && char == "-") {
                numberString.append(char)
            } else if let number = Double(numberString) {
                numbers.append(number)
                numberString = ""
                operators.append(char)
            } else {
                return nil
            }
        }
        
        if let number = Double(numberString) {
            numbers.append(number)
        } else {
            return nil
        }
        
        // Evaluate multiplication and division first
        var index = 0
        while index < operators.count {
            let operatorChar = operators[index]
            if operatorChar == "*" || operatorChar == "/" {
                let number1 = numbers[index]
                let number2 = numbers[index + 1]
                var result: Double
                
                if operatorChar == "*" {
                    result = number1 * number2
                } else {
                    if number2 == 0 {
                        return nil // Division by zero error
                    }
                    result = number1 / number2
                }
                
                // Update numbers and operators arrays
                numbers[index] = result
                numbers.remove(at: index + 1)
                operators.remove(at: index)
            } else {
                index += 1
            }
        }
        
        // Evaluate addition and subtraction
        var result = numbers[0]
        
        for (index, operatorChar) in operators.enumerated() {
            let number = numbers[index + 1]
            
            if operatorChar == "+" {
                result += number
            } else {
                result -= number
            }
        }
        
        return result
    }
}
