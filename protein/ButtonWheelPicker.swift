//
//  ButtonWheelPicker.swift
//  protein
//
//  Created by Tyler Hernandez on 2/22/23.
//

import SwiftUI


struct ButtonWheelPicker: View {
    
    @State private var num = 1
    
    var body: some View {
        VStack {
            Text("Number: \(num)")
            Picker("", selection: $num) {
                ForEach([1,2,3,4,5,6], id: \.self) {
                    Text("\($0)")
                }
            }
        }
    }
    
}
