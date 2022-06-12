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
    let payment: M_PayData
    let additionalData: [M_AppData]
    
    static func purchaseRequestSub(with maasId: String, completion: @escaping (Result<M_SubPayStartResponse, APIError>) -> Void) {
        let payment: [String: String] = [:]
        let additionalData: [String: String] = [:]
        
        let body: [String: Any] = [
            "maaSTariffId": maasId,
            "payment": payment,
            "additionalData": additionalData
        ]
        
        let client = APIClient.authClient
        client.send(.POST(path: "/api/subscription/v1/pay/start", body: body, contentType: .json)) { result in
            switch result {
            case .success(let response):
                let json = JSON(response.data)
                guard let startPayResponse = M_SubPayStartResponse(data: json) else {
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

enum M_PaymentMethod: String {
    case CARD = "CARD"
    case APAY = "APAY"
    case GPAY = "GPAY"
    case SPAY = "SPAY"
}

struct M_PayData {
    let paymentMethod: M_PaymentMethod
    let redirectUrl: M_RedirectUrl
    let paymentToken: String
    let id: String
}

struct M_RedirectUrl {
    let succeed: String
    let declined: String
    let canceled: String
}

struct M_AppData {
    let serviceId: String
    let key: String
    let value: String
}
