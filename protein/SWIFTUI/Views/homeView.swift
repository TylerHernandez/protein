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
    @Published var listOfEntries: [Entry]
    
    @Published var config : Dictionary<String, String>
    
    init() {
        listOfEntries = []
        config = [:]
    }
    
    func reload(date: String) {
        listOfEntries = loadListFromStorage(date: date)
        config = loadConfigFromStorage()
    }
    
    func intake() -> Int {
        var sum = 0
        for item in listOfEntries {
            sum += item.grams
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
    
    func loadListFromStorage(date: String) -> [Entry] {
        
        let defaults = UserDefaults.standard
        
        let key = "p" + date
        
        if let storedList = defaults.string(forKey: key) {
            return toList(str: storedList)
        }
        return []
    }
    
    func saveListToStorage(date: String) -> Void {
        
        let defaults = UserDefaults.standard
        
        let key = "p" + date
        
        let storedList = toStorage(list: self.listOfEntries)
        defaults.set(storedList, forKey: key)
        
    }
    
    // [15, 25, 30, 40] -> "15+25+30+40+"
    func toStorage(list: [Entry]) -> String {
        var str = ""
        for item in list{
            str += (String(item.grams) + "+")
        }
        
        return str
    }
    
    func toList(str: String) -> [Entry] {
        var newList: [Entry] = []
        
        for item in str.components(separatedBy: ["+"]){
            if let itemInt = Int(item) {newList.append(Entry(grams: itemInt))} else { return newList }
        }
        
        return newList
    }
    
    
    
}

struct homeView: View {
    @StateObject var globalString = GlobalString()
    
    @State private var date = Calendar.current.startOfDay(for: Date.now)
    
    @State private var todayLabel = ""
    
    @State private var showPopup = false
    
    var body: some View {
        NavigationView {
            
            VStack{
                
                HStack {
                    
                    // Go Back by 1 date
                    Button {
                        date = Calendar.current.date(byAdding: .day, value: -1, to: date)!
                        loadTodayLabel()
                        globalString.listOfEntries = globalString.loadListFromStorage(date: date.formatted(date: .long, time: .omitted))
                    } label: {
                        Image(systemName: "arrowshape.turn.up.backward.badge.clock")
                    }.font(.title)
                    
                    Spacer()
                    
                    Text(date.formatted(date: .long, time: .omitted)).font(.title)
                    
                    Spacer()
                    
                    // Go Forward by 1 date
                    Button {
                        date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
                        loadTodayLabel()
                        globalString.listOfEntries = globalString.loadListFromStorage(date: date.formatted(date: .long, time: .omitted))
                    } label: {
                        Image(systemName: "arrowshape.turn.up.backward.badge.clock.rtl")
                    }.font(.title)
                    
                }
                
                Text(todayLabel).foregroundColor(.blue)
                
                List {
                    ForEach(globalString.listOfEntries, id: \.id) { entry in
                        Text("\(entry.grams)")
                    }
                }.onAppear {
                    globalString.reload(date: date.formatted(date: .long, time: .omitted))
                }
                
                
                Text("Total Sum: \(totalSum()) grams").font(.title2)
                
                Spacer().frame(width: 1, height: 30, alignment: .bottom)
                
                HStack(spacing: 50){
                
                    NavigationLink(destination: calendarView()){
                        VStack {
                            Image(systemName: "book")
                            Text("History")
                        }.font(.title3)
                    }
                    
                    NavigationLink(destination: configurationView(date: date.formatted(date: .long, time: .omitted))){
                        VStack {
                            Image(systemName: "gear")
                            Text("Config")
                        }.font(.title3)
                    }
                    
                    NavigationLink(destination: entryView(date: date.formatted(date: .long, time: .omitted))){
                        VStack {
                            Image(systemName: "plus.app")
                            Text("Entry")
                        }.font(.title3)
                    }
                    
                } // Ends HStack
                
                Spacer().frame(width: 1, height: 30, alignment: .bottom)
                
            }// Ends VStack
            .navigationTitle("Home")
            .onAppear(perform: loadTodayLabel)
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
        }// Navigation View
        
    }
    
   // Save our list of entries to storage with our given timestamp.
    func saveListOfEntriesToStorage() {
        // Given a
    }
    
    func loadListOfEntriesFromStorage() {
        
    }
    
    
    func loadTodayLabel() -> Void {
        if (Calendar.current.isDateInToday(date)){
            todayLabel = "(Today)"
        } else if (Calendar.current.isDateInYesterday(date)) {
            todayLabel = "(Yesterday)"
        } else if (Calendar.current.isDateInTomorrow(date)) {
            todayLabel = "(Tomorrow)"
        } else {
            
            let numberOfDays = Calendar.current.dateComponents([.day], from: date, to: Calendar.current.startOfDay(for: Date.now)).day!
            
            if (numberOfDays < 0) {
                todayLabel = "in \(-numberOfDays) days"
            } else {
                todayLabel = "\(numberOfDays) days ago"
            }
            
        }
    }
    
    func totalSum() -> Int {
        var sum = 0
        for x in globalString.listOfEntries {
            sum += x.grams
        }
        return sum
    }
    

}

struct homeView_Previews: PreviewProvider {
    static var previews: some View {
        homeView().preferredColorScheme(.dark)
    }
}
