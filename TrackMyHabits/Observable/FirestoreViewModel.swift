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
    
   
    
    func initializeUserData(_ user:User,completion:  @escaping ((ThrowableResult) -> Void )){
        do{
            try repo.getUserDocument(user.email).setData(from:user)
            completion(ThrowableResult(finishedWithoutError: true))
        }
        catch {
            completion(ThrowableResult(finishedWithoutError: false,value: error.localizedDescription))
        }
    }
    
    func uploadHabit(habit:Habit,completion: @escaping ((ThrowableResult) -> Void )){
        guard let email = user?.email,let docId = habit.id else { return }
        do{
            try repo.getUserHabitDocument(email,docId:docId).setData(from:habit)
            completion(ThrowableResult(finishedWithoutError: true))
        }
        catch {
            completion(ThrowableResult(finishedWithoutError: false,value: error.localizedDescription))
        }
    }
    
    func updateHabitData(docId:String,
                         data:[[String:Any]],
                         completion: @escaping ((ThrowableResult) -> Void )){
        guard let email = user?.email else { return }
        DispatchQueue.main.async {
            for field in data{
                self.repo.getUserHabitDocument(email,docId:docId).updateData(field)
            }
        }
        //completion(ThrowableResult(finishedWithoutError: true))
    }
    
    func appendNewHabitDone(docId:String,
                            habitDone:Any,
                            completion: @escaping ((ThrowableResult) -> Void )){
        guard let email = user?.email else { return }
        self.repo.getUserHabitDocument(email,docId:docId).updateData(["habitsDone":FieldValue.arrayUnion([habitDone])]){ err in
            if err != nil{ completion(ThrowableResult(finishedWithoutError: false,value: err)); return}
            completion(ThrowableResult(finishedWithoutError: true))
        }
    }
    
    func removeHabitDone(docId:String,
                            habitDone:Any,
                            completion: @escaping ((ThrowableResult) -> Void )){
        guard let email = user?.email else { return }
        self.repo.getUserHabitDocument(email,docId:docId).updateData(["habitsDone":FieldValue.arrayRemove([habitDone])]){ err in
            if err != nil{ completion(ThrowableResult(finishedWithoutError: false,value: err)); return}
            completion(ThrowableResult(finishedWithoutError: true))
        }
    }
    
    func storeOldHabitStreak(docId:String,
                            habitStreak:HabitStreak,
                            completion: @escaping ((ThrowableResult) -> Void )){
        guard let email = user?.email else { return }
        do{
            try repo.getHabitStreakDocument(email,docId:docId).setData(from:habitStreak){ err in
                if err != nil{ completion(ThrowableResult(finishedWithoutError: false,value: err)); return}
                completion(ThrowableResult(finishedWithoutError: true))
            }
        }
        catch {
            completion(ThrowableResult(finishedWithoutError: false,value: error.localizedDescription))
        }
    }
    
    func updateHabitStreak(docId:String,
                            habitStreak:Any,
                            completion: @escaping ((ThrowableResult) -> Void )){
        guard let email = user?.email else { return }
        repo.getUserHabitDocument(email,docId:docId).updateData(["streak":habitStreak]){ err in
            if err != nil{ completion(ThrowableResult(finishedWithoutError: false,value: err)); return}
            completion(ThrowableResult(finishedWithoutError: true))
        }
    }
    
    func removeHabitStreak(docId:String,
                           completion: @escaping ((ThrowableResult) -> Void )){
        guard let email = user?.email else { return }
        repo.getUserHabitDocument(email,docId:docId).updateData(["streak":FieldValue.delete()]){ err in
            if err != nil{ completion(ThrowableResult(finishedWithoutError: false,value: err)); return}
            completion(ThrowableResult(finishedWithoutError: true))
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
}
