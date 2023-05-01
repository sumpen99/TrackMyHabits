//
//  HabitSettingsView.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-29.
//
import SwiftUI
struct HabitSettingsView: View{
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var notificationHandler: NotificationHandler
    @EnvironmentObject var firestoreViewModel: FirestoreViewModel
    @State var showWeekdays:Bool = false
    @State var showNotificationWeekdays:Bool = false
    @State var removeNotifications:Bool = false
    @State var removeHabit:Bool = false
    var habit: Habit
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
                    Toggle("Visa dagar", isOn: $showWeekdays.animation())
                        .foregroundColor(.gray)
                    if showWeekdays {
                        ForEach(habit.weekDaysFrequence,id: \.id){ weekday in
                            Text(weekday.name.uppercased()).foregroundColor(.gray)
                        }
                    }
                }
                Section(header: Text("Notifikationer")){
                    if !habit.notificationTime.isSet{
                        Text("Inga notifikationer").foregroundColor(.gray)
                    }
                    else{
                        Toggle("Visa notifikations inställningar", isOn: $showNotificationWeekdays.animation())
                            .foregroundColor(.gray)
                        if showNotificationWeekdays {
                            Text("\(habit.notificationTime.hour.zeroString())" + ":" +             "\(habit.notificationTime.minutes.zeroString())").foregroundColor(.gray)
                            ForEach(habit.weekDaysNotification,id: \.id){ weekday in
                                Text(weekday.name.uppercased()).foregroundColor(.gray)
                            }
                        }
                    }
                }
                if habit.notificationTime.isSet{
                    Section(header: Text("Ta bort notifikationer")){
                        Toggle("Avsluta", isOn: $removeNotifications.animation())
                            .foregroundColor(.gray)
                        if removeNotifications {
                            Button("Spara"){
                                updateHabitAndRemoveNotifications()
                            }
                        }
                    }
                }
                
                Section(header: Text("Radera vana")){
                    Toggle("Radera", isOn: $removeHabit.animation())
                        .foregroundColor(.gray)
                    if removeHabit {
                        Button("Verifiera"){
                            removeHabitFromFirebase()
                        }
                    }
                }
                
            }
            .modifier(NavigationViewModifier(title: "Inställningar"))
        }
    }
    
    func removeHabitFromFirebase(){
        clearNotifications()
        guard let docId = habit.id else { return }
        firestoreViewModel.removeHabit(docId: docId){ result in
            if result.finishedWithoutError{
                closeView()
            }
        }
    }
    
    func updateHabitAndRemoveNotifications(){
        guard let docId = habit.id else { return }
        clearNotifications()
        firestoreViewModel.updateHabitData(docId: docId,data:
                                            [["weekDaysNotification":[WeekDay]()],
                                             ["notificationTime":["isSet":false,
                                                                  "hour": 0,
                                                                  "minutes":0]],
                                             ["notificationId":""]]){ result in
            /*if result.finishedWithoutError{
                printAny(result.finishedWithoutError)
            }
            else{
                printAny(result.value)
            }*/
            
        }
    }
    
    func clearNotifications(){
        var identifiers:[String] = [String]()
        for day in habit.weekDaysFrequence{
            identifiers.append(notificationHandler.createID(notificationID: habit.notificationId,
                                                            weekDay: day.name))
        }
        notificationHandler.removeNotifications(identifiers: identifiers)
    }
    
    func closeView(){
        dismiss()
    }
}
