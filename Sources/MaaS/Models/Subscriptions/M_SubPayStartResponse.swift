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
    
    init(data: JSON) {
        self.paymentId = data["paymentId"].stringValue
        self.subscription = M_SubscriptionInfo(data: data["subscription"])
    }
}
