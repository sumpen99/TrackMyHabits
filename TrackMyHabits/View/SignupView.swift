//
//  SignupView.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-17.
//

import SwiftUI

struct SignupView : View {
    @Environment(\.dismiss) private var dismiss
    //@Environment(\.isPresented) private var isPresented
    @EnvironmentObject var firebaseHandler: FirebaseHandler
    @Binding var user: User
    @State private var isSignupResult: Bool = false
    @StateObject private var passwordHelper: PasswordHelper = PasswordHelper()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Your Info")) {
                    TextFieldsUser(user: self.$user)
                }
                Section(header: Text("Password"),footer: Text("Password must be between \(MIN_PASSWORD_LEN) - \(MAX_PASSWORD_LEN) characters long")) {
                    PasswordView()
                    .environmentObject(passwordHelper)
                }
                Section {
                    ConfirmedPassword(action:signUserUp)
                        .environmentObject(passwordHelper)
                }
            }
            .scrollContentBackground(.hidden)
            .background( appLinearGradient() )
            .navigationBarTitle(Text("Registration Form"))
            .alert(isPresented: $isSignupResult, content: {
                onResultAlert {
                    if firebaseHandler.isSuccessful {
                        dismiss()
                    }
                }
            })
        }
    }
    
    func signUserUp(){
        // 0
        if user.name.isEmpty { activateMissingFieldsAlert(); return }
        firebaseHandler.signup(user: user, password: passwordHelper.password){ (result,error) in
            // 2
            guard let error = error else {
                // 3
                firebaseHandler.manager.initializeUser(user){ result in
                    // 4
                    if result.finishedWithoutError{
                        // 5
                        activateSuccessAlert()
                    }
                    activateFailedCreationOfUserAlert(error:result.asString())
                }
                // 6
                return
            }
            activateFailedSignupAlert(error:error)
        }
        // 1
    }
    
    func activateMissingFieldsAlert(){
        ALERT_TITLE = "Error"
        ALERT_MESSAGE = "Missing fields. One of the required field is empty or contains invalid data"
        isSignupResult.toggle()
    }
    
    func activateSuccessAlert(){
        ALERT_TITLE = "Signup success"
        ALERT_MESSAGE = "Proceed to login"
        firebaseHandler.isSuccessful = true
        isSignupResult.toggle()
    }
    
    func activateFailedSignupAlert(error:Error){
        ALERT_TITLE = "Signup failed"
        ALERT_MESSAGE = error.localizedDescription
        firebaseHandler.isSuccessful = false
        isSignupResult.toggle()
    }
    
    func activateFailedCreationOfUserAlert(error:String){
        ALERT_TITLE = "Signup failed"
        ALERT_MESSAGE = error
        firebaseHandler.isSuccessful = false
        isSignupResult.toggle()
    }
    
}

struct TextFieldsUser: View{
    @Binding var user: User
    var body: some View{
        TextField("Name",text: $user.name.max(MAX_TEXTFIELD_LEN))
            .removePredictiveSuggestions()
            .textContentType(.name)
        TextField("Email",text: $user.email.max(MAX_TEXTFIELD_LEN))
            .removePredictiveSuggestions()
            .textContentType(.emailAddress)
        
    }
}

struct ConfirmedPassword : View{
    @EnvironmentObject var passwordHelper: PasswordHelper
    var action: () -> Void
    var body: some View{
        if self.passwordHelper.level != .none {
            ToggleSecurefieldView(label:"Confirm password",text: $passwordHelper.confirmedPassword)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(passwordHelper.passwordsIsAMatch ? .green : .red, lineWidth: 2)
            }
            if passwordHelper.passwordsIsAMatch{
                Button(action: { action()}) {
                    Text("Sign Up")
                }
            }
            else{
                Text("Password is not a match")
                    .foregroundColor(.gray)
                    .font(.headline)
            }
            
        }
    }
}
