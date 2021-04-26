//
//  ImagePicker.swift
//  UI-168
//
//  Created by にゃんにゃん丸 on 2021/04/26.
//

import SwiftUI

struct ImagePicker:  UIViewControllerRepresentable {
    func makeCoordinator() -> Coordinator {
        
        return ImagePicker.Coordinator(parent: self)
        
    }
    
    @Binding var showPicker : Bool
    
    @Binding var imageData : Data
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        
        let view = UIImagePickerController()
        view.sourceType = .photoLibrary
        view.delegate = context.coordinator
        
        return view
        
    }
   
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    class Coordinator:NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
        
        var parent : ImagePicker
        init(parent:ImagePicker) {
            self.parent = parent
        }
        
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let imageData = (info[.originalImage] as? UIImage)? .pngData(){
                
                parent.imageData = imageData
                parent.showPicker.toggle()
                
            }
            
        }
        
        
        
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            
            parent.showPicker.toggle()
            
        }
        
        
        
    }
}
