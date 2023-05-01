//
//  AppGlobal.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-17.
//
import SwiftUI

let PROGRESS_CIRCLE_SIZE = 80.0
let HABIT_CARDVIEW_HEIGHT = 100.0
let MIN_PASSWORD_LEN = 6
let MAX_PASSWORD_LEN = 12
let MAX_TEXTFIELD_LEN = 255
var ALERT_TITLE_SAVE_HABIT = ""
var ALERT_TITLE = ""
var ALERT_MESSAGE = ""
var DID_SAVE_NEW_HABIT = false
var ALERT_IS_SUCCESSFUL = false
var ALERT_PRIVACY_TITLE = "Missing Permission"
var ALERT_PRIVACY_MESSAGE = "Please go to settings to set permission"
let USER_COLLECTION = "users"
let USER_HABIT_COLLECTION = "habits"
let HABIT_STREAK_COLLECTION = "streaks"
var USER_PROFILE_PIC_PATH = "profilepic"
let APP_BACKGROUND_COLOR: Color = .black
let APP_BACKGROUND_UI_COLOR: UIColor = UIColor(APP_BACKGROUND_COLOR)

let FOOT_TITLE = "Ändra din hjärnas vanemönster genom att börja med ett nytt beteende, hellre än att försöka sluta med en dålig vana. Det är i allmänhet lättare att lägga till en god vana"
let FOOT_MOTIVATION = "Skriv ner en enkel och tydlig mening om varför det är viktigt för dig att skapa en ny vana. Se till att läsa formuleringen varje dag så att du påminns om din inre motivation"
let FOOT_GOALS = "Bestäm ett konkret och mätbart mål för att öka fokus på ditt ändrade beteende. Dokumentera såväl måluppfyllelse som motgångar och fira när du når delmål"
let FOOT_FREQ = "Upprepa det ändrade beteendet varje dag för att effektivt etablera en ny vana. Det är betydligt svårare att skapa en vana som bara ska upprepas någon gång per vecka."

func printAny(_ msg: Any){
    print("\(msg)")
}

func openPrivacySettings(){
    guard let url = URL(string: UIApplication.openSettingsURLString),
            UIApplication.shared.canOpenURL(url) else {
                assertionFailure("Not able to open App privacy settings")
                return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
}


