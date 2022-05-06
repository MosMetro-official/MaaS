//
//  File.swift
//  
//
//  Created by Слава Платонов on 05.05.2022.
//

import UIKit

extension UITableViewHeaderFooterView {
    static internal var nib  : UINib {
        return UINib(nibName: identifire, bundle: .module)
    }
    static internal var identifire : String {
        return String(describing: self)
    }
}
