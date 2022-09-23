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
    
    public static func sendRequestSub(with subId: String) async throws -> M_SubPayStartResponse {
        let client = APIClient.authClient
        let body = M_SubPayStartRequest(
            maaSTariffId: subId,
            payment: .init(
                paymentMethod: .card,
                redirectUrl: .init(
                    succeed: MaaS.succeedUrl,
                    declined: MaaS.declinedUrl,
                    canceled: MaaS.canceledUrl
                ),
                paymentToken: nil,
                id: nil
            ),
            additionalData: nil
        )
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
