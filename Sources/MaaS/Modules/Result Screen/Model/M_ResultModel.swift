//
//  M_ResultModel.swift
//  MaaS
//
//  Created by Слава Платонов on 26.06.2022.
//

import Foundation

enum M_ResultModel {
    case successSub(M_Subscription)
    case failureSub(id: String)
    case successCard(M_UserInfo)
    case failureCard
    case none
}
