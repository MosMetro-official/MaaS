//
//  M_BaseResponse.swift
//  MaaS
//
//  Created by Слава Платонов on 21.09.2022.
//

import Foundation

struct M_BaseResponse<T: Decodable>: Decodable {
    let success: Bool
    let data: T
    
    private enum CodingKeys: String, CodingKey {
        case success, data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try container.decode(Bool.self, forKey: .success)
        data = try container.decode(T.self, forKey: .data)
    }
}
