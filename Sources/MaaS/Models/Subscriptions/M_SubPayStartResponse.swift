//
//  M_SubPayStartResponse.swift
//  MaaS
//
//  Created by Слава Платонов on 11.06.2022.
//

import Foundation
import MMCoreNetworkAsync

public struct M_SubPayStartResponse: Codable {
    public let paymentId: String
    public let subscription: M_Subscription?
}

public struct M_SubPayStatusResponse: Codable {
    public let subscription: M_Subscription
    public let payment: M_PaymentInfo
}
