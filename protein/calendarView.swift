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
            
            Text("total sum across \(countEntriesWithValues()) entries: \(sumEntries())")
            
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
    
    func countEntriesWithValues() -> Int {
        var count = 0
        for d in Array(dates) {
            
            if ("0" != loadProteinFromStorage(date: d.date ?? Date.now)) {
                count += 1
            }
        }
        return count
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

    weak var navigationController: UINavigationController?

    var body: some View {
        VStack {
            HStack {
                Text("Calendar")
                    .bold()
                    .font(.system(size: 21.0))
            }

            datePicker()

            Spacer()
                .frame(width: 1, height: 74, alignment: .bottom)
            VStack(alignment: .center){
                Button(action: {
                    navigationController?.popViewController(animated: true)
                }) {
                    Text("Back to UIKit")
                        .font(.system(size: 21.0))
                        .bold()
                        .frame(width: UIScreen.main.bounds.width, height: 10, alignment: .center)
                }
            }
            
            Spacer()
                .frame(width: 2, height: 105, alignment: .bottom)
        }.navigationBarHidden(true) // Need to keep this hidden or navigation controller blocks other buttons.
        
    } // ends view
}

struct calendarView_Previews: PreviewProvider {
    static var previews: some View {
        calendarView()
    }
}
