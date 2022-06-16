//
//  File.swift
//  
//
//  Created by Слава Платонов on 29.04.2022.
//

import UIKit

extension UIColor {
    static internal func from(hex: String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    static func getAssetColor(name: String) -> UIColor {
        return UIColor(named: name, in: MaaS.shared.bundle, compatibleWith: nil) ?? UIColor.red
    }
    
    static func getCardHolderColor(for card: String) -> UIColor {
        switch card {
        case "MIR":
            return UIColor.getAssetColor(name: "mirC")
        case "VISA":
            return UIColor.getAssetColor(name: "visaC")
        case "RUBLE":
            return UIColor.getAssetColor(name: "rubleC")
        case "MC":
            return UIColor.getAssetColor(name: "mastercardC")
        case "UP":
            return UIColor.getAssetColor(name: "unionpayC")
        default:
            return UIColor.getAssetColor(name: "unknown")
        }
    }
}
