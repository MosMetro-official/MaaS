//
//  File.swift
//  
//
//  Created by Слава Платонов on 03.05.2022.
//

import UIKit

protocol _Appearance: AnyObject {
    static var customFonts: [FontTextStyle: UIFont] { get }
}

public enum FontTextStyle: String {
    case navTitle = "navTitle"
    case largeTitle = "largeTitle"
    case boldTitle = "boldTitle"
    case header = "header"
    case body = "body"
    case card = "card"
    case smallBody = "smallBody"
    case onboarding = "onboarding"
    case price = "price"
    case button = "button"
    case errorTitle = "errorTitle"
    case errorDescr = "errorDescr"
    case loading = "loading"
    case retryButton = "retryButton"
}

public final class Appearance: _Appearance {

    public static var customFonts: [FontTextStyle: UIFont] = [
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
        .errorDescr: UIFont(name: "MoscowSans-Regular", size: 18) ?? UIFont.systemFont(ofSize: 23, weight: .regular),
        .loading: UIFont(name: "MoscowSans-Regular", size: 22) ?? UIFont.systemFont(ofSize: 22, weight: .regular),
        .retryButton: UIFont(name: "MoscowSans-Regular", size: 21) ?? UIFont.systemFont(ofSize: 21, weight: .regular)
    ]
}
