//
//  calendarView.swift
//  protein
//
//  Created by Tyler Hernandez on 3/13/23.
//

import SwiftUI

extension DateComponents: Comparable {
    public static func < (lhs: DateComponents, rhs: DateComponents) -> Bool {
        let now = Date()
        let calendar = Calendar.current
        return calendar.date(byAdding: lhs, to: now)! < calendar.date(byAdding: rhs, to: now)!
    }
}

struct datePicker: View {
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
            
            Button("Trends") {
                showPopup = true
            }
            
            MultiDatePicker("Dates Available", selection: $dates, in: bounds)
                .fixedSize()
            
            
            List {
                ForEach(dates.sorted(), id: \.self) { date in
                    
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
    
    func loadProteinFromStorage(date: Date) -> String {

        let defaults = UserDefaults.standard

        let key = (date.formatted(date: .long, time: .omitted))

        if let storedIntake = defaults.string(forKey: key) {
            return storedIntake
        } else {
            return "0"
        }
    }
    
}

struct calendarView: View {

    var body: some View {
        VStack {

            datePicker()

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
                    NavigationLink(destination: detailView(text: generateTrend(days: 7))) {
                        Text(generateTrend(days: 7))
                    }
            NavigationLink(destination: detailView(text: generateTrend(days: 14))) {
                Text(generateTrend(days: 14))
            }
            NavigationLink(destination: detailView(text: generateTrend(days: 30))) {
                Text(generateTrend(days: 30))
            }
            NavigationLink(destination: detailView(text: generateTrend(days: 60))) {
                Text(generateTrend(days: 60))
            }
            NavigationLink(destination: detailView(text: generateTrend(days: 90))) {
                Text(generateTrend(days: 90))
            }
                }
    }
    
    // Past 7 days.
    func generateTrend(days: Int) -> String {
        
        var totalGrams = 0
        var currentDate = date
        
        // Start off with day before and work back x days.
        for daysAgo in 1 ... days {
            currentDate = Calendar.current.date(byAdding: .day, value: -daysAgo, to: date)!
            
            
            if let value = Int(loadProteinFromStorage(date: currentDate)){
                totalGrams += value
                //print("\(currentDate) - \(value)")
            } else {
                return "Past \(days) days: Unavailable Trend"
            }
            
        }
        
        return "Past \(days) days: Average \(totalGrams / days) grams per day"
    }
    
    func loadProteinFromStorage(date: Date) -> String {

        let defaults = UserDefaults.standard

        let key = (date.formatted(date: .long, time: .omitted))

        if let storedIntake = defaults.string(forKey: key) {
            return storedIntake
        } else {
            return "0"
        }
    }
    
}

struct detailView: View {
    
    var text: String

    var body: some View {
        Text(text)
            .navigationBarTitle("Detail")
    }
    
}

struct calendarView_Previews: PreviewProvider {
    static var previews: some View {
        calendarView().preferredColorScheme(.dark)
    }
}


