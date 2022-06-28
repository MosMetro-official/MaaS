//
//  File.swift
//  
//
//  Created by Слава Платонов on 29.04.2022.
//

import UIKit

extension UIView {
    static internal func loadFromNib() -> Self {
        let nib = UINib(nibName: String(describing: self), bundle: MaaS.bundle)
        return nib.instantiate(withOwner: nil, options: nil).first as! Self
    }
}
