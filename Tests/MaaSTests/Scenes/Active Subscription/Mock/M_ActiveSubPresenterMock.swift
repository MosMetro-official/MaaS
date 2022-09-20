//
//  M_ActiveSubPresenterMock.swift
//  MaaSTests
//
//  Created by Слава Платонов on 20.09.2022.
//

import Foundation
@testable import MaaS

final class M_ActiveSubPresenterMock: M_ActiveSubPresentationLogic {
    
    private(set) var isCalledPrepareResult = false
    private(set) var isCalledPrepareError = false
    private(set) var isCalledPrepareLoading = false
    private(set) var isCalledPrepareSupport = false
    private(set) var isCalledPrepareDebt = false

    func prepareResultState(_ response: M_ActiveSubModels.Response.UserInfo) {
        isCalledPrepareResult = true
    }
    
    func prepareError(_ response: M_ActiveSubModels.Response.Error) {
        isCalledPrepareError = true
    }
    
    func prepareLoading(_ response: M_ActiveSubModels.Response.Loading) {
        isCalledPrepareLoading = true
    }
    
    func prepareSupportForm(_ response: M_ActiveSubModels.Response.SupportForm) {
        isCalledPrepareSupport = true
    }
    
    func prepareDebtNotifications(_ response: M_ActiveSubModels.Response.Debt) {
        isCalledPrepareDebt = true
    }
}
