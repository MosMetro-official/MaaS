//
//  M_HistoryTrips.swift
//  MaaS
//
//  Created by Слава Платонов on 11.06.2022.
//

import Foundation
import MMCoreNetworkCallbacks

struct M_HistoryTrips {
    let subscription: M_Subscription
    let trip: M_TripDetails
    
    init?(data: JSON) {
        guard
            let sub = M_Subscription(data: data["subscription"]),
            let trip = M_TripDetails(data: data["trip"]) else { return nil }
        self.subscription = sub
        self.trip = trip
    }
    
    static func fetchHistoryTrips(by limit: Int, completion: @escaping (Result<[M_HistoryTrips], APIError>) -> Void) {
        let client = APIClient.authClient
        let query = ["limit": "\(limit)"]
        client.send(.GET(path: "/api/user/v1/trips", query: query)) { result in
            switch result {
            case .success(let response):
                let json = JSON(response.data)
                guard let array = json["data"].array else {
                    completion(.failure(.badMapping))
                    return
                }
                let trips = array.compactMap { M_HistoryTrips(data: $0) }
                completion(.success(trips))
                return
            case .failure(let error):
                completion(.failure(error))
                return
            }
        }
    }
}

public enum TripStatus: String {
    case started = "STARTED"
    case done = "DONE"
    case canceled = "CANCELED"
}

struct M_TripDetails {
    let serviceTripId: String
    let terminalId: String
    let count: Int
    let time: M_TravelTime
    let status: TripStatus?
    let serviceId: String
    let route: M_Description
    
    init?(data: JSON) {
        guard
            let serviceTripId = data["serviceTripId"].string,
            let terminalId = data["terminalId"].string,
            let count = data["count"].int,
            let time = M_TravelTime(data: data["time"]),
            let status = data["status"].string,
            let serviceId = data["serviceId"].string,
            let route = M_Description(data: data["route"]) else { return nil }
                
        self.serviceTripId = serviceTripId
        self.terminalId = terminalId
        self.count = count
        self.time = time
        self.status = TripStatus(rawValue: status)
        self.serviceId = serviceId
        self.route = route
    }
}

struct M_TravelTime {
    let start: String
    let end: String
    
    init?(data: JSON) {
        guard let start = data["start"].string, let end = data["end"].string else { return nil }
        self.start = start
        self.end = end
    }
}
