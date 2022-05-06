//
//  File.swift
//  
//
//  Created by Слава Платонов on 29.04.2022.
//

import Foundation
import UIKit

struct Subscription: Equatable {
    
    static func == (lhs: Subscription, rhs: Subscription) -> Bool {
        return lhs.title == rhs.title
    }
    
    let title: String
    let price: String
    let tariffs: [SubTariffs]
    
    static func getSubscriptions() -> [Subscription] {
        return [
            Subscription(
                title: "Мини",
                price: "1999 ₽",
                tariffs: [
                    SubTariffs(
                        title: "Такси",
                        trasnportTariff: "10 поездок",
                        transportImage: UIImage.getAssetImage(image: "taxi")
                    ),
                    SubTariffs(
                        title: "Общественный транспорт",
                        trasnportTariff: "Безлимит",
                        transportImage: UIImage.getAssetImage(image: "transport")
                    ),
                    SubTariffs(
                        title: "Велобайк",
                        trasnportTariff: "15 поездок в день до 30 минут",
                        transportImage: UIImage.getAssetImage(image: "transport")
                    )
                ]
            ),
            Subscription(
                title: "Стандарт",
                price: "2999 ₽",
                tariffs: [
                    SubTariffs(
                        title: "Общественный транспорт",
                        trasnportTariff: "Безлимит",
                        transportImage: UIImage.getAssetImage(image: "transport")
                    ),
                    SubTariffs(
                        title: "Велобайк",
                        trasnportTariff: "15 поездок в день до 30 минут",
                        transportImage: UIImage.getAssetImage(image: "transport")
                    )
                ]
            ),
            Subscription(
                title: "Макси",
                price: "2999 ₽",
                tariffs: [
                    SubTariffs(
                        title: "Общественный транспорт",
                        trasnportTariff: "Безлимит",
                        transportImage: UIImage.getAssetImage(image: "transport")
                    )
                ]
            )
        ]
    }
}

struct SubTariffs {
    let title: String
    let trasnportTariff: String
    let transportImage: UIImage
}

struct UserSubscription {
    let active: String
    let cardNumber: String
    let cardImage: UIImage
    let tariffs: [UserTariff]
    
    static func getUserSubscription() -> UserSubscription {
        return UserSubscription(
            active: "Активна до 22 марта 2022",
            cardNumber: "МИР •••• 2267",
            cardImage: UIImage.getAssetImage(image: "mir"),
            tariffs: [
                UserTariff(title: "Такси", type: nil, leftTripCount: 2, totalTripCount: 10),
                UserTariff(title: "Общественный транспорт", type: "Безлимит", leftTripCount: nil, totalTripCount: nil)
            ]
        )
    }
}

struct UserTariff {
    let title: String
    let type: String?
    let leftTripCount: Int?
    let totalTripCount: Int?
}
