//
//  WeekDays.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-28.
//
import SwiftUI
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
