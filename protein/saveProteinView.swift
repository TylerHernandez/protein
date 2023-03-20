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
            
        }.navigationBarHidden(false) // Need to keep this hidden or navigation controller blocks other buttons.
            .navigationBarBackButtonHidden(true)
            .navigationTitle("Save Protein")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        navigationController?.popViewController(animated: true)
                    } label: {
                        HStack {
                            Image(systemName: "chevron.backward")
                            Text("Back")
                        }
                    }
                }
            } // ends toolbar.
        
    }// ends body.
    
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
