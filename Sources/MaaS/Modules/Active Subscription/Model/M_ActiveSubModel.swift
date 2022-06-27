//
//  M_ActiveSubModel.swift
//  MaaS
//
//  Created by Слава Платонов on 24.06.2022.
//

import Foundation

typealias Debet = (hasDebet: Bool, totalDebet: Int)

public struct M_ActiveSubModel {
    
    var userInfo: M_UserInfo?
    var debits: [M_DebtInfo]?
    var newMaskedPan: String?
    var oldMaskedPan: String?
    var repeats: Int = 0
    
    var debetInfo: Debet {
        checkAllPossibleDebets()
    }
    
    var needReloadCard: Bool {
        newMaskedPan == oldMaskedPan
    }
    
    init(userInfo: M_UserInfo? = nil, debits: [M_DebtInfo]? = nil) {
        self.userInfo = userInfo
        self.debits = debits
    }
    
    private func checkAllPossibleDebets() -> (Bool, Int) {
        guard let debits = debits else { return (false, 0) }
        let total = debits.reduce(0) { $0 + $1.amount }
        return (total != 0, total)
    }
}
