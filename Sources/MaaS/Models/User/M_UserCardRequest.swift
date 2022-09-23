//
//  M_UserCardRequest.swift
//  MaaS
//
//  Created by Слава Платонов on 16.06.2022.
//

import Foundation
import MMCoreNetworkAsync


public struct M_UserCardRequest: Codable {
    let payData: M_PayData
}

public struct M_PayData: Codable {
    let redirectUrl: M_RedirectUrl
    let paymentMethod: M_PaymentMethod
    
    private enum CodingKeys: String, CodingKey {
        case redirectUrl
        case paymentMethod
    }
}
