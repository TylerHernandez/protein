//
//  home.swift
//  protein
//
//  Created by Tyler Hernandez on 2/28/23.
//

import UIKit
import SwiftUI

extension ViewController {
    
    @objc func clearList(sender: UIButton!) {
        listOfEntries = [] // clear list
        
        totalSum = 0
        
        saveListToStorage()
        
        viewContainer.removeFromSuperview()
        
        viewDidLoad()
    }
    
    @objc func viewHistory() {
        let calendarViewController = UIHostingController(rootView: calendarView(navigationController: self.navigationController))
            self.navigationController?.pushViewController(calendarViewController, animated: true)
        }
    
    @objc func viewSaveProtein() {
        let saveProteinViewController = UIHostingController(rootView: saveProteinView(navigationController: self.navigationController, intake: totalSum))
            self.navigationController?.pushViewController(saveProteinViewController, animated: true)
        }
    
    @objc func viewEntryView() {
        print("view entry view")
        let entryViewController = UIHostingController(rootView: protein.entryView(navigationController: self.navigationController, config: config))
            self.navigationController?.pushViewController(entryViewController, animated: true)
        }
    
    // TODO: change background color of app based on totalSum.
    func refreshViewContainer() -> UIView{
        print("refreshed")
        totalSum = 0 // Reset totalSum since we're going to recompute it below.
        
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        let height = bounds.size.height
        
        let homeView: UIView = UIView(frame: CGRect(x: bounds.minX, y: bounds.minY + 10, width: width, height: height))
        
        // Create clear list button.
        let clearListButton = UIButton(frame: CGRect(x: 10, y: 50, width: 50, height: 50))
        clearListButton.backgroundColor = .systemRed
        clearListButton.setTitle("-", for: .normal)
        clearListButton.addTarget(self, action: #selector(clearList), for: .touchUpInside)
        homeView.addSubview(clearListButton)
        
        // Create Edit Config button.
        let configButton = UIButton(frame: CGRect(x: (bounds.midX/2) - 25, y: 50, width: 50, height: 50))
        configButton.backgroundColor = .systemGreen
        configButton.setTitle("!", for: .normal)
        configButton.addTarget(self, action: #selector(editConfigButton), for: .touchUpInside)
        homeView.addSubview(configButton)
        
        // Create Save Protein.
        let saveButton = UIButton(frame: CGRect(x: (bounds.midX) - 25, y: 50, width: 50, height: 50))
        saveButton.backgroundColor = .systemGreen
        saveButton.setTitle("S", for: .normal)
        saveButton.addTarget(self, action: #selector(viewSaveProtein), for: .touchUpInside)
        homeView.addSubview(saveButton)
        
        // Create calendar view button.
        let historyButton = UIButton(frame: CGRect(x: (bounds.midX + (bounds.midX / 2)) - 25, y: 50, width: 50, height: 50))
        historyButton.backgroundColor = .systemGreen
        historyButton.setTitle("*", for: .normal)
        historyButton.addTarget(self, action: #selector(viewHistory), for: .touchUpInside)
        homeView.addSubview(historyButton)
        
        // Create Add Entry button.
        let entryButton = UIButton(frame: CGRect(x: (bounds.maxX - 10) - 50, y: 50, width: 50, height: 50))
        entryButton.backgroundColor = .systemBlue
        entryButton.setTitle("+", for: .normal)
        entryButton.addTarget(self, action: #selector(viewEntryView), for: .touchUpInside) // addEntryButton
        homeView.addSubview(entryButton)
        
        
        // TODO: use a table view to display our entries
        //let tableView = UITableView()
        
        var label = UILabel()
        // Retrieve list
        var separator = 30 // start off separator at 30, then continuously add to push down our list.
        for item in listOfEntries{
            // 90 to leave space for our total label - nvm this will not move once we add our table view
//            if(separator + 90 > )
            label = UILabel(frame: CGRect(x: 70, y: 150 + separator, width: 50, height: 50))
            label.text = String(item)
            label.font = label.font.withSize(25)
            separator += 30
            homeView.addSubview(label)
            totalSum += item
        }
        // Display sum line
        label = UILabel(frame: CGRect(x: 70, y: 150 + separator, width: 50, height: 50))
        label.text = "----"
        label.font = label.font.withSize(25)
        homeView.addSubview(label)
        separator += 20
        
        // Display sum
        label = UILabel(frame: CGRect(x: 70, y: 150 + separator, width: 150, height: 50))
        label.text = String(totalSum) + " grams"
        label.font = label.font.withSize(25)
        homeView.addSubview(label)
        return homeView
    }
}
