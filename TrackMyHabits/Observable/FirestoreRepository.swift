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
    
    func getUserDocument(_ user:User) -> DocumentReference {
        return firestoreDB.collection(USER_COLLECTION).document(user.email)
    }
}
