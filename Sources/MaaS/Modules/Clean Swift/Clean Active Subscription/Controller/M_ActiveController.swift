//
//  M_ActiveController.swift
//  MaaS
//
//  Created by Слава Платонов on 01.08.2022.
//

import UIKit
import SafariServices

protocol ActiveDisplayLogic: AnyObject {
    func dismiss()
    func pushDebtScreen()
    func openOnboarding()
    func requestUserInfo()
    func requestCardUpdate()
    func pushHistoryScreen()
    func requestSupportUrl()
    func pushChangeCardScreen()
    func openSafariController(_ url: URL)
    func showDebtNotification(_ notification: M_MaasDebtNotifification)
    func displayUserInfo(with viewModel: M_ActiveSubModels.ViewModel.ViewState.DataState)
}

public class M_ActiveController: UIViewController {
    
    private let nestedView = M_ActiveSubView.loadFromNib()
    private var safariController: SFSafariViewController?

    var interactor: ActiveSubscriptionInteractor?
    var router: (ActiveRoutingLogic & ActiveDataPassing)?
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    public override func loadView() {
        super.loadView()
        self.view = nestedView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.fetchUserInfo()
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage.getAssetImage(image: "mainBackButton"),
            style: .plain, target: self,
            action: #selector(closeTapped)
        )
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.titleTextAttributes = [
            .font: Appearance.getFont(.navTitle)
        ]
        title = "Подписка"
    }
    
    @objc private func closeTapped() {
        self.dismiss(animated: true)
    }
    
    private func setup() {
        let presenter = M_ActiveSubPresenter(controller: self)
        let interactor = M_ActiveSubInteractor(presenter: presenter)
        let router = M_ActiveSubRouter(controller: self, dataStore: interactor)
        self.interactor = interactor
        self.router = router
    }
        
    deinit {
        print("🥰🥰🥰 ActiveController deinited")
    }
}

extension M_ActiveController: ActiveDisplayLogic {
    
    func displayUserInfo(with viewModel: M_ActiveSubModels.ViewModel.ViewState.DataState) {
        self.nestedView.viewModel = viewModel
    }
    
    func requestUserInfo() {
        interactor?.fetchUserInfo()
    }
    
    func requestCardUpdate() {
        interactor?.checkCardUpdates()
    }
    
    func pushChangeCardScreen() {
        router?.routeToChangeCard()
    }
    
    func pushDebtScreen() {
        router?.routeToDebtNotifications()
    }
    
    func pushHistoryScreen() {
        router?.routeToHistoryTrips()
    }
    
    func requestSupportUrl() {
        interactor?.fetchSupportUrl()
    }
    
    func openSafariController(_ url: URL) {
        safariController = SFSafariViewController(url: url)
        if let svc = safariController {
            svc.delegate = self
            router?.routeToSupport(svc)
        }
    }
    
    func openOnboarding() {
        router?.routeToOnboarding()
    }
    
    func showDebtNotification(_ notification: M_MaasDebtNotifification) {
        router?.presentDebtNotification(notification)
    }
    
    func dismiss() {
        router?.dismiss()
    }
}

extension M_ActiveController: SFSafariViewControllerDelegate {
    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        interactor?.fetchUserInfo()
    }
}
