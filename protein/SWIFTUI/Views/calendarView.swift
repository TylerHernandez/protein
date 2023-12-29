//
//  calendarView.swift
//  protein
//
//  Created by Tyler Hernandez on 3/13/23.
//

import SwiftUI
import Charts

extension DateComponents: Comparable {
    public static func < (lhs: DateComponents, rhs: DateComponents) -> Bool {
        let now = Date()
        let calendar = Calendar.current
        return calendar.date(byAdding: lhs, to: now)! < calendar.date(byAdding: rhs, to: now)!
    }
}

struct datePicker: View {
    
    @StateObject var globalString : GlobalString
    
    @Environment(\.calendar) var calendar
    @Environment(\.timeZone) var timeZone
    
    var bounds: PartialRangeUpTo<Date> {
        
        let date = Date()
        
        let end = calendar.date(
            from: DateComponents(
                timeZone: timeZone,
                year: calendar.component(.year, from: date),
                month: calendar.component(.month, from: date),
                day: calendar.component(.day, from: date))
        )!
        
        return ..<end
        
    }
    
    @State public var dates: Set<DateComponents> = []
    
    @State private var showPopup = false
    
    var body: some View {
        VStack{
            
            HStack(spacing: 20) {
                
                Button("See Trends") {
                    showPopup = true
                }
                
                NavigationLink("Import/Export", destination: importExportView())
                
            }
            
            MultiDatePicker("Dates Available", selection: $dates, in: bounds)
                .fixedSize()
            
            
            List {
                ForEach(dates.sorted(), id: \.self) { date in
                    // TODO: Change this mechanism for imported history to be validated.
                    let grams = loadProteinFromStorage(date: date.date ?? Date.now)
                    
                    Text("\((date.date ?? Date.now).formatted(date: .long, time: .omitted)):  \(grams) grams")
                    
                }
            }
            
            Text("total sum across \(dates.count) entries: \(sumEntries())")
            
            Text("Average:  \(retrieveAverageFromSelected())")
        }
        .popover(isPresented: $showPopup) {
                NavigationView {
                    showTrendView()
                    .navigationBarTitle("Trends")
                }
                
        }
        
    }
    
    
    func retrieveAverageFromSelected() -> Int {
        var count = 0
        var length = 0
        for d in Array(dates) {
            
            if let value = Int(loadProteinFromStorage(date: d.date!)){
                count += value
                length += 1
            }
        }
        
        guard length > 0 else {
            return 0
        }
        
        return (count / length)
    }
    
    func sumEntries() -> Int {
        var count = 0
        for d in Array(dates) {
            
            let value = Int(loadProteinFromStorage(date: d.date!)) ?? 0
                
                count += value
        }
        return count
    }
    
//    func loadProteinFromStorage(date: Date) -> String {
//
//        let defaults = UserDefaults.standard
//
//        let key = (date.formatted(date: .long, time: .omitted))
//
//        if let storedIntake = defaults.string(forKey: key) {
//            return storedIntake
//        } else {
//            return "0"
//        }
//    }
    
    func loadProteinFromStorage(date: Date) -> String {
        let entryList = globalString.loadListFromStorage(date: (date.formatted(date: .long, time: .omitted)))
        
        var totalSum = 0
        
        for entry in entryList {
            totalSum += entry.grams
        }
        
        return String(totalSum)
    }
    
}

struct calendarView: View {
    
    @StateObject var globalString : GlobalString

    var body: some View {
        VStack {

            datePicker(globalString: globalString)

            Spacer()
            
        }
            .navigationBarHidden(false)
            .navigationBarBackButtonHidden(false)
            .navigationTitle("History")
        
    } // ends view
}


struct showTrendView: View {
    
    @State private var date = Calendar.current.startOfDay(for: Date.now)
    
    var body: some View {
        
        VStack(spacing: 20) {
            NavigationLink(destination: graphView(previousDays: 7))  {
                Text(generateTrend(days: 7))
            }
            NavigationLink(destination: graphView(previousDays: 14))  {
                Text(generateTrend(days: 14))
            }
            NavigationLink(destination: graphView(previousDays: 30))  {
                Text(generateTrend(days: 30))
            }
            NavigationLink(destination: graphView(previousDays: 60))  {
                Text(generateTrend(days: 60))
            }
            NavigationLink(destination: graphView(previousDays: 90))  {
                Text(generateTrend(days: 90))
            }
        }// vstack
        
    }// body
    
    // Past 7 days.
    func generateTrend(days: Int) -> String {
        
        var totalGrams = 0
        var currentDate = date
        
        // Start off with day before and work back x days.
        for daysAgo in 1 ... days {
            currentDate = Calendar.current.date(byAdding: .day, value: -daysAgo, to: date)!
            
            
            if let value = loadProteinFromStorage(date: currentDate){
                totalGrams += Int(value) ?? 0
            } else {
                return "Past \(days) days: Unavailable Trend"
            }
            
        }
        
        return "Past \(days) days: Average \(totalGrams / days) grams per day"
    }
    
    func loadProteinFromStorage(date: Date) -> String? {

        let defaults = UserDefaults.standard

        let key = (date.formatted(date: .long, time: .omitted))

        return defaults.string(forKey: key)
    }
    
}

//struct calendarView_Previews: PreviewProvider {
//    static var previews: some View {
//        calendarView().preferredColorScheme(.dark)
//    }
//}


