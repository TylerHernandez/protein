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
}

class ViewController: UIViewController {
    
    var listOfEntries: [Int] = []
    var totalSum = 0
    
    var viewContainer: UIView = UIView()
    var entryView: UIView = UIView()
    
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
        
        // Create Add Entry button.
        let entryButton = UIButton(frame: CGRect(x: 325, y: 50, width: 50, height: 50))
        entryButton.backgroundColor = .systemBlue
        entryButton.setTitle("+", for: .normal)
        entryButton.addTarget(self, action: #selector(addEntryButton), for: .touchUpInside)
        
        // Add Entry button to view.
        newView.addSubview(entryButton)
        
        // Create clear list button.
        let clearListButton = UIButton(frame: CGRect(x: 10, y: 50, width: 50, height: 50))
        clearListButton.backgroundColor = .systemRed
        clearListButton.setTitle("-", for: .normal)
        clearListButton.addTarget(self, action: #selector(clearList), for: .touchUpInside)
        
        // Add clear list button to view.
        newView.addSubview(clearListButton)
        
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
        let newView = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
        
        // Create a back button.
        var button = UIButton(frame: CGRect(x: 10, y: 50, width: 50, height: 50))
        button.backgroundColor = .systemRed
        button.setTitle("<-", for: .normal)
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        newView.addSubview(button)
        
        // Create suggestion buttons for user.
        
        // 1 Glass of Milk
        button = UIButton(frame: CGRect(x: 25, y: 130, width: 100, height: 100))
        button.backgroundColor = .systemCyan
        button.setTitle("+1 Milk", for: .normal)
        button.addTarget(self, action: #selector(addQuickEntry), for: .touchUpInside)
        newView.addSubview(button)
        
        // 2 Eggs
        button = UIButton(frame: CGRect(x: 145, y: 130, width: 100, height: 100))
        button.backgroundColor = .systemMint
        button.setTitle("+2 Eggs", for: .normal)
        button.addTarget(self, action: #selector(addQuickEntry), for: .touchUpInside)
        newView.addSubview(button)
        
        // 1 Scoop of whey protein
        button = UIButton(frame: CGRect(x: 265, y: 130, width: 100, height: 100))
        button.backgroundColor = .systemGreen
        button.setTitle("+1 Whey", for: .normal)
        button.addTarget(self, action: #selector(addQuickEntry), for: .touchUpInside)
        newView.addSubview(button)
        
        
        // Create instructional label.
        let label = UILabel(frame: CGRect(x: 30, y: 230, width: 300, height: 50))
        label.text = "Enter your protein intake"
        newView.addSubview(label)
       
        
        // Create a textbox for user to input their protein intake for a given meal.
        let textOutlet = UITextField(frame: CGRect(x: 30, y: 250, width: 150, height: 150))
        textOutlet.placeholder = "input here"
        textOutlet.addTarget(self, action: #selector(submitNewEntry), for: .editingDidEndOnExit)
        newView.addSubview(textOutlet)
        
        return newView
    }
    
    @objc func addQuickEntry(sender: UIButton!) {
        var grams = 0
        
        if (sender.currentTitle == "+1 Milk"){
            grams = 7
        }
        else if (sender.currentTitle == "+2 Eggs"){
            grams = 12
        }
        else if (sender.currentTitle == "+1 Whey"){
            grams = 25
        }
        
        guard (grams > 0) else {return}
        
        // Immitate sending from our textOutlet.
        let payload = UITextField()
        payload.text = String(grams)
        
        submitNewEntry(sender: payload)
    }
    
    @objc func goBack(sender: UIButton!){
        entryView.removeFromSuperview()
        viewDidLoad()
    }

    @objc func addEntryButton(sender: UIButton!) {
        entryView = addEntryView()
        
        view.addSubview(entryView)
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
    
    // [15, 25, 30, 40] -> "15+25+30+40+"
    func toStorage(list: [Int]) -> String {
        var str = ""
        for item in list{
            str += (String(item) + "+")
        }
        
        return str
    }
    
    func toList(json: String) -> [Int] {
        var newList: [Int] = []
        
        for item in json.components(separatedBy: ["+"]){
            if let itemInt = Int(item) {newList.append(itemInt)} else { return newList }
        }
        
        return newList
    }
    
    
    func saveListToStorage() {
        
        let defaults = UserDefaults.standard
        
        let storedList = toStorage(list: listOfEntries)
        defaults.set(storedList, forKey: DefaultsKeys.key)
    }
    
    func loadListFromStorage() {
        
        let defaults = UserDefaults.standard
        
        if let storedList = defaults.string(forKey: DefaultsKeys.key) {
            listOfEntries = toList(json: storedList)
        }
    }


}
