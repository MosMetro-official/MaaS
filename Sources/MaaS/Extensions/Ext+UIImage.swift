//
//  File.swift
//  
//
//  Created by Слава Платонов on 29.04.2022.
//

import UIKit

extension UIImage {
    static internal func getAssetImage(image name: String) -> UIImage {
        return UIImage(named: name, in: MaaS.shared.bundle, with: nil) ?? UIImage()
    }
}
