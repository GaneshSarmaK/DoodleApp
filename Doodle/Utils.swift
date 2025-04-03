//
//  Utils.swift
//  Doodle
//
//  Created by NVR4GET on 17/3/2025.
//
import SwiftUI

extension Color {
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}

extension CGFloat{
    
    static var randomWidth: CGFloat{
        return .random(in: 0...1) * (UIScreen.main.bounds.width - 50)
    }
    
    static var randomHeight: CGFloat{
        return .random(in: 0...1) * (UIScreen.main.bounds.height - 100)
    }
}

enum NavViews: String, Hashable {
    case createDoodleView
    
    var navTitle: String {
        switch self {
        case .createDoodleView:
            return "Create Doodle View"
        }
    }
}

enum DoodleMode: String, CaseIterable, Identifiable {
    case text = "Text"
    case photo = "Photo"
    
    var id: String { self.rawValue }
}

extension Data {
    var toImage: Image? {
        guard let uiImage = UIImage(data: self) else { return nil }
        return Image(uiImage: uiImage)
    }
}

struct ImageManager {
    
    static func saveImageToDocuments(data: Data) -> String? {
        let filename = "\(UUID().uuidString).jpg"
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsURL.appendingPathComponent(filename)
        
        do {
            try data.write(to: fileURL)
            print(filename)
            return filename
        } catch {
            print("Failed to write image data: \(error)")
            return nil
        }
    }
    
    static func deleteImageFromDocuments(filename: String) {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = directory.appendingPathComponent(filename)

        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(at: fileURL)
                print("Deleted image: \(filename)")
            } catch {
                print("Failed to delete image: \(error.localizedDescription)")
            }
        } else {
            print("File does not exist at path: \(fileURL.path)")
        }
    }
    
    static func loadImageFromDocuments(filename: String) -> Image {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = directory.appendingPathComponent(filename)

        if let uiImage = UIImage(contentsOfFile: fileURL.path) {
            return Image(uiImage: uiImage)
        } else {
            print(" Failed to load image at: \(fileURL.path)")
            return Image(systemName: "exclamationmark.triangle")
        }
    }
}
