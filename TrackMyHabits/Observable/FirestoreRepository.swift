//
//  FirestoreRepository.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-19.
//


import Firebase
import FirebaseStorage

class FirestoreRepository{
    
    private let firestoreDB = Firestore.firestore()
    private let firestoreStorage = Storage.storage()
    
    func getUserDocument(_ email:String) -> DocumentReference {
        return firestoreDB.collection(USER_COLLECTION).document(email)
    }
    
    func getUserHabitDocument(_ email:String,docId:String) -> DocumentReference {
        return getUserDocument(email).collection(USER_HABIT_COLLECTION).document(docId)
    }
    
    func getHabitStreakDocument(_ email:String,docId:String) -> DocumentReference {
        return getUserHabitDocument(email, docId: docId).collection(HABIT_STREAK_COLLECTION).document(docId)
    }
    
    func getUserHabits(_ email:String) -> CollectionReference {
        return getUserDocument(email).collection(USER_HABIT_COLLECTION)
    }
}
