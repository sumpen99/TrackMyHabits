//
//  AddHabitView.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-26.
//

import SwiftUI

struct AddHabitView: View{
    @EnvironmentObject var notificationPermissionHandler: NotificationPermissionHandler
    @State var habitTitle:String = ""
    @State var habitMotivation:String = ""
    @State var habitGoal:String = ""
    @State var habitWeekDays:[Bool] = Array(repeating: false, count: 7)
    @State private var isPrivacyResult = false
    
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
                                     text: $habitTitle)
                    SectionTextField(headerText: Text("Motivation"),
                                     footerText: FOOT_MOTIVATION,
                                     text: $habitMotivation)
                    SectionTextField(headerText: Text("Målbild"),
                                     footerText: FOOT_GOALS,
                                     text: $habitMotivation)
                    Section(header:Text("Frekvens")){
                        NavigationLink { PickWeekDays(weekdays: $habitWeekDays) } label: {
                            Text("Välj dagar då vanan skall upprepas")
                                .foregroundColor(.blue)
                        }
                    }
                    Section(header:Text("Notifikationer")){
                        NavigationLink { PickNotificationTime(isPrivacyResult: $isPrivacyResult)} label:{
                            Text("Ställ in tid och få en notifikation")
                                .foregroundColor(.blue)
                        }
                    }
                    
                    Button(action: {}) {
                        Text("Spara")
                    }.frame(maxWidth: .infinity, alignment: .center)
                }
                .alert(isPresented: $isPrivacyResult, content: {
                    onPrivacyAlert{
                        openPrivacySettings()
                    }
                })
               .modifier(NavigationViewModifier(title: ""))
            }
            
        }
    }
}

struct PickNotificationTime:View{
    @EnvironmentObject var notificationPermissionHandler: NotificationPermissionHandler
    @Binding var isPrivacyResult:Bool
    var body: some View{
        NavigationStack {
            ZStack {
                List{
                    
                }
            }
            .modifier(NavigationViewModifier(title: ""))
        }
        .onAppear(){
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
        }
    }
}

struct PickWeekDays:View{
    @Binding var weekdays:[Bool]
    let weekdaysSymbols = Calendar.current.weekdaySymbols
    var body: some View{
        VStack{
            List{
                ForEach(Array(weekdaysSymbols.enumerated()),id:\.element){index,element in
                    WeekdayCheckBox(title: element,isOn: $weekdays[index])
                }
            }
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

