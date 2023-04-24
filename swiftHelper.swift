//
//  swiftHelper.swift
//  protein
//
//  Created by Tyler Hernandez on 4/23/23.
//

import Foundation

struct swiftHelper {
    
    func countToSeconds(seconds: TimeInterval) {
        
        var currentTime = Date().timeIntervalSince1970
        let desiredTime = currentTime + seconds
        
        while (currentTime < desiredTime){
            print("Counting...\(currentTime - desiredTime)")
            currentTime = Date().timeIntervalSince1970
        }
        print("Finished")
        
    }
    
}
