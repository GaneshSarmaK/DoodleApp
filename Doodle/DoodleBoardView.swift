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
    
    @State private var showConfirmation = false

    @State private var path: [NavViews] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                ZStack {
                    ForEach(doodleItemsOnBoard) { item in
                        if item.isPhoto {
                            DoodleImageItemView(item: item)
                        } else {
                            DoodleTextItemView(item: item)
                        }
                    }
                }
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(role: .destructive) {
                        showConfirmation = true
                    } label: {
                        Text("Reset")
                        Image(systemName: "arrow.counterclockwise")
                    }
                    .confirmationDialog("Are you sure you want to delete all data?",
                                        isPresented: $showConfirmation,
                                        titleVisibility: .visible) {
                        Button("Delete Everything", role: .destructive) {
                            for item in doodleItemsOnBoard {
                                    if item.isPhoto {
                                        ImageManager.deleteImageFromDocuments(filename: item.photoURL)
                                    }
                                }
                            do {
                                try modelContext.delete(model: DoodleItem.self)
                            } catch {
                                print("Failed to save after deletion: \(error)")
                            }
                        }
                        Button("Cancel", role: .cancel) { }
                    }
                    
                    //                .fullScreenCover(isPresented: $isInputViewPresented, content: {
                    //                    InputView()
                    //                })
                }
                .overlay(alignment: .center, content: {
                    Button(action: {
                        path.append(.createDoodleView)
                    }, label: {
                        Text("Add new text")
                            .padding()
                            .foregroundColor(.white)
                            .background(.blue)
                    })
                    .clipShape(.capsule)
                    .shadow(color: colorScheme == .dark ? .white : .gray, radius: 2, x: 0.5, y: 0.5)
                })
                .padding()
            }
            .navigationDestination(for: NavViews.self) { destination in
                switch destination {
                    case .createDoodleView:
                        CreateDoodleView(path: $path)
                }
            }
        }
    }
    
    func deleteDoodleItem(item: DoodleItem){
        withAnimation {
            ImageManager.deleteImageFromDocuments(filename: item.photoURL)
            modelContext.delete(item)
            try? modelContext.save()
        }
    }
}

#Preview {
    DoodleBoardView()
        .modelContainer(for: DoodleItem.self, inMemory: true)
}
