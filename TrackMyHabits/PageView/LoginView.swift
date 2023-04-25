//
//  LoginView.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-17.
//

import SwiftUI

struct LoginView: View{
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var firestoreViewModel: FirestoreViewModel
    @State var user = User()
    @State private var password = ""
    @State private var showingSignUpSheet = false
    @State private var isLoginResult = false
    let dummy = Dummy(name:"LoginView",printOnDestroy: true)
    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                ScrollView{
                    VStack() {
                        LoginHeader()
                        VStack(alignment: .center, spacing: 15) {
                            TextField("Email", text: $user.email)
                                .removePredictiveSuggestions()
                                .padding()
                                .background(.white)
                                .cornerRadius(20.0)
                            ToggleSecurefieldView(text: self.$password)
                                .background(.white)
                                .cornerRadius(20.0)
                            Button(action: { loginUser() }) {
                                Text("Sign In")
                                    .formButtonDesign(
                                        width: geometry.size.width*0.8, backgroundColor: Color.green)
                            }
                            Spacer()
                            Button(action: {showingSignUpSheet.toggle()}) {
                                Text("Dont have an account? Sign Up")
                                    .formButtonDesign(
                                        width: geometry.size.width*0.8, backgroundColor: Color.black)
                            }
                        }.padding([.leading, .trailing], 27.5)
                    }
                }
            }
            .background(appLinearGradient())
            .sheet(isPresented: $showingSignUpSheet){
                SignupView(user: self.$user)
            }
            .alert(isPresented: $isLoginResult, content: {
                onResultAlert{ }
            })
        }
    }
    
    func loginUser(){
        firestoreViewModel.login(email: user.email, password: password){(result,error) in
            guard let error = error else {
                firestoreViewModel.refreshLoggedInStatus()
                return
            }
            activateFailedLoginAlert(error:error)
        }
    }
    
    func activateFailedLoginAlert(error:Error){
        ALERT_TITLE = "Login failed"
        ALERT_MESSAGE = error.localizedDescription
        isLoginResult.toggle()
    }
}


struct LoginHeader: View{
    var body: some View{
        Text("Track..My..Habits\n(please) ")
            .font(
                .system(
                    .largeTitle,design: .rounded
                ).weight(.bold))
            .foregroundColor(Color.white)
            .padding([.top, .bottom], 40)
            .multilineTextAlignment(.center)
        Image("HabitClock")
            .resizable()
            .frame(width: 250, height: 250)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 4))
            .shadow(radius: 10)
            .padding(.bottom, 50)
        
    }
}
