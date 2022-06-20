//
//  M_AuthInfo.swift
//  MaaS
//
//  Created by Слава Платонов on 11.06.2022.
//

import Foundation
import MMCoreNetworkCallbacks

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
