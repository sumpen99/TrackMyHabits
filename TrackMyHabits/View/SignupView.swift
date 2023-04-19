//
//  SignupView.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-17.
//

import SwiftUI

struct SignupView : View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.isPresented) private var isPresented
    @EnvironmentObject var firebaseAuth: FirebaseAuth
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
                    if firebaseAuth.isSuccessful {
                        dismiss()
                    }
                }
            })
        }
    }
    
    func signUserUp(){
        firebaseAuth.signup(user: user, password: passwordHelper.password){ (result,error) in
            guard let error = error else {
                ALERT_TITLE = "Signup success"
                ALERT_MESSAGE = "Proceed to login"
                firebaseAuth.isSuccessful = true
                isSignupResult.toggle()
                return
            }
            ALERT_TITLE = "Signup failed"
            ALERT_MESSAGE = error.localizedDescription
            firebaseAuth.isSuccessful = false
            isSignupResult.toggle()
        }
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
            ToggleSecurefieldView(text: $passwordHelper.confirmedPassword)
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
