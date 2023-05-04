//
//  User.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-17.
//

import FirebaseFirestoreSwift
import SwiftUI

struct UserRaw{
    var name:String = ""
    var email:String = ""
    
    func converted()->User{
        return User(name:self.name,email:self.email)
    }
}

struct HabitRaw{
    var title:String = ""
    var motivation:String = ""
    var goal:String = ""
    var notificationTime:NotificationTime = NotificationTime()
    var notificationId:String = UUID().uuidString
    var weekDays:WeekDays = WeekDays()
    var notificationWeekDays:WeekDays = WeekDays()
    
    
    func converted()->Habit{
        return Habit(
            creation:Date(),
            title:self.title,
            motivation:self.motivation,
            goal:self.goal,
            lastRegistredDate:Date().yesterDay(),
            weekDaysFrequence:self.weekDays.selectedDays,
            weekDaysNotification:self.notificationWeekDays.selectedDays,
            notificationTime: self.notificationTime,
            notificationId: self.notificationId,
            streak: HabitStreak(keepStreakGoing: findClosestNextDay()))
    }
    
    func findClosestNextDay()->Date{
        let today = Date()
        var nextDate = today.yesterDay()
        let todayInt = today.dayValue()
        var nextDayRange:Int = 7
        for day in self.weekDays.selectedDays{
            if todayInt == day.value{
                return today
            }
            else{
                if let nextDay = today.nextWeekDay(weekday: day.value),
                   let daysUntilNext = today.numberOfDaysTo(nextDay){
                    if daysUntilNext < nextDayRange{
                        nextDate = today.plusThisMuchDays(daysUntilNext)
                        nextDayRange = daysUntilNext
                    }
                }
            }
        }
        
        return nextDate ?? today
    }
}

struct User: Codable,Identifiable{
    @DocumentID var id: String?
    var name:String
    var email:String
}

struct Habit: Codable,Identifiable{
    @DocumentID var id: String? = UUID().uuidString
    var creation:Date
    var title:String
    var motivation:String
    var goal:String
    var lastRegistredDate:Date?
    var weekDaysFrequence:[WeekDay]
    var weekDaysNotification:[WeekDay]
    var notificationTime:NotificationTime
    var notificationId:String
    var streak:HabitStreak
    
    func todaysTodo() -> HabitTodo{
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
                isDone = lastRegistredDate?.isSameDayAs(today) ?? false
            }
            
            if let nextDay = today.nextWeekDay(weekday: day.value),
               let daysUntilNext = today.numberOfDaysTo(nextDay){
                if daysUntilNext < nextDayRange{
                    nextDate = today.plusThisMuchDays(daysUntilNext)
                    nextDayRange = daysUntilNext
                    nextDayStr = nextDay.dayName()
                }
            }
        }
        
        return HabitTodo(title:title,
                         daysUntilNext: nextDayRange,
                         nextDay: nextDayStr,
                         nextDate: nextDate,
                         streak: streak,
                         todoToday: todoToday,
                         isDone: isDone,
                         docId: id)
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
    var keepStreakGoing:Date
    var habitsDone: [String:HabitDone] = [:]
    
    func isActive() ->Bool{
        return keepStreakGoing.isSameDayAs(Date())
    }
    
    func toMap(nextDate:Date,habitDone:HabitDone) -> [String:Any]{
      
        var mapList = habitsDone.mapValues(){$0.toMap()}
        mapList[habitDone.timeOfExecution] = habitDone.toMap()
        
        return ["id":id,"keepStreakGoing": nextDate,"habitsDone": mapList]
        
    }
    
    func getHabitListItems() -> [HabitListItem]{
        return sortByMonth(habitsDone:Array(habitsDone.values))
    }
    
    func getHabitsDone() -> [HabitDone]?{
        let values = habitsDone.map{$0.value}
        return values.sorted(by: {$0.compareTo($1)})
    }
    
    func getTestData() -> [HabitListItem]{
        let commentGood = "Idag gick det bra"
        let commentBad = "Inget vidare"
        var habitsDone = [HabitDone]()
        var dateFrom =  Date()
        var dateTo = Date() 
        
        let fmt = ISO8601DateFormatter()
        fmt.formatOptions = [.withFullDate]
        dateFrom = fmt.date(from: "2023-01-01T10:12:31.484Z")!
        dateTo = fmt.date(from: "2023-12-31T10:12:31.484Z")!


        while dateFrom <= dateTo {
            let rating = Float(Int.random(in: 0..<6))
            let done = HabitDone(id: UUID().uuidString,
                                 timeOfExecution: dateFrom.toISO8601String(),
                                 comments: rating < 3 ? commentBad : commentGood,
                                 rating: rating,
                                 year:dateFrom.year(),
                                 monthInt:dateFrom.month(),
                                 monthStr:dateFrom.monthName(),
                                 dayInt:dateFrom.day(),
                                 dayStr:dateFrom.dayName())
            habitsDone.append(done)
            guard let nextDate = Calendar.current.date(
                byAdding: .day,
                value: 1,
                to:dateFrom) else { break }
            dateFrom = nextDate
        }
        
        return sortByMonth(habitsDone: habitsDone)
    }
    
    func sortByMonth(habitsDone:[HabitDone]) -> [HabitListItem]{
        var monthlyList = [HabitListItem]()
        let groupedList = Dictionary(grouping: habitsDone, by: { $0.monthStr })
        for key in groupedList.keys.sorted(by:{ sortMonth(month: $0) < sortMonth(month: $1)}) {
            monthlyList.append(HabitListItem(
                month: key.capitalizingFirstLetter(),
                habitDone: groupedList[key]!))
        }
        return monthlyList
    }
    
    func sortMonth(month:String) -> Int{
        switch month{
        case "januari":
            return 0
        case "februari":
            return 1
        case "mars":
            return 2
        case "april":
            return 3
        case "maj":
            return 4
        case "juni":
            return 5
        case "juli":
            return 6
        case "augusti":
            return 7
        case "september":
            return 8
        case "oktober":
            return 9
        case "november":
            return 10
        case "december":
            return 11
        default:
            return 0
        }
     }
}

struct HabitListItem:Codable,Identifiable{
    var id = UUID().uuidString
    let month: String
    let habitDone: [HabitDone]
}

struct HabitDone: Codable,Identifiable{
    var id:String
    var timeOfExecution: String
    var comments: String
    var rating: Float
    var year:Int
    var monthInt:Int
    var monthStr:String
    var dayInt:Int
    var dayStr:String
    
    func compareTo(_ habit:HabitDone) -> Bool{
        let d1 = Date.fromISO8601StringToDate(timeOfExecution)
        let d2 = Date.fromISO8601StringToDate(habit.timeOfExecution)
        guard let d1 = d1,let d2 = d2 else{
            return false
        }
        return d1.compare(d2) == .orderedAscending
    }
    
    func getTimeFormatted() -> (dateformatted:String,weekday:String){
        return Date.fromISO8601StringToDate(timeOfExecution)?.dayDateMonthYear() ?? (dateformatted:timeOfExecution,weekday:"?")
    }
    
    func toMap() -> [String:Any]{
        return ["id": self.id,
                "timeOfExecution": self.timeOfExecution,
                "comments": self.comments,
                "rating": self.rating,
                "year":self.year,
                "monthInt":self.monthInt,
                "monthStr":self.monthStr,
                "dayInt":self.dayInt,
                "dayStr":self.dayStr]
    }
    
}


struct WeekDays{
   var days:[Bool] = Array(repeating: false, count: 7)
   var selectedDays: [WeekDay] = [WeekDay]()
   
   mutating func storeSelectedDays(autoSelect:Bool = false){
       clearSelectedDays()
       for i in 0..<days.count{
           if autoSelect {
               days[i] = true
               selectedDays.append(WeekDay(value:i+1))
               
           }
           else if days[i]{
               selectedDays.append(WeekDay(value:i+1))
           }
       }
   }
   
   mutating func clearSelectedDays(){
       selectedDays.removeAll()
   }
}

struct WeekDay:Codable,Identifiable{
   var id = UUID()
   var value:Int = 1
   var name:String {
       return Calendar.current.weekdaySymbols[value-1]
   }
   
}
