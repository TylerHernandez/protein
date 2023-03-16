//
//  SwiftUIView.swift
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
                    Text(String(date.month!) + "/" + String(date.day!) + "/" + String(date.year!))
                }
            }
        }
        
    }
}

struct SwiftUIView: View {

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

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
