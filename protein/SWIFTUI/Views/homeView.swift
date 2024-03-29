//
//  homeView.swift
//  protein
//
//  Created by Tyler Hernandez on 3/21/23.
//

import SwiftUI
import Foundation

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
        print("reloaded")
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
            
            
            let fromStorageList = toList(str: storedList)
            
            saveProteinRecordToApi(date: date, list: storedList, sum: String(totalSum(list: fromStorageList)))
            
            return fromStorageList
        }
        return []
    }
    
    func saveListToStorage(date: String) -> Void {
        
        let defaults = UserDefaults.standard
        
        let key = "p" + date
        
        let storedList = toStorage(list: self.listOfEntries)
        defaults.set(storedList, forKey: key)
        
        
        // TODO: Trigger update queue with new change. 
        
        let entry = ProteinEntry(date: date, list: storedList, sum: String(totalSum(list: listOfEntries)))
        
        var updateQueue = ProteinApiQueue()
        updateQueue.append(latestEntry: entry)
        
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
    
    func saveProteinRecordToApi(date: String, list: String , sum: String) -> Void {
        print("saving to api")
        
        let apiUrl = URL(string: "")!
        
        var request = URLRequest(url: apiUrl)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestData = ProteinEntry(date: date, list: list, sum: sum)
        
        do {
            // Encode the request data to JSON
            let jsonEncoder = JSONEncoder()
            let requestBody = try jsonEncoder.encode(requestData)
            request.httpBody = requestBody
            
            // Make the API request
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                
                if let data = data {
                    do {
                        // Decode the response JSON data
                        let jsonDecoder = JSONDecoder()
                        let responseObject = try jsonDecoder.decode(ProteinApiResponse.self, from: data)
                        print("Response: \(responseObject)")
                    } catch {
                        print("Error decoding response: \(error)")
                    }
                }
            }
            
            task.resume()
            
        } catch {
            print("Error encoding request data: \(error)")
        }
    }
    
    func totalSum(list: [Entry] ) -> Int {
        var sum = 0
        for x in list {
            sum += x.grams
        }
        return sum
    }
    
    
}

struct homeView: View {
    @StateObject var globalString : GlobalString
    
    @State private var date = Calendar.current.startOfDay(for: Date.now)
    
    @State private var todayLabel = ""
    
    @State private var showPopup = false
    
    @State private var activeEntry: Int = 0
    
    @State private var modifiedEntry: String = ""
    
    @State private var isModifyingEntryPopoverPresented = false
    
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
                
                /*
                 *
                 *
                 *
                 *
                 *
                 !Display our list of entries!
                 *
                 *
                 *
                 *
                 *
                 */
                
                List {
                    ForEach(globalString.listOfEntries, id: \.id) { entry in
                        HStack {
                            
                            
                            Button(action: {
                                // Modify action
                                activeEntry = entry.grams
                                isModifyingEntryPopoverPresented = true
                            }) {
                                Image(systemName: "pencil")
                                    .foregroundColor(.blue)
                            }
                            Divider()
                                .background(Color.gray)
                                .frame(height: 20) // Doesn't quite fill the cell, to keep its continuous feel.
                            
                            
                            Spacer()
                            Text("\(entry.grams)")
                            Spacer()
                            Divider()
                                .background(Color.gray)
                                .frame(height: 20)
                            
                            Image(systemName: "line.horizontal.3") // Hamburger icon
                                .foregroundColor(.gray)
                        }
                    }
                    .onMove(perform: moveEntry)
                    .onDelete(perform: deleteEntry)
                }
                .onAppear {
                    globalString.reload(date: date.formatted(date: .long, time: .omitted))
                    print("loaded")
                }
                
                
                Text("Total: \(totalSum()) grams").font(.title2)
                
                Spacer().frame(width: 1, height: 30, alignment: .bottom)
                
                HStack(spacing: 50){
                    
                    NavigationLink(destination: calendarView(globalString: globalString)){
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
            
            // Popover for modifying an entry.
            .popover(isPresented: $isModifyingEntryPopoverPresented) {
                VStack {
                    
                    Group{
                        Text("Modifying entry: ")
                        
                        HStack {
                            Text("\(activeEntry)")
                                .onAppear(){
                                    // Our state view does not always refresh.
                                    let placeholder = activeEntry
                                    activeEntry = 0
                                    activeEntry = placeholder
                                    // the previous code reminds it to refresh :)
                                }
                        }
                    }
                    
                    TextField("Enter new value", text: $modifiedEntry)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .keyboardType(.numbersAndPunctuation)
                    Button("Save") {
                        modifyEntryAndSaveToList(oldEntryGrams: activeEntry, newEntry: modifiedEntry)
                        isModifyingEntryPopoverPresented = false
                        modifiedEntry = ""
                    }
                }
                .padding()
            }
            // "Saved" popup
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
    
    func modifyEntryAndSaveToList(oldEntryGrams: Int, newEntry: String) {
        
        let newEntryGrams = Math.evaluateMathExpression(newEntry)
        
        if newEntryGrams > 0 { // these nums will never be added.
            if let index = globalString.listOfEntries.findEntry(Entry: oldEntryGrams) {
                globalString.listOfEntries.remove(at: index)
                
                // now replace
                globalString.listOfEntries.insert(Entry(grams: newEntryGrams), at: index)
            }
            
        }
        
        globalString.saveListToStorage(date: date.formatted(date: .long, time: .omitted))
        
    }
    
    func deleteEntry(at offsets: IndexSet) {
        globalString.listOfEntries.remove(atOffsets: offsets)
        globalString.saveListToStorage(date: date.formatted(date: .long, time: .omitted))
    }
    
    func moveEntry(from source: IndexSet, to destination: Int) {
        globalString.listOfEntries.move(fromOffsets: source, toOffset: destination)
        globalString.saveListToStorage(date: date.formatted(date: .long, time: .omitted))
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

//struct homeView_Previews: PreviewProvider {
//    static var previews: some View {
//        homeView().preferredColorScheme(.dark)
//    }
//}
