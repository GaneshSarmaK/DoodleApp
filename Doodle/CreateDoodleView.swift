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
    
    @State var photoData: Data?
    
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
                (photoData?.toImage ?? Image(systemName: "person.circle"))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .clipShape(.circle)
                
                PhotosPicker("Select image", selection: $photoPickerItem, matching: .images)
                
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
            
            Button(action: {
                if selectedMode == .photo {
                    addNewDoodleItem(isPhoto: true, photoData: photoData)
                } else {
                    addNewDoodleItem(text: textFieldInputText)
                }
            },
                   label: {
                Text("Add")
                    .frame(maxWidth: 100)
                    .padding()
                    .foregroundColor(.white)
                    .background(.blue)
            })
            .clipShape(.capsule)
            .shadow(color: colorScheme == .dark ? .white : .gray, radius: 2, x: 0.5, y: 0.5)
            .disabled(selectedMode == .text ? textFieldInputText.isEmpty : photoData == nil)
            
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
                if let imageData = try? await photoPickerItem?.loadTransferable(type: Data.self) {
                    photoData = imageData
                } else {
                    print("Photo failed")
                }
            }
            print(selectedMode.rawValue)
        }
        .onChange(of: selectedMode) {
            print(selectedMode.rawValue)
        }
    }
    
    func addNewDoodleItem(isPhoto: Bool = false, photoData: Data? = nil, text: String = "") {
        var photoURL = ""
        if isPhoto {
            photoURL = ImageManager.saveImageToDocuments(data: photoData!) ?? ""
        }
        let newItem = DoodleItem(
            text: text,
            colour: selectedColor,
            location: CGPoint(x: .randomWidth + 30, y: .randomHeight),
            scaleValue: 1.0,
            rotation: .zero,
            isPhoto: isPhoto,
            photoURL: photoURL
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


