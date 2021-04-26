//
//  Home.swift
//  UI-168
//
//  Created by にゃんにゃん丸 on 2021/04/26.
//

import SwiftUI

struct Home: View {
    @StateObject var model = DrawingViewModel()
    var body: some View {
        ZStack{
            
            NavigationView{
                
                
                VStack{
                    
                    if let _ = UIImage(data: model.imageData){
                        
                        DrawingScreen()
                            .environmentObject(model)
                            
                        
                        
                            .toolbar(content: {
                                ToolbarItem(placement: .navigationBarLeading) {
                                    
                                    Button(action: model.cancelImageEditing, label: {
                                        Image(systemName: "xmark")
                                    })
                                    
                                }
                            })
                        
                        
                        
                        
                        
                    }
                    
                    else{
                        
                        
                        Button(action: {
                            model.showPicker.toggle()
                            
                        }, label: {
                            Image(systemName: "plus")
                                .font(.title)
                                .foregroundColor(.black)
                                .frame(width: 70, height: 70)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 5, y: 5)
                               
                        })
                    }
                    
                    
                    
                }
                .navigationTitle("Image Editor")
            }
            
            if model.addNewBox{
                
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                
                
                TextField("Enter Words", text: $model.textBoxes[model.currentindex].text)
                    .font(.system(size: 35, weight: model.textBoxes[model.currentindex].isBold ? .bold : .regular))
                    .colorScheme(.dark)
                    .foregroundColor(model.textBoxes[model.currentindex].textColor)
                    .padding()
                
                HStack{
                    
                    
                    Button(action: {
                        model.textBoxes[model.currentindex].isAdded = true
                        
                        model.toolPicker.setVisible(true, forFirstResponder: model.canvas)
                        model.toolPicker.addObserver(model.canvas)
                        model.canvas.becomeFirstResponder()
                        withAnimation{
                            model.addNewBox = false
                        }
                    }, label: {
                        Text("ADD")
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .padding()
                    })
                    
                    
                    
                    Spacer()
                    
                    Button(action: model.cancelTextView, label: {
                        Text("Cancel")
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .padding()
                    })
                    
                    
                    
                }
               
                .overlay(
                
                    HStack(spacing:15){
                        
                        
                        ColorPicker("", selection: $model.textBoxes[model.currentindex].textColor)
                            .labelsHidden()
                        
                        Button(action: {
                            
                            
                            model.textBoxes[model.currentindex].isBold.toggle()
                            
                        }, label: {
                            
                            Text(model.textBoxes[model.currentindex].isBold ? "Normal" : "Bold")
                            
                        })
                        
                    }
                )
                .frame(maxHeight: .infinity,alignment: .top)
                
            }
        }
        .sheet(isPresented: $model.showPicker, content: {
            ImagePicker(showPicker: $model.showPicker, imageData: $model.imageData)
        })
        .alert(isPresented: $model.showAlert, content: {
            Alert(title: Text("message"), message: Text(model.message), dismissButton: .destructive(Text("OK")))
        })
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
