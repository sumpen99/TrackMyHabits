//
//  ProfileView.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-19.
//

import SwiftUI
import Photos
//https://www.hackingwithswift.com/forums/swiftui/background-color-of-a-list-make-it-clear-color/3379
struct ProfileView: View{
    @EnvironmentObject var firebaseHandler: FirebaseHandler
    @State var isShowPicker: Bool = false
    @State var image: Image? = Image(systemName:"photo.fill")
    @State private var isPrivacyResult = false
    var body: some View {
        NavigationStack {
            Form {
                UserImage(profilePicture:$image,
                    isShowPicker:$isShowPicker,
                          isPrivacyResult: $isPrivacyResult)
                Section(header: Text("Your Info 1")) {
                    TextFieldsToTest()
                }
                Section(header: Text("Your Info 1")) {
                    TextFieldsToBeRemoved()
                }
                Section(header: Text("Your Info 2")) {
                    TextFieldsToBeRemoved()
                }
                Section(header: Text("Your Info 3")) {
                    TextFieldsToBeRemoved()
                }
                Section(header: Text("Your Info 1")) {
                    NavigationLink(destination: Text("aaa")) {
                    MenuInformationDetailView(title: "Changing behaviour", subTitle: "How to use the behavioural experiments feature", imageName: "questionmark.circle.fill")
                        //.background( NavigationLink("", destination: Text("The detail view")) )
                        
                    }
                }
                ZStack {
                  //Create a NavigationLink without the disclosure indicator
                  NavigationLink(destination: Text("Hello, World!")) {
                    EmptyView()
                  }

                  //Replicate the default cell
                  HStack {
                    Text("Custom UI")
                    Spacer()
                    Image(systemName: "chevron.right")
                      .resizable()
                      .aspectRatio(contentMode: .fit)
                      .frame(width: 7)
                      .foregroundColor(.red) //Apply color for arrow only
                  }
                  .foregroundColor(.purple) //Optional: Apply color on all inner elements
                }
                
                Button("Logga ut") {
                    firebaseHandler.signOut()
                }
            }
            .sheet(isPresented: $isShowPicker) {
                ImagePicker(image: self.$image,sourceType: .photoLibrary)
            }
            .alert(isPresented: $isPrivacyResult, content: {
                onPrivacyAlert{
                    openPrivacySettings()
                }
            })
            .modifier(NavigationViewModifier(title: "Fredrik Sundström"))
        }
    }
    
    func openPrivacySettings(){
        guard let url = URL(string: UIApplication.openSettingsURLString),
                UIApplication.shared.canOpenURL(url) else {
                    assertionFailure("Not able to open App privacy settings")
                    return
            }

            UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
     
}

class PhotoGalleryManager : ObservableObject {
    @Published var authorizationStatus:PHAuthorizationStatus = .notDetermined
    
    func checkPermission(){
        authorizationStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
    }
    
    func requestPermission() {
        PHPhotoLibrary.requestAuthorization({ [weak self] status in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.authorizationStatus = status
            }
        })
    }
}


struct UserImage: View{
    @Binding var profilePicture:Image?
    @Binding var isShowPicker:Bool
    @Binding var isPrivacyResult:Bool
    @StateObject var photoGalleryManager = PhotoGalleryManager()
    
    var body: some View{
        HStack(alignment: .center){
            Spacer()
            profilePicture?
                .resizable()
                .frame(width: 150, height: 150)
                .clipShape(Circle())
                .foregroundColor(.darkCardBackground)
                .onTapGesture {
                    photoGalleryManager.checkPermission()
                    switch photoGalleryManager.authorizationStatus {
                      case .notDetermined:
                            photoGalleryManager.requestPermission()
                      case .denied, .restricted:
                            activateAccessDeniedAlert()
                            isPrivacyResult.toggle()
                      case .authorized:
                            isShowPicker.toggle()
                     case .limited:
                            activateNotImplementedAlert()
                            isPrivacyResult.toggle()
                      @unknown default:
                         fatalError("PHPhotoLibrary::execute - \"Unknown case\"")
                    }
                }
            Spacer()
        }
        .onAppear(perform: activateNotImplementedAlert)
        .listRowBackground(Color.clear)
        
    }
    
    func activateNotImplementedAlert(){
        ALERT_PRIVACY_TITLE = "Sorry"
        ALERT_PRIVACY_MESSAGE = "We have not impelemented choose pictures yet. If you still want to choose images, please go to settings to set permission"
    }
    
    func activateAccessDeniedAlert(){
        ALERT_PRIVACY_TITLE = "Missing Permission"
        ALERT_PRIVACY_MESSAGE = "Please go to settings to set permission"
    }
}

struct TextFieldsToBeRemoved: View{
    var body: some View{
        Text("$user.name")
            .removePredictiveSuggestions()
            .textContentType(.name)
        Text("$user.email")
            .removePredictiveSuggestions()
            .textContentType(.emailAddress)
        
    }
}

struct TextFieldsToTest: View{
    var body: some View{
        Text("Onsdag 19 April")
            .removePredictiveSuggestions()
            .textContentType(.name)
        Text("Översikt")
            .removePredictiveSuggestions()
            .textContentType(.emailAddress)
        
    }
}

struct MenuInformationDetailView: View {
    var title: String = "title"
    var subTitle: String = "subTitle"
    var imageName: String = "exclamationmark.circle.fill"
    
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: imageName)
                .font(.largeTitle)
                .foregroundColor(.blue)
                .padding()
                .accessibility(hidden: true)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.blue)
                    .accessibility(addTraits: .isHeader)
                
                Text(subTitle)
                    .font(.body)
                    .foregroundColor(.blue)
                    .opacity(0.8)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        
    }
    
}
