//
//  UpdateQueue.swift
//  protein
//
//  Created by Tyler Hernandez on 12/27/23.
//

import Foundation

// Queue of ProteinEntries

struct ProteinEntry : Codable {
    let date: String
    let list: String
    let sum: String
}

struct ProteinApiResponse: Codable {
    let message: String
}

// TODO: Check when API is available and create dequeue functions with API calls.
struct ProteinApiQueue {
    
    let key = "this_is_my_queue"
    let defaults = UserDefaults.standard
    
    var queue = [ProteinEntry]()
    
    mutating func append(latestEntry: ProteinEntry) {
        queue = getQueueFromStorage()
        
        // Check if an entry with the same date exists in the queue
        if let existingIndex = queue.firstIndex(where: { $0.date == latestEntry.date }) {
            queue[existingIndex] = latestEntry
        } else {
            queue.append(latestEntry)
        }

        storeQueue()
    }
    
    private func storeQueue() {
        if let encodedQueue = try? JSONEncoder().encode(queue) {
            defaults.set(encodedQueue, forKey: key)
        } else {
            print("Failed to encode queue.")
        }
    }
    
    private func getQueueFromStorage() -> [ProteinEntry] {
        if let decodedData = defaults.data(forKey: key) {
            do {
                let decodedQueue = try JSONDecoder().decode([ProteinEntry].self, from: decodedData)
                return decodedQueue
            } catch {
                print("Error decoding our queue from storage: \(error)")
            }
        }
        return []
    }
}


