//
//  M_Utils.swift
//  MaaS
//
//  Created by Слава Платонов on 13.07.2022.
//

import Foundation

struct M_Utils {
    public static func validImageUrl(imageURL: String) -> URL? {
        var valid = imageURL.replacingOccurrences(of: "\\", with: "")
        if let p = valid.firstIndex(of: "p") {
            let index = valid.index(after: p)
            valid.insert("s", at: index)
        }
        guard let url = URL(string: valid) else { return nil }
        return url
    }
}
