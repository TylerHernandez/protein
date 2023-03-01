//
//  ViewController.swift
//  protein
//
//  Created by Tyler Hernandez on 9/29/22.
//

import UIKit


struct DefaultsKeys {
    static let entryKey = "this_is_my_key"
    static let configKey = "this_is_my_config_key"
}


class ViewController: UIViewController {
    
    // Config
    var buttonName = ""
    var buttonValue = ""
    var config: Dictionary<String, String> = [:]
    var currentlyEdittingButton = 6 // Keeps track of which button we are editting.
    
    // Home
    var totalSum = 0
    var listOfEntries: [Int] = []


    // Views
    var viewContainer: UIView = UIView()
    var entryView: UIView = UIView()
    var configView: UIView = UIView()
    var transitionView: UIView = UIView()
    
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
    /// UI Functions
    ///
    ///
    
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
    
  
    
    ///
    /// Storage Helper Functions
    ///

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


}
