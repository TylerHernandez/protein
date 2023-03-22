//
//  homeView.swift
//  protein
//
//  Created by Tyler Hernandez on 3/21/23.
//

import SwiftUI

struct DefaultsKeys {
    static let entryKey = "this_is_my_key"
    static let configKey = "this_is_my_config_key"
}

class GlobalString: ObservableObject {
    @Published var listOfEntries: [Int]
    
    @Published var config : Dictionary<String, String>
    
    init() {
        listOfEntries = []
        config = [:]
    }
    
    func reload() {
        listOfEntries = loadListFromStorage()
        config = loadConfigFromStorage()
    }
    
    func intake() -> Int {
        var sum = 0
        for item in listOfEntries {
            sum += item
        }
        return sum
    }
    
    // Retrieves a config from storage as a dictionary
    func loadConfigFromStorage() -> Dictionary<String, String> {
        
        let defaults = UserDefaults.standard
        
        if let storedConfigStr = defaults.string(forKey: DefaultsKeys.configKey) {
            if let dict = dictFromString(str: storedConfigStr) {
                return  dict
            }
        }
        return [:]
    }
    
    // Given a string dictionary, format into usable data type.
    func dictFromString(str: String) -> Dictionary<String, String>? {

        if let data = str.data(using: .utf8) {
            return try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
        }
        return nil
    }
    
    func loadListFromStorage() -> [Int] {
        
        let defaults = UserDefaults.standard
        
        if let storedList = defaults.string(forKey: DefaultsKeys.entryKey) {
            return toList(str: storedList)
        }
        return []
    }
    
    func toList(str: String) -> [Int] {
        var newList: [Int] = []
        
        for item in str.components(separatedBy: ["+"]){
            if let itemInt = Int(item) {newList.append(itemInt)} else { return newList }
        }
        
        return newList
    }
    
    
    
}

struct homeView: View {
    @StateObject var globalString = GlobalString()
    
    var body: some View {
        NavigationView {
            VStack{
                
                HStack(spacing: 30){
                
                    NavigationLink(destination: calendarView()){
                        Text("Calendar View")
                    }
                    
                    NavigationLink(destination: saveProteinView(intake: globalString.intake())){
                        Text("Save Protein View")
                    }
                    
                    NavigationLink(destination: entryView()){
                        Text("Entry View")
                    }
                    
                } // Ends HStack
                
                //Spacer()
                
                List {
                    ForEach(globalString.listOfEntries, id: \.self) { entry in
                        Text("\(entry)")
                    }
                }.onAppear {
                    globalString.reload()
                }
                
                
                Text("total sum: \(totalSum())")
                
                
            }// Ends VStack
            .navigationTitle("Navigation View")
        }
        
    }
    
    func totalSum() -> Int {
        var sum = 0
        for x in globalString.listOfEntries {
            sum += x
        }
        return sum
    }
    

}

struct homeView_Previews: PreviewProvider {
    static var previews: some View {
        homeView()
    }
}
