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
            
            let sortedKeys = globalString.config.keys.sorted {
                globalString.config[$0]! < globalString.config[$1]!
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(Array(sortedKeys.enumerated()), id: \.offset) { index, key in
                        if let value = globalString.config[key] {
                            Button(value) {
                                addQuickEntry(grams: stripProteinFrom(str: value) ?? 0)
                                saveProteinToStorage()
                                showPopup = true
                                print(value)
                            }
                            .padding(8)
                            .frame(width: 130, height: 120, alignment: .center)
                            .font(.system(size: 18))
                            .buttonStyle(.bordered)
                            .multilineTextAlignment(.center)
                            .foregroundColor(colorForButton(at: index))
                        }
                    }
                }
            }


            
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
            
//            HStack {
//
//                Button(globalString.config["1Button"] ?? "Cup of Milk (8g)"){
//                    addQuickEntry(grams: stripProteinFrom(str: globalString.config["1Button"] ?? "Cup of Milk (8g)") ?? 0)
//                    saveProteinToStorage()
//                    showPopup = true
//                }
//                .padding(8)
//                .frame(width: 130, height: 120, alignment: .center )
//                .font(.system(size: 18))
//                .buttonStyle(.bordered)
//                .multilineTextAlignment(.center)
//                .foregroundColor(.blue)
//
//                Spacer()
//
//                Button(globalString.config["2Button"] ?? "4oz Chicken Breast (35g)"){
//                    addQuickEntry(grams: stripProteinFrom(str: globalString.config["2Button"] ?? "4oz Chicken Breast (35g)") ?? 0)
//                    saveProteinToStorage()
//                    showPopup = true
//                }
//                .padding(8)
//                .frame(width: 130, height: 120, alignment: .center )
//                .font(.system(size: 18))
//                .buttonStyle(.bordered)
//                .multilineTextAlignment(.center)
//                .foregroundColor(.red)
//
//
//                Spacer()
//
//                Button(globalString.config["3Button"] ?? "Scoop of Whey (25g)"){
//                    addQuickEntry(grams: stripProteinFrom(str: globalString.config["3Button"] ?? "Scoop of Whey (25g)") ?? 0)
//                    saveProteinToStorage()
//                    showPopup = true
//                }
//                .padding(8)
//                .frame(width: 130, height: 120, alignment: .center )
//                .font(.system(size: 18))
//                .buttonStyle(.bordered)
//                .multilineTextAlignment(.center)
//                .foregroundColor(.green)
//
//                Spacer()
//            } // Hstack 1
//            HStack {
//                Spacer()
//                Button(globalString.config["4Button"] ?? "3 Eggs (18g)"){
//                    addQuickEntry(grams: stripProteinFrom(str: globalString.config["4Button"] ?? "3 eggs (18g)") ?? 0)
//                    saveProteinToStorage()
//                    showPopup = true
//                }
//                .padding(8)
//                .frame(width: 130, height: 120, alignment: .center )
//                .font(.system(size: 18))
//                .buttonStyle(.bordered)
//                .multilineTextAlignment(.center)
//                .foregroundColor(.yellow)
//
//                Spacer()
//                Button(globalString.config["5Button"] ?? "Nonfat Greek Yogurt (17g)"){
//                    addQuickEntry(grams: stripProteinFrom(str: globalString.config["5Button"] ?? "Nonfat Greek Yogurt (17g)") ?? 0)
//                    saveProteinToStorage()
//                    showPopup = true
//                }
//                .padding(8)
//                .frame(width: 130, height: 120, alignment: .center )
//                .font(.system(size: 18))
//                .buttonStyle(.bordered)
//                .multilineTextAlignment(.center)
//                .foregroundColor(.orange)
//
//                Spacer()
//                Button(globalString.config["6Button"] ?? "Protein Bar (20g)"){
//                    addQuickEntry(grams: stripProteinFrom(str: globalString.config["6Button"] ?? "Protein Bar (20g)") ?? 0)
//                    saveProteinToStorage()
//                    showPopup = true
//                }
//                .padding(8)
//                .frame(width: 130, height: 120, alignment: .center )
//                .font(.system(size: 18))
//                .buttonStyle(.bordered)
//                .multilineTextAlignment(.center)
//                .foregroundColor(.purple)
//
//                Spacer()
//            } // Hstack 2
            
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
                    addQuickEntry(grams: Math.evaluateMathExpression(entry))
                    saveProteinToStorage()
                    showPopup = true
                    entry = ""
                    
                }.keyboardType(.numbersAndPunctuation)
                
            } // Vstack 2
            
            Spacer().frame(width: 1, height: 120, alignment: .bottom)

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
    
    func colorForButton(at index: Int) -> Color {
        let colors: [Color] = [.blue, .red, .green, .yellow, .orange, .purple, .cyan, .pink, .mint, .teal]
        return colors[index % colors.count]
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
