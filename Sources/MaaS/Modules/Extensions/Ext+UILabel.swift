//
//  File.swift
//  
//
//  Created by Слава Платонов on 03.05.2022.
//

import UIKit

@IBDesignable
extension UILabel {
    
    @IBInspectable
    public var userFontName : String {
        set (userFont) {
            self.font = Appearance.customFonts[.init(rawValue: userFont) ?? .body]
        }
        get {
            return self.userFontName
        }
    }
}
