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
    
//    func createRequestBody() -> [String: Any] {
//        var result = [String: Any]()
//        result.updateValue(maaSTariffId, forKey: "maaSTariffId")
//        let paymentBody = payment.createRequestBody()
//        result.updateValue(paymentBody, forKey: "payment")
//        return result
//    }
    
    public static func sendRequestSub(with body: M_SubPayStartRequest) async throws -> M_SubPayStartResponse {
        let client = APIClient.authClient
        let response = try await client.send(.POST(path: "/api/subscription/v1/pay/start", body: body, contentType: .json))
        let subPayResponse = try JSONDecoder().decode(M_SubPayStartResponse.self, from: response.data)
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
    
//    func createRequestBody() -> [String: Any] {
//        var result = [String: Any]()
//        result.updateValue(M_PaymentMethod.card.rawValue, forKey: "paymentMethod")
//        let redirectBody = redirectUrl.createRequsetBody()
//        result.updateValue(redirectBody, forKey: "redirectUrl")
//        return result
//    }
}

public struct M_RedirectUrl: Codable {
    public let succeed: String
    public let declined: String
    public let canceled: String
    
//    func createRequsetBody() -> [String: Any] {
//        var result = [String: Any]()
//        result.updateValue(succeed, forKey: "succeed")
//        result.updateValue(declined, forKey: "declined")
//        result.updateValue(canceled, forKey: "canceled")
//        return result
//    }
}

public struct M_AppData: Codable {
    public let serviceId: String
    public let key: String
    public let value: String
}
