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
            
            Button ("Reset Config"){
                configHelper(globalString: globalString).resetToDefaultConfig()
            }
            
            
            HStack {
                Spacer()
                
                NavigationLink (globalString.config["1Button"] ?? "Configure me"){
                    editConfigView(date: date,
                                   button: "1Button",
                                   foodName: stripTitleFrom(str: globalString.config["1Button"] ?? ""),
                                   foodValue: stripProteinFrom(str: globalString.config["1Button"] ?? "") ?? 0,
                                   showPopup: false
                    )
                }
                .padding(8)
                .frame(width: 130, height: 120, alignment: .center )
                .font(.system(size: 18))
                .buttonStyle(.bordered)
                .multilineTextAlignment(.center)
                .foregroundColor(.blue)
                
                Spacer()
                
                NavigationLink (globalString.config["2Button"] ?? "Configure me"){
                    editConfigView(date: date,
                                   button: "2Button",
                                   foodName: stripTitleFrom(str: globalString.config["2Button"] ?? ""),
                                   foodValue: stripProteinFrom(str: globalString.config["2Button"] ?? "") ?? 0,
                                   showPopup: false
                    )
                }
                .padding(8)
                .frame(width: 130, height: 120, alignment: .center )
                .font(.system(size: 18))
                .buttonStyle(.bordered)
                .multilineTextAlignment(.center)
                .foregroundColor(.red)
                
                
                Spacer()
                
                NavigationLink (globalString.config["3Button"] ?? "Configure me"){
                    editConfigView(date: date,
                                   button: "3Button",
                                   foodName: stripTitleFrom(str: globalString.config["3Button"] ?? ""),
                                   foodValue: stripProteinFrom(str: globalString.config["3Button"] ?? "") ?? 0,
                                   showPopup: false
                    )
                }
                .padding(8)
                .frame(width: 130, height: 120, alignment: .center )
                .font(.system(size: 18))
                .buttonStyle(.bordered)
                .multilineTextAlignment(.center)
                .foregroundColor(.green)
                
                Spacer()
            } // Hstack 1
            HStack {
                Spacer()
                NavigationLink (globalString.config["4Button"] ?? "Configure me"){
                    editConfigView(date: date,
                                   button: "4Button",
                                   foodName: stripTitleFrom(str: globalString.config["4Button"] ?? ""),
                                   foodValue: stripProteinFrom(str: globalString.config["4Button"] ?? "") ?? 0,
                                   showPopup: false
                    )
                }
                .padding(8)
                .frame(width: 130, height: 120, alignment: .center )
                .font(.system(size: 18))
                .buttonStyle(.bordered)
                .multilineTextAlignment(.center)
                .foregroundColor(.yellow)
                
                Spacer()
                NavigationLink (globalString.config["5Button"] ?? "Configure me"){
                    editConfigView(date: date,
                                   button: "5Button",
                                   foodName: stripTitleFrom(str: globalString.config["5Button"] ?? ""),
                                   foodValue: stripProteinFrom(str: globalString.config["5Button"] ?? "") ?? 0,
                                   showPopup: false
                    )
                }
                .padding(8)
                .frame(width: 130, height: 120, alignment: .center )
                .font(.system(size: 18))
                .buttonStyle(.bordered)
                .multilineTextAlignment(.center)
                .foregroundColor(.orange)
                
                Spacer()
                NavigationLink (globalString.config["6Button"] ?? "Configure me"){
                    editConfigView(date: date,
                                   button: "6Button",
                                   foodName: stripTitleFrom(str: globalString.config["6Button"] ?? ""),
                                   foodValue: stripProteinFrom(str: globalString.config["6Button"] ?? "") ?? 0,
                                   showPopup: false
                    )
                }
                .padding(8)
                .frame(width: 130, height: 120, alignment: .center )
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
                Button("Submitted"){}
                    .font(.system(size: 25))
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                    .onAppear(){
                        showPopup = false
                    }
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
                    configHelper(globalString: globalString).saveToConfig(foodName: foodName, foodValue: foodValue, button: button)
                    showPopup = true
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
    
}// ends struct

struct configHelper {
    
    @StateObject var globalString: GlobalString
    
    func resetToDefaultConfig() {

        // Resetting buttons to their default state.
        saveToConfig(foodName: "Cup of Milk", foodValue: 8, button: "1Button")
        saveToConfig(foodName: "4oz Chicken Breast", foodValue: 35, button: "2Button")
        saveToConfig(foodName: "Scoop of Whey", foodValue: 25, button: "3Button")
        saveToConfig(foodName: "3 Eggs", foodValue: 18, button: "4Button")
        saveToConfig(foodName: "Nonfat Greek Yogurt", foodValue: 17, button: "5Button")
        saveToConfig(foodName: "Protein Bar", foodValue: 20, button: "6Button")

    }
    
    // Saves pair {button} : {name and value} into config.
    func saveToConfig(foodName: String, foodValue: Int, button: String) {

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
    
    // Puts dictionary config into storage
    func storeConfig(config: Dictionary<String, String>){

        let defaults = UserDefaults.standard

        let str = stringifyConfig(config: config)
        defaults.set(str, forKey: DefaultsKeys.configKey)
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

    // Given a string dictionary, format into usable data type.
    func dictFromString(str: String) -> Dictionary<String, String>? {

        if let data = str.data(using: .utf8) {
            return try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
        }
        return nil
    }
}

struct configurationView_Previews: PreviewProvider {
    static var previews: some View {
        editConfigView(date: "", button: "1Button", showPopup: false).preferredColorScheme(.dark)
    }
}
