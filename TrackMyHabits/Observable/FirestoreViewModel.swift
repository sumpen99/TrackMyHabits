//
//  FirestoreViewModel.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-25.
//

import Firebase
import SwiftUI
class FirestoreViewModel: ObservableObject{
    let repo = FirestoreRepository()
    var listenerUser: ListenerRegistration?
    @Published var user:User?
    
    func initializeUserData(_ user:User,completion: ((ThrowableResult) -> Void )){
        var throwableResult = ThrowableResult()
        do{
            try repo.getUserDocument(user.email).setData(from:user)
            throwableResult.finishedWithoutError = true
        }
        catch {
            throwableResult.finishedWithoutError = false
            throwableResult.value = error.localizedDescription
        }
        completion(throwableResult)
    }
    
    func getUserData(email:String?){
        guard let email = email else { return }
        closeListenerUser()
        listenerUser = repo.getUserDocument(email).addSnapshotListener{ [weak self] snapshot, error in
            guard let strongSelf = self else { return }
            guard let changes = snapshot else { return }
            do {
                let user  = try changes.data(as: User.self)
                USER_PROFILE_PIC_PATH = user.email
                strongSelf.user = user
            }
            catch {
                //printAny(error)
            }
        }
    }
    
    func closeListenerUser(){
        listenerUser?.remove()
    }
    
    deinit{
        closeListenerUser()
    }
    
    /*
     func updateName(fullname: String) {
         guard let uid = user.id else { return }
         Firestore.firestore().collection("users").document(uid).updateData(["fullname": fullname]) { _ in
             self.user.fullname = fullname
         }
     }
     */
    
}
