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
    var listenerHabit: ListenerRegistration?
    @Published var user:User?
    @Published var habits = [Habit]()
    @Published var userStatus = UserStatus()
    
    // MAKE PUBLISHED TODAYS TODO STRUCT 
    
    func initializeUserData(_ user:User,completion:  @escaping ((ThrowableResult) -> Void )){
        do{
            try repo.getUserDocument(user.email).setData(from:user)
            completion(ThrowableResult(finishedWithoutError: true))
        }
        catch {
            completion(ThrowableResult(finishedWithoutError: false,value: error.localizedDescription))
        }
    }
    
    func uploadOrSetHabit(habit:Habit,completion: @escaping ((ThrowableResult) -> Void )){
        guard let email = user?.email,let docId = habit.id else { return }
        do{
            try repo.getUserHabitDocument(email,docId:docId).setData(from:habit)
            completion(ThrowableResult(finishedWithoutError: true))
        }
        catch {
            completion(ThrowableResult(finishedWithoutError: false,value: error.localizedDescription))
        }
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
    
    func doesHabitAlreadyExist(title:String,completion: @escaping ((Bool)->Void)){
        guard let email = user?.email else { return }
        repo.getUserHabits(email).whereField("title", isEqualTo: title)
            .limit(to:1)
            .getDocuments(){ querySnapshot, error in
                if error != nil {
                    completion(false)
                    return
                }

                guard let docs = querySnapshot?.documents else { completion(false) ; return}
                completion(!docs.isEmpty)
            }
    }
    
    
    func removeHabit(docId:String,completion: @escaping ((ThrowableResult) -> Void )) {
        guard let email = user?.email else { return }
        repo.getUserHabitDocument(email,docId:docId).delete { error in
            guard let error = error else {
                completion(ThrowableResult(finishedWithoutError: true))
                return
            }
            completion(ThrowableResult(finishedWithoutError: false,value: error.localizedDescription))
        }
    }
     
    func getUserHabits(email:String?) {
        guard let email = email else { return }
        listenerHabit = repo.getUserHabits(email).addSnapshotListener{ [ weak self ] (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
              printAny("No documents")
              return
            }
            guard let strongSelf = self else { return }
            strongSelf.habits.removeAll()
            strongSelf.userStatus.resetValues()
            for doc in documents{
                do{
                    let habit  = try doc.data(as: Habit.self)
                    strongSelf.habits.append(habit)
                    strongSelf.userStatus.updateValues(habitTodo:habit.todaysTodo())
                }
                catch{
                    
                }
            }
          }
    }
    
    func closeListenerUser(){
        listenerUser?.remove()
    }
    
    func closeListenerHabit(){
        listenerHabit?.remove()
    }
    
    deinit{
        habits.removeAll()
        closeListenerHabit()
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
    
    
    /*
     guard let email = user?.email else { return }
     repo.repo.getUserHabits(email).whereField("title", isEqualTo: title)
         .limit(to:1)
         .getDocuments(completion: { querySnapshot, error in
             if let err = error {
                 print(err.localizedDescription)
                 return
             }

             guard let docs = querySnapshot?.documents else { return }

             for doc in docs {
                 let docId = doc.documentID
                 let name = doc.get("name")
                 print(docId, name)

                 let ref = doc.reference
                 ref.updateData(["age": 20])
             }
         })
     
     */
}
