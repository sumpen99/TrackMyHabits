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
    @DocumentID var id: String? = UUID().uuidString
    var creation:Date = Date()
    var title:String = ""
    var motivation:String = ""
    var goal:String = ""
    var lastRegistredDate:Date?
    var weekDaysFrequence:[WeekDay] = [WeekDay]()
    var weekDaysNotification:[WeekDay]?
    var notificationTime:NotificationTime = NotificationTime()
    var notificationId:String = UUID().uuidString
    var streak:Int = 0
    var habitsDone: [HabitDone]?
    
    func removeNotifications() -> Habit{
        return Habit(
            id:self.id,
            creation:self.creation,
            title:self.title,
            motivation:self.motivation,
            goal:self.goal,
            lastRegistredDate: self.lastRegistredDate,
            weekDaysFrequence:self.weekDaysFrequence,
            weekDaysNotification:nil,
            notificationTime:NotificationTime(),
            notificationId:self.notificationId,
            streak: self.streak,
            habitsDone: self.habitsDone
        )
    }
    
    func todaysTodo() -> HabitTodo{
        let today = Date()
        let todayStr = today.dayName()
        var nextDayRange:Int = 7
        var nextDayStr:String = todayStr
        var todoToday:Bool = false
        var isDone = false
        for day in weekDaysFrequence{
            if todayStr == day.name{
                todoToday = true
                isDone = lastRegistredDate?.isSameDayAs(today) ?? false
            }
            else{
                if let nextDay = today.nextWeekDay(weekday: day.value),
                   let daysUntilNext = today.numberOfDaysTo(nextDay){
                    if daysUntilNext < nextDayRange{
                        nextDayRange = daysUntilNext
                        nextDayStr = nextDay.dayName()
                    }
                }
            }
        }
        return HabitTodo(title:title,
                         daysUntilNext: nextDayRange,
                         nextDay: nextDayStr,
                         todoToday: todoToday,
                         isDone: isDone,
                         docId: id)
    }
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

struct HabitTodo: Codable,Identifiable{
    var id = UUID().uuidString
    let title:String
    let daysUntilNext:Int
    let nextDay:String
    let todoToday:Bool
    let isDone:Bool
    let docId:String?
}


