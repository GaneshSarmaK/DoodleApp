//
//  DoodleImageItemView.swift
//  Doodle
//
//  Created by NVR4GET on 3/4/2025.
//

import SwiftUI
import SwiftData
import PhotosUI

struct DoodleImageItemView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) var colorScheme
    @Environment(DoodleItemViewModel.self) var viewModel
    
    @State private var lastScale: CGFloat = 1.0
    
    var item: DoodleItem
    
    var body: some View {
        
        ImageManager.loadImageFromDocuments(filename: item.photoURL!)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 200)
            .clipShape(.circle)
            .padding()
            .scaleEffect(item.scaleValue)
            .rotationEffect(Angle(radians: item.rotation))
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
            .highPriorityGesture(
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


