//
//  UserStatus.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-30.
//
import SwiftUI
class UserStatus{
    var habitsTodo:[HabitTodo] = [HabitTodo]()
    var todaysDayNames:[String] = [String]()
    var todoToday:Int = 0
    var doneToday:Int = 0
    var totalHabits:Int = 0
    var daysUntilNext:Int = 7
    var nextDayStr:String = ""
    
    func resetValues(){
        todaysDayNames.removeAll()
        habitsTodo.removeAll()
        todoToday = 0
        doneToday = 0
        totalHabits = 0
        daysUntilNext = 7
        nextDayStr = ""
    }
    
    func updateValues(habitTodo:HabitTodo){
        if habitTodo.todoToday{
            todoToday += 1
            doneToday += habitTodo.isDone ? 1 : 0
            habitsTodo.append(habitTodo)
        }
        if habitTodo.daysUntilNext < daysUntilNext{
            daysUntilNext = habitTodo.daysUntilNext
            nextDayStr = habitTodo.nextDay
        }
        todaysDayNames.append(habitTodo.title)
    }
    
    func getTodayMsg() -> String{
        if habitsTodo.isEmpty{ return "" }
        if todoToday == 0 { return "Inga aktiviteter idag" }
        else {
            if todoToday == 1{
                return "Du har en aktivitet idag"
            }
            return "Du har \(todoToday) aktiviteter idag"
            /*if todoToday == 1{
                return "Du har en aktivitet idag (\(todaysDayNames[0])"
            }
            var actv = ""
            for day in todaysDayNames{
                actv += "\(day) "
            }
            actv = actv.trimmingCharacters(in: .whitespacesAndNewlines)
            return "Du har \(todoToday) aktiviteter idag \(actv)"*/
        }
    }
    
    func getDoneMsg() -> String{
        if habitsTodo.isEmpty{ return "" }
        return todoToday == 0 ? "" : "\(doneToday)/\(todoToday)"
    }
    
    func getNextMsg() -> String{
        if habitsTodo.isEmpty{ return "" }
        switch daysUntilNext{
            case 1:
                return "Imorgon \(nextDayStr)"
            case 7:
                return "\(Date().dayName()) om en vecka"
            default:
                return "\(nextDayStr) om \(daysUntilNext) dagar"
        }
    }
    
    func getProgress() -> CGFloat{
        if todoToday == 0 { return 0.1 }
        else if doneToday > todoToday { return 0.9 }
        return Float(Float(doneToday)/Float(todoToday))
                .remapValue(min1: 0.0, max1: 1.0, min2: 0.1, max2: 0.9)
    }
}
