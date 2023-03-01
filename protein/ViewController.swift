//
//  ViewController.swift
//  protein
//
//  Created by Tyler Hernandez on 9/29/22.
//

import UIKit
import SwiftUI


struct DefaultsKeys {
    static let entryKey = "this_is_my_key"
    static let configKey = "this_is_my_config_key"
}


class ViewController: UIViewController {
    
    var buttonName = ""
    var buttonValue = ""
    
    var listOfEntries: [Int] = []
    var config: Dictionary<String, String> = [:]
    var totalSum = 0
    
    var viewContainer: UIView = UIView()
    var entryView: UIView = UIView()
    var configView: UIView = UIView()
    var transitionView: UIView = UIView()
    
    var currentEntry = 0
    
    var currentlyEdittingButton = 6 // Keeps track of which button we are editting.
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        loadListFromStorage()
        
        loadConfig()
        
        viewContainer = refreshViewContainer()
        
        view.addSubview(viewContainer)
        
        
      }
    
    // Prevents app from trying to display window horizontally
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait

        }
    }
    
    ///
    ///
    /// Views
    ///
    ///
    
    // TODO: change background color of app based on totalSum.
    func refreshViewContainer() -> UIView{
        totalSum = 0 // Reset totalSum since we're going to recompute it below.
        let newView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
        
        // Create clear list button.
        let clearListButton = UIButton(frame: CGRect(x: 10, y: 50, width: 50, height: 50))
        clearListButton.backgroundColor = .systemRed
        clearListButton.setTitle("-", for: .normal)
        clearListButton.addTarget(self, action: #selector(clearList), for: .touchUpInside)
        newView.addSubview(clearListButton)
        
        // Create Edit Config button.
        let configButton = UIButton(frame: CGRect(x: 160, y: 50, width: 50, height: 50))
        configButton.backgroundColor = .systemGreen
        configButton.setTitle("!", for: .normal)
        configButton.addTarget(self, action: #selector(editConfigButton), for: .touchUpInside)
        newView.addSubview(configButton)
        
        // Create Add Entry button.
        let entryButton = UIButton(frame: CGRect(x: 325, y: 50, width: 50, height: 50))
        entryButton.backgroundColor = .systemBlue
        entryButton.setTitle("+", for: .normal)
        entryButton.addTarget(self, action: #selector(addEntryButton), for: .touchUpInside)
        newView.addSubview(entryButton)
        
        
        var label = UILabel()
        // Retrieve list
        var separator = 20 // start off separator at 20, then continuously add to push down our list.
        for item in listOfEntries{
            label = UILabel(frame: CGRect(x: 30, y: 130 + separator, width: 50, height: 50))
            label.text = String(item)
            separator += 20
            newView.addSubview(label)
            totalSum += item
        }
        // Display sum line
        label = UILabel(frame: CGRect(x: 10, y: 130 + separator, width: 300, height: 50))
        label.text = "--------------------------------"
        newView.addSubview(label)
        separator += 20
        
        // Display sum
        label = UILabel(frame: CGRect(x: 30, y: 130 + separator, width: 100, height: 50))
        label.text = String(totalSum) + " grams"
        newView.addSubview(label)
        return newView
    }
    
    func addEntryView() -> UIView  {
        
        let separator: CGFloat = 20
        
        let newView = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 700))
        
        // Create a back button.
        var button = UIButton(frame: CGRect(x: 10, y: 50, width: 50, height: 50))
        button.backgroundColor = .systemRed
        button.setTitle("<-", for: .normal)
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        button.tag = 0
        newView.addSubview(button)
        
        // Create suggestion buttons for user.
        
        let startingX: CGFloat = 25
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
        
        button = UIButton(frame: CGRect(x: currentX, y: 130, width: defaultButtonWidth, height: defaultButtonHeight))
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
        
        button = UIButton(frame: CGRect(x: previousX + separator, y: 130, width: defaultButtonWidth, height: defaultButtonHeight))
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
    
    func transitionConfigView() -> UIView {
        
        // Display our buttons and their current values.
        
        let separator: CGFloat = 20
        
        let newView = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 700))
        
        // Create a back button.
        var button = UIButton(frame: CGRect(x: 10, y: 50, width: 50, height: 50))
        button.backgroundColor = .systemRed
        button.setTitle("<-", for: .normal)
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        button.tag = 2
        newView.addSubview(button)
        
        
        // Create reset to default config button.
        let resetConfigButton = UIButton(frame: CGRect(x: 120, y: 50, width: 150, height: 50))
        resetConfigButton.backgroundColor = .systemGreen
        resetConfigButton.setTitle("Reset Config", for: .normal)
        resetConfigButton.tag = 0
        resetConfigButton.addTarget(self, action: #selector(resetToDefaultConfig), for: .touchUpInside)
        newView.addSubview(resetConfigButton)
        
        
        // Create suggestion buttons for user.
        
        let startingX: CGFloat = 25
        let startingY: CGFloat = 130
        let defaultButtonHeight: CGFloat = 100
        let defaultButtonWidth: CGFloat = 100
        
        // First button
        var firstTitle = ""
        
        if (config.keys.contains("1Button")) {
            if let val = config["1Button"] {
                firstTitle = val
            }
        }
        
        button = UIButton(frame: CGRect(x: startingX, y: startingY, width: defaultButtonWidth, height: defaultButtonHeight))
        button.backgroundColor = .systemCyan // change color here.
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping // Allows new line text wrap.
        button.titleLabel?.textAlignment = NSTextAlignment.center // centers text for when line wraps.
        button.setTitle(firstTitle, for: .normal)
        button.tag = 1 // Send which button through tag
        button.addTarget(self, action: #selector(didSelectButton), for: .touchUpInside)
        newView.addSubview(button)
        
        
        var previousX = button.frame.maxX
        var currentX = previousX + separator
        
        // Second button
        var secondTitle = ""
        
        if (config.keys.contains("2Button")) {
            if let val = config["2Button"] {
                secondTitle = val
            }
        }
        
        button = UIButton(frame: CGRect(x: currentX, y: 130, width: defaultButtonWidth, height: defaultButtonHeight))
        button.backgroundColor = .systemMint
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        button.titleLabel?.textAlignment = NSTextAlignment.center
        button.setTitle(secondTitle, for: .normal)
        button.tag = 2
        button.addTarget(self, action: #selector(didSelectButton), for: .touchUpInside)
        newView.addSubview(button)
        
        
        previousX = button.frame.maxX
        currentX = previousX + separator
        
        // Third button
        var thirdTitle = ""
        
        if (config.keys.contains("3Button")) {
            if let val = config["3Button"] {
                thirdTitle = val
            }
        }
        
        button = UIButton(frame: CGRect(x: previousX + separator, y: 130, width: defaultButtonWidth, height: defaultButtonHeight))
        button.backgroundColor = .systemGreen
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        button.titleLabel?.textAlignment = NSTextAlignment.center
        button.setTitle(thirdTitle, for: .normal)
        button.tag = 3
        button.addTarget(self, action: #selector(didSelectButton), for: .touchUpInside)
        newView.addSubview(button)
        
        // New Row
        
        var previousY = button.frame.maxY
        var currentY = previousY + separator
        
        // Fourth button
        var fourthTitle = ""
        
        if (config.keys.contains("4Button")) {
            if let val = config["4Button"] {
                fourthTitle = val
            }
        }
        
        button = UIButton(frame: CGRect(x: startingX, y: currentY, width: defaultButtonWidth, height: defaultButtonHeight))
        button.backgroundColor = .systemRed
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        button.titleLabel?.textAlignment = NSTextAlignment.center
        button.setTitle(fourthTitle, for: .normal)
        button.tag = 4
        button.addTarget(self, action: #selector(didSelectButton), for: .touchUpInside)
        newView.addSubview(button)
        
        previousX = button.frame.maxX
        currentX = previousX + separator
        
        // Fifth button
        var fifthTitle = ""
        
        if (config.keys.contains("5Button")) {
            if let val = config["5Button"] {
                fifthTitle = val
            }
        }
        
        
        button = UIButton(frame: CGRect(x: currentX, y: currentY, width: defaultButtonWidth, height: defaultButtonHeight))
        button.backgroundColor = .systemOrange
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        button.titleLabel?.textAlignment = NSTextAlignment.center
        button.setTitle(fifthTitle, for: .normal)
        button.tag = 5
        button.addTarget(self, action: #selector(didSelectButton), for: .touchUpInside)
        newView.addSubview(button)
        
        previousX = button.frame.maxX
        currentX = previousX + separator
        
        // Sixth Button
        
        var sixthTitle = ""
        
        if (config.keys.contains("6Button")) {
            if let val = config["6Button"] {
                sixthTitle = val
            }
        }
        button = UIButton(frame: CGRect(x: currentX, y: currentY, width: defaultButtonWidth, height: defaultButtonHeight))
        button.backgroundColor = .systemYellow
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        button.titleLabel?.textAlignment = NSTextAlignment.center
        button.setTitle(sixthTitle, for: .normal)
        button.tag = 6
        button.addTarget(self, action: #selector(didSelectButton), for: .touchUpInside)
        newView.addSubview(button)
        
        previousY = button.frame.maxY
        currentY = previousY + separator
        currentX = startingX + 5.0
        
        
        return newView
        
    }
    
    func editConfigView() -> UIView {
        
        let configView = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 1000))
        
        // Create back button.
        let backButton = UIButton(frame: CGRect(x: 10, y: 50, width: 50, height: 50))
        backButton.backgroundColor = .systemRed
        backButton.setTitle("<-", for: .normal)
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        backButton.tag = 1
        configView.addSubview(backButton)
        
        let key = String(currentlyEdittingButton) + "Button"
        
        var retrievedName: String = ""
        var retrievedValue: Int = 0
        
        if (config.keys.contains(key)) {
            if let val = config[key] {
                retrievedName = val
                
                if let grams = stripProteinFrom(str: retrievedName) {
                    retrievedValue = grams
                }
                
                // find index of "(", remove everything past that.
                while(retrievedName.contains("(")) {
                    retrievedName.removeLast()
                }
            }
        }
        
        let firstOutlet = UITextField(frame: CGRect(x: 115, y: 100, width: 150, height: 50))
        firstOutlet.textAlignment = NSTextAlignment.center
        firstOutlet.borderStyle = .roundedRect
        firstOutlet.text = retrievedName
        firstOutlet.addTarget(self, action: #selector(saveName), for: .allEvents)
        configView.addSubview(firstOutlet)
        saveName(sender: firstOutlet)
        
        
        // Create text outlet for config value
        let textOutlet = UITextField(frame: CGRect(x: 115, y: 150, width: 150, height: 50))
        textOutlet.textAlignment = NSTextAlignment.center
        textOutlet.borderStyle = .roundedRect
        textOutlet.keyboardType = .numberPad
        
        if (retrievedValue > 0) {
            textOutlet.text = String(retrievedValue)
        } else {
            textOutlet.text = ""
        }
        
        textOutlet.addTarget(self, action: #selector(saveValue), for: .allEvents)
        configView.addSubview(textOutlet)
        saveValue(sender: textOutlet)


        let saveConfig = UIButton(frame: CGRect(x: 140, y: 220, width: 100, height: 50))
        saveConfig.backgroundColor = .systemGreen
        saveConfig.setTitle("SUBMIT", for: .normal)
        saveConfig.addTarget(self, action: #selector(saveToConfigFromButton), for: .touchUpInside)
        configView.addSubview(saveConfig)
    
        return configView
    }
    
    
    ///
    ///
    /// UI Functions
    ///
    ///
    
    
    // Calls saveToConfig then goes back to main page.
    @objc func saveToConfigFromButton(sender: UIButton) {
        saveToConfig()
        configView.removeFromSuperview()
        viewDidLoad()
    }
    
    // Hard coded default values for user.
    @objc func resetToDefaultConfig(sender: UIButton) {
        
        if (sender.tag == 0){
            
            // Resetting buttons 1-4 to their default state.
            buttonName = "1 Milk "
            buttonValue = "7"
            currentlyEdittingButton = 1
            saveToConfig()
            
            buttonName = "2 Eggs/1 Yogurt "
            buttonValue = "12"
            currentlyEdittingButton = 2
            saveToConfig()
            
            buttonName = "1 Whey "
            buttonValue = "25"
            currentlyEdittingButton = 3
            saveToConfig()
            
            buttonName = "2 Bread "
            buttonValue = "10"
            currentlyEdittingButton = 4
            saveToConfig()
            
            
            
        } else if (sender.tag == 1){
            // TODO: Only reset specified button in currentlyEdittingButton
            
            
            
            
            print("TODO")
        } else {
            print("unrecognized button tag")
        }
        
    }
    
    @objc func saveName(sender: UITextField!) {
        print("saved name")
        if let text = sender.text {
            buttonName = text
        }
    }
    @objc func saveValue(sender: UITextField!) {
        print("saved value")
        if let text = sender.text {
            buttonValue = text
        }
    }
    
    // Mark down which button we are editting from sender, then display our config view.
    @objc func didSelectButton(sender: UIButton!) {
        // Copy button from button's tag. E.g. 1 = first button.
        currentlyEdittingButton = sender.tag // Mark which button we are going to edit
        
        transitionView.removeFromSuperview()
        configView = editConfigView()
        
        view.addSubview(configView)
        viewContainer.removeFromSuperview()
        
    }
    
    @objc func addQuickEntry(sender: UIButton!) {
        let grams = sender.tag // Copy protein amount from button's tag. Default value = 0.
        
        guard (grams > 0) else { return }
        
        // Immitate sending from our textOutlet.
        let payload = UITextField()
        payload.text = String(grams)
        
        submitNewEntry(sender: payload)
    }
    
    @objc func goBack(sender: UIButton!){
        // Back Buttons are tagged by which view sent them.
        // 0 = entryView, 1 = configView
        if (sender.tag == 0) {
            entryView.removeFromSuperview()
        } else if (sender.tag == 1) {
            configView.removeFromSuperview()
        } else if (sender.tag == 2) {
            transitionView.removeFromSuperview()
            
        }
        
        viewDidLoad()
    }

    @objc func addEntryButton(sender: UIButton!) {
        entryView = addEntryView()
        
        view.addSubview(entryView)
        viewContainer.removeFromSuperview()
    }
    
    @objc func editConfigButton(sender: UIButton!) {
        transitionView = transitionConfigView()
        
        view.addSubview(transitionView)
        viewContainer.removeFromSuperview()
    }
    
    @objc func clearList(sender: UIButton!) {
        listOfEntries = [] // clear list
        
        totalSum = 0
        
        saveListToStorage()
        
        viewContainer.removeFromSuperview()
        
        viewDidLoad()
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
    
    ///
    ///
    /// Helper Functions
    ///
    ///

    // Saves pair {currentlyEdittingButton} : {name and value} into config.
    func saveToConfig() {
        
        let buttonText = String(currentlyEdittingButton) + "Button" // Determine button we are editting.
        
        let values = buttonName + "(" + buttonValue + "g)"
        let text = "{\"" + buttonText + "\":\"" + values + "\"}"
        
            if let dict = dictFromString(str: text) {
                config = config.merging(dict){ (_, new) in new } // merges config with new values in dict.
                storeConfig(config: config)
            } else {
                print("failed dict from String")
            }
    }
    
    // Helper function for finding how much protein is in the title
    // E.g. "+1 test value (18g)" -> 18
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
    /// Storage Helper Functions
    ///
    
    /// Config
    // Retrieve a string version of config to store.
    func stringifyConfig(config: Dictionary<String, String>) -> String {
        var str = "{"
        for (key, value) in config {
            str += ("\"" + key + "\" : \"" + value + "\",")
        }
        str += "}"
        return str
    }
    
    // Given a string dictionary, format into usable data type.
    func dictFromString(str: String) -> Dictionary<String, String>? {

        if let data = str.data(using: .utf8) {
            return try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
        }
        return nil
    }
    
    /// Entries
    // [15, 25, 30, 40] -> "15+25+30+40+"
    func toStorage(list: [Int]) -> String {
        var str = ""
        for item in list{
            str += (String(item) + "+")
        }
        
        return str
    }
    
    func toList(str: String) -> [Int] {
        var newList: [Int] = []
        
        for item in str.components(separatedBy: ["+"]){
            if let itemInt = Int(item) {newList.append(itemInt)} else { return newList }
        }
        
        return newList
    }
    
    ///
    /// Loading from and saving to storage.
    ///
    
    func saveListToStorage() {
        
        let defaults = UserDefaults.standard
        
        let storedList = toStorage(list: listOfEntries)
        defaults.set(storedList, forKey: DefaultsKeys.entryKey)
    }
    
    func loadListFromStorage() {
        
        let defaults = UserDefaults.standard
        
        if let storedList = defaults.string(forKey: DefaultsKeys.entryKey) {
            listOfEntries = toList(str: storedList)
        }
    }
    
    // Puts dictionary config into storage
    func storeConfig(config: Dictionary<String, String>){
        
        let defaults = UserDefaults.standard
        
        let str = stringifyConfig(config: config)
        defaults.set(str, forKey: DefaultsKeys.configKey)
    }
    
    // Retrieves a config from storage as a dictionary
    func loadConfig()  {
        
        let defaults = UserDefaults.standard
        
        if let storedConfigStr = defaults.string(forKey: DefaultsKeys.configKey) {
            if let dict = dictFromString(str: storedConfigStr) {
                config = dict
            }
        }
    }


}
