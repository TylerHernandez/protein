//
//  ViewController.swift
//  protein
//
//  Created by Tyler Hernandez on 9/29/22.
//

import UIKit

/*
 
    MVP: Display a list of numbers vertically and sum below. User is able to add numbers to list. User is able to reset list.
 
 */

struct DefaultsKeys {
    static let key = "this_is_my_key"
    static let configKey = "this_is_my_config_key"
}

class ViewController: UIViewController {
    
    var listOfEntries: [Int] = []
    var config: Dictionary<String, String> = [:]
    var totalSum = 0
    
    var viewContainer: UIView = UIView()
    var entryView: UIView = UIView()
    var configView: UIView = UIView()
    
    var currentEntry = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        loadListFromStorage()
        
        viewContainer = refreshViewContainer()
        
        view.addSubview(viewContainer)
        
        
      }
    
    // Prevents app from trying to display window horizontally
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait

        }
    }
    
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
        
        // 1 Glass of milk
        button = UIButton(frame: CGRect(x: startingX, y: startingY, width: defaultButtonWidth, height: defaultButtonHeight))
        button.backgroundColor = .systemCyan // change color here.
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping // Allows new line text wrap.
        button.titleLabel?.textAlignment = NSTextAlignment.center // centers text for when line wraps.
        button.setTitle("+1 Milk \n(7g)", for: .normal)
        button.tag = 7 // sends grams of protein through tag.
        button.addTarget(self, action: #selector(addQuickEntry), for: .touchUpInside)
        newView.addSubview(button)
        
        
        var previousX = button.frame.maxX
        var currentX = previousX + separator
        
        // 2 Eggs or 1 serving of yogurt
        button = UIButton(frame: CGRect(x: currentX, y: 130, width: defaultButtonWidth, height: defaultButtonHeight))
        button.backgroundColor = .systemMint
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        button.titleLabel?.textAlignment = NSTextAlignment.center
        button.setTitle("+2 Eggs/\n+1 Yogurt \n(12g)", for: .normal)
        button.tag = 12
        button.addTarget(self, action: #selector(addQuickEntry), for: .touchUpInside)
        newView.addSubview(button)
        
        
        previousX = button.frame.maxX
        currentX = previousX + separator
        
        // 1 Scoop of whey protein
        button = UIButton(frame: CGRect(x: previousX + separator, y: 130, width: defaultButtonWidth, height: defaultButtonHeight))
        button.backgroundColor = .systemGreen
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        button.titleLabel?.textAlignment = NSTextAlignment.center
        button.setTitle("+1 Whey \n(25g)", for: .normal)
        button.tag = 25
        button.addTarget(self, action: #selector(addQuickEntry), for: .touchUpInside)
        newView.addSubview(button)
        
        // New Row
        
        // 2 Slices of bread
        var previousY = button.frame.maxY
        var currentY = previousY + separator
        
        button = UIButton(frame: CGRect(x: startingX, y: currentY, width: defaultButtonWidth, height: defaultButtonHeight))
        button.backgroundColor = .systemRed
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        button.titleLabel?.textAlignment = NSTextAlignment.center
        button.setTitle("+2 Bread \n(10g)", for: .normal)
        button.tag = 10
        button.addTarget(self, action: #selector(addQuickEntry), for: .touchUpInside)
        newView.addSubview(button)
        
        previousX = button.frame.maxX
        currentX = previousX + separator
        
        // 1 serving of yogurt
        button = UIButton(frame: CGRect(x: currentX, y: currentY, width: defaultButtonWidth, height: defaultButtonHeight))
        button.backgroundColor = .systemOrange
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        button.titleLabel?.textAlignment = NSTextAlignment.center
        button.setTitle("", for: .normal)
        button.tag = 0
        button.addTarget(self, action: #selector(addQuickEntry), for: .touchUpInside)
        newView.addSubview(button)
        
        previousX = button.frame.maxX
        currentX = previousX + separator
        
        // Config Value
        
        var sixthTag = 0
        var sixthTitle = ""
        
        if (config.keys.contains("6thButton")) {
            if let val = config["6thButton"] {
                sixthTitle = val
                // TODO: Strip protein value from val and assign sixthTag.
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
        let textOutlet = UITextField(frame: CGRect(x: center - 75, y: currentY, width: 150, height: 35))
        textOutlet.textAlignment = NSTextAlignment.center
        textOutlet.placeholder = "input here"
        textOutlet.addTarget(self, action: #selector(submitNewEntry), for: .editingDidEndOnExit)
        textOutlet.keyboardType = .numbersAndPunctuation
        newView.addSubview(textOutlet)
        
        return newView
    }
    
    func editConfigView() -> UIView {
        
        let configView = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 700))
        
        // Create back button.
        let backButton = UIButton(frame: CGRect(x: 10, y: 50, width: 50, height: 50))
        backButton.backgroundColor = .systemRed
        backButton.setTitle("<-", for: .normal)
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        backButton.tag = 1
        configView.addSubview(backButton)
        
        // Create text outlet for config value
        let textOutlet = UITextField(frame: CGRect(x: 100, y: 100, width: 150, height: 65))
        textOutlet.textAlignment = NSTextAlignment.center
        textOutlet.text = "{\"6thButton\":\"+1TestValue\n(18g)\"}"
        textOutlet.addTarget(self, action: #selector(saveToConfig), for: .editingDidEndOnExit)
        configView.addSubview(textOutlet)
    
        return configView
    }
    
    @objc func saveToConfig(sender: UITextField!) {
        if let text = sender.text {
            if let dict = dictFromString(str: text) {
                config = dict
            }
        }
    }
    
    @objc func addQuickEntry(sender: UIButton!) {
        let grams = sender.tag // Copy protein amount from button's tag. Default value = 0.
        
        guard (grams > 0) else {return}
        
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
        }
        
        viewDidLoad()
    }

    @objc func addEntryButton(sender: UIButton!) {
        entryView = addEntryView()
        
        view.addSubview(entryView)
        viewContainer.removeFromSuperview()
    }
    
    @objc func editConfigButton(sender: UIButton!) {
        configView = editConfigView()
        
        view.addSubview(configView)
        viewContainer.removeFromSuperview()
    }
    
    @objc func clearList(sender: UIButton!) {
        listOfEntries = [] // clear list
        
        totalSum = 0
        
        saveListToStorage()
        
        viewContainer.removeFromSuperview()
        
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
    /// Storage Helper Functions
    ///
    
    /// Config
    // Retrieve a string version of config to store.
    func stringifyConfig(config: Dictionary<String, String>) -> String {
        var str = "{"
        for (key, value) in config {
            str += (key + " : " + value + ",")
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
    
    func stringFromDict(dict: Dictionary<String, String> ) -> String? {
        // TODO.
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
        defaults.set(storedList, forKey: DefaultsKeys.key)
    }
    
    func loadListFromStorage() {
        
        let defaults = UserDefaults.standard
        
        if let storedList = defaults.string(forKey: DefaultsKeys.key) {
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
        // look inside storage for existing config.
        
        let defaults = UserDefaults.standard
        
        if let storedConfigStr = defaults.string(forKey: DefaultsKeys.configKey) {
            if let dict = dictFromString(str: storedConfigStr) {
                config = dict
            }
        }
        
    }


}
