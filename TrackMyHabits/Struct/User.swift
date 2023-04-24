//
//  User.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-17.
//


import FirebaseFirestoreSwift
import SwiftUI
struct User: Codable,Identifiable{
    @DocumentID var id: String?
    var name = ""
    var email = ""
}

struct Habit: Codable,Identifiable{
    @DocumentID var id: String?
    var title = ""
    var description = ""
    var streak: Int = 0
    var habitsDone: [HabitDone] = [HabitDone]()
    
}

struct HabitDone: Codable{
    var timeOfExecution: String = ""
    var information: String = ""
}
