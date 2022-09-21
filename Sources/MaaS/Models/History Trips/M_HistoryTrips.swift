//
//  M_HistoryTrips.swift
//  MaaS
//
//  Created by Слава Платонов on 11.06.2022.
//

import Foundation
import MMCoreNetworkAsync

public struct M_HistoryTrips: Codable {
    let subscription: M_Subscription
    let trip: M_TripDetails
    let imageURL: URL?
    
    static func fetchHistoryTrips(by limit: Int, offset: Int) async throws -> [M_HistoryTrips] {
        let client = APIClient.authClient
        let query = ["limit": "\(limit)", "offset": "\(offset)"]
        let response = try await client.send(.GET(path: "/api/user/v1/trips", query: query))
        let trips = try JSONDecoder().decode([M_HistoryTrips].self, from: response.data)
        return trips
    }
}

public enum TripStatus: String, Codable {
    case started = "STARTED"
    case done = "DONE"
    case canceled = "CANCELED"
}

public struct M_TripDetails: Codable {
    let serviceTripId: String
    let terminalId: String
    let count: Int
    let time: M_TravelTime
    let status: TripStatus?
    let serviceId: String
    let route: M_Description
    
    private enum CodingKeys: String, CodingKey {
        case serviceTripId
        case terminalId
        case count
        case time
        case status
        case serviceId
        case route
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: M_TripDetails.CodingKeys.self)
        serviceTripId = try values.decode(String.self, forKey: .serviceTripId)
        terminalId = try values.decode(String.self, forKey: .terminalId)
        count = try values.decode(Int.self, forKey: .count)
        time = try values.decode(M_TravelTime.self, forKey: .time)
        status = try values.decodeIfPresent(TripStatus.self, forKey: .status)
        serviceId = try values.decode(String.self, forKey: .serviceId)
        route = try values.decode(M_Description.self, forKey: .route)
    }
}

public struct M_TravelTime: Codable {
    let start: Date?
    let end: Date?
    
    enum CodingKeys: CodingKey {
        case start
        case end
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let start = try container.decodeIfPresent(String.self, forKey: .start)
        let end = try container.decodeIfPresent(String.self, forKey: .end)
        self.start = start?.converToDate()
        self.end = end?.converToDate()
    }
}
