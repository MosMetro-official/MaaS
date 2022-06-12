//
//  M_PayStatusResponse.swift
//  MaaS
//
//  Created by Слава Платонов on 12.06.2022.
//

import Foundation
import MMCoreNetworkCallbacks

struct M_PayStatusResponse {
    let payment: M_PaymentInfo
    
    init?(data: JSON) {
        guard let payment = M_PaymentInfo(data: data["payment"]) else { return nil }
        self.payment = payment
    }
    
    static func statusOfPayment(for paymentId: String, completion: @escaping (Result<M_PayStatusResponse, APIError>) -> Void) {
        let query: [String: String] = ["paymentId": "\(paymentId)"]
        let client = APIClient.authClient
        client.send(.GET(path: "/api/payments/v1/status", query: query)) { result in
            switch result {
            case .success(let response):
                let json = JSON(response.data)
                guard let payResponse = M_PayStatusResponse(data: json["data"]) else {
                    completion(.failure(.badMapping))
                    return
                }
                completion(.success(payResponse))
                return
            case .failure(let error):
                completion(.failure(error))
                return
            }
        }
    }
}

struct M_PaymentInfo {
    let url: String
    let authInfo: M_AuthInfo
    
    init?(data: JSON) {
        guard let url = data["url"].string, let auth = M_AuthInfo(data: data["auth"]) else { return nil }
        self.url = url
        self.authInfo = auth
    }
}
