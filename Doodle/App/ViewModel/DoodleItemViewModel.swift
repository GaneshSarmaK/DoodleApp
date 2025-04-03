//
//  DoodleItemViewModel.swift
//  Doodle
//
//  Created by NVR4GET on 3/4/2025.
//


import SwiftUI
import SwiftData

@Observable
final class DoodleItemViewModel {
    
    let dataSource: DoodleDataSource
    
    var doodleItems: [DoodleItem] = []
    
    init() {
        let container = ModelContainer.sharedModelContainer
        dataSource = DoodleDataSource(modelContainer: container)
    }
    
    func fetch() async {
        let items = await dataSource.fetchDoodles()
        doodleItems = items
    }
    
    func addDoodle(text: String? = nil, colour: Color = .random, scaleValue: CGFloat = 1, rotation: Angle = .zero, photoData: Data? = nil) async {
        var photoURL: String? = nil
        
        if let photoData = photoData {
            photoURL = ImageManager.saveImageToDocuments(data: photoData) ?? ""
        }
        
        let newDoodle = DoodleItem(
            text: text,
            colour: colour,
            location: CGPoint(x: .randomWidth + 30, y: .randomHeight),
            scaleValue: 1.0,
            rotation: .zero,
            photoURL: photoURL
        )
        
        await dataSource.insert(newDoodle)
        await dataSource.save()
        doodleItems.append(newDoodle)
    }
    
    func delete(doodle: DoodleItem) async {
        if let url = doodle.photoURL {
            ImageManager.deleteImageFromDocuments(filename: url)
        }

        if let index = doodleItems.firstIndex(where: { $0.id == doodle.id }) {
            doodleItems.remove(at: index)
        } else {
            print("Not found")
        }

        await dataSource.deleteDoodle(doodle)
        await dataSource.save()
    }
    
    func deleteAllDoodles() async {
        for item in doodleItems {
            if let url = item.photoURL {
                ImageManager.deleteImageFromDocuments(filename: url)
            }
        }
        await dataSource.deleteAllDoodles()
        await dataSource.save()
        doodleItems = []
    }
}
