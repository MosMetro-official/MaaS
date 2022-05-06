//
//  File.swift
//  
//
//  Created by Слава Платонов on 05.05.2022.
//

import UIKit

extension UIStackView {
    
    func removeFullyAllArrangedSubviews() {
        arrangedSubviews.forEach { (view) in
            removeFully(view: view)
        }
    }
    
    func removeFully(view: UIView) {
        removeArrangedSubview(view)
        view.removeFromSuperview()
    }
}
