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
    var daysUntilNext:Int = 100
    var nextDayStr:String = ""
    @Published var toggle:Bool = false
    
    func resetValues(){
        todaysDayNames.removeAll()
        habitsTodo.removeAll()
        todoToday = 0
        doneToday = 0
        totalHabits = 0
        daysUntilNext = 100
        nextDayStr = ""
        toggle.toggle()
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
        if todoToday == 0 { return "Inga aktiviteter idag" }
        else {
            if todoToday == 1{
                return "Du har en aktivitet idag"
            }
            return "Du har \(todoToday) aktiviteter idag"
        }
    }
    
    func getDoneMsg() -> String{
        return todoToday == 0 ? "" : "\(doneToday)/\(todoToday)"
    }
    
    func getTodayColor() ->Color{
        return todoToday == 0 ? Color.gray : Color.indigo
    }
    
    func getDoneColor() ->Color{
        return doneToday ==  todoToday ? Color.green : Color.red
    }
    
    func getNextMsg() -> String{
        switch daysUntilNext{
            case 1:
                return "Imorgon \(nextDayStr)"
            case 7:
                return "\(Date().dayName()) om en vecka"
            case 100:
                return "Inga planlagda"
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
