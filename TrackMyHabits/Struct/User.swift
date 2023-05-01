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
    var lastRegistredDate:Date? = Date().yesterDay()
    var weekDaysFrequence:[WeekDay] = [WeekDay]()
    var weekDaysNotification:[WeekDay] = [WeekDay]()
    var notificationTime:NotificationTime = NotificationTime()
    var notificationId:String = UUID().uuidString
    var streak:HabitStreak?
    var habitsDone: [HabitDone] = [HabitDone]()
    
    func todaysTodo() -> HabitTodo{
        let habitsDoneList = habitsDone.sorted(by: {
            $0.timeOfExecution.compare($1.timeOfExecution) == .orderedDescending
        })
        let today = Date()
        let todayStr = today.dayName()
        var nextDate:Date?
        var nextDayRange:Int = 7
        var nextDayStr:String = todayStr
        var todoToday:Bool = false
        var isDone = false
        for day in weekDaysFrequence{
            if todayStr == day.name{
                todoToday = true
                isDone = habitsDoneList.last?.timeOfExecution.isSameDayAs(today) ?? false
            }
            else{
                if let nextDay = today.nextWeekDay(weekday: day.value),
                   let daysUntilNext = today.numberOfDaysTo(nextDay){
                    if daysUntilNext < nextDayRange{
                        nextDate = today.plusThisMuchDays(daysUntilNext)
                        nextDayRange = daysUntilNext
                        nextDayStr = nextDay.dayName()
                    }
                }
            }
        }
        return HabitTodo(title:title,
                         daysUntilNext: nextDayRange,
                         nextDay: nextDayStr,
                         nextDate: nextDate,
                         streak: streak ?? HabitStreak(isActive:false,keepStreakGoing: today),
                         todoToday: todoToday,
                         isDone: isDone,
                         docId: id)
    }
}

struct HabitDone: Codable{
    var id:String
    var timeOfExecution: Date
    var comments: String
    var rating: Float
    
    func toMap() -> [String:Any]{
        return ["id": self.id,
                "timeOfExecution": self.timeOfExecution,
                "comments": self.comments,
                "rating": self.rating]
    }
}

struct NotificationTime: Codable{
    var isSet = false
    var hour:Int = 0
    var minutes:Int = 0
    
}

struct HabitTodo: Codable,Identifiable{
    var id = UUID().uuidString
    let title:String
    let daysUntilNext:Int
    let nextDay:String
    let nextDate:Date?
    let streak:HabitStreak
    let todoToday:Bool
    let isDone:Bool
    let docId:String?
}

struct HabitStreak: Codable,Identifiable{
    var id = UUID().uuidString
    let isActive:Bool
    var keepStreakGoing:Date
    var dates:[Date] = [Date]()
    var streak:Int = 0
    var rating:Float = 0.0
    
    func toMap() -> [String:Any]{
        return ["id": self.id,
                "isActive": self.isActive,
                "keepStreakGoing": self.keepStreakGoing,
                "dates": self.dates,
                "streak": self.streak,
                "rating": self.rating]
    }
}


