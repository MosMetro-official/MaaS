//
//  M_DebtNotificationsController.swift
//  Pods
//
//  Created by Слава Платонов on 08.09.2022.
//

import UIKit
import SafariServices
import CoreAnalytics

protocol M_DebtUserNotificationsDisplayLogic: AnyObject {
    func popViewController()
    func displaySafariController(_ url: URL)
    func handleNotification(_ notification: M_MaasDebtNotifification)
    func displayNotifications(_ viewModel: M_DebtUserNotificationsModels.ViewModel)
}

final class M_DebtNotificationsController: UIViewController {
    
    private let nestedView = M_DebtNotificationsView.loadFromNib()
    private var analyticsEvents = M_AnalyticsEvents()
    private var analyticsManager : _AnalyticsManager
    
    var interactor: M_DebtUserNotificationsBusinessLogic?
    var router: (M_DebtUserNotificationsRoutingLogic & M_DebtUserNotificationsDataPassing)?
    
    private var safariController: SFSafariViewController?
    
    public init(analyticsManager: _AnalyticsManager) {
        self.analyticsManager = analyticsManager
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = nestedView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.requestState()
    }
    
    private func setup() {
        let presenter = M_DebtUserNotificationsPresenter(controller: self)
        let interactor = M_DebtUserNotificationsInteractor(presenter: presenter)
        let router = M_DebtUserNotificationsRouter(controller: self, dataStore: interactor)
        self.interactor = interactor
        self.router = router
    }
}

extension M_DebtNotificationsController: M_DebtUserNotificationsDisplayLogic {
    
    func displayNotifications(_ viewModel: M_DebtUserNotificationsModels.ViewModel) {
        nestedView.viewState = viewModel.viewState
    }
    
    func handleNotification(_ notification: M_MaasDebtNotifification) {
        let request = M_DebtUserNotificationsModels.Request.Notification(notification: notification)
        analyticsManager.report(analyticsEvents.makeNotificationsEvent())
        analyticsManager.report(analyticsEvents.makeOldNameNotificationsEvent())
        interactor?.handleNotification(request)
    }
    
    func displaySafariController(_ url: URL) {
        safariController = SFSafariViewController(url: url)
        if let svc = safariController {
            svc.delegate = self
            router?.presentSafariController(svc)
        }
    }
    
    func popViewController() {
        router?.popViewController()
    }
}

extension M_DebtNotificationsController: SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        interactor?.requestReloadNotifications()
    }
}
