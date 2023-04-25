//
//  AppGlobal.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-17.
//
import SwiftUI

let MIN_PASSWORD_LEN = 6
let MAX_PASSWORD_LEN = 12
let MAX_TEXTFIELD_LEN = 255
var ALERT_TITLE = ""
var ALERT_MESSAGE = ""
var ALERT_IS_SUCCESSFUL = false
var ALERT_PRIVACY_TITLE = "Missing Permission"
var ALERT_PRIVACY_MESSAGE = "Please go to settings to set permission"
let USER_COLLECTION = "users"
var USER_PROFILE_PIC_PATH = "profilepic"
let APP_BACKGROUND_COLOR: Color = .black
let APP_BACKGROUND_UI_COLOR: UIColor = UIColor(APP_BACKGROUND_COLOR)
func printAny(_ msg: Any){
    print("\(msg)")
}
