//
//  M_DebtNotificationsController.swift
//  Pods
//
//  Created by Слава Платонов on 08.09.2022.
//

import UIKit
import SafariServices

protocol M_DebtUserNotificationsDisplayLogic: AnyObject {
    func popViewController()
    func displaySafariController(_ url: URL)
    func handleNotification(_ notification: M_MaasDebtNotifification)
    func displayNotifications(_ viewModel: M_DebtUserNotificationsModels.ViewModel.ViewState)
}

final class M_DebtNotificationsController: UIViewController {
    
    private let nestedView = M_DebtNotificationsView.loadFromNib()
    
    var interactor: M_DebtUserNotificationsBusinessLogic?
    var router: (M_DebtUserNotificationsRoutingLogic & M_DebtUserNotificationsDataPassing)?
    
    private var safariController: SFSafariViewController?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
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
    
    func displayNotifications(_ viewModel: M_DebtUserNotificationsModels.ViewModel.ViewState) {
        nestedView.viewModel = viewModel
    }
    
    func handleNotification(_ notification: M_MaasDebtNotifification) {
        let request = M_DebtUserNotificationsModels.Request.Notification(notification: notification)
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
