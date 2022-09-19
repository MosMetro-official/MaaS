//
//  AnalyticsEngine.swift
//  MaaSExample
//
//  Created by Слава Платонов on 19.09.2022.
//

import YandexMobileMetrica
import CoreAnalytics
import MaaS

final class YandexAnalyticsEngine {
    
    public init() {
        configure()
    }
    
    /// Для отправления событий с параметрами и без
    /// - Parameters:
    ///   - name: имя события в фотмате "\(приложение).\(модуль).\(событие)"
    ///   - metadata: (опционально) расширенные параметры, например, версия приложения: ["version": "4.0.0"]
    public func reportEvent(name: String, metadata: [String: AnyHashable]? = nil) {
        YMMYandexMetrica.reportEvent(name, parameters: metadata) { error in
            print("💔💔💔 Event with name \(name) not sent")
            print("REPORT ERROR: \(error.localizedDescription)")
        }
    }
    
    /// Для отправления ошибки с параметрами и без
    /// - Parameters:
    ///   - id: id ошибки (TBD)
    ///   - message: сообщение, что именно произошло и когда
    ///   - metadata: (опционально) расширенные параметры, например, версия приложения: ["version": "4.0.0"]
    public func reportError(id: String, message: String, metadata: [String: AnyHashable]? = nil) {
        YMMYandexMetrica.report(error: YMMError(identifier: id, message: message, parameters: metadata)) { error in
            print("💔💔💔 Error with id \(id) not sent")
            print("REPORT ERROR: \(error.localizedDescription)")
        }
    }
    
    /// Для отправления информации о совершённом платеже
    /// - Parameters:
    ///   - id: id товара, который купили - используем названия билетов?
    ///   - price: текущая цена товара
    ///   - currency: текущая валюта (да, обычно рубли)
    ///   - quantity: количество купленного товара
    public func reportRevenue(id: String, price: String, currency: String = "RUB", quantity: Int = 1) {
        let price = NSDecimalNumber(string: price)
        // Initializing the Revenue instance.
        let revenueInfo = YMMMutableRevenueInfo.init(priceDecimal: price, currency: currency)
        revenueInfo.quantity = 1
        revenueInfo.productID = id
        // Set purchase information for validation.
        YMMYandexMetrica.reportRevenue(revenueInfo, onFailure: { (error) in
            print("REPORT ERROR: \(error.localizedDescription)")
        })
    }
    
    public func reportECommerce(event: ECommerceEvent) {
        switch event {
        case .purchaseEventWithOrder(let order):
            reportPurchaseEvent(with: order)
        case .addCartItemEventWithItem(let cartItem):
            reportAddToCartEvent(with: cartItem)
        case .showScreenEventWithScreen(let screen):
            reportShowScreenEvent(with: screen)
        case .removeCartItemEventWithItem(let cartItem):
            reportRemoveFromCartEvent(with: cartItem)
        case .beginCheckoutEventWithOrder(let order):
            reportBeginCheckoutEvent(with: order)
        case .showProductCardEventWithProduct(let product, let screen):
            reportShowProductCardEvent(with: product, on: screen)
        case .showProductDetailsEventWithProduct(let product, let referrer):
            reportShowProductDetailsEvent(with: product, referrer: referrer)
        }
    }
}

extension YandexAnalyticsEngine : _AnalyticsEngine {
    
    private var apiKey : String {
        return "4f023df8-11f2-4db6-bf1d-9e9855736a8f"
    }
    
    private func configure() {
        let bundle = MaaS.bundle
        guard
            let appVersion = bundle.infoDictionary?["CFBundleShortVersionString"] as? String,
            let yandexMetricsConfiguration = YMMYandexMetricaConfiguration.init(apiKey: apiKey)
        else { fatalError("🤬🤬🤬 No Api Key Found") }
#if !prod
        /// Включает/отключает логирование работы библиотеки.
        yandexMetricsConfiguration.logs = true
#endif
        yandexMetricsConfiguration.appVersion = appVersion
        yandexMetricsConfiguration.crashReporting = true
        
        /// Включает/выключает автоматический сбор и отправку информации о запуске приложения через deeplink.
        yandexMetricsConfiguration.appOpenTrackingEnabled = true
        
        /// Определяет инициализацию AppMetrica как начало сессии.
        /// 'true' — первый запуск определяется как обновление.
        /// 'false' — первый запуск определяется как новая установка.
        yandexMetricsConfiguration.handleFirstActivationAsUpdate = false
        
        /// Определяет инициализацию AppMetrica как начало пользовательской сессии.
        /// 'true' - пользовательская сессия создается в момент инициализации библиотеки
        /// 'false' - в момент инициализации библиотеки создается фоновая сессия, а пользовательская сессия создается после системного события UIApplicationDidBecomeActiveNotification.
        yandexMetricsConfiguration.handleActivationAsSessionStart = false
        
        YMMYandexMetrica.activate(with: yandexMetricsConfiguration)
    }
    
    private func reportPurchaseEvent(with order: _ECommerceOrder) {
        let yOrder = order.mapToYandex()
        YMMYandexMetrica.report(eCommerce: .purchaseEvent(order: yOrder))
    }
    
    private func reportAddToCartEvent(with cartItem: _ECommerceCartItem) {
        let yCartItem = cartItem.mapToYandex()
        YMMYandexMetrica.report(eCommerce: .addCartItemEvent(cartItem: yCartItem))
    }
    
    private func reportShowScreenEvent(with screen: _ECommerceScreen) {
        let yScreen = screen.mapToYandex()
        YMMYandexMetrica.report(eCommerce: .showScreenEvent(screen: yScreen))
    }
    
    private func reportRemoveFromCartEvent(with cartItem: _ECommerceCartItem) {
        let yCartItem = cartItem.mapToYandex()
        YMMYandexMetrica.report(eCommerce: .removeCartItemEvent(cartItem: yCartItem))
    }
    
    private func reportBeginCheckoutEvent(with order: _ECommerceOrder) {
        let yOrder = order.mapToYandex()
        YMMYandexMetrica.report(eCommerce: .beginCheckoutEvent(order: yOrder))
    }
    
    private func reportShowProductCardEvent(with product: _ECommerceProduct, on screen: _ECommerceScreen) {
        let yScreen = screen.mapToYandex()
        let yProduct = product.mapToYandex()
        YMMYandexMetrica.report(eCommerce: .showProductCardEvent(product: yProduct, screen: yScreen))
    }
    
    private func reportShowProductDetailsEvent(with product: _ECommerceProduct, referrer: _ECommerceReferrer) {
        let yProduct = product.mapToYandex()
        let yReferrer = referrer.mapToYandex()
        YMMYandexMetrica.report(eCommerce: .showProductDetailsEvent(product: yProduct, referrer: yReferrer))
    }
}

extension _ECommerceOrder {
    
    func mapToYandex() -> YMMECommerceOrder {
        return YMMECommerceOrder(
            identifier: id,
            cartItems: cartItems.map({
                $0.mapToYandex()
            }),
            payload: metadata
        )
    }
}

extension _ECommerceCartItem {
    
    func mapToYandex() -> YMMECommerceCartItem {
        return YMMECommerceCartItem(
            product: product.mapToYandex(),
            quantity: NSDecimalNumber(value: quantity),
            revenue: revenue.mapToYandex(),
            referrer: referrer?.mapToYandex()
        )
    }
}

extension _ECommerceProduct {
    
    func mapToYandex() -> YMMECommerceProduct {
        return YMMECommerceProduct(
            sku: sku,
            name: name,
            categoryComponents: categoryComponents,
            payload: metadata,
            actualPrice: actualPrice.mapToYandex(),
            originalPrice: originalPrice.mapToYandex(),
            promoCodes: promocodes
        )
    }
}

extension _ECommercePrice {
    
    func mapToYandex() -> YMMECommercePrice {
        return .init(
            fiat: fiat.mapToYandex(),
            internalComponents: internalComponents.map({
                return $0.mapToYandex()
            })
        )
    }
}

extension _ECommerceReferrer {
    
    func mapToYandex() -> YMMECommerceReferrer {
        return YMMECommerceReferrer(
            type: type.rawValue,
            identifier: id,
            screen: screen.mapToYandex()
        )
    }
}

extension _ECommerceScreen {
    
    func mapToYandex() -> YMMECommerceScreen {
        return YMMECommerceScreen(
            name: name,
            categoryComponents: categoryComponents,
            searchQuery: route,
            payload: metadata
        )
    }
}

extension _ECommerceAmount {
    
    func mapToYandex() -> YMMECommerceAmount {
        return YMMECommerceAmount(
            unit: unit,
            value: NSDecimalNumber(value: value)
        )
    }
}
