//
//  FirestoreManager.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-19.
//


import Firebase
import SwiftUI
class FirestoreManager: ObservableObject{
    let repo = FirestoreRepository()
    var listenerUser: ListenerRegistration?
    func initializeUser(_ user:User,completion: @escaping ((ThrowableResult) -> Void )){
        handleThrowable(try repo.getUserDocument(user.email).setData(from:user)){ result in
            completion(result)
        }
        
    }
     
    deinit{
        closeListenerUser()
    }
    
    func closeListenerUser(){
        listenerUser?.remove()
    }
    
    func getUser(email:String,completion:@escaping ((User)->Void)){
        closeListenerUser()
        listenerUser = repo.getUserDocument(email).addSnapshotListener{snapshot, error in
            guard let changes = snapshot else { return }
            do {
                let user = try changes.data(as: User.self)
                completion(user)
            }
            catch {
                printAny(error)
            }
        }
    }
    
    
    /*
     https://stackoverflow.com/questions/64491888/removing-firestore-snapshotlistener
     https://peterfriese.dev/posts/swiftui-firebase-fetch-data/
     https://stackoverflow.com/questions/59548819/how-to-convert-document-to-a-custom-object-in-swift-5
     
     */
    /*func getUser(email:String,completion: @escaping ((DocumentSnapshot?, (any Error)?) -> Void )){
        repo.getUserDocument(email).getDocument(completion:completion)
    }*/
    
    
    /*
     func updateName(fullname: String) {
         guard let uid = user.id else { return }
         Firestore.firestore().collection("users").document(uid).updateData(["fullname": fullname]) { _ in
             self.user.fullname = fullname
         }
     }
     */
    /*repo.getUserDocument(email).getDocument{ (document,error) in
        if let error = error as NSError? {
            printAny(error)
        }
        else {
            if let document = document {
                do {
                    self.user = try document.data(as: User.self)
                }
                catch {
                    printAny(error)
                }
            }
            
        }
        
        
    }*/
  
}
