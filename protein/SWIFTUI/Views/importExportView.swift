//
//  importExportView.swift
//  protein
//
//  Created by Tyler Hernandez on 9/1/23.
//

import SwiftUI

struct importExportView: View {
    
    
    // Have user choose whether they will be importing or exporting history.
    var body: some View {
        VStack(spacing: 20) {
            
            NavigationLink("Import Data", destination: importView())
            NavigationLink("Export Data", destination: exportView())
            
        }
        
    }
}

struct importView: View {
    
    @State private var importedJSON: String = ""
    
    var body: some View{
        VStack {
            TextField("Paste exported data here", text: $importedJSON)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            
            Button("Import Data") {
                parseAndStore(jsonString: importedJSON)
            }
            .padding()
        }
    }
    
    func parseAndStore(jsonString: String) {
        guard let data = jsonString.data(using: .utf8),
              let historyData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String] else {
            // Handle error
            return
        }

        let defaults = UserDefaults.standard
        for (date, proteinList) in historyData {
            let key = "p" + date
            defaults.set(proteinList, forKey: key)
        }
    }

    
}

struct exportView: View {
    
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var exportedJSON: String = ""
        
    var body: some View {
        VStack(spacing: 20) {
            DatePicker("Start Date", selection: $startDate, displayedComponents: [.date])
            DatePicker("End Date", selection: $endDate, displayedComponents: [.date])
            
            Button("Submit") {
                self.exportedJSON = loadHistory(from: startDate, to: endDate)
            }
            
            Text(exportedJSON)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .onTapGesture {
                    UIPasteboard.general.string = self.exportedJSON
                }

        }
        .padding()
    }
    
    func loadHistory(from startDate: Date, to endDate: Date) -> String {
        var currentDay = startDate
        var historyData: [String: String] = [:]
        
        while currentDay <= endDate {
            let formattedDate = currentDay.formatted(date: .long, time: .omitted)
            let proteinList = getProteinListForDate(date: formattedDate)
            historyData[formattedDate] = proteinList
            
            currentDay = Calendar.current.date(byAdding: .day, value: 1, to: currentDay) ?? currentDay
        }
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: historyData, options: []),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        } else {
            return "{}"  // empty JSON if an error occurs
        }
    }
    
    func getProteinListForDate(date: String) -> String {
        
        let defaults = UserDefaults.standard
        
        let key = "p" + date
        
        if let storedList = defaults.string(forKey: key) {
            return storedList
        }
        return "0"
    }
}
