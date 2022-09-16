//
//  M_ResScreenController.swift
//  Pods
//
//  Created by Слава Платонов on 30.08.2022.
//

import UIKit
import SafariServices

protocol M_ResScreenDisplayLogic: AnyObject {
    func showOnboarding()
    func popViewController()
    func popToActiveController()
    func showSupportForm(_ url: URL)
    func requestSupportUrl(with id: String)
    func popToActiveControllerWith(maskedPan: String)
    func displayResultState(_ viewModel: M_ResScreenModels.ViewModel.ViewState)
}

final class M_ResScreenController: UIViewController {
    
    private let nestedView = M_ResultView.loadFromNib()
    private var safariController: SFSafariViewController?
    
    var interactor: M_ResScreenBusinessLogic?
    var router: (M_ResScreenRoutingLogic & M_ResScreenDataPassing)?
    
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

extension M_ResScreenController: M_ResScreenDisplayLogic {
    
    func displayResultState(_ viewModel: M_ResScreenModels.ViewModel.ViewState) {
        nestedView.viewModel = viewModel
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
        router?.routeToActive(with: "")
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

extension M_ResScreenController: SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        interactor?.requestState()
    }
}
