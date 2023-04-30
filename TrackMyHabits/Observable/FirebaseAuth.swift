//
//  FirebaseAuth.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-25.
//

import Firebase
import SwiftUI
class FirebaseAuth: ObservableObject{
    let auth = Auth.auth()
     @Published var isLoggedIn: Bool = false
    
    func refreshLoggedInStatus(){
        isLoggedIn.toggle()
    }
    
    func isUserLoggedIn(){
        isLoggedIn = auth.currentUser != nil
    }
    
    func signOut(){
        do{
            try auth.signOut()
            refreshLoggedInStatus()
        }
        catch{
            printAny(error)
        }
    }
    
    func getUserEmail() ->String? {
        return auth.currentUser?.email
    }
    
    func getUserID() ->String? {
        return auth.currentUser?.uid
    }
    
    func login(email:String,password:String,completion:((AuthDataResult?,Error?)->Void)?){
        auth.signIn(withEmail: email, password: password,completion:completion)
    }
    
    func signup(user:User,password:String,completion:((AuthDataResult?,Error?)->Void)?){
        auth.createUser(withEmail: user.email, password: password,completion: completion)
    }
    
}
