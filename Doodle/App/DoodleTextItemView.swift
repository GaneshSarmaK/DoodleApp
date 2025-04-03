//
//  DoodleTextItemView.swift
//  Doodle
//
//  Created by NVR4GET on 17/3/2025.
//
import SwiftUI
import SwiftData

struct DoodleTextItemView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) var colorScheme
    @Environment(DoodleItemViewModel.self) var viewModel
    
    var item: DoodleItem
    
//    @State var doodleitemViewModel: DoodleItemViewModel = DoodleItemViewModel()
    @State private var lastScale: CGFloat = 1.0
    
    var body: some View {
        
        Text(item.text ?? "")
            .padding()
            .font(.title)
            .scaleEffect(item.scaleValue)
            .rotationEffect(Angle(radians: item.rotation))
            .foregroundColor(item.colour)
            .shadow(color: colorScheme == .dark ? .white : .gray, radius: 0.5, x: 0.5, y: 0.5)
            .contextMenu {
                Button(role: .destructive) {
                    Task {
                        await viewModel.delete(doodle: item)
                    }
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
            .position(item.location)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        withAnimation(.easeInOut){
                            item.location = value.location
                        }
                    }
            )
            .simultaneousGesture(
                MagnifyGesture()
                    .onChanged{ value in
                        withAnimation(.easeInOut) {
                            item.scaleValue = max(1.0, min(5.0, lastScale * value.magnification))
                        }
                    }
                    .onEnded { _ in
                        lastScale = item.scaleValue
                    }
            )
            .simultaneousGesture(
                RotateGesture()
                    .onChanged { value in
                        withAnimation(.easeInOut) {
                            item.rotation = value.rotation.radians
                        }
                    }
            )
    }
}
