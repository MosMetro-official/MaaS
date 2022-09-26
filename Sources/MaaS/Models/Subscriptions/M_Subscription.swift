//
//  M_SubscriptionInfo.swift
//  MaaS
//
//  Created by Слава Платонов on 10.06.2022.
//

import Foundation
import MMCoreNetworkAsync


public enum Status: String, Codable {
    case unknown = "UNKNOWN" // процесс оформления подписки
    case created = "CREATED" // процесс оплаты подписки
    case processing = "PROCESSING" // процесс оплаты подписки
    case active = "ACTIVE" // действующая
    case expired = "EXPIRED" // срок действия истек
    case canceled = "CANCELED" // аннулирована
    case blocked = "BLOCKED" // заблокирован
    case maasError = "MAAS_ERROR"
    case undefined = "UNDEFINED"
    case refused = "REFUSED"
    case declined = "DECLINED"
    case error = "ERROR"
    case preauth = "PREAUTH"
    case authCanceled = "AUTH_CANCELED"
    case hold = "HOLD"
    case reserved = "RESERVED"
}

public struct M_Description: Codable {
    public let ru: String
    public let en: String
}

public struct M_Subscription: Codable {
    public let id: String
    public let price: Int
    public let name: M_Description?
    public let description: M_Description?
    public let duration: Int
    public let tariffs: [M_Tariff]
    public let serviceId: String?
    public let valid: M_Valid?
    public let status: Status?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case price
        case name
        case description
        case duration
        case tariffs = "services"
        case serviceId
        case valid
        case status
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.price = try container.decode(Int.self, forKey: .price)
        self.name = try container.decodeIfPresent(M_Description.self, forKey: .name)
        self.description = try container.decodeIfPresent(M_Description.self, forKey: .description)
        self.duration = try container.decode(Int.self, forKey: .duration)
        self.tariffs = try container.decode([M_Tariff].self, forKey: .tariffs)
        self.serviceId = try container.decodeIfPresent(String.self, forKey: .serviceId)
        self.valid = try container.decodeIfPresent(M_Valid.self, forKey: .valid)
        self.status = try container.decodeIfPresent(Status.self, forKey: .status)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.price, forKey: .price)
        try container.encodeIfPresent(self.name, forKey: .name)
        try container.encodeIfPresent(self.description, forKey: .description)
        try container.encode(self.duration, forKey: .duration)
        try container.encode(self.tariffs, forKey: .tariffs)
        try container.encodeIfPresent(self.serviceId, forKey: .serviceId)
        try container.encodeIfPresent(self.valid, forKey: .valid)
        try container.encodeIfPresent(self.status, forKey: .status)
    }
    
    static func fetchSubscriptions() async throws -> [M_Subscription] {
        let client = APIClient.authClient
        let response = try await client.send(.GET(path: "/api/subscription/v1/list"))
        let subscriptions = try JSONDecoder().decode(M_BaseResponse<[M_Subscription]>.self, from: response.data).data
        return subscriptions
    }
}

extension M_Subscription: Equatable {
    public static func == (lhs: M_Subscription, rhs: M_Subscription) -> Bool {
        return lhs.id == rhs.id
    }
}

public struct M_Tariff: Codable {
    public let serviceId: String
    public let tariffId: String
    public let imageURL: String
    public let price: Int
    public let name: M_Description?
    public let description: M_Description?
    public let duration: Int
    public let trip: M_Trip
    public let access: Bool
    public let valid: M_Valid?
    public let status: Status?
    
    private enum CodingKeys: String, CodingKey {
        case serviceId
        case tariffId
        case imageURL
        case price
        case name
        case description
        case duration
        case trip
        case access
        case valid
        case status
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.serviceId = try container.decode(String.self, forKey: .serviceId)
        self.tariffId = try container.decode(String.self, forKey: .tariffId)
        self.imageURL = try container.decode(String.self, forKey: .imageURL)
        self.price = try container.decode(Int.self, forKey: .price)
        self.name = try container.decodeIfPresent(M_Description.self, forKey: .name)
        self.description = try container.decodeIfPresent(M_Description.self, forKey: .description)
        self.duration = try container.decode(Int.self, forKey: .duration)
        self.trip = try container.decode(M_Trip.self, forKey: .trip)
        self.access = try container.decode(Bool.self, forKey: .access)
        self.valid = try container.decodeIfPresent(M_Valid.self, forKey: .valid)
        self.status = try container.decodeIfPresent(Status.self, forKey: .status)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.serviceId, forKey: .serviceId)
        try container.encode(self.tariffId, forKey: .tariffId)
        try container.encode(self.imageURL, forKey: .imageURL)
        try container.encode(self.price, forKey: .price)
        try container.encodeIfPresent(self.name, forKey: .name)
        try container.encodeIfPresent(self.description, forKey: .description)
        try container.encode(self.duration, forKey: .duration)
        try container.encode(self.trip, forKey: .trip)
        try container.encode(self.access, forKey: .access)
        try container.encodeIfPresent(self.valid, forKey: .valid)
        try container.encodeIfPresent(self.status, forKey: .status)
    }
}

public struct M_Trip: Codable {
    
    public enum TripType: String, Codable {
        case amount = "AMOUNT"
        case time = "TIME"
        case distance = "DISTANCE"
        case count = "COUNT"
    }
    
    public let count: Int
    public let type: TripType?
    public let single: Int
    public let total: Int
    
    public var countDescr: String {
        switch count {
        case -1:
            return "Безлимит"
        default:
            return "\(count) поездок"
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.count = try container.decode(Int.self, forKey: .count)
        self.type = try container.decodeIfPresent(M_Trip.TripType.self, forKey: .type)
        self.single = try container.decode(Int.self, forKey: .single)
        self.total = try container.decode(Int.self, forKey: .total)
    }
}

public struct M_Valid: Codable {
    public let from: Date?
    public let to: Date?
    
    enum CodingKeys: String, CodingKey {
        case from
        case to
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let from = try container.decodeIfPresent(String.self, forKey: .from)
        let to = try container.decodeIfPresent(String.self, forKey: .to)
        self.from = from?.converToDate()
        self.to = to?.converToDate()
    }
}
