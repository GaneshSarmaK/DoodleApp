//
//  DoodleItem.swift
//  Doodle
//
//  Created by NVR4GET on 14/3/2025.
//

import SwiftData
import SwiftUI


@Model
final class DoodleItem: Identifiable {
    //Private(set) sets scope of the Setter methods to private. get remians public
    @Attribute(.unique) private(set) var id: String = UUID().uuidString
    var text: String
    var locationX: Double
    var locationY: Double
    var scaleValue: Double
    var rotation: Double
    var colourRed: Double
    var colourGreen: Double
    var colourBlue: Double
    var isPhoto: Bool
    var photoURL: String

    init(text: String, colour: Color, location: CGPoint, scaleValue: CGFloat, rotation: Angle, isPhoto: Bool, photoURL: String) {
//        self.id
        self.text = text
        self.locationX = location.x
        self.locationY = location.y
        self.scaleValue = scaleValue
        self.rotation = rotation.radians
        self.isPhoto = isPhoto
        self.photoURL = photoURL
        
        // Store color components
        if let uiColour = UIColor(colour).cgColor.components {
            self.colourRed = Double(uiColour[0])
            self.colourGreen = Double(uiColour[1])
            self.colourBlue = Double(uiColour[2])
        } else {
            self.colourRed = 0
            self.colourGreen = 0
            self.colourBlue = 0
        }
    }

    var location: CGPoint {
        get { CGPoint(x: locationX, y: locationY) }
        set {
            locationX = newValue.x
            locationY = newValue.y
        }
    }

    var angle: Angle {
        get { Angle(radians: rotation) }
        set { rotation = newValue.radians }
    }

    var colour: Color {
        get { Color(red: colourRed, green: colourGreen, blue: colourBlue) }
        set {
            if let uiColour = UIColor(newValue).cgColor.components {
                self.colourRed = Double(uiColour[0])
                self.colourGreen = Double(uiColour[1])
                self.colourBlue = Double(uiColour[2])
            }
        }
    }
}

extension DoodleItem: Equatable {
    static func == (lhs: DoodleItem, rhs: DoodleItem) -> Bool {
        return lhs.id == rhs.id &&
        lhs.isPhoto == rhs.isPhoto &&
        lhs.text == rhs.text &&
        lhs.colour == rhs.colour &&
        lhs.location == rhs.location &&
        lhs.scaleValue == rhs.scaleValue &&
        lhs.rotation == rhs.rotation &&
        lhs.photoURL == rhs.photoURL
    }
}

extension DoodleItem: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}



