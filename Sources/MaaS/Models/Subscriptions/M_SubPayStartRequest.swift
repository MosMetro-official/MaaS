//
//  M_SubPayStartRequest.swift
//  MaaS
//
//  Created by Слава Платонов on 11.06.2022.
//

import Foundation
import MMCoreNetworkCallbacks

struct M_SubPayStartRequest {
    let maaSTariffId: String
    let payment: M_PayDataSub
    let additionalData: [M_AppData]?
    
    func createRequestBody() -> [String: Any] {
        var result = [String: Any]()
        result.updateValue(maaSTariffId, forKey: "maaSTariffId")
        let paymentBody = payment.createRequestBody()
        result.updateValue(paymentBody, forKey: "payment")
        return result
    }
    
    static func sendRequestSub(with body: [String: Any], completion: @escaping (Result<M_SubPayStartResponse, APIError>) -> Void) {
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

struct M_PayDataSub {
    let paymentMethod: M_PaymentMethod?
    let redirectUrl: M_RedirectUrl
    let paymentToken: String?
    let id: String?
    
    func createRequestBody() -> [String: Any] {
        var result = [String: Any]()
        result.updateValue(M_PaymentMethod.card.rawValue, forKey: "paymentMethod")
        let redirectBody = redirectUrl.createRequsetBody()
        result.updateValue(redirectBody, forKey: "redirectUrl")
        return result
    }
}

struct M_RedirectUrl {
    let succeed: String
    let declined: String
    let canceled: String
    
    func createRequsetBody() -> [String: Any] {
        var result = [String: Any]()
        result.updateValue(succeed, forKey: "succeed")
        result.updateValue(declined, forKey: "declined")
        result.updateValue(canceled, forKey: "canceled")
        return result
    }
}

struct M_AppData {
    let serviceId: String
    let key: String
    let value: String
}
