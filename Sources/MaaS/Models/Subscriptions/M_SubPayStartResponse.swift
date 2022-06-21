//
//  M_SubPayStartResponse.swift
//  MaaS
//
//  Created by Слава Платонов on 11.06.2022.
//

import Foundation
import MMCoreNetworkCallbacks

public struct M_SubPayStartResponse {
    public let paymentId: String
    public let subscription: M_Subscription?
    
    init?(data: JSON) {
        self.paymentId = data["paymentId"].stringValue
        self.subscription = M_Subscription(data: data["subscription"])
    }
}

public struct M_SubPayStatusResponse {
    public let subscription: M_Subscription
    public let payment: M_PaymentInfo
    
    init?(data: JSON) {
        guard
            let sub = M_Subscription(data: data["subscription"]),
            let payment = M_PaymentInfo(data: data["payment"]) else { return nil }
        self.subscription = sub
        self.payment = payment
    }
}
