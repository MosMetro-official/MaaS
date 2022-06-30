//
//  Ext+String.swift
//  MaaS
//
//  Created by Слава Платонов on 16.06.2022.
//

import Foundation
extension String {
    
    static func randomString(of length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var s = ""
        for _ in 0 ..< length {
            s.append(letters.randomElement()!)
        }
        return s
    }
    
    public func converToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: self) ?? nil
    }
}
