//
//  config.swift
//  protein
//
//  Created by Tyler Hernandez on 2/28/23.
//

import UIKit

extension ViewController {
    
    
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
    @objc func didSelectConfigureButton(sender: UIButton!) {
        // Copy button from button's tag. E.g. 1 = first button.
        currentlyEdittingButton = sender.tag // Mark which button we are going to edit
        
        transitionView.removeFromSuperview()
        configView = editConfigView()
        
        view.addSubview(configView)
        viewContainer.removeFromSuperview()
        
    }
    
    // Config button pressed, display transition view.
    @objc func editConfigButton(sender: UIButton!) {
        transitionView = transitionConfigView()
        
        view.addSubview(transitionView)
        viewContainer.removeFromSuperview()
    }
    
    
    ///
    /// Helper Functions
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
    
    // Retrieve a string version of config to store.
    func stringifyConfig(config: Dictionary<String, String>) -> String {
        var str = "{"
        for (key, value) in config {
            str += ("\"" + key + "\" : \"" + value + "\",")
        }
        str += "}"
        return str
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
    
    // Given a string dictionary, format into usable data type.
    func dictFromString(str: String) -> Dictionary<String, String>? {

        if let data = str.data(using: .utf8) {
            return try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
        }
        return nil
    }
    
    
    ///
    /// Transition Config View
    ///
    
    func transitionConfigView() -> UIView {
        
        // Display our buttons and their current values.
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
        button.tag = 2
        newView.addSubview(button)
        
        
        // Create reset to default config button.
        let resetConfigButton = UIButton(frame: CGRect(x: 130, y: 50, width: 150, height: 50))
        resetConfigButton.backgroundColor = .systemGreen
        resetConfigButton.setTitle("Reset Config", for: .normal)
        resetConfigButton.tag = 0
        resetConfigButton.addTarget(self, action: #selector(resetToDefaultConfig), for: .touchUpInside)
        newView.addSubview(resetConfigButton)
        
        
        // Create suggestion buttons for user.
        
        let startingX: CGFloat = 35
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
        button.addTarget(self, action: #selector(didSelectConfigureButton), for: .touchUpInside)
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
        
        button = UIButton(frame: CGRect(x: currentX, y: startingY, width: defaultButtonWidth, height: defaultButtonHeight))
        button.backgroundColor = .systemMint
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        button.titleLabel?.textAlignment = NSTextAlignment.center
        button.setTitle(secondTitle, for: .normal)
        button.tag = 2
        button.addTarget(self, action: #selector(didSelectConfigureButton), for: .touchUpInside)
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
        
        button = UIButton(frame: CGRect(x: previousX + separator, y: startingY, width: defaultButtonWidth, height: defaultButtonHeight))
        button.backgroundColor = .systemGreen
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        button.titleLabel?.textAlignment = NSTextAlignment.center
        button.setTitle(thirdTitle, for: .normal)
        button.tag = 3
        button.addTarget(self, action: #selector(didSelectConfigureButton), for: .touchUpInside)
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
        button.addTarget(self, action: #selector(didSelectConfigureButton), for: .touchUpInside)
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
        button.addTarget(self, action: #selector(didSelectConfigureButton), for: .touchUpInside)
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
        button.addTarget(self, action: #selector(didSelectConfigureButton), for: .touchUpInside)
        newView.addSubview(button)
        
        previousY = button.frame.maxY
        currentY = previousY + separator
        currentX = startingX + 5.0
        
        
        return newView
        
    }
    
    
    // Edit Config View
    
    func editConfigView() -> UIView {
        
        let bounds = UIScreen.main.bounds
//        let width = bounds.size.width
//        let height = bounds.size.height
        let configView = UIView(frame: CGRect(x: bounds.midX - 200, y: bounds.midY - 350 , width: 400, height: 700))
        
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
        
        let firstOutlet = UITextField(frame: CGRect(x: 130, y: 100, width: 150, height: 50))
        firstOutlet.textAlignment = NSTextAlignment.center
        firstOutlet.borderStyle = .roundedRect
        firstOutlet.text = retrievedName
        firstOutlet.addTarget(self, action: #selector(saveName), for: .allEvents)
        configView.addSubview(firstOutlet)
        saveName(sender: firstOutlet)
        
        
        // Create text outlet for config value
        let textOutlet = UITextField(frame: CGRect(x: 130, y: 150, width: 150, height: 50))
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


        let saveConfig = UIButton(frame: CGRect(x: 130, y: 220, width: 150, height: 50))
        saveConfig.backgroundColor = .systemGreen
        saveConfig.titleLabel?.textAlignment = .center
        saveConfig.setTitle("SUBMIT", for: .normal)
        saveConfig.addTarget(self, action: #selector(saveToConfigFromButton), for: .touchUpInside)
        configView.addSubview(saveConfig)
    
        return configView
    }
    
    
    
}
