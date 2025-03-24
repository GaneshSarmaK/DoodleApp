//
//  Item.swift
//  Doodle
//
//  Created by NVR4GET on 14/3/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
