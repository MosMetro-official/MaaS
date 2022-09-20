//
//  M_ActiveSubRouter.swift
//  MaaS
//
//  Created by Слава Платонов on 02.08.2022.
//

import OnBoardingModule
import CoreAnalytics

protocol M_ActiveRoutingLogic: AnyObject {
    func dismiss()
    func routeToChangeCard(analyticsManager: _AnalyticsManager)
    func routeToOnboarding()
    func routeToHistoryTrips()
    func routeToDebtNotifications(analyticsManager: _AnalyticsManager)
    func routeToSupport(_ safariController: UIViewController)
    func presentDebtNotification(_ notification: M_MaasDebtNotifification)
}

protocol M_ActiveDataPassing: AnyObject {
    var dataStore: M_ActiveDataStore? { get }
}

final class M_ActiveSubRouter: M_ActiveRoutingLogic, M_ActiveDataPassing {
    
    weak var controller: M_ActiveSubController?
    var dataStore: M_ActiveDataStore?
    
    init(controller: M_ActiveSubController? = nil, dataStore: M_ActiveDataStore? = nil) {
        self.controller = controller
        self.dataStore = dataStore
    }
    
    func routeToChangeCard(analyticsManager: _AnalyticsManager) {
        let changeCardController = M_ChangeCardController(analyticsManager: analyticsManager)
        guard
            let activeDataStore = dataStore,
            let changeCardDataStore = changeCardController.router?.dataStore else {
            return
        }
        changeCardDataStore.userInfo = activeDataStore.userInfo
        controller?.navigationController?.pushViewController(changeCardController, animated: true)
    }
    
    func routeToHistoryTrips() {
        let historyController = M_TripsHistoryController()
        controller?.navigationController?.pushViewController(historyController, animated: true)
    }
    
    func routeToSupport(_ safariController: UIViewController) {
        DispatchQueue.main.async {
            self.controller?.present(safariController, animated: true)
        }
    }
    
    func routeToOnboarding() {
        UserDefaults.standard.set(true, forKey: "maasOnboarding")
        let onboarding = OnBoardingModule().getOnboarding(name: "onboarding_ios_maas")
        onboarding.modalTransitionStyle = .crossDissolve
        onboarding.modalPresentationStyle = .fullScreen
        controller?.present(onboarding, animated: true)
    }
    
    func routeToDebtNotifications(analyticsManager: _AnalyticsManager) {
        let debtNotification = M_DebtNotificationsController(analyticsManager: analyticsManager)
        guard
            let activeDataStore = dataStore,
            let debtDataStore = debtNotification.router?.dataStore else {
            return
        }
        debtDataStore.notifications = activeDataStore.notifications
        controller?.navigationController?.pushViewController(debtNotification, animated: true)
    }
    
    func presentDebtNotification(_ notification: M_MaasDebtNotifification) {
        DispatchQueue.main.async {
            let debtNotificationController = M_ModalDebetNotificationController()
            debtNotificationController.debtNotification = notification
            debtNotificationController.modalPresentationStyle = .fullScreen
            self.controller?.present(debtNotificationController, animated: true)
        }
    }
    
    func dismiss() {
        controller?.dismiss(animated: true)
    }
    
    deinit {
        #if DEBUG
        print("🥰🥰🥰 Active router deinited")
        #endif
    }
}
