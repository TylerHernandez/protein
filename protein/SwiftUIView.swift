//
//  SwiftUIView.swift
//  protein
//
//  Created by Tyler Hernandez on 3/13/23.
//

import SwiftUI

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
            
//            for date in dates {
//                Text(date.day!)
//            }
            
            // TODO: Prevent text from overflowing screen.
            Text(datesSelected)
                .fixedSize()
        }
    }
    
    var datesSelected: String {
        var str = ""
        
        for date in dates {
            str += String(date.day!) + "\n"
        }
        return str
    }
}

struct SwiftUIView: View {

    weak var navigationController: UINavigationController?

    var body: some View {
        VStack {
            HStack {
                Text("Calendar Screen")
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
