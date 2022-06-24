//
//  M_Utils.swift
//  MaaS
//
//  Created by Слава Платонов on 24.06.2022.
//

import Foundation

public struct M_Utils {
    public static func getCurrentDate(from string: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let date = dateFormatter.date(from: string) {
            dateFormatter.dateFormat = "dd MMMM yyyy"
            dateFormatter.locale = .current
            return dateFormatter.string(from: date)
        }
        return "неизвестно"
    }
}
