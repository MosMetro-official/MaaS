//
//  Ext+URLRequest.swift
//  MaaS
//
//  Created by Слава Платонов on 10.06.2022.
//

import Foundation

extension URLRequest {
        
    enum Headers: String {
        case deviceHeader = "X-DeviceID"
        case sessionHeader = "X-SessionID"
        case contentHeader = "Content-Type"
        case contentLength = "Content-Length"
        case languageHeader = "Accept-Language"
        case userAgentHeader = "User-Agent"
        case apiVariantHeader = "X-API-Variant"
        case applicationHeader = "Application"
        case authorizationHeader = "Authorization"
        
        static var device = deviceHeader.rawValue
        static var length = contentLength.rawValue
        static var session = sessionHeader.rawValue
        static var content = contentHeader.rawValue
        static var language = languageHeader.rawValue
        static var userAgent = userAgentHeader.rawValue
        static var application = applicationHeader.rawValue
        static var authorization = authorizationHeader.rawValue
        static var apiVariant = apiVariantHeader.rawValue
    }
    
    mutating func appendAuthHeaders() {
        appendBasicHeaders()
        if let authToken = MaaS.shared.token {
            self.setValue("Bearer \(authToken)", forHTTPHeaderField: Headers.application)
            self.setValue("Bearer \(authToken)", forHTTPHeaderField: Headers.authorization)
        }
    }
    
    mutating func appendBasicHeaders() {
        self.setValue(MaaS.shared.deviceUUID, forHTTPHeaderField: Headers.device)
        self.setValue(MaaS.shared.deviceUserAgent, forHTTPHeaderField: Headers.userAgent)
        self.setValue(MaaS.shared.language, forHTTPHeaderField: Headers.language)
    }
}
