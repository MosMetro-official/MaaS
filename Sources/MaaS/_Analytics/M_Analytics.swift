//
//  M_Analytics.swift
//
//
//  Created by polykuzin on 14/09/2022.
//

import CoreAnalytics

internal struct M_AnalyticsEvents {
    
    struct AnalyticsEvent : _AnalyticsEvent {
        var name: String
        var metadata: [String : AnyHashable]?
    }
    
    func makeChangeCardEvent() -> _AnalyticsEvent {
        return AnalyticsEvent(
            name: "mm.maas.сard"
        )
    }
    
    func makeOldNameChangeCardEvent() -> _AnalyticsEvent {
        return AnalyticsEvent(
            name: "newmetro.cabinet.maas.tap.changeCard"
        )
    }
    
    func makeOnboardingEvent() -> _AnalyticsEvent {
        return AnalyticsEvent(
            name: "mm.maas.onboarding"
        )
    }
    
    func makeOldNameOnboardingEvent() -> _AnalyticsEvent {
        return AnalyticsEvent(
            name: "newmetro.cabinet.maas.tap.howWork"
        )
    }
    
    func makePassHistoryEvent() -> _AnalyticsEvent {
        return AnalyticsEvent(
            name: "mm.maas.passHistory"
        )
    }
    
    func makeOldNamePassHistoryEvent() -> _AnalyticsEvent {
        return AnalyticsEvent(
            name: "newmetro.cabinet.maas.tap.passHistory"
        )
    }
    
    func makeNotificationsEvent() -> _AnalyticsEvent {
        return AnalyticsEvent(
            name: "mm.maas.notifications"
        )
    }
    
    func makeOldNameNotificationsEvent() -> _AnalyticsEvent {
        return AnalyticsEvent(
            name: "newmetro.cabinet.maas.tap.notifications"
        )
    }
    
    func makeLinkCardEvent() -> _AnalyticsEvent {
        return AnalyticsEvent(
            name: "mm.maas.linkCard"
        )
    }
    
    func makeOldNameLinkCardEvent() -> _AnalyticsEvent {
        return AnalyticsEvent(
            name: "newmetro.cabinet.maas.tap.linkCard"
        )
    }
    
    func makeChangeCardTappedEvent() -> _AnalyticsEvent {
        return AnalyticsEvent(
            name: "mm.maas.changeCard"
        )
    }
    
    func makeOldNameChangeCardTappedEvent() -> _AnalyticsEvent {
        return AnalyticsEvent(
            name: "newmetro.cabinet.maas.changeCard.tap.change"
        )
    }
    
    func makeBuySubcriptionEvent(_ data: M_Subscription) -> _AnalyticsEvent {
        return AnalyticsEvent(
            name: "mm.maas.buySubcription",
            metadata: [
                "id": data.id,
                "name": data.name.ru,
                "price": data.price,
                "serviceId": data.serviceId
            ]
        )
    }
    
    func makeOldNameBuySubcriptionEvent(_ data: M_Subscription) -> _AnalyticsEvent {
        return AnalyticsEvent(
            name: "newmetro.cabinet.maas.tap.buySub",
            metadata: [
                "id": data.id,
                "sum": data.price
            ]
        )
    }
}
