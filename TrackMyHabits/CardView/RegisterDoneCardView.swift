//
//  RegisterDoneCardView.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-05-01.
//

import SwiftUI

struct RegisterDoneCardView: View {
    @EnvironmentObject var firestoreViewModel: FirestoreViewModel
    let docId:String?
    let title:String
    let nextDate:Date?
    let streak:HabitStreak
    let subtitleNotDone: String = "Vill du lägga till en kommentar från dagen?"
    let subtitleDone: String = "Bra jobbat"
    @State var habitIsDone:Bool = false
    @State var isTextFieldShowing:Bool = false
    @State var userComment:String = ""
    @State var userRating:Int = 0
    @Binding var showSuccesAlert:Bool
    var body: some View {
        ZStack(alignment: .center){
            Color.lightBackground
            HStack(alignment: .center) {
                Image(systemName: habitIsDone ? "checkmark" : "questionmark")
                    .font(.largeTitle)
                    .foregroundColor(Color.cardColor)
                    .padding()
                    .accessibility(hidden: true)
                    .frame(alignment:.leading)
                VStack(alignment: .leading,spacing: 10) {
                    Text(title)
                        .lineLimit(1)
                        .foregroundColor(Color.cardColor)
                        .frame(alignment: .leading)
                    Text(habitIsDone ? subtitleDone : subtitleNotDone)
                        .font(.caption)
                        .foregroundColor(Color.cardColor)
                        .opacity(0.8)
                        .lineLimit(1)
                    if habitIsDone{
                        HStack{ Spacer() }.padding(.leading)
                    }
                    else{
                        HStack{
                            Toggle("Ja", isOn: $isTextFieldShowing.animation())
                                .foregroundColor(Color.cardColor)
                                .toggleStyle(ButtonToogle())
                                .frame(alignment: .leading)
                            Button("Nej, skicka in utan") {
                                updateHabitIsDone()
                            }
                            .foregroundColor(Color.cardColor)
                            .buttonStyle(.bordered)
                            .disabled(isTextFieldShowing)
                            .opacity(isTextFieldShowing ? 0.0 : 1.0)
                        }
                        if isTextFieldShowing {
                            Divider()
                            VStack(alignment: .leading,spacing: 10.0){
                                TextField("Skriv en kort kommentar", text: $userComment.max(MAX_TEXTFIELD_LEN))
                                    .padding(10)
                                    .background(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                RatingView(rating:$userRating)
                                HStack{
                                    Spacer()
                                    Button("Skicka in") {
                                        updateHabitIsDone()
                                    }
                                    .foregroundColor(Color.cardColor)
                                    .buttonStyle(.bordered)
                                }.padding([.trailing])
                            }
                            .padding([.top,.bottom])
                        }
                    }
                }
                .padding([.trailing],30.0)
            }
        }
        .modifier(CardModifier(size: getSize() ))
        .padding()
    }
    
    func getSize()->CGFloat{
        if habitIsDone { return 120.0}
        return isTextFieldShowing ? 270.0 : 120.0
    }
    
    func updateHabitIsDone(){
        guard let docId = docId,let nextDate = nextDate else { return }
        updateStreak(docId: docId,nextDate: nextDate)
        habitIsDone = true
        showSuccesAlert.toggle()
    }
    
    func updateStreak(docId:String,nextDate:Date){
        let today = Date()
        let year = today.year()
        let monthInt = today.month()
        let monthStr = today.monthName()
        let dayInt = today.day()
        let dayStr = today.dayName()
        let habitDone = HabitDone(id: UUID().uuidString,
                                  timeOfExecution: Date().toISO8601String(),
                                  comments: userComment,
                                  rating: Float(userRating),
                                  year:year,
                                  monthInt:monthInt,
                                  monthStr:monthStr,
                                  dayInt:dayInt,
                                  dayStr:dayStr)
        if streak.isActive(){
            updateCurrentStreak(docId: docId,habitDone: habitDone,nextDate:nextDate)
        }
        else{
            storePreviousStreak(docId: docId)
            startNewStreak(docId: docId,habitDone: habitDone,nextDate:nextDate)
         }
       
    }
    
    func updateCurrentStreak(docId:String,habitDone:HabitDone,nextDate:Date){
        let newStreak = streak.toMap(
            nextDate: nextDate,
            habitDone: habitDone)
        firestoreViewModel.updateHabitStreak(docId: docId,habitStreak:newStreak){ result in
            result.printSelf()
        }
    }
    
    func storePreviousStreak(docId:String){
        firestoreViewModel.storeOldHabitStreak(docId: docId, habitStreak: streak){result in
            result.printSelf()
        }
    }
    
    func startNewStreak(docId:String,habitDone:HabitDone,nextDate:Date){
        let newStreak = HabitStreak(keepStreakGoing: nextDate).toMap(
            nextDate: nextDate,
            habitDone: habitDone)
        firestoreViewModel.updateHabitStreak(docId: docId,habitStreak:newStreak){ result in
            result.printSelf()
        }
    }
    
}

struct RatingView: View{
    @Binding var rating: Int
    var maximumRating = 5
    var offColor = Color.gray
    var onColor = Color.yellow
    
    var body: some View{
        HStack {
            ForEach(1..<maximumRating+1, id: \.self) { number in
                Image(systemName: "star.fill")
                    .foregroundColor(number > rating ? offColor : onColor)
                    .onTapGesture {
                        rating = (number == rating) ? number-1 : number
                    }
            }
        }
    }
    
}

struct CardGrayTrailing:View{
    var body:some View{
        Spacer()
        Rectangle()
             .fill(Color.gray)
             .frame(width:30)
    }
}

struct ButtonToogle: ToggleStyle {

    func makeBody(configuration: Self.Configuration) -> some View {

        return HStack() {
            Button(configuration.isOn ? "Avbryt" : "Ja") {
                configuration.isOn.toggle()
            }.buttonStyle(.bordered)
        }
    }
}
