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
    
    var body: some View {
        VStack{
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
                .frame(width: 1, height: 74, alignment: .bottom)
            
        }
            .navigationBarHidden(false)
            .navigationBarBackButtonHidden(false)
            .navigationTitle("History")
        
    } // ends view
}

struct calendarView_Previews: PreviewProvider {
    static var previews: some View {
        calendarView().preferredColorScheme(.dark)
    }
}
