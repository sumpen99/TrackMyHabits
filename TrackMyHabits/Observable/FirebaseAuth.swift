//
//  FirebaseAuth.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-17.
//

import Foundation
import Firebase

class FirebaseAuth: ObservableObject{
    let auth = Auth.auth()
    var isSuccessful:Bool = false
    @Published var isLoggedIn: Bool
    
    /*func isLoggedIn() -> Bool{
        return auth.currentUser != nil
    }*/
    
    
    
    init(){
        isLoggedIn = auth.currentUser != nil
        do{
            try auth.signOut()
        }
        catch{
            
        }
    }
    
    func login(email:String,password:String,completion:((AuthDataResult?,Error?)->Void)?){
        auth.signIn(withEmail: email, password: password,completion:completion)
    }
    
    func signup(user:User,password:String,completion:((AuthDataResult?,Error?)->Void)?){
        auth.createUser(withEmail: user.email, password: password,completion: completion)
    }
}
