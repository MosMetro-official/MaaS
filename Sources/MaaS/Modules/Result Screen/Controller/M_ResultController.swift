//
//  M_ResultController.swift
//  Pods
//
//  Created by Слава Платонов on 30.08.2022.
//

import UIKit
import SafariServices
import CoreAnalytics

protocol M_ResScreenDisplayLogic: AnyObject {
    func showOnboarding()
    func popViewController()
    func popToActiveController()
    func showSupportForm(_ url: URL)
    func requestSupportUrl(with id: String)
    func popToActiveControllerWith(maskedPan: String)
    func displayResultState(_ viewModel: M_ResScreenModels.ViewModel)
}

final class M_ResultController: UIViewController {
    
    private let nestedView = M_ResultView.loadFromNib()
    private var safariController: SFSafariViewController?
    private var analyticsManager : _AnalyticsManager
    
    var interactor: M_ResScreenBusinessLogic?
    var router: (M_ResScreenRoutingLogic & M_ResScreenDataPassing)?
    
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
        setListeners()
        interactor?.requestState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setup() {
        let presenter = M_ResScreenPresenter(controller: self)
        let interactor = M_ResScreenInteractor(presenter: presenter)
        let router = M_ResScreenRouter(controller: self, dataStore: interactor)
        self.interactor = interactor
        self.router = router
    }
    
    private func setListeners() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleSupportForm), name: .maasSupportForm, object: nil)
    }
    
    @objc func handleSupportForm() {
        hideSafatiController {
            self.interactor?.requestState()
        }
    }
    
    private func hideSafatiController(onDismiss: @escaping () -> Void) {
        guard let safariController = safariController else {
            return
        }
        safariController.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.safariController = nil
            onDismiss()
        }
    }
}

extension M_ResultController: M_ResScreenDisplayLogic {
    
    func displayResultState(_ viewModel: M_ResScreenModels.ViewModel) {
        nestedView.viewState = viewModel.viewState
    }
    
    func showSupportForm(_ url: URL) {
        safariController = SFSafariViewController(url: url)
        if let svc = safariController {
            svc.delegate = self
            router?.showSupportController(svc)
        }
    }
    
    func popViewController() {
        router?.popViewController()
    }
    
    func popToActiveController() {
        router?.popToActiveWithSuccessSub(analyticsManager: analyticsManager)
    }
    
    func popToActiveControllerWith(maskedPan: String) {
        router?.routeToActive(with: maskedPan)
    }
    
    func showOnboarding() {
        router?.routeToOnboarding()
    }
    
    func requestSupportUrl(with id: String) {
        interactor?.requestSupportUrl(with: id)
    }
}

extension M_ResultController: SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        interactor?.requestState()
    }
}
