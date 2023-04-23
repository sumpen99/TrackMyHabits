//
//  ImagePicker.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-23.
//
import SwiftUI
struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode)
    var presentationMode
    @Binding var image: Image?
    var sourceType: UIImagePickerController.SourceType
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(presentationMode: presentationMode, image: $image)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<ImagePicker>) {

    }

    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

        @Binding var presentationMode: PresentationMode
        @Binding var image: Image?

        init(presentationMode: Binding<PresentationMode>, image: Binding<Image?>) {
            _presentationMode = presentationMode
            _image = image
        }
        
        deinit{
            printAny("deinit coordinator")
        }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
                printAny("we have not image")
                presentationMode.dismiss()
                return
            }
            printAny("we have image")
            image = Image(uiImage: uiImage)
            presentationMode.dismiss()

        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            printAny("dismiss")
            presentationMode.dismiss()
        }

    }

}
