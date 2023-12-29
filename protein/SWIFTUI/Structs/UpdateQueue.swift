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
    
    init () {
        queue = getQueueFromStorage()
    }
    
    mutating func append(latestEntry: ProteinEntry) {
        
        // Check if an entry with the same date exists in the queue
        if let existingIndex = queue.firstIndex(where: { $0.date == latestEntry.date }) {
            queue[existingIndex] = latestEntry
        } else {
            queue.append(latestEntry)
        }

        storeQueue()
    }
    
    mutating func dequeue() -> Void {
        if (!queue.isEmpty) {
            let entry = queue.removeFirst()
            saveProteinRecordToApi(date: entry.date, list: entry.list, sum: entry.sum)
            storeQueue()
        }
    }
    
    func saveProteinRecordToApi(date: String, list: String , sum: String) -> Void {
        
        let apiUrl = URL(string: "http://192.168.1.240:5000/api/protein") ?? URL(string: "localhost")!
        
        var request = URLRequest(url: apiUrl)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestData = ProteinEntry(date: date, list: list, sum: sum)
        
        do {
            // Encode the request data to JSON
            let jsonEncoder = JSONEncoder()
            let requestBody = try jsonEncoder.encode(requestData)
            request.httpBody = requestBody
            
            // Make the API request
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                
                if let data = data {
                    do {
                        // Decode the response JSON data
                        let jsonDecoder = JSONDecoder()
                        let responseObject = try jsonDecoder.decode(ProteinApiResponse.self, from: data)
                        print("Response: \(responseObject)")
                        
                        /*
                         Response: ProteinApiResponse(message: "Protein record created or updated successfully")
                         */
                    } catch {
                        print("Error decoding response: \(error)")
                    }
                }
            }
            
            task.resume()
            
        } catch {
            print("Error encoding request data: \(error)")
        }
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


