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
    
    private enum CodingKeys: String, CodingKey {
        case paymentId
        case subscription
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.paymentId, forKey: .paymentId)
        try container.encodeIfPresent(self.subscription, forKey: .subscription)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.paymentId = try container.decode(String.self, forKey: .paymentId)
        self.subscription = try container.decodeIfPresent(M_Subscription.self, forKey: .subscription)
    }
}

public struct M_SubPayStatusResponse: Codable {
    public let subscription: M_Subscription
    public let payment: M_PaymentInfo
}
