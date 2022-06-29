//
//  M_DateConverter.swift
//  MaaS
//
//  Created by Слава Платонов on 28.06.2022.
//

import Foundation

// TODO: - set valid date

public struct M_DateConverter {
    public static func validateStringFrom(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        dateFormatter.locale = .current
        dateFormatter.calendar = .current
        return dateFormatter.string(from: date)
    }
}
