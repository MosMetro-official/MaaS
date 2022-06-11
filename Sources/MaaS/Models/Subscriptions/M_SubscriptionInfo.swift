//
//  M_SubscriptionInfo.swift
//  MaaS
//
//  Created by Слава Платонов on 10.06.2022.
//

import Foundation
import MMCoreNetworkCallbacks


struct M_SubscriptionInfo {
    let id: String
    let price: Int
    let name: Description
    let description: Description
    let duration: Int
    let services: [Service]
    let serviceID: String
    let valid: Valid
    let status: String
    
    init(data: JSON) {
        self.id = data["id"].stringValue
        self.price = data["price"].intValue
        self.name = Description(data: data["name"])
        self.description = Description(data: data["description"])
        self.duration = data["duration"].intValue
        self.services = data["services"].arrayValue.map { Service(data: $0) }
        self.serviceID = data["serviceId"].stringValue
        self.valid = Valid(data: data["valid"])
        self.status = data["status"].stringValue
    }
    
    static func getSubscriptions(completion: @escaping (Result<[M_SubscriptionInfo], Error>) -> Void) {
        let client = APIClient.authClient
        client.send(.GET(path: "/api/subscription/v1/list")) { result in
            switch result {
            case .success(let response):
                let json = JSON(response.data)
                guard let array = json["data"].array else { return }
                let subscriptions = array.map { M_SubscriptionInfo(data: $0) }
                completion(.success(subscriptions))
                return
            case .failure(let error):
                completion(.failure(error))
                return
            }
        }
    }
}

struct Description {
    let ru: String
    let en: String
    
    init(data: JSON) {
        self.ru = data["ru"].stringValue
        self.en = data["en"].stringValue
    }
}

struct Service {
    let serviceID: String
    let tariffID: String
    let price: Int
    let name: Description
    let description: Description
    let duration: Int
    let trip: Trip
    let access: Bool
    let valid: Valid
    let status: String
    
    init(data: JSON) {
        self.serviceID = data["serviceId"].stringValue
        self.tariffID = data["tariffId"].stringValue
        self.price = data["price"].intValue
        self.name = Description(data: data["name"])
        self.description = Description(data: data["description"])
        self.duration = data["duration"].intValue
        self.trip = Trip(data: data["trip"])
        self.access = data["access"].boolValue
        self.valid = Valid(data: data["valid"])
        self.status = data["status"].stringValue
    }
}

struct Trip {
    let count: Int
    let type: String
    let single: Int
    let total: Int
    
    init(data: JSON) {
        self.count = data["count"].intValue
        self.type = data["type"].stringValue
        self.single = data["single"].intValue
        self.total = data["total"].intValue
    }
}

struct Valid {
    let from: String
    let to: String
    
    init(data: JSON) {
        self.from = data["from"].stringValue
        self.to = data["to"].stringValue
    }
}

extension M_SubscriptionInfo: Equatable {
    static func == (lhs: M_SubscriptionInfo, rhs: M_SubscriptionInfo) -> Bool {
        return lhs.name.ru == rhs.name.ru
    }
}
