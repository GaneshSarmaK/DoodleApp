//
//  ContentView.swift
//  Doodle
//
//  Created by NVR4GET on 14/3/2025.
//

import SwiftUI
import SwiftData

struct DoodleBoardView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Environment(\.colorScheme) var colorScheme
    
    @Query private var doodleItemsOnBoard: [DoodleItem]
    
//    @State private var isInputViewPresented: Bool = false
    
    @State private var path: [String] = []
        
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                ZStack {
                    ForEach(doodleItemsOnBoard) { item in
                        DoodleTextItemView(item: item)
                    }
                }
                
                Spacer()
                
                HStack {
                    Button(action: {
                        path.append("InputView")
    //                    isInputViewPresented = true
                    }, label: {
                        Text("Add new text")
                            .padding()
                            .foregroundColor(.white)
                            .background(.blue)
                    })
                    .clipShape(.capsule)
                    .shadow(color: colorScheme == .dark ? .white : .gray, radius: 2, x: 0.5, y: 0.5)
    //                .fullScreenCover(isPresented: $isInputViewPresented, content: {
    //                    InputView()
    //                })
                }
                .padding()
            }
            .navigationDestination(for: String.self) { destination in
                if destination == "InputView" {
                    InputView(path: $path)
                }
            }
        }
    }
    
    func deleteDoodleItem(item: DoodleItem){
        withAnimation {
            modelContext.delete(item)
            try? modelContext.save()
        }
    }
}

#Preview {
    DoodleBoardView()
        .modelContainer(for: DoodleItem.self, inMemory: true)
}
