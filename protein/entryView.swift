//
//  entryView.swift
//  protein
//
//  Created by Tyler Hernandez on 3/20/23.
//

import SwiftUI

struct entryView: View {
    
    @StateObject var globalString = GlobalString()
    
    @State private var entry: String = ""
    
    @State private var removal: String = ""
    
    var body: some View {
        
        VStack {
            
            Button("Remove All"){
                for item in globalString.listOfEntries {
                    removeOldEntry(grams: item)
                }
                print("Removing all entries from list")
            } .padding(10)
                .frame(width: 110, height: 100, alignment: .center )
                .font(.system(size: 18))
                .buttonStyle(.bordered)
                .multilineTextAlignment(.center)
                .foregroundColor(.blue)
            
            HStack {
                Spacer()
                
                Button(globalString.config["1Button"] ?? "1Button"){
                    addQuickEntry(grams: stripProteinFrom(str: globalString.config["1Button"] ?? "") ?? 0)
                }
                    .padding(10)
                    .frame(width: 110, height: 100, alignment: .center )
                    .font(.system(size: 18))
                    .buttonStyle(.bordered)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.blue)
                
                Spacer()
                
                Button(globalString.config["2Button"] ?? "2Button"){
                    addQuickEntry(grams: stripProteinFrom(str: globalString.config["2Button"] ?? "") ?? 0)
                }
                    .padding(10)
                    .frame(width: 110, height: 100, alignment: .center )
                    .font(.system(size: 18))
                    .buttonStyle(.bordered)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.red)
                
                
                Spacer()
                
                Button(globalString.config["3Button"] ?? "3Button"){
                    addQuickEntry(grams: stripProteinFrom(str: globalString.config["3Button"] ?? "") ?? 0)
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
                Button(globalString.config["4Button"] ?? "4Button"){
                    addQuickEntry(grams: stripProteinFrom(str: globalString.config["4Button"] ?? "") ?? 0)
                }
                    .padding(10)
                    .frame(width: 110, height: 100, alignment: .center )
                    .font(.system(size: 18))
                    .buttonStyle(.bordered)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.yellow)
                
                Spacer()
                Button(globalString.config["5Button"] ?? "5Button"){
                    addQuickEntry(grams: stripProteinFrom(str: globalString.config["5Button"] ?? "") ?? 0)
                }
                    .padding(10)
                    .frame(width: 110, height: 100, alignment: .center )
                    .font(.system(size: 18))
                    .buttonStyle(.bordered)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.orange)
                
                Spacer()
                Button(globalString.config["6Button"] ?? "6Button"){
                    addQuickEntry(grams: stripProteinFrom(str: globalString.config["6Button"] ?? "") ?? 0)
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
                TextField("Entry Here", text: $entry).frame(width: CGFloat(100), height: CGFloat(30), alignment: .center).onSubmit {
                    addQuickEntry(grams: Int(entry) ?? 0)
                    print("Added \(entry)")
                }
                TextField("Remove Here", text: $removal).frame(width: CGFloat(120), height: CGFloat(30), alignment: .center).onSubmit {
                    removeOldEntry(grams: Int(removal) ?? 0)
                    print("Removed \(entry)")
                }
            } // Vstack 2
            
        } // Vstack 1
            .navigationBarHidden(false)
            .navigationBarBackButtonHidden(false)
            .navigationTitle("Entry View")
            .onAppear {
                // Need to reload string with most up to date listOfEntries or it will be empty.
                globalString.reload()
            }
    }
     
    
    func removeOldEntry(grams: Int) {
        if grams > 0 { // these nums will never be added.
            if let index = globalString.listOfEntries.lastIndex(of: grams) {
                globalString.listOfEntries.remove(at: index)
            }
        }

        saveListToStorage()

    }
    
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
