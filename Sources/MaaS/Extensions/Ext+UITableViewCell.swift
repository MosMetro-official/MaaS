//
//  File.swift
//  
//
//  Created by Слава Платонов on 29.04.2022.
//

import UIKit

extension UITableViewCell {
    static internal var nib  : UINib {
        return UINib(nibName: identifire, bundle: MaaS.shared.bundle)
    }
    static internal var identifire : String {
        return String(describing: self)
    }
}
