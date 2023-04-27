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
                                     text: $habitGoal)
                    Section(header:Text("Frekvens")){
                        NavigationLink { PickWeekDays(weekdays: $habitWeekDays) } label: {
                            Text("Välj dagar då vanan skall upprepas")
                                .foregroundColor(.blue)
                        }
                    }
                    Section(header:Text("Notifikationer")){
                        NavigationLink { PickNotificationTime()} label:{
                            Text("Ställ in tid och få en notifikation")
                                .foregroundColor(.blue)
                        }
                    }
                    Section(header:Text("Granska")){
                        NavigationLink { ReviewNewHabit()} label:{
                            Text("Granska din nya vana")
                                .foregroundColor(.blue)
                        }
                    }
                    
                    Button(action: {}) {
                        Text("Lägg till")
                    }.frame(maxWidth: .infinity, alignment: .center)
                }
               .modifier(NavigationViewModifier(title: ""))
            }
            
        }
    }
}

struct ReviewNewHabit:View{
    var body: some View{
        NavigationStack {
            Form {
                Section(header: Text("Title")){
                    Text("TITEL").foregroundColor(.gray)
                }
                Section(header: Text("Motivation")){
                    Text("Motivation").foregroundColor(.gray).lineLimit(nil)
                }
                Section(header: Text("MÅLBILD")){
                    Text("MÅLBILD").foregroundColor(.gray).lineLimit(nil)
                }
                Section(header: Text("FREKVENS")){
                    Text("MÅNDAG").foregroundColor(.gray)
                    Text("TISDAG").foregroundColor(.gray)
                    Text("ONSDAG").foregroundColor(.gray)
                    Text("TORSDAG").foregroundColor(.gray)
                    Text("FREDAG").foregroundColor(.gray)
                    Text("LÖRDAG").foregroundColor(.gray)
                    Text("SÖNDAG").foregroundColor(.gray)
                }
                Section(header: Text("Notifikationer")){
                    Text("10:45").foregroundColor(.gray)
                    Text("MÅNDAG").foregroundColor(.gray)
                    Text("TISDAG").foregroundColor(.gray)
                    Text("ONSDAG").foregroundColor(.gray)
                    Text("TORSDAG").foregroundColor(.gray)
                    Text("FREDAG").foregroundColor(.gray)
                    Text("LÖRDAG").foregroundColor(.gray)
                    Text("SÖNDAG").foregroundColor(.gray)
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
    @State var habitWeekDays:[Bool] = Array(repeating: false, count: 7)
    @State var data: [(String, [String])] = [
            ("Hour", Array(0...23).map {$0 < 10 ?  "0\($0)" : "\($0)" }),
            ("Minutes", Array(0...59).map {$0 < 10 ?  "0\($0)" : "\($0)" })
        ]
    @State var selection: [String] = [Date().hourMinuteSeconds().hour,
                                      Date().hourMinuteSeconds().minutes].map { $0 < 10 ?  "0\($0)" : "\($0)"  }
    var body: some View{
        NavigationStack {
            ZStack {
                List{
                    Button(action: {isSaved.toggle()}) {
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
        .alert("Notifikation sparad\n\(selection[0]) : \(selection[1])", isPresented: $isSaved) {
                    Button("OK", role: .cancel) { closeView() }
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
    
    func closeView(){
        dismiss()
    }
}

struct PickWeekDays:View{
    @Binding var weekdays:[Bool]
    let weekdaysSymbols = Calendar.current.weekdaySymbols
    var body: some View{
        NavigationStack {
            ZStack {
                VStack{
                    List{
                        ForEach(Array(weekdaysSymbols.enumerated()),id:\.element){index,element in
                            WeekdayCheckBox(title: element,isOn: $weekdays[index])
                        }
                    }
                }
            }
            .modifier(NavigationViewModifier(title: ""))
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
                    ForEach(0..<self.data.count, id: \.self) { column in
                        Picker(self.data[column].0, selection: self.$selection[column]) {
                            ForEach(0..<self.data[column].1.count,id: \.self) { row in
                                Text(verbatim: self.data[column].1[row])
                                .tag(self.data[column].1[row])
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

