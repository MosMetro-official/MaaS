//
//  File.swift
//  
//
//  Created by Слава Платонов on 29.04.2022.
//

import Foundation
import UIKit

struct Subscription: Equatable {
    let title: String
    let price: String
    let taxiCount: String
    let trasnportTariff: String
    let bikeTariff: String
    
    static func getSubscriptions() -> [Subscription] {
        return [
            Subscription(
                title: "Мини",
                price: "1999 ₽",
                taxiCount: "10 поездок",
                trasnportTariff: "Безлимит",
                bikeTariff: "15 поездок в день до 30 минут"
            ),
            Subscription(
                title: "Стандарт",
                price: "2999 ₽",
                taxiCount: "10 поездок",
                trasnportTariff: "Безлимит",
                bikeTariff: "15 поездок в день до 30 минут"
            ),
            Subscription(
                title: "Макси",
                price: "2999 ₽",
                taxiCount: "10 поездок",
                trasnportTariff: "Безлимит",
                bikeTariff: "15 поездок в день до 30 минут"
            )
        ]
    }
}
