//
//  FirestoreViewModel.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-25.
//

import Firebase
import SwiftUI
class FirestoreViewModel: ObservableObject{
    let auth = Auth.auth()
    let repo = FirestoreRepository()
    var listenerUser: ListenerRegistration?
    @Published var user:User?
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
            user = nil
            closeListenerUser()
            refreshLoggedInStatus()
        }
        catch{
            printAny(error)
        }
    }
    
    func getUserEmail() ->String {
        guard let user = auth.currentUser else { return ""}
        return user.email ?? ""
    }
    
    func login(email:String,password:String,completion:((AuthDataResult?,Error?)->Void)?){
        auth.signIn(withEmail: email, password: password,completion:completion)
    }
    
    func signup(user:User,password:String,completion:((AuthDataResult?,Error?)->Void)?){
        auth.createUser(withEmail: user.email, password: password,completion: completion)
    }
    
    func initializeUser(_ user:User,completion: ((ThrowableResult) -> Void )){
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
    
    func getUser(){
        closeListenerUser()
        listenerUser = repo.getUserDocument(getUserEmail()).addSnapshotListener{ [weak self] snapshot, error in
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
