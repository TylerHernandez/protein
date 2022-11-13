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
    
    func refreshViewContainer() -> UIView{
        let newView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
        // Create Add Entry button.
        var button = UIButton(frame: CGRect(x: 325, y: 50, width: 50, height: 50))
        button.backgroundColor = .systemBlue
        button.setTitle("+", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        // Add Entry button to view.
        newView.addSubview(button)
        
        
        // Create clear list button.
        button = UIButton(frame: CGRect(x: 10, y: 50, width: 50, height: 50))
        button.backgroundColor = .systemRed
        button.setTitle("-", for: .normal)
        button.addTarget(self, action: #selector(clearList), for: .touchUpInside)
        
        // Add clear list button to view.
        newView.addSubview(button)
        
        
        
        var label = UILabel()
        // Retrieve list
        var separator = 20
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
        
        let label = UILabel(frame: CGRect(x: 30, y: 130, width: 300, height: 50))
        label.text = "Enter your protein intake"
        newView.addSubview(label)
       
        
        // Create a textbox for user to input their protein intake for a given meal
        
        let textOutlet = UITextField(frame: CGRect(x: 30, y: 150, width: 100, height: 100))
        textOutlet.placeholder = "input here"
        textOutlet.addTarget(self, action: #selector(submitNewEntry), for: .editingDidEndOnExit)
        newView.addSubview(textOutlet)
        
        return newView
    }

    @objc func buttonAction(sender: UIButton!) {
        
        entryView = addEntryView()
        
        view.addSubview(entryView)
        viewContainer.removeFromSuperview()
        //viewDidLoad()
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
            listOfEntries.append(num)
        }
        totalSum = 0
        
        saveListToStorage()
        
        entryView.removeFromSuperview()
        
        viewDidLoad()
        
    }
    
    // [15, 25, 30, 40] -> "15+25+30+40"
    func toStorage(list: [Int]) -> String{
        var str = ""
        for item in list{
            str += (String(item) + "+")
        }
        
        return str
    }
    
    func toList(json: String) -> [Int]{
        var newList: [Int] = []
        
        for item in json.components(separatedBy: ["+"]){
            if let itemInt = Int(item) {newList.append(itemInt)} else { return newList }
        }
        
        return newList
    }
    
    
    func saveListToStorage(){
        
        let defaults = UserDefaults.standard
        
        let storedList = toStorage(list: listOfEntries)
        defaults.set(storedList, forKey: DefaultsKeys.key)
    }
    
    func loadListFromStorage(){
        
        let defaults = UserDefaults.standard
        
        if let storedList = defaults.string(forKey: DefaultsKeys.key) {
            listOfEntries = toList(json: storedList)
        }
    }


}
