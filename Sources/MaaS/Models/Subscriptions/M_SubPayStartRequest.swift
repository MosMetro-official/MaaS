//
//  M_SubPayStartRequest.swift
//  MaaS
//
//  Created by Слава Платонов on 11.06.2022.
//

import Foundation
import MMCoreNetworkCallbacks

public struct M_SubPayStartRequest {
    public let maaSTariffId: String
    public let payment: M_PayDataSub
    public let additionalData: [M_AppData]?
    
    func createRequestBody() -> [String: Any] {
        var result = [String: Any]()
        result.updateValue(maaSTariffId, forKey: "maaSTariffId")
        let paymentBody = payment.createRequestBody()
        result.updateValue(paymentBody, forKey: "payment")
        return result
    }
    
    public static func sendRequestSub(with body: [String: Any], completion: @escaping (Result<M_SubPayStartResponse, APIError>) -> Void) {
        let client = APIClient.authClient
        client.send(.POST(path: "/api/subscription/v1/pay/start", body: body, contentType: .json)) { result in
            switch result {
            case .success(let response):
                let json = JSON(response.data)
                guard let startPayResponse = M_SubPayStartResponse(data: json["data"]) else {
                    completion(.failure(.badMapping))
                    return
                }
                completion(.success(startPayResponse))
                return
            case .failure(let error):
                completion(.failure(error))
                return
            }
        }
    }
}

public enum M_PaymentMethod: String {
    case card = "CARD"
    case apay = "APAY"
    case gpay = "GPAY"
    case spay = "SPAY"
    case mpay = "MPAY"
    case unknown = "UNKNOWN_METHOD"
    case `default` = "DEFAULT"
}

public struct M_PayDataSub {
    public let paymentMethod: M_PaymentMethod?
    public let redirectUrl: M_RedirectUrl
    public let paymentToken: String?
    public let id: String?
    
    func createRequestBody() -> [String: Any] {
        var result = [String: Any]()
        result.updateValue(M_PaymentMethod.card.rawValue, forKey: "paymentMethod")
        let redirectBody = redirectUrl.createRequsetBody()
        result.updateValue(redirectBody, forKey: "redirectUrl")
        return result
    }
}

public struct M_RedirectUrl {
    public let succeed: String
    public let declined: String
    public let canceled: String
    
    func createRequsetBody() -> [String: Any] {
        var result = [String: Any]()
        result.updateValue(succeed, forKey: "succeed")
        result.updateValue(declined, forKey: "declined")
        result.updateValue(canceled, forKey: "canceled")
        return result
    }
}

public struct M_AppData {
    public let serviceId: String
    public let key: String
    public let value: String
}
