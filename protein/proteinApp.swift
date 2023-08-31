//
//  proteinApp.swift
//  protein
//
//  Created by Tyler Hernandez on 3/21/23.
//

import SwiftUI

@main
struct ProteinApp: App {
    
    var globalString = GlobalString()
    
    var body: some Scene {
        WindowGroup {
            homeView(globalString: globalString)
                .onOpenURL { url in
                    handleOpenURL(url)
                }
        }
    }
    
    func handleOpenURL(_ url: URL) {
        // Check if the URL contains "addProtein"
        if url.absoluteString.contains("addProtein") {
            if let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
               let queryItems = components.queryItems {
                
                // Loop through URL parameters
                for item in queryItems {
                    if item.name == "amount", let itemValue = item.value, let grams = Int(itemValue) {
                        
                        let date = Calendar.current.startOfDay(for: Date())
                        addQuickEntry(date: date.formatted(date: .long, time: .omitted), grams: grams)
                    }
                }
            }
        }
    }
    
    func addQuickEntry(date: String, grams: Int) {
        guard grams > 0 else { return }
        
        // Need to reload our globalString in order to access up to date values.
        globalString.reload(date: date)
        globalString.listOfEntries.append(Entry(grams: grams))
        globalString.saveListToStorage(date: date)
        
    }
}

