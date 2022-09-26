//
//  M_SubPayStartRequest.swift
//  MaaS
//
//  Created by Слава Платонов on 11.06.2022.
//

import Foundation
import MMCoreNetworkAsync

public struct M_SubPayStartRequest: Codable {
    public let maaSTariffId: String
    public let payment: M_PayDataSub
    public let additionalData: [M_AppData]?
    
    private enum CodingKeys: String, CodingKey {
        case maaSTariffId
        case payment
        case additionalData
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(maaSTariffId, forKey: .maaSTariffId)
        try container.encode(payment, forKey: .payment)
        try container.encodeIfPresent(additionalData, forKey: .additionalData)
    }
    
    public static func sendRequestSub(with body: M_SubPayStartRequest) async throws -> M_SubPayStartResponse {
        let client = APIClient.authClient
        let response = try await client.send(.POST(path: "/api/subscription/v1/pay/start", body: body, contentType: .json))
        let subPayResponse = try JSONDecoder().decode(M_BaseResponse<M_SubPayStartResponse>.self, from: response.data).data
        return subPayResponse
    }
}

public enum M_PaymentMethod: String, Codable {
    case card = "CARD"
    case apay = "APAY"
    case gpay = "GPAY"
    case spay = "SPAY"
    case mpay = "MPAY"
    case unknown = "UNKNOWN_METHOD"
    case `default` = "DEFAULT"
}

public struct M_PayDataSub: Codable {
    public let paymentMethod: M_PaymentMethod?
    public let redirectUrl: M_RedirectUrl
    public let paymentToken: String?
    public let id: String?
}

public struct M_RedirectUrl: Codable {
    public let succeed: String
    public let declined: String
    public let canceled: String
}

public struct M_AppData: Codable {
    public let serviceId: String
    public let key: String
    public let value: String
}
