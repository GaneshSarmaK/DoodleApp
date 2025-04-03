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
    
    
    @State private var showConfirmation = false
    @State private var path: [NavViews] = []
    @State var viewModel: DoodleItemViewModel = DoodleItemViewModel()

    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                ZStack {
                    ForEach(viewModel.doodleItems) { item in
                        if item.photoURL != nil {
                            DoodleImageItemView(item: item)
                        } else {
                            DoodleTextItemView(item: item)
                        }
                    }
                }
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    resetButton
                }
                .overlay(alignment: .center, content: {
                    Button(action: {
                        path.append(.createDoodleView)
                    }, label: {
                        Text("Add new Doodle")
                            .padding()
                            .foregroundColor(.white)
                            .background(.blue)
                    })
                    .clipShape(.capsule)
                    .shadow(color: colorScheme == .dark ? .white : .gray, radius: 2, x: 0.5, y: 0.5)
                })
                .padding()
            }
            .onAppear {
                Task {
                    await viewModel.fetch()
                }
            }
            .navigationDestination(for: NavViews.self) { destination in
                switch destination {
                    case .createDoodleView:
                        CreateDoodleView(path: $path)
                }
            }
        }
        .environment(viewModel)
    }
    
    var resetButton: some View {
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
                Task {
                    await viewModel.deleteAllDoodles()
                }
            }
            
            Button("Cancel", role: .cancel) { }
        }
    }
}

#Preview {
    DoodleBoardView()
        .modelContainer(for: DoodleItem.self, inMemory: true)
}
