//
//  Colors.swift
//  Thela At Home
//
//  Created by Vandit Jain on 12/04/20.
//  Copyright © 2020 jainvandit. All rights reserved.
//

import Foundation
import UIKit

class Colors {
    
    static var darkGreen = UIColor(hex: "1A5E2C")
    static var green = UIColor(hex: "3E8C43")
    static var lightGreen = UIColor(hex: "97C97F")
    static var secondaryLight = UIColor(hex: "E3EDCB")
    static var secondaryDark = UIColor(hex: "001700")
    
}

extension UIColor {
    convenience init(hex: String) {
        let hexTrim = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hexTrim).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hexTrim.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
