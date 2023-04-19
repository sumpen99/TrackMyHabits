//
//  PasswordHelper.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-17.
//

import SwiftUI

class PasswordHelper: ObservableObject {
    @Published public var didChange = false
    @Published var confirmedPassword: String = ""

    let constants = Constants.validChars
    
    var password: String = "" {
        didSet {
            self.checkForPassword(password:self.password)
        }
    }
    
        
    var level: PasswordLevel = .none {
        didSet {
            self.didChange.toggle()
        }
    }
    
    var passwordsIsAMatch : Bool { return self.level != .none && password == confirmedPassword}
    
    func checkForPassword(password:String) {
        let numOfSpecialChars = password.filter{ !self.constants.contains($0) && $0 != "●"}.count
        if password.count < MIN_PASSWORD_LEN{
            self.level = .none
        } else if numOfSpecialChars == 0 {
            self.level = .weak
        } else if numOfSpecialChars == 1 {
            self.level = .ok
        } else {
            self.level = .strong
        }
    }
    
    deinit{
        printAny("deinit passwordhelper")
    }
    
    init(){
        printAny("init passwordhelper")
    }
    
}
