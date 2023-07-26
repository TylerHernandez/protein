//
//  graphView.swift
//  protein
//
//  Created by Tyler Hernandez on 7/20/23.
//

import SwiftUI
import Charts
import Foundation

struct graphView: View {
    
    var previousDays : Int
    
    @State private var date = Calendar.current.startOfDay(for: Date.now)
    
    var body: some View {
        PlotView(proteinData: generateChartData(days: previousDays))
    }
    
    func generateChartData(days: Int) -> [ProteinData] {
        
        var currentDate = date
        
        var data : [ProteinData] = []
        
        let dateFormatter = DateFormatter()
        
        
        dateFormatter.dateFormat = "MMM d"
        
        // Start off with day before and work back x days.
        for daysAgo in 1 ... days {
            currentDate = Calendar.current.date(byAdding: .day, value: -daysAgo, to: date)!
            
            // Append found value to list alongside it's date.
            if let value = Int(loadProteinFromStorage(date: currentDate)){
                data.append(ProteinData(date: dateFormatter.string(from: currentDate), gramsConsumed: value))
                
            } else {
                data.append(ProteinData(date: dateFormatter.string(from: currentDate), gramsConsumed: 0))
            }
            
        }
        
        return data.sorted { $0.date < $1.date } // Sort the data chronologically
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

struct ProteinData: Equatable, Identifiable {
    let id = UUID()
    let date: String
    let gramsConsumed: Int
}

struct PlotView: View {
    
    let proteinData: [ProteinData]
    
    
    var body: some View {
        if #available(iOS 16.4, *) {
                ScrollView(.horizontal) {
                        Chart {
                            ForEach(proteinData) {
                                PointMark(
                                    x: .value("Date", $0.date),
                                    y: .value("Grams Consumed", $0.gramsConsumed)
                                )
                            }
                            RuleMark(y: .value("Goal", 180))
                                .foregroundStyle(.green)
                                .blur(radius: 8)
                            RuleMark(y: .value("Goal", 145))
                                .foregroundStyle(.red)
                                .blur(radius: 8)
                        }
                        .padding(5)
                        .chartYAxis {
                                    AxisMarks(preset: .automatic, position: .leading)
                                    AxisMarks(preset: .automatic, position: .trailing)
                                    }
                        .frame(width: CGFloat( log(1.0 + Double(proteinData.count) / 2.65) * 300))
                    
                
            }
        } else {
            // Fallback on earlier versions
            VStack{
                Chart {
                    ForEach(proteinData) {
                        PointMark(
                            x: .value("Date", $0.date),
                            y: .value("Grams Consumed", $0.gramsConsumed)
                        )
                    }
                    RuleMark(y: .value("Goal", 180))
                        .foregroundStyle(.green)
                    RuleMark(y: .value("Goal", 145))
                        .foregroundStyle(.red)
                }.scaledToFit()
                
                Chart {
                    ForEach(proteinData) {
                        LineMark(
                            x: .value("Date", $0.date),
                            y: .value("Grams Consumed", $0.gramsConsumed)
                        )
                    }
                    RuleMark(y: .value("Goal", 180))
                        .foregroundStyle(.green)
                    RuleMark(y: .value("Goal", 145))
                        .foregroundStyle(.red)
                }.scaledToFit()
            }
            
        }
    }
    
}
