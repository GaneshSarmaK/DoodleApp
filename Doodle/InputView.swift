//
//  InputView.swift
//  Doodle
//
//  Created by NVR4GET on 16/3/2025.
//

import SwiftUI

struct InputView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var textFieldInputText: String = ""
    
    @Binding var path: [String]
    
    var body: some View {
       
        VStack {
            TextField("Enter text to add", text: $textFieldInputText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(maxWidth: 300)
                .padding()
                .shadow(color: colorScheme == .dark ? .white : .gray, radius: 2, x: 0.5, y: 0.5)
            
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
        .navigationTitle(Text("Input"))
        .toolbar {
            ToolbarItem(placement: .principal) { // Centers & styles title
                Text("Input")
                    .font(.body)
                    .bold()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func addNewTextItem() {
        var newItem = DoodleItem(
            text: textFieldInputText,
            colour: .random,
            location: CGPoint(x: .randomWidth + 30, y: .randomHeight),
            scaleValue: 1.0,
            rotation: .zero
        )
        
        modelContext.insert(newItem)
        
        do {
            try modelContext.save()
        } catch {
            print("Error saving: \(error)")
        }
        path.removeLast()
    }
}


