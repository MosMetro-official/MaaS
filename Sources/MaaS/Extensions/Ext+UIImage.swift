//
//  File.swift
//  
//
//  Created by Слава Платонов on 29.04.2022.
//

import UIKit

extension UIImage {
    static func getAssetImage(image name: String) -> UIImage {
        return UIImage(named: name, in: MaaS.shared.bundle, with: nil) ?? UIImage()
    }
    
    static func getCardHolderImage(for card: String) -> UIImage {
        switch card {
        case "MIR":
            return UIImage.getAssetImage(image: "mir")
        case "VISA":
            return UIImage.getAssetImage(image: "visa")
        case "RUBLE":
            return UIImage.getAssetImage(image: "ruble")
        case "MC":
            return UIImage.getAssetImage(image: "mastercard")
        case "UP":
            return UIImage.getAssetImage(image: "unionpay")
        default:
            return UIImage.getAssetImage(image: "unknown_ps")
        }
    }
}
