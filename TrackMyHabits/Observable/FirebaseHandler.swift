//
//  FirebaseHandler.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-19.
//

import SwiftUI
import Firebase
class FirebaseHandler: ObservableObject{
    let auth = Auth.auth()
    let manager = FirestoreManager()

    var isSuccessful:Bool = false
    @Published var isLoggedIn: Bool = false
    
    func refreshLoggedInStatus(){
        isLoggedIn = auth.currentUser != nil
    }
    
    
    
    /*init(){
        do{
            try auth.signOut()
        }
        catch{
            
        }
    }*/
    
    func login(email:String,password:String,completion:((AuthDataResult?,Error?)->Void)?){
        auth.signIn(withEmail: email, password: password,completion:completion)
    }
    
    func signup(user:User,password:String,completion:((AuthDataResult?,Error?)->Void)?){
        auth.createUser(withEmail: user.email, password: password,completion: completion)
    }
    
    
}
