//
//  InputView.swift
//  Doodle
//
//  Created by NVR4GET on 16/3/2025.
//

import SwiftUI
import PhotosUI

struct CreateDoodleView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var textFieldInputText: String = ""
    
    @State private var selectedColor: Color = .random
    
    @State private var photoPickerItem: PhotosPickerItem?
    
    @State var selectedPhoto: Image?
    
    @State private var selectedMode: DoodleMode = .text
    
    @Binding var path: [NavViews]
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            Picker("Selection", selection: $selectedMode) {
                ForEach(DoodleMode.allCases) {
                    Text($0.rawValue)
                        .tag($0)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            Spacer()
            
            
            
            if selectedMode == .photo {
                (selectedPhoto ?? Image(systemName: "person.circle") )
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .clipShape(.circle)
                                
                PhotosPicker("Select image", selection: $photoPickerItem, matching: .images)
                    .padding()
            } else {
                TextField("Enter text to add", text: $textFieldInputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: 300)
                    .shadow(color: colorScheme == .dark ? .white : .gray, radius: 2, x: 0.5, y: 0.5)
                
                
                HStack{
                    Spacer()
                    
                    Text("Pick a colour")
                        .padding()
                    
                    ColorPicker("Pick a Color", selection: $selectedColor)
                        .padding()
                        .labelsHidden()
                    
                    Spacer()
                }
            }
            
            Spacer()
            
            Button(action: addNewTextItem,
                   label: {
                Text("Add")
                    .frame(maxWidth: 100)
                    .padding()
                    .foregroundColor(.white)
                    .background(.blue)
            })
            .clipShape(.capsule)
            .shadow(color: colorScheme == .dark ? .white : .gray, radius: 2, x: 0.5, y: 0.5)
            .disabled(textFieldInputText.isEmpty)
            
        }
        .toolbar {
            ToolbarItem(placement: .principal) { // Centers & styles title
                Text(NavViews.createDoodleView.navTitle)
                    .font(.body)
                    .bold()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: photoPickerItem) {
            Task {
                if let image = try? await photoPickerItem?.loadTransferable(type: Image.self) {
                    selectedPhoto = image
                } else {
                    print("Photo failed")
                }
            }
        }
    }
    
    func addNewTextItem() {
        let newItem = DoodleItem(
            text: textFieldInputText,
            colour: selectedColor,
            location: CGPoint(x: .randomWidth + 30, y: .randomHeight),
            scaleValue: 1.0,
            rotation: .zero
        )
        
        modelContext.insert(newItem)
        
        // Testing
        //        for index in 1...30 {
        //            let newItem = DoodleItem(
        //                text: "Item \(index)",
        //                colour: .random,
        //                location: CGPoint(x: .randomWidth + 30, y: .randomHeight),
        //                scaleValue: 1.0,
        //                rotation: .zero
        //            )
        //            modelContext.insert(newItem)
        //        }
        
        do {
            try modelContext.save()
        } catch {
            print("Error saving: \(error)")
        }
        path.removeLast()
    }
    
}


