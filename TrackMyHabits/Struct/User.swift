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
    var name:String = ""
    var email:String = ""
}

struct Habit: Codable,Identifiable{
    @DocumentID var id: String?
    var creation:Date = Date()
    var title:String = ""
    var motivation:String = ""
    var goal:String = ""
    var weekDaysFrequence:[WeekDay] = [WeekDay]()
    var weekDaysNotification:[WeekDay]?
    var notificationTime:NotificationTime = NotificationTime()
    var streak:Int = 0
    var habitsDone: [HabitDone]?
}

struct HabitDone: Codable{
    let date:Date?
    let timeOfExecution: String
    let comments: String
    
}

struct NotificationTime: Codable{
    var isSet = false
    var hour:Int?
    var minutes:Int?
}


