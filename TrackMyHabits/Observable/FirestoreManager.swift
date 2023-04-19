//
//  FirestoreManager.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-19.
//


import Firebase

class FirestoreManager: ObservableObject{
    let repo = FirestoreRepository()
    
    init(){
        printAny("init firestoremanager")
    }
    
    func initializeUser(_ user:User,completion: @escaping ((ThrowableResult) -> Void )){
        handleThrowable(try repo.getUserDocument(user).setData(from:user)){ result in
            completion(result)
        }
    }
  
}
