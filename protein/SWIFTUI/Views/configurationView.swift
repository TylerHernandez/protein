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
        VStack{
            
            NavigationLink ("Reset Config"){
                editConfigView(date: date, button: "", showPopup: true)
            }
            
            
            HStack {
                Spacer()
                
                NavigationLink (globalString.config["1Button"] ?? "1Button"){
                    editConfigView(date: date,
                                   button: "1Button",
                                   foodName: stripTitleFrom(str: globalString.config["1Button"] ?? ""),
                                   foodValue: stripProteinFrom(str: globalString.config["1Button"] ?? "") ?? 0,
                                   showPopup: false
                    )
                }
                .padding(10)
                .frame(width: 110, height: 100, alignment: .center )
                .font(.system(size: 18))
                .buttonStyle(.bordered)
                .multilineTextAlignment(.center)
                .foregroundColor(.blue)
                
                Spacer()
                
                NavigationLink (globalString.config["2Button"] ?? "2Button"){
                    editConfigView(date: date,
                                   button: "2Button",
                                   foodName: stripTitleFrom(str: globalString.config["2Button"] ?? ""),
                                   foodValue: stripProteinFrom(str: globalString.config["2Button"] ?? "") ?? 0,
                                   showPopup: false
                    )
                }
                .padding(10)
                .frame(width: 110, height: 100, alignment: .center )
                .font(.system(size: 18))
                .buttonStyle(.bordered)
                .multilineTextAlignment(.center)
                .foregroundColor(.red)
                
                
                Spacer()
                
                NavigationLink (globalString.config["3Button"] ?? "3Button"){
                    editConfigView(date: date,
                                   button: "3Button",
                                   foodName: stripTitleFrom(str: globalString.config["3Button"] ?? ""),
                                   foodValue: stripProteinFrom(str: globalString.config["3Button"] ?? "") ?? 0,
                                   showPopup: false
                    )
                }
                .padding(10)
                .frame(width: 110, height: 100, alignment: .center )
                .font(.system(size: 18))
                .buttonStyle(.bordered)
                .multilineTextAlignment(.center)
                .foregroundColor(.green)
                
                Spacer()
            } // Hstack 1
            HStack {
                Spacer()
                NavigationLink (globalString.config["4Button"] ?? "4Button"){
                    editConfigView(date: date,
                                   button: "4Button",
                                   foodName: stripTitleFrom(str: globalString.config["4Button"] ?? ""),
                                   foodValue: stripProteinFrom(str: globalString.config["4Button"] ?? "") ?? 0,
                                   showPopup: false
                    )
                }
                .padding(10)
                .frame(width: 110, height: 100, alignment: .center )
                .font(.system(size: 18))
                .buttonStyle(.bordered)
                .multilineTextAlignment(.center)
                .foregroundColor(.yellow)
                
                Spacer()
                NavigationLink (globalString.config["5Button"] ?? "5Button"){
                    editConfigView(date: date,
                                   button: "5Button",
                                   foodName: stripTitleFrom(str: globalString.config["5Button"] ?? ""),
                                   foodValue: stripProteinFrom(str: globalString.config["5Button"] ?? "") ?? 0,
                                   showPopup: false
                    )
                }
                .padding(10)
                .frame(width: 110, height: 100, alignment: .center )
                .font(.system(size: 18))
                .buttonStyle(.bordered)
                .multilineTextAlignment(.center)
                .foregroundColor(.orange)
                
                Spacer()
                NavigationLink (globalString.config["6Button"] ?? "6Button"){
                    editConfigView(date: date,
                                   button: "6Button",
                                   foodName: stripTitleFrom(str: globalString.config["6Button"] ?? ""),
                                   foodValue: stripProteinFrom(str: globalString.config["6Button"] ?? "") ?? 0,
                                   showPopup: false
                    )
                }
                .padding(10)
                .frame(width: 110, height: 100, alignment: .center )
                .font(.system(size: 18))
                .buttonStyle(.bordered)
                .multilineTextAlignment(.center)
                .foregroundColor(.purple)
                
                Spacer()
            } // Hstack 2
            
            Spacer().frame(width: 1, height: 60, alignment: .bottom)
        } // Ends VStack 1
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(false)
        .navigationTitle("Configuration")
        .onAppear {
            // Need to reload string with most up to date listOfEntries or it will be empty.
            globalString.reload(date: date)
        }// Ends onAppear
        .popover(isPresented: $showPopup) {
            ZStack {
                Button("SUBMITTED!") {
                    showPopup = false
                }
                    .font(.system(size: 25))
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
            }.background(BackgroundBlurView())
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
    
}// Ends Struct

struct editConfigView : View {
    
    var date : String
    
    @State var button: String
    
    @StateObject var globalString = GlobalString()
    
    @State var foodName: String = ""
    @State var foodValue: Int = 0
    
    @State var showPopup: Bool
    
    var body : some View {
        VStack {
            Form {
                Text("Editting \(button)")
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
                    saveToConfig()
                }
                
                
                
            }.onDisappear() {
            }
        }
        .onAppear {
            // Need to reload string with most up to date listOfEntries or it will be empty.
            print("Refreshing config from storage")
            globalString.reload(date: date)
        }// Ends onAppear
        
        .popover(isPresented: $showPopup) {
            ZStack {
                Button("Reset Configuration") {
                    resetToDefaultConfig()
                    showPopup = false
                }
                    .font(.system(size: 25))
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
            }.background(BackgroundBlurView())
        }
        
    }
    
    func resetToDefaultConfig() {

        // Resetting buttons 1-4 to their default state.
        foodName = "1 Milk"
        foodValue = 7
        button = "1Button"
        saveToConfig()

        foodName = "2 Eggs/1 Yogurt"
        foodValue = 12
        button = "2Button"
        saveToConfig()

        foodName = "1 Whey"
        foodValue = 25
        button = "3Button"
        saveToConfig()

        foodName = "2 Bread"
        foodValue = 10
        button = "4Button"
        saveToConfig()

    }
    
    // Saves pair {button} : {name and value} into config.
    func saveToConfig() {

        let buttonText = button // Determine button we are editting.
        
        let values = foodName + " (" + String(foodValue) + "g)"
        let text = "{\"" + buttonText + "\":\"" + values + "\"}"

            if let dict = dictFromString(str: text) {
                globalString.config = globalString.config.merging(dict){ (_, new) in new } // merges config with new values in dict.
                storeConfig(config: globalString.config)
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

    // Given a string dictionary, format into usable data type.
    func dictFromString(str: String) -> Dictionary<String, String>? {

        if let data = str.data(using: .utf8) {
            return try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
        }
        return nil
    }
    
}// ends struct

struct configurationView_Previews: PreviewProvider {
    static var previews: some View {
        editConfigView(date: "", button: "1Button", showPopup: false).preferredColorScheme(.dark)
    }
}
