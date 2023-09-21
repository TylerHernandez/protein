//
//  configurationView.swift
//  protein
//
//  Created by Tyler Hernandez on 3/26/23.
//

import SwiftUI

struct configurationView: View {
    
    var date : String
    
    @StateObject var globalString = GlobalString()
    
    @State private var showPopup = false
    
    
    var body: some View {
        ScrollView {
            VStack {
                
                let sortedKeys = globalString.config.keys.sorted {
                    globalString.config[$0]! < globalString.config[$1]!
                }
                
                // Loop through the sorted keys
                ForEach(Array(sortedKeys.enumerated()), id: \.offset) { index, key in
                    if index % 2 == 0 { // Only start a new HStack for even indices
                        HStack {
                            // Use the key to get the value and create the button
                            if let value = globalString.config[key] {
                                configButton(value: value, key: key)
                            }
                            
                            // Check if there's a next button
                            if index + 1 < sortedKeys.count {
                                let nextKey = sortedKeys[index + 1]
                                if let nextValue = globalString.config[nextKey] {
                                    configButton(value: nextValue, key: nextKey)
                                }
                            }
                        }
                    }
                }
                
                Button("Add New Config") {
                    addNewConfig()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                
            } // Ends VStack
            .navigationBarHidden(false)
            .navigationBarBackButtonHidden(false)
            .navigationTitle("Configuration")
            .onAppear {
                globalString.reload(date: date)
            }
        }
        
    }// Ends Body
    
        // Helper function for finding how much protein is in the title
        // E.g. "1 test value (18g)" -> 18
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
    
    // Take out protein value from string.
    // E.g. "1 test value (18g)" -> "1 test value "
    func stripTitleFrom(str: String) -> String {
        var input = str
        
        // find index of "(", remove everything past that.
        while(input.contains("(")) {
            input.removeLast()
        }
        return input
    }
    
    func configButton(value: String, key: String) -> some View {
        NavigationLink(value) {
            editConfigView(date: date,
                           buttonKey: key,
                           foodName: stripTitleFrom(str: value),
                           foodValue: stripProteinFrom(str: value) ?? 0,
                           showPopup: false
            )
        }
        .padding(8)
        .frame(width: 130, height: 120, alignment: .center)
        .font(.system(size: 18))
        .buttonStyle(.bordered)
        .multilineTextAlignment(.center)
        .foregroundColor(colorForButton(at: value))
    }
      
      func colorForButton(at value: String) -> Color {
          let colors: [Color] = [.blue, .red, .green, .yellow, .orange, .purple]
          if let index = Array(globalString.config.values.sorted()).firstIndex(of: value) {
              return colors[index % colors.count]
          }
          return .gray
      }
    
    func addNewConfig() {
        let uuidKey = UUID().uuidString
        globalString.config[uuidKey] = "*Configure me"
    }
    
}// Ends Struct

struct editConfigView : View {
    
    var date : String
    
    @State var buttonKey: String
    
    @StateObject var globalString = GlobalString()
    
    @State var foodName: String = ""
    @State var foodValue: Int = 0
    
    @State var showPopup: Bool
    
    var body : some View {
        VStack {
            Form {
                TextField("Enter Name", text: $foodName)
                HStack{
                    TextField("Protein (g)", value: $foodValue, format: .number).padding(0)
                    Text("grams")
                    Stepper("", onIncrement: {
                        foodValue += 1
                    }, onDecrement: {
                        foodValue -= 1
                    })
                    
                }
                
                Button("Save Configuration") {
                    print("saving to config")
                    print(foodName)
                    print(foodValue)
                    configHelper.saveToConfig(globalString: globalString, foodName: foodName, foodValue: foodValue, buttonKey: buttonKey)
                    showPopup = true
                }
                
                
                
            }.navigationBarItems(trailing: Button(action: deleteConfig) {
                Image(systemName: "trash")
                    .font(.title)
                    .foregroundColor(.red)
            })
        }
        .onAppear {
            // Need to reload string with most up to date listOfEntries or it will be empty.
            print("Refreshing config from storage")
            globalString.reload(date: date)
        }// Ends onAppear
        .popover(isPresented: $showPopup) {
            ZStack {
                Button("Saved!"){}
                    .font(.system(size: 25))
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                    .onAppear(){
                        showPopup = false
                    }
            }.background(BackgroundBlurView())
            
        }
        
    }
    
    func deleteConfig() {
        globalString.config.removeValue(forKey: buttonKey)
        print(buttonKey)
        configHelper.storeConfig(globalString: globalString)
    }
    
    
}// ends struct

struct configHelper {
    
    // Saves pair {button} : {name and value} into config.
    static func saveToConfig(globalString: GlobalString, foodName: String, foodValue: Int, buttonKey: String) {
        
        let values = foodName + " (" + String(foodValue) + "g)"
        let text = "{\"" + buttonKey + "\":\"" + values + "\"}"

            if let dict = dictFromString(str: text) {
                globalString.config = globalString.config.merging(dict){ (_, new) in new } // merges config with new values in dict.
                storeConfig(globalString: globalString)
                print("failed dict from String")
            }
    }
    
    // Puts dictionarysconfig into storage
    static func storeConfig(globalString: GlobalString){
        
        let config = globalString.config

        let defaults = UserDefaults.standard

        let str = stringifyConfig(config: config)
        defaults.set(str, forKey: DefaultsKeys.configKey)
    }
    
    // Retrieve a string version of config to store.
    static func stringifyConfig(config: Dictionary<String, String>) -> String {
        var str = "{"
        for (key, value) in config {
            str += ("\"" + key + "\" : \"" + value + "\",")
        }
        str += "}"
        return str
    }

    // Given a string dictionary, format into usable data type.
    static func dictFromString(str: String) -> Dictionary<String, String>? {

        if let data = str.data(using: .utf8) {
            return try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
        }
        return nil
    }
}
