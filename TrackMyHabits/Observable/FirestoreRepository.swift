//
//  FirestoreRepository.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-19.
//

import Foundation
import Firebase
import FirebaseStorage
// https://designcode.io/swiftui-advanced-handbook-firebase-storage
class FirestoreRepository{
    
    private let firestoreDB = Firestore.firestore()
    private let firestoreStorage = Storage.storage()
    
    func getUserDocument(_ email:String) -> DocumentReference {
        return firestoreDB.collection(USER_COLLECTION).document(email)
    }
    
    func getUserHabitDocument(_ email:String,title:String) -> DocumentReference {
        return getUserDocument(email).collection(USER_HABIT_COLLECTION).document(title.uppercased())
    }
    
    func getUserHabits(_ email:String) -> CollectionReference {
        return getUserDocument(email).collection(USER_HABIT_COLLECTION)
    }
}
