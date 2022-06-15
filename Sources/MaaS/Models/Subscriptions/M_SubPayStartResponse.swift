//
//  M_SubPayStartResponse.swift
//  MaaS
//
//  Created by Слава Платонов on 11.06.2022.
//

import Foundation
import MMCoreNetworkCallbacks

struct M_SubPayStartResponse {
    let paymentId: String
    let subscription: M_SubscriptionInfo?
    
    init?(data: JSON) {
        self.paymentId = data["paymentId"].stringValue
        self.subscription = M_SubscriptionInfo(data: data["subscription"])
    }
}

struct M_SubPayStatusResponse {
    let subscription: M_SubscriptionInfo
    let payment: M_PaymentInfo
    
    init?(data: JSON) {
        guard
            let sub = M_SubscriptionInfo(data: data["subscription"]),
            let payment = M_PaymentInfo(data: data["payment"]) else { return nil }
        self.subscription = sub
        self.payment = payment
    }
}
