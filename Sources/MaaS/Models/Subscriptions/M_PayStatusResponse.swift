//
//  M_PayStatusResponse.swift
//  MaaS
//
//  Created by Слава Платонов on 12.06.2022.
//

import Foundation
import MMCoreNetworkCallbacks

struct M_PayStatusResponse {
    let subscription: M_Subscription
    let payment: M_PaymentInfo
    
    init?(data: JSON) {
        guard
            let sub = M_Subscription(data: data["subscription"]),
            let payment = M_PaymentInfo(data: data["payment"]) else { return nil }
        self.subscription = sub
        self.payment = payment
    }
    
    static func statusOfPayment(for paymentId: String, completion: @escaping (Result<M_PayStatusResponse, APIError>) -> Void) {
        let query: [String: String] = ["paymentId": "\(paymentId)"]
        let client = APIClient.authClient
        client.send(.GET(path: "/api/subscription/v1/pay/status", query: query)) { result in
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
    let authInfo: M_AuthInfo?
    
    init?(data: JSON) {
        self.url = data["url"].stringValue
        self.authInfo = M_AuthInfo(data: data["auth"])
    }
}

public enum PayStatus: String {
    case unknown = "UNKNOWN"
    case created = "CREATED"
    case processing = "PROCESSING"
    case active = "ACTIVE"
    case expired = "EXPIRED"
    case canceled = "CANCELED"
    case maasError = "MAAS_KEY_ERROR"
    case undefined = "UNDEFINED"
    case refused = "REFUSED"
    case declined = "DECLINED"
    case error = "ERROR"
    case preauth = "PREAUTH"
    case authCanceled = "AUTH_CANCELED"
    case hold = "HOLD"
}

public struct M_AuthInfo {
    let status: M_AuthStatus?
    let date: String
    let rnn: String
    let code: String
    let card: M_CardInfo?
    let receiptUrl: String?

    init?(data: JSON) {
        guard
            let rnn = data["rnn"].string,
            let code = data["code"].string else { return nil }

        self.status = M_AuthStatus(data: data["status"])
        self.date = data["date"].stringValue
        self.rnn = rnn
        self.code = code
        self.card = M_CardInfo(data: data["card"])
        self.receiptUrl = data["receiptUrl"].stringValue
    }
}

struct M_AuthStatus {
    let responseCode: String
    let responseDescr: String
    let status: PayStatus?

    init?(data: JSON) {
        guard
            let responseCode = data["responseCode"].string,
            let responseDescr = data["responseDescr"].string,
            let status = data["status"].string else { return nil }

        self.responseCode = responseCode
        self.responseDescr = responseDescr
        self.status = PayStatus(rawValue: status)
    }
}

public enum PaySystem: String {
    case visa = "VISA"
    case mc = "MC"
    case mir = "MIR"
    case cup = "CUP"
    case unknown = "UNKNOWN_PS"
}

struct M_CardInfo {
    let hashKey: String
    let paySystem: PaySystem?
    let type: String
    let maskedPan: String
    let expDate: String
    let cardId: String

    init?(data: JSON) {
        guard
            let hash = data["hashKey"].string,
            let type = data["type"].string,
            let maskedPan = data["maskedPan"].string,
            let expDate = data["expDate"].string,
            let cardId = data["cardId"].string else { return nil }

        self.hashKey = hash
        self.paySystem = PaySystem(rawValue: data["paySystem"].stringValue)
        self.type = type
        self.maskedPan = maskedPan
        self.expDate = expDate
        self.cardId = cardId
    }
}
