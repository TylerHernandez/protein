//
//  saveProteinView.swift
//  protein
//
//  Created by Tyler Hernandez on 3/17/23.
//

import SwiftUI

struct saveProteinView: View {
    
    weak var navigationController: UINavigationController?
    
    // Retrieve current protein intake from home page.
    var intake: Int?
    
    @State private var date = Date.now
    
    
    var body: some View {
        VStack {
            HStack {
                Text("Save Protein")
                    .bold()
                    .font(.system(size: 21.0))
            }
            
            
            VStack {
                DatePicker(selection: $date, in: ...Date.now, displayedComponents: .date) {
                    Text("Select a date")
                    
                }
                
                
                Text("Selected Date: \(date.formatted(date: .long, time: .omitted))")
                    }
            
            Text("Intake: \(intake ?? 0) grams")
            
            Button ("Save") {
                saveProteinToStorage()
            }.fixedSize()

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
    }
    
    func saveProteinToStorage() {
        
        let defaults = UserDefaults.standard
        
        let key = (date.formatted(date: .long, time: .omitted))
        
        let storedIntake = String(intake!)
        
        defaults.set(storedIntake, forKey: key)
        
    }
    
}

struct saveProteinView_Previews: PreviewProvider {
    static var previews: some View {
        saveProteinView()
    }
}
