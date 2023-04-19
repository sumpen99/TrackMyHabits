//
//  ThrowableResult.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-19.
//

struct ThrowableResult{
    var finishedWithoutError : Bool = true
    var value : Any?
    
    func asString() -> String {
        return value as? String ?? "Unexpected Error"
    }
}
