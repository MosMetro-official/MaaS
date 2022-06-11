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
    let payment: PayData
    let additionalData: [AppData]
    
    static func purchaseRequestSub(with maasId: String, completion: @escaping (Result<M_SubPayStartResponse, Error>) -> Void) {
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
                let startPayResponse = M_SubPayStartResponse(data: json)
                completion(.success(startPayResponse))
                return
            case .failure(let error):
                completion(.failure(error))
                return
            }
        }
    }
}

enum PaymentMethod: String {
    case CARD = "CARD"
    case APAY = "APAY"
    case GPAY = "GPAY"
    case SPAY = "SPAY"
}

struct PayData {
    let paymentMethod: PaymentMethod
    let redirectUrl: RedirectUrl
    let paymentToken: String
    let id: String
}

struct RedirectUrl {
    let succeed: String
    let declined: String
    let canceled: String
}

struct AppData {
    let serviceId: String
    let key: String
    let value: String
}
