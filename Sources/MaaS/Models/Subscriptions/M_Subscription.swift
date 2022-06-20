//
//  M_SubscriptionInfo.swift
//  MaaS
//
//  Created by Слава Платонов on 10.06.2022.
//

import Foundation
import MMCoreNetworkCallbacks


public enum Status: String {
    case unknow = "UNKNOWN" // процесс оформления подписки
    case created = "CREATED" // процесс оплаты подписки
    case processing = "PROCESSING" // процесс оплаты подписки
    case active = "ACTIVE" // действующая
    case expired = "EXPIRED" // срок действия истек
    case canceled = "CANCELED" // аннулирована
    case blocked = "BLOCKED" // заблокирован
}

public struct M_Subscription {
    public let id: String
    public let price: Int
    public let name: M_Description?
    public let description: M_Description?
    public let duration: Int
    public let services: [M_Tariff]
    public let serviceId: String?
    public let valid: M_Valid?
    public let status: Status?
    
    init?(data: JSON) {
        self.id = data["id"].stringValue
        self.price = data["price"].intValue
        self.name = M_Description(data: data["name"])
        self.description = M_Description(data: data["description"])
        self.duration = data["duration"].intValue
        self.services = data["services"].arrayValue.compactMap { M_Tariff(data: $0) }
        self.serviceId = data["serviceId"].stringValue
        self.valid = M_Valid(data: data["valid"])
        self.status = Status(rawValue: data["status"].stringValue)
    }
    
    static func fetchSubscriptions(completion: @escaping (Result<[M_Subscription], APIError>) -> Void) {
        let client = APIClient.authClient
        client.send(.GET(path: "/api/subscription/v1/list")) { result in
            switch result {
            case .success(let response):
                let json = JSON(response.data)
                guard let array = json["data"].array else {
                    completion(.failure(.badMapping))
                    return
                }
                let subscriptions = array.compactMap { M_Subscription(data: $0) }
                completion(.success(subscriptions))
                return
            case .failure(let error):
                completion(.failure(error))
                return
            }
        }
    }
}

public struct M_Description {
    public let ru: String
    public let en: String
    
    init?(data: JSON) {
        guard let ru = data["ru"].string, let en = data["en"].string else { return nil }
        self.ru = ru
        self.en = en
    }
}

public struct M_Tariff {
    public let serviceId: String
    public let tariffId: String
    public let imageURL: String
    public let price: Int
    public let name: M_Description
    public let description: M_Description
    public let duration: Int
    public let trip: M_Trip
    public let access: Bool
    public let valid: M_Valid?
    public let status: Status?
    
    init?(data: JSON) {
        guard
            let serviceId = data["serviceId"].string,
            let tariffId = data["tariffId"].string,
            let imgUrl = data["imageURL"].string,
            let price = data["price"].int,
            let name = M_Description(data: data["name"]),
            let descr = M_Description(data: data["description"]),
            let duration = data["duration"].int,
            let trip = M_Trip(data: data["trip"]),
            let access = data["access"].bool,
            let status = data["status"].string else { return nil }
        
        self.serviceId = serviceId
        self.tariffId = tariffId
        self.imageURL = imgUrl
        self.price = price
        self.name = name
        self.description = descr
        self.duration = duration
        self.trip = trip
        self.access = access
        self.valid = M_Valid(data: data["valid"])
        self.status = Status(rawValue: status)
    }
}

public struct M_Trip {
    public let count: Int
    public let type: String
    public let single: Int
    public let total: Int
    
    init?(data: JSON) {
        guard
            let count = data["count"].int,
            let type = data["type"].string,
            let single = data["single"].int,
            let total = data["total"].int else { return nil }
        self.count = count
        self.type = type
        self.single = single
        self.total = total
    }
    
    var countDescr: String {
        switch count {
        case -1:
            return "Безлимит"
        default:
            return "\(count) поездок"
        }
    }
}

public struct M_Valid {
    public let from: String
    public let to: String
    
    init?(data: JSON) {
        guard let from = data["from"].string, let to = data["to"].string else { return nil }
        self.from = from
        self.to = to
    }
}

extension M_Subscription: Equatable {
    public static func == (lhs: M_Subscription, rhs: M_Subscription) -> Bool {
        return lhs.name?.ru == rhs.name?.ru
    }
}
