//
//  M_PayStatusResponse.swift
//  MaaS
//
//  Created by Слава Платонов on 12.06.2022.
//

import Foundation
import MMCoreNetworkAsync

public struct M_PayStatusResponse: Codable {
    public let subscription: M_Subscription
    public let payment: M_PaymentInfo
    
    public static func statusOfPayment(for paymentId: String) async throws -> M_PayStatusResponse {
        let query: [String: String] = ["paymentId": "\(paymentId)"]
        let client = APIClient.authClient
        let response = try await client.send(.GET(path: "/api/subscription/v1/pay/status", query: query))
        let payStatus = try JSONDecoder().decode(M_PayStatusResponse.self, from: response.data)
        return payStatus
    }
}

public struct M_PaymentInfo: Codable {
    public let url: String
    public let authInfo: M_AuthInfo?
}

public enum PayStatus: String, Codable, CodingKey {
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

public struct M_AuthInfo: Codable {
    public let status: M_AuthStatus?
    public let date: Date?
    public let rnn: String
    public let code: String
    public let card: M_CardInfo?
    public let receiptUrl: [String]?
    
    enum CodingKeys: CodingKey {
        case status
        case date
        case rnn
        case code
        case card
        case receiptUrl
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try container.decodeIfPresent(M_AuthStatus.self, forKey: .status)
        let date = try container.decodeIfPresent(String.self, forKey: .date)
        self.date = date?.converToDate()
        self.rnn = try container.decode(String.self, forKey: .rnn)
        self.code = try container.decode(String.self, forKey: .code)
        self.card = try container.decodeIfPresent(M_CardInfo.self, forKey: .card)
        self.receiptUrl = try container.decodeIfPresent([String].self, forKey: .receiptUrl)
    }
}

public struct M_AuthStatus: Codable {
    public let responseCode: String
    public let responseDescr: String
    public let status: PayStatus?
}

public enum PaySystem: String, Codable, CodingKey {
    case visa = "VISA"
    case mc = "MC"
    case mir = "MIR"
    case cup = "CUP"
    case unknown = "UNKNOWN_PS"
}

public struct M_CardInfo: Codable {
    public let hashKey: String
    public let paySystem: PaySystem?
    public let type: String
    public let maskedPan: String
    public let expDate: Date?
    public let cardId: String
    
    enum CodingKeys: CodingKey {
        case hashKey
        case paySystem
        case type
        case maskedPan
        case expDate
        case cardId
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.hashKey = try container.decode(String.self, forKey: .hashKey)
        self.paySystem = try container.decodeIfPresent(PaySystem.self, forKey: .paySystem)
        self.type = try container.decode(String.self, forKey: .type)
        self.maskedPan = try container.decode(String.self, forKey: .maskedPan)
        let expDate = try container.decodeIfPresent(String.self, forKey: .expDate)
        self.expDate = expDate?.converToDate()
        self.cardId = try container.decode(String.self, forKey: .cardId)
    }
}
