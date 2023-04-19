//
//  User.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-17.
//


import FirebaseFirestoreSwift
struct User: Codable,Identifiable{
    @DocumentID var id: String?
    var name = ""
    var email = ""
}
