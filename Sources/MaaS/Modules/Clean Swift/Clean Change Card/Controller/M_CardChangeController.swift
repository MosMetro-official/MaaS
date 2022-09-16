//
//  M_CardChangeController.swift
//  MaaS
//
//  Created by Слава Платонов on 02.08.2022.
//

import UIKit
import SafariServices

protocol CardChangeDisplayLogic: AnyObject {
    func requestChangeCard()
    func popViewController()
    func displaySafariController(with url: URL)
    func displayCardState(_ viewModel: M_CardChangeModels.ViewModel.ViewState)
}

class M_CardChangeController: UIViewController {
    
    private let nestedView = M_ChangeCardView.loadFromNib()
    var interactor: CardChangeInteractor?
    private(set) var router: (CardChangeRoutingLogic & CardChangeDataPassing)?
    private var safariController: SFSafariViewController?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = nestedView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setListeners()
        setupBackButton()
        setupNavigationTitle()
        interactor?.makeRequset()
    }
    
    private func setup() {
        let presenter = M_CardChangePresenter(controller: self)
        let interactor = M_CardChangeInteractor(presenter: presenter)
        let router = M_CardChangeRouter(controller: self, dataStore: interactor)
        self.interactor = interactor
        self.router = router
    }
    
    private func setupNavigationTitle() {
        navigationController?.navigationBar.titleTextAttributes = [
            .font: Appearance.getFont(.navTitle)
        ]
        title = "Карта"
    }
    
    private func setListeners() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleSuccessChange), name: .maasChangeCardSucceed, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDeclinedChange), name: .maasChangeCardDeclined, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleCanceledChange), name: .maasChangeCardCanceled, object: nil)
    }
    
    @objc private func handleSuccessChange() {
        let request = M_CardChangeModels.Request.Loading(
            title: "Меняем номер вашей карты...",
            descr: "Осталось совсем немного"
        )
        interactor?.requestLoading(request)
        hideSafariController {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.router?.routeToResultScreen(.success)
            }
        }
    }
    
    @objc private func handleDeclinedChange() {
        self.interactor?.makeRequset()
        hideSafariController {
            // anaLiticks?
        }
    }
    
    @objc private func handleCanceledChange() {
        let request = M_CardChangeModels.Request.Loading(
            title: "Меняем номер вашей карты...",
            descr: "Осталось совсем немного"
        )
        interactor?.requestLoading(request)
        hideSafariController {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.router?.routeToResultScreen(.failure)
            }
        }
    }
    
    private func hideSafariController(onDismiss: @escaping () -> Void) {
        guard let safariController = safariController else {
            return
        }
        safariController.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.safariController = nil
            onDismiss()
        }
    }
    
    deinit {
        print("🥰🥰🥰 CardChangeController deinited")
    }
}

extension M_CardChangeController: CardChangeDisplayLogic {
    
    func displayCardState(_ viewModel: M_CardChangeModels.ViewModel.ViewState) {
        nestedView.viewModel = viewModel
    }
    
    func requestChangeCard() {
        interactor?.sendRequestCardKey()
    }
    
    func displaySafariController(with url: URL) {
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

extension M_CardChangeController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        interactor?.makeRequset()
    }
}
