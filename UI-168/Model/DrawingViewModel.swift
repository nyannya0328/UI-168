//
//  DrawingViewModel.swift
//  UI-168
//
//  Created by にゃんにゃん丸 on 2021/04/26.
//

import SwiftUI
import PencilKit

class DrawingViewModel: ObservableObject {
    
    @Published var showPicker = false
    @Published var imageData : Data = Data(count: 0)
    
    @Published var canvas = PKCanvasView()
    
    @Published var toolPicker = PKToolPicker()
    
    @Published var textBoxes : [TextBox] = []
    
    @Published var addNewBox = false
    
    @Published var currentindex : Int = 0
    
    @Published var rect : CGRect = .zero
    
    @Published var showAlert = false
    @Published var message = ""
    
    
    func cancelImageEditing(){
        
        
        imageData = Data(count: 0)
        canvas = PKCanvasView()
        textBoxes.removeAll()
    }
    
    func cancelTextView(){
        
        toolPicker.setVisible(false, forFirstResponder: canvas)
        canvas.resignFirstResponder()
        
        withAnimation{
            
            addNewBox = false
        
        }
        
        if !textBoxes[currentindex].isAdded{
        
        textBoxes.removeLast()
        }
        
        
    }
    
    func SaveImage(){
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        
        canvas.drawHierarchy(in: CGRect(origin: .zero, size: rect.size), afterScreenUpdates: true)
        
        
        let swiftuiview = ZStack{
            
            
            ForEach(textBoxes){[self]box in
                
                
                Text(textBoxes[currentindex].id == box.id && addNewBox ? "" : box.text)
                    .font(.system(size: box.size))
                    .fontWeight(box.isBold ? .bold : .none)
                    .foregroundColor(box.textColor)
                    .offset(box.offset)
                
            }
            
            
            
        }
        
        let controller = UIHostingController(rootView: swiftuiview).view!
        
        controller.frame = rect
        controller.backgroundColor = .clear
        canvas.backgroundColor = .clear
        controller.drawHierarchy(in: CGRect(origin: .zero, size: rect.size), afterScreenUpdates: true)
        
        
        
        let geneRateImage = UIGraphicsGetImageFromCurrentImageContext()
        
         UIGraphicsEndImageContext()
        
        if let image = geneRateImage?.pngData(){
            
            
            UIImageWriteToSavedPhotosAlbum(UIImage(data: image)!, nil, nil, nil)
            
            self.message = "OK"
            
            showAlert.toggle()
            
        }
        
        
        
        
        
    }
    
    
}

