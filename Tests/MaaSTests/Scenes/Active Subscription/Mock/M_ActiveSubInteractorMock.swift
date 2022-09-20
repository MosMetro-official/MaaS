//
//  M_ActiveSubInteractorMock.swift
//  MaaSTests
//
//  Created by Слава Платонов on 20.09.2022.
//

import Foundation
@testable import MaaS

final class M_ActiveSubInteractorMock: M_ActiveSubBusinessLogic {
    
    private(set) var isCalledFetchUser = false
    private(set) var isCalledFetchSupport = false
    private(set) var isCalledFetchDebt = false

    func fetchUserInfo() {
        isCalledFetchUser = true
    }
    
    func fetchSupportUrl() {
        isCalledFetchSupport = true
    }
    
    func checkCardUpdates() {
        isCalledFetchDebt = true
    }
}
