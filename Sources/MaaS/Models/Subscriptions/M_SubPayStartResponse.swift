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
    let subscription: M_SubscriptionInfo
    
    init?(data: JSON) {
        guard let id = data["paymentId"].string, let sub = M_SubscriptionInfo(data: data["subscription"]) else { return nil }
        self.paymentId = id
        self.subscription = sub
    }
}
