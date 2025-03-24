//
//  DoodleApp.swift
//  Doodle
//
//  Created by NVR4GET on 14/3/2025.
//

import SwiftUI
import SwiftData

@main
struct DoodleApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            DoodleItem.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            DoodleBoardView()
        }
        .modelContainer(sharedModelContainer)
//        .modelContext(sharedModelContainer.mainContext)
    }
}
