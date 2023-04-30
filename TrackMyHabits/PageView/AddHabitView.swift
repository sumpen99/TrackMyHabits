//
//  AddHabitView.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-26.
//

import SwiftUI

struct AddHabitView: View{
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var firestoreViewModel: FirestoreViewModel
    @EnvironmentObject var notificationHandler: NotificationHandler
    @State var habit:Habit = Habit()
    @State var weekDays:WeekDays = WeekDays()
    @State var notificationWeekDays:WeekDays = WeekDays()
    @State var isTryToSave:Bool = false
    
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                Form {
                    SectionTextField(headerText:
                                        Text("\(Image(systemName: "staroflife.fill")) Titel"),
                                     footerText: FOOT_TITLE,
                                     text: $habit.title)
                    SectionTextField(headerText: Text("Motivation"),
                                     footerText: FOOT_MOTIVATION,
                                     text: $habit.motivation)
                    SectionTextField(headerText: Text("Målbild"),
                                     footerText: FOOT_GOALS,
                                     text: $habit.goal)
                    Section(header:Text("Frekvens")){
                        NavigationLink { PickWeekDays(weekdays: $weekDays) } label: {
                            Text("Välj dagar då vanan skall upprepas")
                                .foregroundColor(.blue)
                        }
                    }
                    Section(header:Text("Notifikationer")){
                        NavigationLink { PickNotificationTime(
                            selectedTime: $habit.notificationTime,
                            habitWeekDays: $notificationWeekDays)} label:{
                                Text("Ställ in tid och få en notifikation")
                                    .foregroundColor(.blue)
                            }
                    }
                    Section(header:Text("Granska")){
                        NavigationLink { ReviewNewHabit(
                            habit:habit,
                            weekDaysFrequence: weekDays,
                            notificationWeekDays: notificationWeekDays)} label:{
                                Text("Granska din nya vana")
                                    .foregroundColor(.blue)
                            }
                    }
                    
                    Button(action: { evaluateAndTryToSave() }) {
                        Text("Lägg till")
                    }.frame(maxWidth: .infinity, alignment: .center)
                }
                .onAppear(){
                    notificationHandler.getScheduleNotifications()
                }
                .alert(ALERT_TITLE_SAVE_HABIT, isPresented: $isTryToSave) { Button("OK", role: .cancel) {
                    if DID_SAVE_NEW_HABIT{ dismiss()}
                }}
               .modifier(NavigationViewModifier(title: "Lägg till en vana"))
            }
        }
    }
        
    func evaluateAndTryToSave(){
        if habit.title.isEmpty || weekDays.selectedDays.isEmpty{
            fireMissingInformation()
        }
        else{
            firestoreViewModel.doesHabitAlreadyExist(title: habit.title){ itDoes in
                if itDoes{
                    fireAlreadyExist()
                }
                else{
                    updateHabitWithWeekdays()
                    setNotificationIfNeeded()
                    firestoreViewModel.uploadOrSetHabit(habit: habit){ result in
                        if result.finishedWithoutError{
                            fireUploadSuccess()
                        }
                        else {
                            fireUploadNoSuccess(error: result.asString())
                        }
                    }
                }
            }
        }
    }
    
    func setNotificationIfNeeded(){
        if habit.notificationTime.isSet{
            guard let hour = habit.notificationTime.hour,
                  let minutes = habit.notificationTime.minutes,
                  let days = habit.weekDaysNotification else{ return }
            
            for day in days{
                let date = notificationHandler.createNotificationDate(
                    weekday: day.value, hour: hour, minutes: minutes)
                guard let date = date else{
                    continue
                }
                notificationHandler.scheduleNotification(date: date, habit: habit)
            }
            
        }
    }
    
    func fireUploadSuccess(){
        DID_SAVE_NEW_HABIT = true
        ALERT_TITLE_SAVE_HABIT = "Ny vana tillagd"
        isTryToSave.toggle()
    }
    
    func fireUploadNoSuccess(error:String){
        DID_SAVE_NEW_HABIT = false
        ALERT_TITLE_SAVE_HABIT = error
        isTryToSave.toggle()
    }
    
    func fireMissingInformation(){
        var msg:String = ""
        if habit.title.isEmpty && weekDays.selectedDays.isEmpty{
            msg = "Saknar Titel och Frekvens (Mån-Sön)"
        }
        else if habit.title.isEmpty{
            msg = "Saknar Titel"
        }
        else {
            msg = "Saknar Frekvens (Mån-Sön)"
        }
        DID_SAVE_NEW_HABIT = false
        ALERT_TITLE_SAVE_HABIT = msg
        isTryToSave.toggle()
    }
    
    func fireAlreadyExist(){
        DID_SAVE_NEW_HABIT = false
        ALERT_TITLE_SAVE_HABIT = "Det finns redan en vana med liknande titel"
        isTryToSave.toggle()
    }
    
    func updateHabitWithWeekdays(){
        habit.weekDaysFrequence = weekDays.selectedDays
        habit.weekDaysNotification = notificationWeekDays.selectedDays
    }
    
}

struct ReviewNewHabit:View{
    let habit:Habit
    var weekDaysFrequence:WeekDays
    let notificationWeekDays:WeekDays
    
    var body: some View{
        NavigationStack {
            Form {
                Section(header: Text("Title")){
                    if habit.title.isEmpty{
                        Text("Saknar titel").foregroundColor(.gray)
                    }
                    else{
                        Text(habit.title).foregroundColor(.gray).lineLimit(nil)
                    }
                }
                Section(header: Text("Motivation")){
                    Text(habit.motivation).foregroundColor(.gray).lineLimit(nil)
                }
                Section(header: Text("MÅLBILD")){
                    Text(habit.goal).foregroundColor(.gray).lineLimit(nil)
                }
                Section(header: Text("FREKVENS")){
                    if weekDaysFrequence.selectedDays.isEmpty{
                        Text("Saknar valda dagar").foregroundColor(.gray)
                    }
                    else{
                        ForEach(weekDaysFrequence.selectedDays,id: \.id){ weekday in
                            Text(weekday.name.uppercased()).foregroundColor(.gray)
                        }
                    }
                }
                Section(header: Text("Notifikationer")){
                    if !habit.notificationTime.isSet{
                        Text("Inga notifikationer").foregroundColor(.gray)
                    }
                    else{
                        Text("\(habit.notificationTime.hour.zeroString())" + ":" +             "\(habit.notificationTime.minutes.zeroString())").foregroundColor(.gray)
                        ForEach(notificationWeekDays.selectedDays,id: \.id){ weekday in
                            Text(weekday.name.uppercased()).foregroundColor(.gray)
                        }
                    }
                }
            }
            .modifier(NavigationViewModifier(title: "Sammanställning"))
        }
    }
}

struct PickNotificationTime:View{
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var notificationHandler: NotificationHandler
    @State var isPrivacyResult:Bool = false
    @State var isSaved:Bool = false
    @State var isNotSaved:Bool = false
    @State var data: [(String, [String])] = [
        ("Hour", Array(0...23).map {$0.zeroString()}),
        ("Minutes", Array(0...59).map {$0.zeroString()})]
    @State var selection: [String] = [Date().hourMinuteSeconds().hour,
                                      Date().hourMinuteSeconds().minutes].map { $0.zeroString()  }
    
    @Binding var selectedTime: NotificationTime
    @Binding var habitWeekDays:WeekDays
    
    var body: some View{
        NavigationStack {
            ZStack {
                List{
                    MultiPicker(data: data, selection: $selection).frame(height: 300)
                    NavigationLink { PickWeekDays(weekdays: $habitWeekDays) } label: {
                        Text("Upprepa")
                            .foregroundColor(.blue)
                    }
                }
            }
            .modifier(NavigationViewModifier(title: "Ställ in tid"))
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button("Spara") {
                        validateInfo()
                    }
                }
            }
            
        }
        .alert(isPresented: $isPrivacyResult, content: {
            onPrivacyAlert(
                actionPrimary: openPrivacySettings,
                actionSecondary: closeView)
        })
        .alert("Notifikation\n\(selection[0]) : \(selection[1])\nAktiveras när vana lägs till", isPresented: $isSaved) {
                    Button("OK", role: .cancel) { closeView() }
                }
        .alert("Saknar valda dagar", isPresented: $isNotSaved) {
                    Button("OK", role: .cancel) { }
        }
        .onAppear(){
            notificationHandler.checkPermission(){ settings in
                switch settings.authorizationStatus {
                    case .notDetermined:
                        notificationHandler.requestPermission(){ (granted, error) in
                            //printAny("\(granted) \(error)")
                        }
                    case .denied:
                        isPrivacyResult.toggle()
                        printAny("denied restricted")
                    case .authorized:
                        printAny("authorized")
                    case .provisional:
                        printAny("provisional")
                    case .ephemeral:
                        printAny("ephemeral")
                    @unknown default:
                         fatalError("UNUserNotificationCenter::execute - \"Unknown case\"")
                }
            }
        }
    }
    
    func validateInfo(){
        if habitWeekDays.selectedDays.isEmpty{
            removeSavedTime()
            isNotSaved.toggle()
        }
        else{
            storeSavedTime()
            isSaved.toggle()
        }
    }
    
    func removeSavedTime(){
        selectedTime.isSet = false
        selectedTime.hour = nil
        selectedTime.minutes = nil
    }
    
    func storeSavedTime(){
        selectedTime.isSet = true
        selectedTime.hour = Int(selection[0])
        selectedTime.minutes = Int(selection[1])
    }
    
    func closeView(){
        dismiss()
    }
}

struct PickWeekDays:View{
    @Binding var weekdays:WeekDays
    let weekdaysSymbols = Calendar.current.weekdaySymbols
    @State var selectAll:Bool = false
    var body: some View{
        NavigationStack {
            ZStack {
                VStack{
                    List{
                        ForEach(Array(weekdaysSymbols.enumerated()),id:\.element){index,element in
                            WeekdayCheckBox(title: element,isOn: $weekdays.days[index])
                        }
                        Button(action: {
                            toogleAllDays() }){
                                Text(selectAll ? "Rensa" : "Markera alla dagar")
                        }
                    }
                }
            }
            .modifier(NavigationViewModifier(title:"Välj dagar"))
            /*.toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button("Spara") {
                        storeWeekdays()
                    }
                }
            }*/
            .onDisappear(){
                storeWeekdays()
            }
        }
    }
    
    func storeWeekdays(){
        weekdays.storeSelectedDays()
    }
    
    func toogleAllDays(){
        selectAll.toggle()
        weekdays.days.modifyForEach{
            $1 = selectAll
        }
    }
    
   
}

struct SectionTextField:View{
    
    let headerText:Text
    let footerText:String
    @Binding var text:String
    
    var body:some View{
        Section(header: headerText,footer:Text(footerText)) {
            TextField("",text: $text.max(MAX_TEXTFIELD_LEN))
                .removePredictiveSuggestions()
                .textContentType(.name)
        }
    }
}

struct WeekdayCheckBox:View{
    let title:String
    @Binding var isOn:Bool
    
    var body: some View{
        Toggle(isOn: $isOn) {
            Text("Varje " + title)
            .foregroundColor(.gray)
        }
        .toggleStyle(CheckboxStyle())
    }
}

struct CheckboxStyle: ToggleStyle {

    func makeBody(configuration: Self.Configuration) -> some View {

        return HStack() {
            Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                .resizable()
                .frame(width: 24, height: 24,alignment: .leading)
                .foregroundColor(configuration.isOn ? .green : .gray)
                .font(.system(size: 20, weight: .regular, design: .default))
                configuration.label
        }
        .onTapGesture { configuration.isOn.toggle() }

    }
}

struct MultiPicker: View  {

    typealias Label = String
    typealias Entry = String

    let data: [ (Label, [Entry]) ]
    @Binding var selection: [Entry]

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 5)
                                .frame(height: 32)
                                .foregroundColor(.primary)
                                .opacity(0.5)
                HStack{
                    ForEach(0..<self.data.count, id: \.self) { picker in
                        Picker(self.data[picker].0, selection: self.$selection[picker]) {
                            ForEach(0..<self.data[picker].1.count,id: \.self) { value in
                                Text(verbatim: self.data[picker].1[value])
                                .tag(self.data[picker].1[value])
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: geometry.size.width / CGFloat(self.data.count), height: geometry.size.height)
                        .clipped()
                    }
                }
            }
        }
    }
}

