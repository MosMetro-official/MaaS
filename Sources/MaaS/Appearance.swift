//
//  File.swift
//  
//
//  Created by Слава Платонов on 03.05.2022.
//

import UIKit

struct Constans {
    
    struct Images {
        static let taxi = UIImage.getAssetImage(image: "taxi")
        static let transport = UIImage.getAssetImage(image: "transoprt")
    }
    
    struct Fonts {
        static let body = UIFont.customFont(forTextStyle: .body)
        static let header = UIFont.customFont(forTextStyle: .header)
    }
    
    struct Colors {
        static let primaryText = UIColor.getAssetColor(name: "primaryText")
        static let background = UIColor.getAssetColor(name: "background")
    }
    
}

protocol _Appearance: AnyObject {
    static var customFonts: [FontTextStyle: UIFont] { get }
}

public enum FontTextStyle: String {
    case body = "body"
    case card = "card"
    case price = "price"
    case header = "header"
    case button = "button"
    case debt = "debt"
    case more = "moreText"
    case loading = "loading"
    case navTitle = "navTitle"
    case smallBody = "smallBody"
    case boldTitle = "boldTitle"
    case largeTitle = "largeTitle"
    case onboarding = "onboarding"
    case errorTitle = "errorTitle"
    case errorDescr = "errorDescr"
    case retryButton = "retryButton"
}

public final class Appearance: _Appearance {

    static var customFonts: [FontTextStyle: UIFont] = [
        .navTitle: UIFont(name: "MoscowSans-Medium", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .medium),
        .largeTitle: UIFont(name: "Comfortaa", size: 30) ?? UIFont.systemFont(ofSize: 30, weight: .bold),
        .header: UIFont(name: "MoscowSans-Bold", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .regular),
        .body: UIFont(name: "MoscowSans-Regular", size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .regular),
        .card: UIFont(name: "MoscowSans-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17, weight: .regular),
        .smallBody: UIFont(name: "MoscowSans-Regular", size: 13) ?? UIFont.systemFont(ofSize: 13, weight: .regular),
        .onboarding: UIFont(name: "MoscowSans-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .medium),
        .price: UIFont(name: "MoscowSans-Regular", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .regular),
        .button: UIFont(name: "MoscowSans-Medium", size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .medium),
        .boldTitle: UIFont(name: "MoscowSans-Bold", size: 22) ?? UIFont.systemFont(ofSize: 22, weight: .bold),
        .errorTitle: UIFont(name: "MoscowSans-Regular", size: 25) ?? UIFont.systemFont(ofSize: 30, weight: .regular),
        .debt: UIFont(name: "MoscowSans-Medium", size: 17) ?? UIFont.systemFont(ofSize: 17, weight: .medium),
        .more: UIFont(name: "MoscowSans-Medium", size: 13) ?? UIFont.systemFont(ofSize: 13, weight: .medium),
        .errorDescr: UIFont(name: "MoscowSans-Regular", size: 18) ?? UIFont.systemFont(ofSize: 23, weight: .regular),
        .loading: UIFont(name: "MoscowSans-Regular", size: 22) ?? UIFont.systemFont(ofSize: 22, weight: .regular),
        .retryButton: UIFont(name: "MoscowSans-Regular", size: 21) ?? UIFont.systemFont(ofSize: 21, weight: .regular)
    ]
    
    static func getFont(_ fontStyle: FontTextStyle) -> UIFont {
        return Appearance.customFonts[fontStyle] ?? UIFont.systemFont(ofSize: 15)
    }
}
