//
//  entry.swift
//  protein
//
//  Created by Tyler Hernandez on 2/28/23.
//

import UIKit

extension ViewController {
    
    
    @objc func addQuickEntry(sender: UIButton!) {
        let grams = sender.tag // Copy protein amount from button's tag. Default value = 0.
        
        guard (grams > 0) else { return }
        
        // Immitate sending from our textOutlet.
        let payload = UITextField()
        payload.text = String(grams)
        
        submitNewEntry(sender: payload)
    }
    
    @objc func addEntryButton(sender: UIButton!) {
        entryView = addEntryView()
        
        view.addSubview(entryView)
        viewContainer.removeFromSuperview()
    }
    
    @objc func removeOldEntry(sender: UITextField!) {
        if let num = Int(sender.text!) {
            if num > 0 { // these nums will never be added.
                if let index = listOfEntries.lastIndex(of: num) {
                    listOfEntries.remove(at: index)
                }
            }
        }
        
        saveListToStorage()
        
        entryView.removeFromSuperview()
        
        viewDidLoad()
    }
    
    @objc func submitNewEntry(sender: UITextField!) {
        if let num = Int(sender.text!) {
            if num > 0 { // prevent 0 and negative numbers.
                listOfEntries.append(num)
            }
        }
        
        saveListToStorage()
        
        entryView.removeFromSuperview()
        
        viewDidLoad()
    }
    
    
    // Helper function for finding how much protein is in the title
    // E.g. "1 test value (18g)" -> 18
    func stripProteinFrom(str: String) -> Int? {
        var protein = ""
        
        if let startIndex = str.firstIndex(of: "(") {
            if let endIndex = str.lastIndex(of: "g"){
                let range = str.index(after: startIndex)..<endIndex
                protein = String(str[range])
            }
        }
        
        return Int(protein)
    }
    
    
    ///
    /// Add Entry View
    ///
    
    func addEntryView() -> UIView  {
        
        let bounds = UIScreen.main.bounds
//        let width = bounds.size.width
//        let height = bounds.size.height
        let separator: CGFloat = 20
        let newView = UIView(frame: CGRect(x: bounds.midX - 200, y: bounds.midY - 350, width: 400, height: 700))
        
        // Create a back button.
        var button = UIButton(frame: CGRect(x: 10, y: 50, width: 50, height: 50))
        button.backgroundColor = .systemRed
        button.setTitle("<-", for: .normal)
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        button.tag = 0
        newView.addSubview(button)
        
        // Create suggestion buttons for user.
        let startingX: CGFloat = 30
        let startingY: CGFloat = 130
        let defaultButtonHeight: CGFloat = 100
        let defaultButtonWidth: CGFloat = 100
        let center: CGFloat = newView.frame.width / 2
        
        var firstTag = 0
        var firstTitle = ""
        
        if (config.keys.contains("1Button")) {
            if let val = config["1Button"] {
                firstTitle = val
                // Strip protein value from val and assign tag.
                if let grams = stripProteinFrom(str: firstTitle) {
                    firstTag = grams
                }
            }
        }
        
        button = UIButton(frame: CGRect(x: startingX, y: startingY, width: defaultButtonWidth, height: defaultButtonHeight))
        button.backgroundColor = .systemCyan // change color here.
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping // Allows new line text wrap.
        button.titleLabel?.textAlignment = NSTextAlignment.center // centers text for when line wraps.
        button.setTitle(firstTitle, for: .normal)
        button.tag = firstTag // sends grams of protein through tag.
        button.addTarget(self, action: #selector(addQuickEntry), for: .touchUpInside)
        newView.addSubview(button)
        
        
        var previousX = button.frame.maxX
        var currentX = previousX + separator
        
        var secondTag = 0
        var secondTitle = ""
        
        if (config.keys.contains("2Button")) {
            if let val = config["2Button"] {
                secondTitle = val
                // Strip protein value from val and assign tag.
                if let grams = stripProteinFrom(str: secondTitle) {
                    secondTag = grams
                }
            }
        }
        
        button = UIButton(frame: CGRect(x: currentX, y: startingY, width: defaultButtonWidth, height: defaultButtonHeight))
        button.backgroundColor = .systemMint
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        button.titleLabel?.textAlignment = NSTextAlignment.center
        button.setTitle(secondTitle, for: .normal)
        button.tag = secondTag
        button.addTarget(self, action: #selector(addQuickEntry), for: .touchUpInside)
        newView.addSubview(button)
        
        
        previousX = button.frame.maxX
        currentX = previousX + separator
        
        
        var thirdTag = 0
        var thirdTitle = ""
        
        if (config.keys.contains("3Button")) {
            if let val = config["3Button"] {
                thirdTitle = val
                // Strip protein value from val and assign tag.
                if let grams = stripProteinFrom(str: thirdTitle) {
                    thirdTag = grams
                }
            }
        }
        
        button = UIButton(frame: CGRect(x: previousX + separator, y: startingY, width: defaultButtonWidth, height: defaultButtonHeight))
        button.backgroundColor = .systemGreen
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        button.titleLabel?.textAlignment = NSTextAlignment.center
        button.setTitle(thirdTitle, for: .normal)
        button.tag = thirdTag
        button.addTarget(self, action: #selector(addQuickEntry), for: .touchUpInside)
        newView.addSubview(button)
        
        // New Row
        
        var previousY = button.frame.maxY
        var currentY = previousY + separator
        
        var fourthTag = 0
        var fourthTitle = ""
        
        if (config.keys.contains("4Button")) {
            if let val = config["4Button"] {
                fourthTitle = val
                // Strip protein value from val and assign tag.
                if let fourthGrams = stripProteinFrom(str: fourthTitle) {
                    fourthTag = fourthGrams
                }
            }
        }
        
        button = UIButton(frame: CGRect(x: startingX, y: currentY, width: defaultButtonWidth, height: defaultButtonHeight))
        button.backgroundColor = .systemRed
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        button.titleLabel?.textAlignment = NSTextAlignment.center
        button.setTitle(fourthTitle, for: .normal)
        button.tag = fourthTag
        button.addTarget(self, action: #selector(addQuickEntry), for: .touchUpInside)
        newView.addSubview(button)
        
        previousX = button.frame.maxX
        currentX = previousX + separator
        
        var fifthTag = 0
        var fifthTitle = ""
        
        if (config.keys.contains("5Button")) {
            if let val = config["5Button"] {
                fifthTitle = val
                // Strip protein value from val and assign tag.
                if let fifthGrams = stripProteinFrom(str: fifthTitle) {
                    fifthTag = fifthGrams
                }
            }
        }
        
        button = UIButton(frame: CGRect(x: currentX, y: currentY, width: defaultButtonWidth, height: defaultButtonHeight))
        button.backgroundColor = .systemOrange
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        button.titleLabel?.textAlignment = NSTextAlignment.center
        button.setTitle(fifthTitle, for: .normal)
        button.tag = fifthTag
        button.addTarget(self, action: #selector(addQuickEntry), for: .touchUpInside)
        newView.addSubview(button)
        
        previousX = button.frame.maxX
        currentX = previousX + separator
        
        // Config Value
        
        var sixthTag = 0
        var sixthTitle = ""
        
        if (config.keys.contains("6Button")) {
            if let val = config["6Button"] {
                sixthTitle = val
                // Strip protein value from val and assign sixthTag.
                if let sixthGrams = stripProteinFrom(str: sixthTitle) {
                    sixthTag = sixthGrams
                }
            }
        }
        button = UIButton(frame: CGRect(x: currentX, y: currentY, width: defaultButtonWidth, height: defaultButtonHeight))
        button.backgroundColor = .systemYellow
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        button.titleLabel?.textAlignment = NSTextAlignment.center
        button.setTitle(sixthTitle, for: .normal)
        button.tag = sixthTag
        button.addTarget(self, action: #selector(addQuickEntry), for: .touchUpInside)
        newView.addSubview(button)
        
        previousY = button.frame.maxY
        currentY = previousY + separator
        currentX = startingX + 5.0
        
        // Create instructional label.
        let label = UILabel(frame: CGRect(x: center - 150, y: currentY, width: 300, height: 25))
        label.textAlignment = NSTextAlignment.center
        label.text = "Enter your protein intake"
        newView.addSubview(label)
        
        previousY = label.frame.maxY
        currentY = previousY
        
        
        // Create a textbox for user to input their protein intake for a given meal.
        let entryOutlet = UITextField(frame: CGRect(x: center - 75, y: currentY, width: 150, height: 35))
        entryOutlet.textAlignment = NSTextAlignment.center
        entryOutlet.placeholder = "Entry Here"
        entryOutlet.addTarget(self, action: #selector(submitNewEntry), for: .editingDidEndOnExit)
        entryOutlet.keyboardType = .numbersAndPunctuation
        newView.addSubview(entryOutlet)
        
        previousY = label.frame.maxY
        currentY = previousY + 50
        
        
        // Create a textbox for user to input their protein intake for a given meal.
        let removeOutlet = UITextField(frame: CGRect(x: center - 75, y: currentY, width: 150, height: 35))
        removeOutlet.textAlignment = NSTextAlignment.center
        removeOutlet.placeholder = "REMOVE HERE"
        removeOutlet.addTarget(self, action: #selector(removeOldEntry), for: .editingDidEndOnExit)
        removeOutlet.keyboardType = .numbersAndPunctuation
        newView.addSubview(removeOutlet)
        
        return newView
    }
}
