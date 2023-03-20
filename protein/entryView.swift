//
//  entryView.swift
//  protein
//
//  Created by Tyler Hernandez on 3/20/23.
//

import SwiftUI

struct entryView: View {
    
    weak var navigationController: UINavigationController?
    
    var body: some View {
        
        VStack {
            Text("Entry View")
        }
            .navigationBarHidden(false)
            .navigationBarBackButtonHidden(true)
            .navigationTitle("Entry View")
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
    }
}

struct entryView_Previews: PreviewProvider {
    static var previews: some View {
        entryView()
    }
}
