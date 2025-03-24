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
