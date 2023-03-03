//
//  home.swift
//  protein
//
//  Created by Tyler Hernandez on 2/28/23.
//

import UIKit

extension ViewController {
    
    @objc func clearList(sender: UIButton!) {
        listOfEntries = [] // clear list
        
        totalSum = 0
        
        saveListToStorage()
        
        viewContainer.removeFromSuperview()
        
        viewDidLoad()
    }
    
    
    // TODO: change background color of app based on totalSum.
    func refreshViewContainer() -> UIView{
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
        let configButton = UIButton(frame: CGRect(x: bounds.midX - 25, y: 50, width: 50, height: 50))
        configButton.backgroundColor = .systemGreen
        configButton.setTitle("!", for: .normal)
        configButton.addTarget(self, action: #selector(editConfigButton), for: .touchUpInside)
        homeView.addSubview(configButton)
        
        // Create Add Entry button.
        let entryButton = UIButton(frame: CGRect(x: (bounds.maxX - 10) - 50, y: 50, width: 50, height: 50))
        entryButton.backgroundColor = .systemBlue
        entryButton.setTitle("+", for: .normal)
        entryButton.addTarget(self, action: #selector(addEntryButton), for: .touchUpInside)
        homeView.addSubview(entryButton)
        
        
        var label = UILabel()
        // Retrieve list
        var separator = 20 // start off separator at 20, then continuously add to push down our list.
        for item in listOfEntries{
            label = UILabel(frame: CGRect(x: 30, y: 130 + separator, width: 50, height: 50))
            label.text = String(item)
            separator += 20
            homeView.addSubview(label)
            totalSum += item
        }
        // Display sum line
        label = UILabel(frame: CGRect(x: 10, y: 130 + separator, width: 300, height: 50))
        label.text = "--------------------------------"
        homeView.addSubview(label)
        separator += 20
        
        // Display sum
        label = UILabel(frame: CGRect(x: 30, y: 130 + separator, width: 100, height: 50))
        label.text = String(totalSum) + " grams"
        homeView.addSubview(label)
        return homeView
    }
}
