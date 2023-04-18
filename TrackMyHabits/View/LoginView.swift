//
//  LoginView.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-17.
//

import SwiftUI

struct LoginView: View{
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @State private var email = ""
    @State private var password = ""
    @State private var showingSignUpSheet = false
    @State private var isLoginResult = false
    let dummy = Dummy(name:"LoginView",printOnDestroy: true)
    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                ScrollView{
                    VStack() {
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
                        VStack(alignment: .center, spacing: 15) {
                            TextField("Email", text: self.$email)
                                .removePredictiveSuggestions()
                                .padding()
                                .background(.white)
                                .cornerRadius(20.0)
                            ToggleSecurefieldView(text: self.$password)
                                .background(.white)
                                .cornerRadius(20.0)
                            Button(action: {loginUser()}) {
                                Text("Sign In")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(width: geometry.size.width*0.8, height: 50)
                                    .background(Color.green)
                                    .cornerRadius(15.0)
                            }
                            Spacer()
                            Button(action: {showingSignUpSheet.toggle()}) {
                                Text("Dont have an account? Sign Up")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(width: geometry.size.width*0.8, height: 50)
                                    .background(Color.black)
                                    .cornerRadius(15.0)
                            }
                        }.padding([.leading, .trailing], 27.5)
                    }
                }
            }
            .background(appLinearGradient())
            .sheet(isPresented: $showingSignUpSheet,content: SignupView.init)
            .alert(ALERT_TITLE,isPresented: $isLoginResult,actions: {
                Button("OK", role: .cancel,action: {})
            }, message: {
                Text(ALERT_MESSAGE)
            })
        }
    }
    
    func loginUser(){
        firebaseAuth.login(email: email, password: password){(result,error) in
            guard let error = error else {
                firebaseAuth.isLoggedIn = true
                return
            }
            ALERT_TITLE = "Login failed"
            ALERT_MESSAGE = error.localizedDescription
            isLoginResult.toggle()
        }
    }
}

