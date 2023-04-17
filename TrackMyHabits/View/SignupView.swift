//
//  SignupView.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-17.
//

import SwiftUI

struct SignupView : View {
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @State var user = User()
    @State private var email: String = ""
    @StateObject var passwordHelper: PasswordHelper = PasswordHelper()
    
    init(){
        printAny("init signupview")
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Your Info")) {
                    TextField("Name",text: $user.name.max(MAX_TEXTFIELD_LEN))
                        .removePredictiveSuggestions()
                        .textContentType(.name)
                    TextField("Email",text: $user.email.max(MAX_TEXTFIELD_LEN))
                        .removePredictiveSuggestions()
                        .textContentType(.emailAddress)
                }
                Section(header: Text("Password"),footer: Text("Password must be between \(MIN_PASSWORD_LEN) - \(MAX_PASSWORD_LEN) characters long")) {
                    PasswordView()
                    .environmentObject(passwordHelper)
                }
                Section {
                    if self.passwordHelper.level != .none {
                        ToggleSecurefieldView(text: $passwordHelper.confirmedPassword)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(passwordHelper.passwordsIsAMatch ? .green : .red, lineWidth: 2)
                        }
                        if passwordHelper.passwordsIsAMatch{
                            Button(action: { signUserUp()}) {
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
            .scrollContentBackground(.hidden)
            .background(
              LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all))
            .navigationBarTitle(Text("Registration Form"))
        }
    }
    
    func signUserUp(){
        firebaseAuth.signup(user: user, password: passwordHelper.password)
        /*printAny(firebaseAuth.isLoggedIn)
        printAny("\(passwordHelper.password) " +
                 "\(passwordHelper.confirmedPassword) " +
                 "\(passwordHelper.passwordsIsAMatch) " +
                 "\(user.email)" +
                 "\(user.name)")*/
    }
}
