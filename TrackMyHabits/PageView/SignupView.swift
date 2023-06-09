//
//  SignupView.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-17.
//

import SwiftUI

struct SignupView : View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @EnvironmentObject var firestoreViewModel: FirestoreViewModel
    @Binding var user: UserRaw
    @State private var isSignupResult: Bool = false
    @StateObject private var passwordHelper: PasswordHelper = PasswordHelper()
    
    var body: some View {
        NavigationStack {
            Form {
                ItemRow("Registrera",
                        color: .white,
                        font:.system(
                            .largeTitle,design: .rounded
                        ).weight(.bold),
                        edgeInset: EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                Section(header: Text("Your Info")) {
                    TextFieldsUser(user: self.$user)
                }
                Section(header: Text("Password"),footer: Text("Password must be between \(MIN_PASSWORD_LEN) - \(MAX_PASSWORD_LEN) characters long")) {
                    PasswordView()
                }
                Section {
                    ConfirmedPassword(action:signUserUp)
                }
            }
            .environmentObject(passwordHelper)
            .modifier(NavigationViewModifier(title: ""))
            .alert(isPresented: $isSignupResult, content: {
                onResultAlert {
                    if ALERT_IS_SUCCESSFUL {
                        dismiss()
                    }
                }
            })
        }
    }
    
    func signUserUp(){
        if user.name.isEmpty { activateMissingFieldsAlert(); return }
        firebaseAuth.signup(user: user, password: passwordHelper.password){ (result,error) in
            guard let error = error else {
                firestoreViewModel.initializeUserData(user.converted()){ result in
                    if result.finishedWithoutError{
                        activateSuccessAlert()
                        return
                    }
                    activateFailedCreationOfUserAlert(error:result.asString())
                }
                return
            }
            activateFailedSignupAlert(error:error)
        }
    }
    
    func activateMissingFieldsAlert(){
        ALERT_TITLE = "Error"
        ALERT_MESSAGE = "Missing fields. One of the required field is empty or contains invalid data"
        ALERT_IS_SUCCESSFUL = false
        isSignupResult.toggle()
    }
    
    func activateSuccessAlert(){
        ALERT_TITLE = "Signup success"
        ALERT_MESSAGE = "Proceed to login"
        ALERT_IS_SUCCESSFUL = true
        isSignupResult.toggle()
    }
    
    func activateFailedSignupAlert(error:Error){
        ALERT_TITLE = "Signup failed"
        ALERT_MESSAGE = error.localizedDescription
        ALERT_IS_SUCCESSFUL = false
        isSignupResult.toggle()
    }
    
    func activateFailedCreationOfUserAlert(error:String){
        ALERT_TITLE = "Signup failed"
        ALERT_MESSAGE = error
        ALERT_IS_SUCCESSFUL = false
        isSignupResult.toggle()
    }
    
}

struct TextFieldsUser: View{
    @Binding var user: UserRaw
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

struct PasswordView : View {
    @EnvironmentObject var passwordHelper: PasswordHelper
    @State private var showPassword: Bool = true
    
    var body: some View {
        if self.passwordHelper.level != .none {
            SecureLevelView(level: self.passwordHelper.level)
        }
        ToggleSecurefieldView(text: $passwordHelper.password)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(UIColor.opaqueSeparator), lineWidth: 2)
        }
        
    }
}
