//
//  loginView.swift
//  protein
//
//  Created by Ariel Cobena on 4/20/23.
//

import SwiftUI
import Amplify
import AWSCognitoAuthPlugin

struct loginView: View {
    
    func signIn(email: String, password: String) async {
        do {
            let signInResult = try await Amplify.Auth.signIn(
                username: email,
                password: password
                )
            if signInResult.isSignedIn {
                print("Sign in succeeded")
            }
        } catch let error as AuthError {
            print("Sign in failed \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    @State var email:String = ""
    @State var password:String = ""
    @State var presented:Bool = false
    
    var body: some View {
        VStack{
         
            Form {
                TextField("Email", text: $email)
                SecureField("Password", text: $password)
            }.onSubmit {
                Task {
                    do {
                        await signIn(email: email, password: password)
                    }
                }
            }
            
            NavigationLink(destination: registerView()){
                VStack {
                    Text("Sign Up Here")
                }.font(.title3)
            }
            
            
        }.popover(isPresented:$presented){
            registerView()
        }
        
    }
}

struct loginView_Previews: PreviewProvider {
    static var previews: some View {
        loginView()
    }
}
