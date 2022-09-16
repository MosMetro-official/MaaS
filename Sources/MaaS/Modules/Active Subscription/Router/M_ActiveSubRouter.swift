//
//  M_ActiveSubRouter.swift
//  MaaS
//
//  Created by Слава Платонов on 02.08.2022.
//

import OnBoardingModule

protocol ActiveRoutingLogic: AnyObject {
    func dismiss()
    func routeToChangeCard()
    func routeToOnboarding()
    func routeToHistoryTrips()
    func routeToDebtNotifications()
    func routeToSupport(_ safariController: UIViewController)
    func presentDebtNotification(_ notification: M_MaasDebtNotifification)
}

protocol ActiveDataPassing: AnyObject {
    var dataStore: ActiveDataStore? { get }
}

final class M_ActiveSubRouter: ActiveRoutingLogic, ActiveDataPassing {
    weak var controller: M_ActiveSubController?
    var dataStore: ActiveDataStore?
    
    init(controller: M_ActiveSubController? = nil, dataStore: ActiveDataStore? = nil) {
        self.controller = controller
        self.dataStore = dataStore
    }
    
    func routeToChangeCard() {
        let changeCardController = M_ChangeCardController()
        guard
            let activeDataStore = dataStore,
            let changeCardDataStore = changeCardController.router?.dataStore else {
            return
        }
        changeCardDataStore.userInfo = activeDataStore.userInfo
        controller?.navigationController?.pushViewController(changeCardController, animated: true)
    }
    
    func routeToHistoryTrips() {
        let historyController = M_HistoryController()
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
    
    func routeToDebtNotifications() {
        let debtNotification = M_DebtUserNotificationsController()
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
        print("🥰🥰🥰 ActiveRouter deinited")
    }
}
