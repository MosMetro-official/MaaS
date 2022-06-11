//
//  M_CurrentSubInfo.swift
//  MaaS
//
//  Created by Слава Платонов on 11.06.2022.
//

import Foundation
import MMCoreNetworkCallbacks

struct M_CurrentSubInfo {
    let subscription: M_SubscriptionInfo
    let payment: M_AuthInfo
    
    init(data: JSON) {
        self.subscription = M_SubscriptionInfo(data: data["subscription"])
        self.payment = M_AuthInfo(data: data["payment"])
    }
    
    static func getCurrentStatusOfUser(completion: @escaping (Result<M_CurrentSubInfo, Error>) -> Void) {
        let client = APIClient.authClient
        client.send(.GET(path: "/api/subscription/v1/info")) { result in
            switch result {
            case .success(let response):
                let json = JSON(response.data)
                let currentSubInfo = M_CurrentSubInfo(data: json)
                completion(.success(currentSubInfo))
                return
            case .failure(let error):
                completion(.failure(error))
                return
            }
        }
    }
}

struct M_AuthInfo {
    let status: M_AuthStatus
    let date: String
    let rnn: String
    let code: String
    let card: M_CardInfo
    let receiptUrl: String?
    
    init(data: JSON) {
        self.status = M_AuthStatus(data: data["status"])
        self.date = data["date"].stringValue
        self.rnn = data["rnn"].stringValue
        self.code = data["code"].stringValue
        self.card = M_CardInfo(data: data["card"])
        self.receiptUrl = data["receiptUrl"].string
    }
}

struct M_AuthStatus {
    let responseCode: String
    let responseDescr: String
    let status: String
    
    init(data: JSON) {
        self.responseCode = data["responseCode"].stringValue
        self.responseDescr = data["responseDescr"].stringValue
        self.status = data["status"].stringValue
    }
}

struct M_CardInfo {
    let hashKey: String
    let paySystem: String
    let type: String
    let maskedPan: String
    let expDate: String
    let cardId: String
    
    init(data: JSON) {
        self.hashKey = data["hashKey"].stringValue
        self.paySystem = data["paySystem"].stringValue
        self.type = data["type"].stringValue
        self.maskedPan = data["maskedPan"].stringValue
        self.expDate = data["expDate"].stringValue
        self.cardId = data["cardId"].stringValue
    }
}
