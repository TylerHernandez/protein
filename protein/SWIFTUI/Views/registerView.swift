//
//  registerView.swift
//  protein
//
//  Created by Ariel Cobena on 4/26/23.
//

import SwiftUI
import Amplify
import AWSCognitoAuthPlugin

func signUp(email: String, password: String) async {
    let userAttributes = [AuthUserAttribute(.email, value: email)]
    let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
    do {
        let signUpResult = try await Amplify.Auth.signUp(
            username: email,
            password: password,
            options: options
        )
        if case let .confirmUser(deliveryDetails, _, userId) = signUpResult.nextStep {
            print("Delivery details \(String(describing: deliveryDetails)) for userId: \(String(describing: userId))")
        } else {
            print("SignUp Complete")
        }
    } catch let error as AuthError {
        print("An error occurred while registering a user \(error)")
    } catch {
        print("Unexpected error: \(error)")
    }
}

func confirmSignUp(for username: String, with confirmationCode: String) async {
    do {
        let confirmSignUpResult = try await Amplify.Auth.confirmSignUp(
            for: username,
            confirmationCode: confirmationCode
        )
        print("Confirm sign up result completed: \(confirmSignUpResult.isSignUpComplete)")
    } catch let error as AuthError {
        print("An error occurred while confirming sign up \(error)")
    } catch {
        print("Unexpected error: \(error)")
    }
}

struct registerView: View {
    
    @State var password:String = ""
    @State var email:String = ""
    @State var code:String = ""
    
    var body: some View {
        Form {
            TextField("Email", text: $email)
            SecureField("Password", text: $password)
        }.onSubmit {
            Task {
                do {
                    await signUp(email: email, password: password)
                }
            }
        }
        
        Form {
            TextField("Confirmation Code", text: $code)
        }.onSubmit {
            Task {
                do {
                    await confirmSignUp(for:email, with:code)
                }
            }
        }
    }
}

struct registerView_Previews: PreviewProvider {
    static var previews: some View {
        registerView()
    }
}
