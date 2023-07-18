//
//  entryView.swift
//  protein
//
//  Created by Tyler Hernandez on 3/20/23.
//

import SwiftUI

struct entryView: View {
    
    var date: String
    
    @StateObject var globalString = GlobalString()
    
    @State private var entry: String = ""
    
    @State private var removal: String = ""
    
    @State private var showPopup = false
    
    var body: some View {
        
        VStack {
            
            Button("Remove All"){
                for item in globalString.listOfEntries {
                    removeOldEntry(grams: item.grams)
                }
                print("Removing all entries from list")
                saveProteinToStorage()
                showPopup = true
            } .padding(8)
                .frame(width: 130, height: 120, alignment: .center )
                .font(.system(size: 18))
                .buttonStyle(.bordered)
                .multilineTextAlignment(.center)
                .foregroundColor(.blue)
            
            HStack {
                
                Button(globalString.config["1Button"] ?? "Cup of Milk (8g)"){
                    addQuickEntry(grams: stripProteinFrom(str: globalString.config["1Button"] ?? "Cup of Milk (8g)") ?? 0)
                    saveProteinToStorage()
                    showPopup = true
                }
                .padding(8)
                .frame(width: 130, height: 120, alignment: .center )
                .font(.system(size: 18))
                .buttonStyle(.bordered)
                .multilineTextAlignment(.center)
                .foregroundColor(.blue)
                
                Spacer()
                
                Button(globalString.config["2Button"] ?? "4oz Chicken Breast (35g)"){
                    addQuickEntry(grams: stripProteinFrom(str: globalString.config["2Button"] ?? "4oz Chicken Breast (35g)") ?? 0)
                    saveProteinToStorage()
                    showPopup = true
                }
                .padding(8)
                .frame(width: 130, height: 120, alignment: .center )
                .font(.system(size: 18))
                .buttonStyle(.bordered)
                .multilineTextAlignment(.center)
                .foregroundColor(.red)
                
                
                Spacer()
                
                Button(globalString.config["3Button"] ?? "Scoop of Whey (25g)"){
                    addQuickEntry(grams: stripProteinFrom(str: globalString.config["3Button"] ?? "Scoop of Whey (25g)") ?? 0)
                    saveProteinToStorage()
                    showPopup = true
                }
                .padding(8)
                .frame(width: 130, height: 120, alignment: .center )
                .font(.system(size: 18))
                .buttonStyle(.bordered)
                .multilineTextAlignment(.center)
                .foregroundColor(.green)
                
                Spacer()
            } // Hstack 1
            HStack {
                Spacer()
                Button(globalString.config["4Button"] ?? "3 Eggs (18g)"){
                    addQuickEntry(grams: stripProteinFrom(str: globalString.config["4Button"] ?? "3 eggs (18g)") ?? 0)
                    saveProteinToStorage()
                    showPopup = true
                }
                .padding(8)
                .frame(width: 130, height: 120, alignment: .center )
                .font(.system(size: 18))
                .buttonStyle(.bordered)
                .multilineTextAlignment(.center)
                .foregroundColor(.yellow)
                
                Spacer()
                Button(globalString.config["5Button"] ?? "Nonfat Greek Yogurt (17g)"){
                    addQuickEntry(grams: stripProteinFrom(str: globalString.config["5Button"] ?? "Nonfat Greek Yogurt (17g)") ?? 0)
                    saveProteinToStorage()
                    showPopup = true
                }
                .padding(8)
                .frame(width: 130, height: 120, alignment: .center )
                .font(.system(size: 18))
                .buttonStyle(.bordered)
                .multilineTextAlignment(.center)
                .foregroundColor(.orange)
                
                Spacer()
                Button(globalString.config["6Button"] ?? "Protein Bar (20g)"){
                    addQuickEntry(grams: stripProteinFrom(str: globalString.config["6Button"] ?? "Protein Bar (20g)") ?? 0)
                    saveProteinToStorage()
                    showPopup = true
                }
                .padding(8)
                .frame(width: 130, height: 120, alignment: .center )
                .font(.system(size: 18))
                .buttonStyle(.bordered)
                .multilineTextAlignment(.center)
                .foregroundColor(.purple)
                
                Spacer()
            } // Hstack 2
            
        } // Vstack 1
            .navigationBarHidden(false)
            .navigationBarBackButtonHidden(false)
            .navigationTitle("Entry")
            .onAppear {
                // Need to reload string with most up to date listOfEntries or it will be empty.
                globalString.reload(date: date)
            }
            .popover(isPresented: $showPopup) {
                ZStack {
                    Button("Submitted!"){}
                        .font(.system(size: 25))
                        .buttonStyle(.borderedProminent)
                        .tint(.green)
                        .onAppear(){
                            showPopup = false
                        }
                }.background(BackgroundBlurView())
            }
            
            Spacer().frame(width: 1, height: 40, alignment: .bottom)
            VStack{
                TextField("Entry Here", text: $entry).frame(width: CGFloat(100), height: CGFloat(30), alignment: .center).onSubmit {
                    addQuickEntry(grams: evaluateMathExpression(entry))
                    saveProteinToStorage()
                    showPopup = true
                    entry = ""
                    
                }.keyboardType(.numbersAndPunctuation)
                
                TextField("Remove Here", text: $removal).frame(width: CGFloat(120), height: CGFloat(30), alignment: .center).onSubmit {
                    removeOldEntry(grams: Int(removal) ?? 0)
                    saveProteinToStorage()
                    showPopup = true
                    removal = ""
                }.keyboardType(.numbersAndPunctuation)
            } // Vstack 2
            
            Spacer().frame(width: 1, height: 120, alignment: .bottom)

        
        
    }
    
    func evaluateMathExpression(_ expression: String) -> Int {
        let expression = expression.replacingOccurrences(of: " ", with: "") // Remove any spaces in the expression
        
        if let result = evaluate(expression) {
            return Int(result)
        }
        
        return 0
    }

    private func evaluate(_ expression: String) -> Double? {
        let expression = expression.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let result = evaluateParentheses(expression) {
            return result
        }
        
        return evaluateWithoutParentheses(expression)
    }

    private func evaluateParentheses(_ expression: String) -> Double? {
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

    private func evaluateWithoutParentheses(_ expression: String) -> Double? {
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
    
    func saveProteinToStorage() {
        
        let defaults = UserDefaults.standard
        
        let key = date
        
        let storedIntake = String(globalString.intake())
        
        defaults.set(storedIntake, forKey: key)
        
    }
    
    func removeOldEntry(grams: Int) {
        if grams > 0 { // these nums will never be added.
            if let index = globalString.listOfEntries.findEntry(Entry: grams) {
                globalString.listOfEntries.remove(at: index)
                print("Removed \(grams)")
            }
        }

        globalString.saveListToStorage(date: date)

    }
    
    func addQuickEntry(grams: Int) {
        
        guard (grams > 0) else { return }
        globalString.listOfEntries.append(Entry(grams: grams))
        globalString.saveListToStorage(date: date)
        
        print("Added \(grams)")
    }
    
    // Helper function for finding how much protein is in the title
    // E.g. "1 test value (18g)" -> 18
    func stripProteinFrom(str: String) -> Int? {
        var protein = ""
        
        if let startIndex = str.firstIndex(of: "(") {
            if let endIndex = str.lastIndex(of: "g"){
                let range = str.index(after: startIndex)..<endIndex
                protein = String(str[range])
            } else {return 0}
        } else {return 0}
        
        return Int(protein)
    }
    
}

struct BackgroundBlurView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct entryView_Previews: PreviewProvider {
    static var previews: some View {
        entryView(date: "").preferredColorScheme(.dark)
    }
}
