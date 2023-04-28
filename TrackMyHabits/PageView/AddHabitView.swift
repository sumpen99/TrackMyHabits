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
    @EnvironmentObject var notificationPermissionHandler: NotificationPermissionHandler
    @State var habit:Habit = Habit()
    @State var habitWeekDays:WeekDays = WeekDays()
    @State var habitNotificationWeekDays:WeekDays = WeekDays()
    @State var isTryToSave:Bool = false
    
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                Form {
                    ItemRow("Lägg till en vana",
                            color: .white,
                            font:.system(
                                .largeTitle,design: .rounded
                            ).weight(.bold),
                            edgeInset: EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
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
                        NavigationLink { PickWeekDays(weekdays: $habitWeekDays) } label: {
                            Text("Välj dagar då vanan skall upprepas")
                                .foregroundColor(.blue)
                        }
                    }
                    Section(header:Text("Notifikationer")){
                        NavigationLink { PickNotificationTime(
                            selectedTime: $habit.notificationTime,
                            habitWeekDays: $habitNotificationWeekDays)} label:{
                                Text("Ställ in tid och få en notifikation")
                                    .foregroundColor(.blue)
                            }
                    }
                    Section(header:Text("Granska")){
                        NavigationLink { ReviewNewHabit(
                            habit:habit,
                            weekDaysFrequence: habitWeekDays,
                            notificationWeekDays: habitNotificationWeekDays)} label:{
                                Text("Granska din nya vana")
                                    .foregroundColor(.blue)
                            }
                    }
                    
                    Button(action: { evaluateAndTryToSave() }) {
                        Text("Lägg till")
                    }.frame(maxWidth: .infinity, alignment: .center)
                }
                .alert(ALERT_TITLE_SAVE_HABIT, isPresented: $isTryToSave) { Button("OK", role: .cancel) {
                    if DID_SAVE_NEW_HABIT{ dismiss()}
                }}
               .modifier(NavigationViewModifier(title: ""))
            }
        }
    }
        
    func evaluateAndTryToSave(){
        DID_SAVE_NEW_HABIT = false
        if habit.title.isEmpty || habitWeekDays.selectedDays.isEmpty{
            ALERT_TITLE_SAVE_HABIT = "Saknar information (titel,frekvens)"
            isTryToSave.toggle()
            return
            
        }
        else{
            firestoreViewModel.doesHabitAlreadyExist(habitName: habit.title.uppercased()){ itDoes in
                if itDoes{
                    ALERT_TITLE_SAVE_HABIT = "Det finns redan en vana med liknande titel"
                }
                else{
                    habit.weekDaysFrequence = habitWeekDays.selectedDays
                    habit.weekDaysNotification = habitNotificationWeekDays.selectedDays
                    ALERT_TITLE_SAVE_HABIT = "Ny vana tillagd"
                    habit.printSelf()
                }
                isTryToSave.toggle()
            }
        }
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
                        Text(habit.title).foregroundColor(.gray)
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
                        Text("\(habit.notificationTime.hour ?? 0)" + ":" + "\(habit.notificationTime.minutes ?? 0)").foregroundColor(.gray)
                        ForEach(notificationWeekDays.selectedDays,id: \.id){ weekday in
                            Text(weekday.name.uppercased()).foregroundColor(.gray)
                        }
                    }
                }
            }
            .modifier(NavigationViewModifier(title: ""))
        }
    }
}

struct PickNotificationTime:View{
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var notificationPermissionHandler: NotificationPermissionHandler
    @State var isPrivacyResult:Bool = false
    @State var isSaved:Bool = false
    @State var isNotSaved:Bool = false
    @State var data: [(String, [String])] = [
            ("Hour", Array(0...23).map {$0 < 10 ?  "0\($0)" : "\($0)" }),
            ("Minutes", Array(0...59).map {$0 < 10 ?  "0\($0)" : "\($0)" })
        ]
    @State var selection: [String] = [Date().hourMinuteSeconds().hour,
                                        Date().hourMinuteSeconds().minutes].map { $0 < 10 ?  "0\($0)" : "\($0)"  }
    
    @Binding var selectedTime: NotificationTime
    @Binding var habitWeekDays:WeekDays
    
    var body: some View{
        NavigationStack {
            ZStack {
                List{
                    Button(action: { validateInfo() }){
                        Text("Spara")
                    }
                     //Text(verbatim: "Selection: \(Int(selection[0])) \(Int(selection[1]))")
                    MultiPicker(data: data, selection: $selection).frame(height: 300)
                    NavigationLink { PickWeekDays(weekdays: $habitWeekDays) } label: {
                        Text("Upprepa")
                            .foregroundColor(.blue)
                    }
                }
            }
            .modifier(NavigationViewModifier(title: ""))
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
        /*.onAppear(){
            notificationPermissionHandler.checkPermission(){ settings in
                switch settings.authorizationStatus {
                    case .notDetermined:
                        notificationPermissionHandler.requestPermission(){ (granted, error) in
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
        }*/
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
    var body: some View{
        NavigationStack {
            ZStack {
                VStack{
                    List{
                        ForEach(Array(weekdaysSymbols.enumerated()),id:\.element){index,element in
                            WeekdayCheckBox(title: element,isOn: $weekdays.days[index])
                        }
                    }
                }
            }
            .modifier(NavigationViewModifier(title: ""))
        }
        .onDisappear{
            weekdays.storeSelectedDays()
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

