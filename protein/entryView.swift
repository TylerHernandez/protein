//
//  entryView.swift
//  protein
//
//  Created by Tyler Hernandez on 3/20/23.
//

import SwiftUI

class GlobalString: ObservableObject {
    @Published var listOfEntries: [Int] = loadListFromStorage()
    
    func loadListFromStorage() -> [Int] {
        
        let defaults = UserDefaults.standard
        
        if let storedList = defaults.string(forKey: DefaultsKeys.entryKey) {
            return toList(str: storedList)
        }
    }
    
    func toList(str: String) -> [Int] {
        var newList: [Int] = []
        
        for item in str.components(separatedBy: ["+"]){
            if let itemInt = Int(item) {newList.append(itemInt)} else { return newList }
        }
        
        return newList
    }
    
}

struct entryView: View {
    
    weak var navigationController: UINavigationController?
    
    var config : Dictionary<String, String> = [:]
    
    @StateObject var globalString = GlobalString()
    
    @State private var entry: String = ""
    
    @State private var removal: String = ""
    
    var body: some View {
        
        VStack {
            
            
            HStack {
                Spacer()
                
                Button(config["1Button"] ?? "1Button"){
                    addQuickEntry(grams: stripProteinFrom(str: config["1Button"] ?? "") ?? 0)
                }
                    .padding(10)
                    .frame(width: 110, height: 100, alignment: .center )
                    .font(.system(size: 18))
                    .buttonStyle(.bordered)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.blue)
                
                Spacer()
                
                Button(config["2Button"] ?? "2Button"){
                    addQuickEntry(grams: stripProteinFrom(str: config["2Button"] ?? "") ?? 0)
                }
                    .padding(10)
                    .frame(width: 110, height: 100, alignment: .center )
                    .font(.system(size: 18))
                    .buttonStyle(.bordered)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.red)
                
                
                Spacer()
                
                Button(config["3Button"] ?? "3Button"){
                    addQuickEntry(grams: stripProteinFrom(str: config["3Button"] ?? "") ?? 0)
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
                Button(config["4Button"] ?? "4Button"){
                    addQuickEntry(grams: stripProteinFrom(str: config["4Button"] ?? "") ?? 0)
                }
                    .padding(10)
                    .frame(width: 110, height: 100, alignment: .center )
                    .font(.system(size: 18))
                    .buttonStyle(.bordered)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.yellow)
                
                Spacer()
                Button(config["5Button"] ?? "5Button"){
                    addQuickEntry(grams: stripProteinFrom(str: config["5Button"] ?? "") ?? 0)
                }
                    .padding(10)
                    .frame(width: 110, height: 100, alignment: .center )
                    .font(.system(size: 18))
                    .buttonStyle(.bordered)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.orange)
                
                Spacer()
                Button(config["6Button"] ?? "6Button"){
                    addQuickEntry(grams: stripProteinFrom(str: config["6Button"] ?? "") ?? 0)
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
            VStack{
                TextField("Entry Here", text: $entry).frame(width: CGFloat(100), height: CGFloat(30), alignment: .center)
                TextField("Remove Here", text: $removal).frame(width: CGFloat(120), height: CGFloat(30), alignment: .center)
            } // Vstack 2
            
        } // Vstack 1
            .navigationBarHidden(false)
            .navigationBarBackButtonHidden(true)
            .navigationTitle("Entry View")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        navigationController?.popViewController(animated: true)
                        // navigationController?.topViewController?
                        // would like to refresh background view, or have background view listen to listOfEntries from here to update properly.
                        // Issue could be resolved by bringing whole app to swiftui but would like to integrate swiftui piece by piece.
                        // Ideally would need to reference the viewController from here and call it's goBack method or something of the sort.
                        
                    } label: {
                        HStack {
                            Image(systemName: "chevron.backward")
                            Text("Back")
                        }
                    }
                }
            } // ends toolbar.
    }
    
    
//    func removeOldEntry(sender: UITextField!) {
//        if let num = Int(sender.text!) {
//            if num > 0 { // these nums will never be added.
//                if let index = listOfEntries.lastIndex(of: num) {
//                    listOfEntries.remove(at: index)
//                }
//            }
//        }
//
//        saveListToStorage()
//
//    }
    
    func addQuickEntry(grams: Int) {
        
        guard (grams > 0) else { return }
        globalString.listOfEntries.append(grams)
        saveListToStorage()
    }
    
    func saveListToStorage() {
        
        let defaults = UserDefaults.standard
        
        let storedList = toStorage(list: globalString.listOfEntries)
        defaults.set(storedList, forKey: DefaultsKeys.entryKey)
    }
    
    // [15, 25, 30, 40] -> "15+25+30+40+"
    func toStorage(list: [Int]) -> String {
        var str = ""
        for item in list{
            str += (String(item) + "+")
        }
        
        return str
    }
    
    // Helper function for finding how much protein is in the title
    // E.g. "1 test value (18g)" -> 18
    func stripProteinFrom(str: String) -> Int? {
        var protein = ""
        
        if let startIndex = str.firstIndex(of: "(") {
            if let endIndex = str.lastIndex(of: "g"){
                let range = str.index(after: startIndex)..<endIndex
                protein = String(str[range])
            } else {return 0}
        } else {return 0}
        
        return Int(protein)
    }
    
}

struct entryView_Previews: PreviewProvider {
    static var previews: some View {
        entryView()
    }
}
