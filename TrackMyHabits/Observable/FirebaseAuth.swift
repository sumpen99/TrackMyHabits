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
    
    func login(email:String,password:String){
        auth.signIn(withEmail: email, password: password){ [weak self] (result,error) in
            guard let strongSelf = self else { return }
            guard let error = error else {
                strongSelf.isLoggedIn = true
                return
            }
            printAny(error.localizedDescription)
        }
    }
    
    func signup(user:User,password:String){
        return auth.createUser(withEmail: user.email, password: password){ [weak self] (result,error) in
            guard let strongSelf = self else { return }
            guard let error = error else {
                strongSelf.login(email: user.email, password: password)
                return
            }
            printAny(error.localizedDescription)
        }
    }
}
