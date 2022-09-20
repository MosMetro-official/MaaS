//
//  M_ActiveSubControllerMock.swift
//  MaaSTests
//
//  Created by Слава Платонов on 20.09.2022.
//

import UIKit
@testable import MaaS

final class M_ActiveSubControllerMock: M_ActiveDisplayLogic {
    
    private(set) var isCalledDismiss = false
    private(set) var isCalledPushDebet = false
    private(set) var isCalledOpenOnboarding = false
    private(set) var isCalledRequsetUserInfo = false
    private(set) var isCalledRequestCardUpdate = false
    private(set) var isCalledPushHistory = false
    private(set) var isCalledRequestSupportUrl = false
    private(set) var isCalledPushChangeCard = false
    private(set) var isCalledOpenSafari = false
    private(set) var isCalledShowDebtNotification = false
    private(set) var isCalledDisplayUserInfo = false
    
    func dismiss() {
        isCalledDismiss = true
    }
    
    func pushDebtScreen() {
        isCalledPushDebet = true
    }
    
    func openOnboarding() {
        isCalledOpenOnboarding = true
    }
    
    func requestUserInfo() {
        isCalledRequsetUserInfo = true
    }
    
    func requestCardUpdate() {
        isCalledRequestCardUpdate = true
    }
    
    func pushHistoryScreen() {
        isCalledPushHistory = true
    }
    
    func requestSupportUrl() {
        isCalledRequestSupportUrl = true
    }
    
    func pushChangeCardScreen() {
        isCalledPushChangeCard = true
    }
    
    func openSafariController(_ url: URL) {
        isCalledOpenSafari = true
    }
    
    func showDebtNotification(_ notification: M_MaasDebtNotifification) {
        isCalledShowDebtNotification = true
    }
    
    func displayUserInfo(with viewModel: M_ActiveSubModels.ViewModel.ViewState.DataState) {
        isCalledDisplayUserInfo = true
    }
}
