//
//  M_SubscriptionInfo.swift
//  MaaS
//
//  Created by Слава Платонов on 10.06.2022.
//

import Foundation
import MMCoreNetworkCallbacks

enum Status: String {
    case unknown = "UNKNOWN"
    case created = "CREATED"
    case processing = "PROCESSING"
    case active = "ACTIVE"
    case expired = "EXPIRED"
    case canceled = "CANCELED"
}

struct M_SubscriptionInfo {
    let id: String
    let price: Int
    let name: M_Description?
    let description: M_Description?
    let duration: Int
    let services: [M_Service]
    let serviceId: String?
    let valid: M_Valid?
    let status: Status?
    
    init?(data: JSON) {
        self.id = data["id"].stringValue
        self.price = data["price"].intValue
        self.name = M_Description(data: data["name"])
        self.description = M_Description(data: data["description"])
        self.duration = data["duration"].intValue
        self.services = data["services"].arrayValue.compactMap { M_Service(data: $0) }
        self.serviceId = data["serviceId"].stringValue
        self.valid = M_Valid(data: data["valid"])
        self.status = Status(rawValue: data["status"].stringValue)
    }
    
    static func getSubscriptions(completion: @escaping (Result<[M_SubscriptionInfo], APIError>) -> Void) {
        let client = APIClient.authClient
        client.send(.GET(path: "/api/subscription/v1/list")) { result in
            switch result {
            case .success(let response):
                let json = JSON(response.data)
                guard let array = json["data"].array else {
                    completion(.failure(.badMapping))
                    return
                }
                let subscriptions = array.compactMap { M_SubscriptionInfo(data: $0) }
                completion(.success(subscriptions))
                return
            case .failure(let error):
                completion(.failure(error))
                return
            }
        }
    }
}

struct M_Description {
    let ru: String
    let en: String
    
    init?(data: JSON) {
        guard let ru = data["ru"].string, let en = data["en"].string else { return nil }
        self.ru = ru
        self.en = en
    }
}

struct M_Service {
    let serviceId: String
    let tariffId: String
    let price: Int
    let name: M_Description
    let description: M_Description
    let duration: Int
    let trip: M_Trip
    let access: Bool
    let valid: M_Valid?
    let status: String
    
    init?(data: JSON) {
        guard
            let serviceId = data["serviceId"].string,
            let tariffId = data["tariffId"].string,
            let price = data["price"].int,
            let name = M_Description(data: data["name"]),
            let descr = M_Description(data: data["description"]),
            let duration = data["duration"].int,
            let trip = M_Trip(data: data["trip"]),
            let access = data["access"].bool,
            let status = data["status"].string else { return nil }
        
        self.serviceId = serviceId
        self.tariffId = tariffId
        self.price = price
        self.name = name
        self.description = descr
        self.duration = duration
        self.trip = trip
        self.access = access
        self.valid = M_Valid(data: data["valid"])
        self.status = status
    }
}

struct M_Trip {
    let count: Int
    let type: String
    let single: Int
    let total: Int
    
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

struct M_Valid {
    let from: String
    let to: String
    
    init?(data: JSON) {
        guard let from = data["from"].string, let to = data["to"].string else { return nil }
        self.from = from
        self.to = to
    }
}

extension M_SubscriptionInfo: Equatable {
    static func == (lhs: M_SubscriptionInfo, rhs: M_SubscriptionInfo) -> Bool {
        return lhs.name?.ru == rhs.name?.ru
    }
}
