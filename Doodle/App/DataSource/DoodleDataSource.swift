//
//  DoodleDataSource.swift
//  Doodle
//
//  Created by NVR4GET on 3/4/2025.
//

import SwiftData
import SwiftUI

@ModelActor
final actor DoodleDataSource {
    func fetchDoodles() -> [DoodleItem] {
        do {
            let doodleItems = try modelContext.fetch(
                FetchDescriptor<DoodleItem>(
                    sortBy: [SortDescriptor(\.id)]
                )
            )
            return doodleItems
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func insert(_ item: DoodleItem) {
        modelContext.insert(item)
    }
    
    func deleteDoodle(_ doodle: DoodleItem) {
        modelContext.delete(doodle)
    }
    
    func deleteAllDoodles() {
        do {
            try modelContext.delete(model: DoodleItem.self)
        } catch {
            print("Failed to save after deletion: \(error)")
        }
    }
    
    func save() {
        do {
            try modelContext.save()
            print("Save success")
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
