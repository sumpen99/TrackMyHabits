//
//  LoginView.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-17.
//

import SwiftUI

struct LoginView: View{
    @Environment(\.dismiss) private var dismiss
    //@Environment(\.isPresented) private var isPresented
    @EnvironmentObject var firebaseHandler: FirebaseHandler
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
                            LoginEmailField(user:self.$user)
                            ToggleSecurefieldView(text: self.$password)
                                .background(.white)
                                .cornerRadius(20.0)
                            LoginButton(width: geometry.size.width*0.8,action: loginUser)
                            Spacer()
                            SignupButton(width: geometry.size.width*0.8,showingSignupSheet: $showingSignUpSheet)
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
        firebaseHandler.login(email: user.email, password: password){(result,error) in
            guard let error = error else {
                printAny(firebaseHandler.isLoggedIn)
                firebaseHandler.refreshLoggedInStatus()
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

struct LoginEmailField: View{
    @Binding var user: User
    var body: some View{
        TextField("Email", text: $user.email)
            .removePredictiveSuggestions()
            .padding()
            .background(.white)
            .cornerRadius(20.0)
    }
}

struct LoginButton: View{
    var width:CGFloat
    var action: () -> Void
    var body: some View{
        Button(action: {action()}) {
            Text("Sign In")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(width: width, height: 50)
                .background(Color.green)
                .cornerRadius(15.0)
        }
    }
}

struct SignupButton: View{
    var width:CGFloat
    @Binding var showingSignupSheet : Bool
    
    var body: some View{
        Button(action: {showingSignupSheet.toggle()}) {
            Text("Dont have an account? Sign Up")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(width: width, height: 50)
                .background(Color.black)
                .cornerRadius(15.0)
        }
    }
}
