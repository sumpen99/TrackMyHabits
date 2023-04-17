//
//  LoginView.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-17.
//

import SwiftUI

struct LoginView: View{
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @State var email = ""
    @State var password = ""
    @State private var showingSignUpSheet = false
    let dummy = Dummy(name:"LoginView",printOnDestroy: true)
    
    var isSignInButtonDisabled: Bool {
        [email, password].contains(where: \.isEmpty)
    }
    
    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                ScrollView{
                    VStack() {
                        Text("Sliding Numbers")
                            .font(.largeTitle).foregroundColor(Color.white)
                            .padding([.top, .bottom], 40)
                        
                        Image("HabitClock")
                            .resizable()
                            .frame(width: 250, height: 250)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            .shadow(radius: 10)
                            .padding(.bottom, 50)
                        VStack(alignment: .center, spacing: 15) {
                            TextField("Email", text: self.$email)
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
            .background(
              LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all))
            .sheet(isPresented: $showingSignUpSheet,content: SignupView.init)
        }
    }
    
    func loginUser(){
        firebaseAuth.login(email: email, password: password)
    }
}

