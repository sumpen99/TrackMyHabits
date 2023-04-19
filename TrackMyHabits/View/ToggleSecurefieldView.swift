//
//  ToggleSecurefieldView.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-17.
//

import SwiftUI

struct ToggleSecurefieldView : View {
    var label:String = "Password"
    @Binding var text : String
    @State var isEditing = false
    @State var showPassword = false
    
    func trimTextIfNeeded(newValue:String){
        self.text = newValue.prefix(MAX_PASSWORD_LEN)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var body : some View {
        let showPasswordBinding = Binding<String> {
            self.text
        } set: {
            trimTextIfNeeded(newValue: $0)
        }
        let hidePasswordBinding = Binding<String> {
            String.init(repeating: "●", count: self.text.count)
        } set: { newValue in
            if(newValue.count < self.text.count) {
                self.text = self.text.substring(to: newValue.count)
            } else {
                self.text.append(contentsOf: newValue.suffix(newValue.count - self.text.count) )
                trimTextIfNeeded(newValue:self.text)
            }
        }

        return ZStack(alignment: .trailing) {
            HStack{
                TextField(
                    label,
                    text: showPassword ? showPasswordBinding : hidePasswordBinding,
                    onEditingChanged: { editingChanged in
                        isEditing = editingChanged
                    }
                )
                .textContentType(.password)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                Image(systemName: showPassword ? "eye" : "eye.slash").onTapGesture {
                    showPassword.toggle()
                }
                .foregroundColor(.red)
            }
            .padding()
        }
        
    }
}
