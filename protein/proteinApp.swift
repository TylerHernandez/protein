//
//  main.swift
//  protein
//
//  Created by Tyler Hernandez on 3/21/23.
//

import SwiftUI
import Amplify
import AWSCognitoAuthPlugin

@main
struct proteinApp: App {
    
    func fetchCurrentAuthSession() async {
        do {
            let session = try await Amplify.Auth.fetchAuthSession()
            print("Is user signed in - \(session.isSignedIn)")
        } catch let error as AuthError {
            print("Fetch session failed with error \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    init() {
            do {
                try Amplify.add(plugin: AWSCognitoAuthPlugin())
                try Amplify.configure()
                print("Amplify configured with auth plugin")
            } catch {
                print("Failed to initialize Amplify with \(error)")
            }
        }
    
    var body: some Scene {
        WindowGroup {
            homeView()
        }
    }
}
