//
//  M_ECommerceEvents.swift
//  MaaS
//
//  Created by polykuzin on 16/09/2022.
//

import CoreAnalytics

internal struct M_ECommerceEvents {
    
    private struct Order : _ECommerceOrder {
        var id: String
        var metadata: [String : String]
        var referrer: _ECommerceReferrer
        var cartItems: [_ECommerceCartItem]
    }
    
    private struct Screen : _ECommerceScreen {
        var name: String
        var route: String?
        var metadata: [String: String]
        var categoryComponents: [String]?
    }
    
    private struct CartItem : _ECommerceCartItem {
        var revenue: _ECommercePrice
        var product: _ECommerceProduct
        var quantity: Int
        var referrer: _ECommerceReferrer?
        var metadata: [String : String]?
    }
    
    private struct Refferrer : _ECommerceReferrer {
        var id: String?
        var type: _ECommerceReferrerType
        var screen: _ECommerceScreen
    }
    
    private struct RevenueEvent : _AnalyticsRevenueEvent {
        var id: String
        var price: String
        var quantity: Int
        var currency: String
    }
    
    func makeRevenueEvent(_ product: _ECommerceProduct) -> _AnalyticsRevenueEvent {
        return RevenueEvent(
            id: product.sku,
            price: String(product.actualPrice.fiat.value),
            quantity: 1,
            currency: "RUB"
        )
    }
    
    func makePurchaiseEvent(_ product: _ECommerceProduct) -> ECommerceEvent {
        let order = Order(
            id: UUID().uuidString,
            metadata: [:],
            referrer: Refferrer(
                type: .button,
                screen: Screen(
                    name: "Обычный экран покупки",
                    metadata: [:]
                )
            ),
            cartItems: [
                CartItem(
                    revenue: product.actualPrice,
                    product: product,
                    quantity: 1
                )
            ]
        )
        return .purchaseEventWithOrder(order)
    }
}
