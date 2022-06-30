//
//  File.swift
//  
//
//  Created by Слава Платонов on 29.04.2022.
//

import UIKit

extension UIImage {
    static func getAssetImage(image name: String) -> UIImage {
        return UIImage(named: name, in: MaaS.bundle, with: nil) ?? UIImage()
    }
    
    static func getCardHolderImage(for card: PaySystem) -> UIImage {
        switch card {
        case .mir:
            return UIImage.getAssetImage(image: "mir")
        case .visa:
            return UIImage.getAssetImage(image: "visa")
        case .mc:
            return UIImage.getAssetImage(image: "mastercard")
        case .cup:
            return UIImage.getAssetImage(image: "unionpay")
        case .unknown:
            return UIImage.getAssetImage(image: "unknown_ps")
        }
    }
}
