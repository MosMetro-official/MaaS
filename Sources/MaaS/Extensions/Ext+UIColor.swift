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
        return UIColor(named: name, in: MaaS.bundle, compatibleWith: nil) ?? UIColor.red
    }
    
    static func getCardHolderColor(for card: PaySystem) -> UIColor {
        switch card {
        case .mir:
            return UIColor.getAssetColor(name: "mirC")
        case .visa:
            return UIColor.getAssetColor(name: "visaC")
        case .mc:
            return UIColor.getAssetColor(name: "mastercardC")
        case .cup:
            return UIColor.getAssetColor(name: "unionpayC")
        case .unknown:
            return UIColor.getAssetColor(name: "unknown")
        }
    }
}
