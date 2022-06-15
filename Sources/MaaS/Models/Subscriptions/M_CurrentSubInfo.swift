//
//  M_CurrentSubInfo.swift
//  MaaS
//
//  Created by Слава Платонов on 11.06.2022.
//

import Foundation
import MMCoreNetworkCallbacks

public struct M_CurrentSubInfo {
    let subscription: M_SubscriptionInfo
    let payment: M_AuthInfo?
    
    init?(data: JSON) {
        guard let sub = M_SubscriptionInfo(data: data["subscription"]) else { return nil }
        self.subscription = sub
        self.payment = M_AuthInfo(data: data["payment"])
    }
    
    static func getCurrentStatusOfUser(completion: @escaping (Result<M_CurrentSubInfo, APIError>) -> Void) {
        let client = APIClient.authClient
        client.send(.GET(path: "/api/subscription/v1/info")) { result in
            switch result {
            case .success(let response):
                let json = JSON(response.data)
                guard let currentSubInfo = M_CurrentSubInfo(data: json["data"]) else {
                    completion(.failure(.badMapping))
                    return
                }
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
    let status: String
    
    init?(data: JSON) {
        guard
            let responseCode = data["responseCode"].string,
            let responseDescr = data["responseDescr"].string,
            let status = data["status"].string else { return nil }
        
        self.responseCode = responseCode
        self.responseDescr = responseDescr
        self.status = status
    }
}

struct M_CardInfo {
    let hashKey: String
    let paySystem: String
    let type: String
    let maskedPan: String
    let expDate: String
    let cardId: String
    
    init?(data: JSON) {
        guard
            let hash = data["hashKey"].string,
            let pay = data["paySystem"].string,
            let type = data["type"].string,
            let maskedPan = data["maskedPan"].string,
            let expDate = data["expDate"].string,
            let cardId = data["cardId"].string else { return nil }
        
        self.hashKey = hash
        self.paySystem = pay
        self.type = type
        self.maskedPan = maskedPan
        self.expDate = expDate
        self.cardId = cardId
    }
}
