//
//  DrawingScreen.swift
//  UI-168
//
//  Created by にゃんにゃん丸 on 2021/04/26.
//

import SwiftUI
import PencilKit

struct DrawingScreen: View {
    @EnvironmentObject var model : DrawingViewModel
    var body: some View {
        ZStack{
            
            GeometryReader{proxy -> AnyView in
                
                let size = proxy.frame(in:.global)
                
                DispatchQueue.main.async {
                    if model.rect == .zero{
                        
                        model.rect = size
                    }
                }
                
                
                return AnyView(
                    
                    
                    ZStack{
                        
                        canvasView(canvas:$model.canvas, imagedata: $model.imageData, toolPicker: $model.toolPicker, rect: size.size)
                        
                        ForEach(model.textBoxes){box in
                            
                            
                            Text(model.textBoxes[model.currentindex].id == box.id && model.addNewBox ? "" : box.text)
                                .font(.system(size: box.size))
                                .fontWeight(box.isBold ? .bold : .none)
                                .foregroundColor(box.textColor)
                                .offset(box.offset)
                                .gesture(DragGesture().onChanged({ (value) in
                                    
                                    let current = value.translation
                                    
                                    let lastoffset = box.lastOffset
                                    
                                    let newTranslation = CGSize(width: lastoffset.width + current.width, height: lastoffset.height + current.height)
                                    
                                    model.textBoxes[getIndex(Textbox: box)].offset = newTranslation
                                    
                                    
                                }).onEnded({ (value) in
                                    
                                    model.textBoxes[getIndex(Textbox: box)].lastOffset = value.translation
                                }))
                                .onLongPressGesture {
                                    
                                    model.toolPicker.setVisible(false, forFirstResponder: model.canvas)
                                    model.canvas.resignFirstResponder()
                                    
                                    model.currentindex = getIndex(Textbox:box)
                                    
                                    withAnimation{
                                        model.addNewBox = true
                                        
                                    }
                                }
                            
                        }
                    }
                )
                
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                
                Button(action: model.SaveImage, label: {
                    Text("SAVE")
                })
                
                
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                
                Button(action: {
                    
                    model.toolPicker.setVisible(false, forFirstResponder: model.canvas)
                    model.canvas.resignFirstResponder()
                    
                    model.textBoxes.append(TextBox())
                    model.currentindex = model.textBoxes.count - 1
                    
                    
                    withAnimation{
                        
                        
                        model.addNewBox.toggle()
                    }
                    
                }, label: {
                    Image(systemName: "plus")
                })
                
                
            }
        })
    }
    
    func getIndex(Textbox : TextBox)->Int{
        
        
        let index = model.textBoxes.firstIndex { (box) -> Bool in
            Textbox.id == box.id
        } ?? 0
        
        return index
        
    }
}

struct DrawingScreen_Previews: PreviewProvider {
    static var previews: some View {
       Home()
    }
}

struct canvasView : UIViewRepresentable {
    
    @Binding var canvas : PKCanvasView
    @Binding var imagedata : Data
    @Binding var toolPicker : PKToolPicker
    var rect : CGSize
    func makeUIView(context: Context) -> PKCanvasView {
        canvas.isOpaque = false
        canvas.backgroundColor = .clear
        canvas.drawingPolicy = .anyInput
        
       
        
        
        if let imageData = UIImage(data: imagedata){
            
            let imageView = UIImageView(image: imageData)
            imageView.contentMode = .scaleAspectFit
            imageView.frame = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)
            imageView.clipsToBounds = true
            
            let subView = canvas.subviews[0]
            subView.addSubview(imageView)
            subView.sendSubviewToBack(imageView)
            
            toolPicker.setVisible(true, forFirstResponder: canvas)
            toolPicker.addObserver(canvas)
            canvas.becomeFirstResponder()
            
            
        }
        
     
        return canvas
        
        
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        
    }
}
