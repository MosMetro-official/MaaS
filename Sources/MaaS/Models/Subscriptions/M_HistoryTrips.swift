//
//  M_HistoryTrips.swift
//  MaaS
//
//  Created by Слава Платонов on 11.06.2022.
//

import Foundation
import MMCoreNetworkCallbacks

struct M_HistoryTrips {
    let subscription: M_SubscriptionInfo
    let trip: TripDetails
    
    init(data: JSON) {
        self.subscription = M_SubscriptionInfo(data: data["subscription"])
        self.trip = TripDetails(data: data["trip"])
    }
    
    static func getHistoryTrips(by limit: Int, and offset: Int, completion: @escaping (Result<[M_HistoryTrips], Error>) -> Void) {
        let client = APIClient.authClient
        let query = [
            "limit": "\(limit)",
            "offset": "\(offset)"
        ]
        client.send(.GET(path: "/api/user/v1/trips", query: query)) { result in
            switch result {
            case .success(let response):
                let json = JSON(response.data)
                guard let array = json["data"].array else { return }
                let trips = array.map { M_HistoryTrips(data: $0) }
                completion(.success(trips))
                return
            case .failure(let error):
                completion(.failure(error))
                return
            }
        }
    }
}

struct TripDetails {
    let serviceTripId: String
    let terminalId: String
    let count: Int
    let time: TravelTime
    let status: String
    let serviceId: String
    let route: Description
    
    init(data: JSON) {
        self.serviceTripId = data["serviceTripId"].stringValue
        self.terminalId = data["terminalId"].stringValue
        self.count = data["count"].intValue
        self.time = TravelTime(data: data["time"])
        self.status = data["status"].stringValue
        self.serviceId = data["serviceId"].stringValue
        self.route = Description(data: data["route"])
    }
}

struct TravelTime {
    let start: String
    let end: String
    
    init(data: JSON) {
        self.start = data["start"].stringValue
        self.end = data["end"].stringValue
    }
}
