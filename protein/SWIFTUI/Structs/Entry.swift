//
//  Entry.swift
//  protein
//
//  Created by Tyler Hernandez on 3/26/23.
//

import Foundation

struct Entry : Hashable, Equatable, Identifiable {
    let grams : Int
    let id = UUID()
    // TODO: Add timestamp here, will also need to change storage and retrieval mechanism.
}

extension [Entry] {
    func findEntry(Entry: Int) -> Array.Index? {
         
         let List = self
         
         for item in List.indices {
             if List[item].grams == Entry {
                 return item
             }
         }
         return nil
     }

}
