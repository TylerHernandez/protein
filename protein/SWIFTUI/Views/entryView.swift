//
//  entryView.swift
//  protein
//
//  Created by Tyler Hernandez on 3/20/23.
//

import SwiftUI

struct entryView: View {
    
    var date: String
    
    @StateObject var globalString = GlobalString()
    
    @State private var entry: String = ""
    
    @State private var removal: String = ""
    
    @State private var showPopup = false
    
    var body: some View {
        
        VStack {
            
            Button("Remove All"){
                for item in globalString.listOfEntries {
                    removeOldEntry(grams: item.grams)
                }
                print("Removing all entries from list")
                saveProteinToStorage()
                showPopup = true
            } .padding(8)
                .frame(width: 130, height: 120, alignment: .center )
                .font(.system(size: 18))
                .buttonStyle(.bordered)
                .multilineTextAlignment(.center)
                .foregroundColor(.blue)
            
            HStack {
                
                Button(globalString.config["1Button"] ?? "Cup of Milk (8g)"){
                    addQuickEntry(grams: stripProteinFrom(str: globalString.config["1Button"] ?? "Cup of Milk (8g)") ?? 0)
                    saveProteinToStorage()
                    showPopup = true
                }
                .padding(8)
                .frame(width: 130, height: 120, alignment: .center )
                .font(.system(size: 18))
                .buttonStyle(.bordered)
                .multilineTextAlignment(.center)
                .foregroundColor(.blue)
                
                Spacer()
                
                Button(globalString.config["2Button"] ?? "4oz Chicken Breast (35g)"){
                    addQuickEntry(grams: stripProteinFrom(str: globalString.config["2Button"] ?? "4oz Chicken Breast (35g)") ?? 0)
                    saveProteinToStorage()
                    showPopup = true
                }
                .padding(8)
                .frame(width: 130, height: 120, alignment: .center )
                .font(.system(size: 18))
                .buttonStyle(.bordered)
                .multilineTextAlignment(.center)
                .foregroundColor(.red)
                
                
                Spacer()
                
                Button(globalString.config["3Button"] ?? "Scoop of Whey (25g)"){
                    addQuickEntry(grams: stripProteinFrom(str: globalString.config["3Button"] ?? "Scoop of Whey (25g)") ?? 0)
                    saveProteinToStorage()
                    showPopup = true
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
                Button(globalString.config["4Button"] ?? "3 Eggs (18g)"){
                    addQuickEntry(grams: stripProteinFrom(str: globalString.config["4Button"] ?? "3 eggs (18g)") ?? 0)
                    saveProteinToStorage()
                    showPopup = true
                }
                .padding(8)
                .frame(width: 130, height: 120, alignment: .center )
                .font(.system(size: 18))
                .buttonStyle(.bordered)
                .multilineTextAlignment(.center)
                .foregroundColor(.yellow)
                
                Spacer()
                Button(globalString.config["5Button"] ?? "Nonfat Greek Yogurt (17g)"){
                    addQuickEntry(grams: stripProteinFrom(str: globalString.config["5Button"] ?? "Nonfat Greek Yogurt (17g)") ?? 0)
                    saveProteinToStorage()
                    showPopup = true
                }
                .padding(8)
                .frame(width: 130, height: 120, alignment: .center )
                .font(.system(size: 18))
                .buttonStyle(.bordered)
                .multilineTextAlignment(.center)
                .foregroundColor(.orange)
                
                Spacer()
                Button(globalString.config["6Button"] ?? "Protein Bar (20g)"){
                    addQuickEntry(grams: stripProteinFrom(str: globalString.config["6Button"] ?? "Protein Bar (20g)") ?? 0)
                    saveProteinToStorage()
                    showPopup = true
                }
                .padding(8)
                .frame(width: 130, height: 120, alignment: .center )
                .font(.system(size: 18))
                .buttonStyle(.bordered)
                .multilineTextAlignment(.center)
                .foregroundColor(.purple)
                
                Spacer()
            } // Hstack 2
            
        } // Vstack 1
            .navigationBarHidden(false)
            .navigationBarBackButtonHidden(false)
            .navigationTitle("Entry")
            .onAppear {
                // Need to reload string with most up to date listOfEntries or it will be empty.
                globalString.reload(date: date)
            }
            .popover(isPresented: $showPopup) {
                ZStack {
                    Button("Submitted!"){}
                        .font(.system(size: 25))
                        .buttonStyle(.borderedProminent)
                        .tint(.green)
                        .onAppear(){
                            showPopup = false
                        }
                }.background(BackgroundBlurView())
            }
            
            Spacer().frame(width: 1, height: 40, alignment: .bottom)
            VStack{
                TextField("Entry Here", text: $entry).frame(width: CGFloat(100), height: CGFloat(30), alignment: .center).onSubmit {
                    addQuickEntry(grams: evaluateExpression(entry: entry))
                    saveProteinToStorage()
                    showPopup = true
                    entry = ""
                    
                }.keyboardType(.numbersAndPunctuation)
                
                TextField("Remove Here", text: $removal).frame(width: CGFloat(120), height: CGFloat(30), alignment: .center).onSubmit {
                    removeOldEntry(grams: Int(removal) ?? 0)
                    saveProteinToStorage()
                    showPopup = true
                    removal = ""
                }.keyboardType(.numbersAndPunctuation)
            } // Vstack 2
            
            Spacer().frame(width: 1, height: 120, alignment: .bottom)

        
        
    }
    
    func evaluateExpression(entry: String) -> Int {
        
        let containsAddition = entry.contains("+")
        let containsMultiplication = entry.contains("*")
        
        // Prevent doing multiplication and addition in same expression.
        guard !(containsAddition && containsMultiplication) else {return 0}
        
        
        if (entry.contains("+")) {
            let components = entry.components(separatedBy: "+")
            
            let added = (Int(components[0]) ?? 0) + (Int(components[1]) ?? 0)
            return added
        }
        
        if (entry.contains("*")) {
            let components = entry.components(separatedBy: "*")
            
            let multiplied = (Int(components[0]) ?? 0) * (Int(components[1]) ?? 0)
            return multiplied
        }
        
        return (Int(entry) ?? 0)
        
    }
    
    func saveProteinToStorage() {
        
        let defaults = UserDefaults.standard
        
        let key = date
        
        let storedIntake = String(globalString.intake())
        
        defaults.set(storedIntake, forKey: key)
        
    }
    
    func removeOldEntry(grams: Int) {
        if grams > 0 { // these nums will never be added.
            if let index = globalString.listOfEntries.findEntry(Entry: grams) {
                globalString.listOfEntries.remove(at: index)
                print("Removed \(grams)")
            }
        }

        globalString.saveListToStorage(date: date)

    }
    
    func addQuickEntry(grams: Int) {
        
        guard (grams > 0) else { return }
        globalString.listOfEntries.append(Entry(grams: grams))
        globalString.saveListToStorage(date: date)
        
        print("Added \(grams)")
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

struct BackgroundBlurView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct entryView_Previews: PreviewProvider {
    static var previews: some View {
        entryView(date: "").preferredColorScheme(.dark)
    }
}
