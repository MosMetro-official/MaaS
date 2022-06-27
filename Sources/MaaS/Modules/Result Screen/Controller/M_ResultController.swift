//
//  M_ResultController.swift
//  MaaS
//
//  Created by Слава Платонов on 13.06.2022.
//

import UIKit
import SafariServices
import CoreTableView

class M_ResultController: UIViewController {
    
    private var safariController: SFSafariViewController?
    private var repeats: Int = 0
    
    public var needToCheckUserInfo: Bool? {
        didSet {
            showLoading(with: "Привязываем подписку...", descr: "Немного подождите")
            checkUserSubStatus()
        }
    }
    
    public var resultModel: M_ResultModel = .none {
        didSet {
            makeState()
        }
    }
    
    let nestedView = M_ResultView.loadFromNib()
    
    override func loadView() {
        super.loadView()
        self.view = nestedView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setListeners() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleSupportForm), name: .maasSupportForm, object: nil)
    }
    
    @objc private func handleSupportForm() {
        hideSafatiController {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func checkUserSubStatus() {
        M_UserInfo.fetchUserInfo { result in
            switch result {
            case .success(let userInfo):
                guard let sub = userInfo.subscription else { return }
                switch sub.status {
                case .unknow:
                    if self.repeats <= 5 {
                        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                            self.repeats += 1
                            self.checkUserSubStatus()
                        }
                    } else {
                        self.repeats = 0
                        self.resultModel = .successSub(sub)
                    }
                case .active:
                    self.resultModel = .successSub(sub)
                default:
                    break
                }
            case .failure(let error):
                let onRetry = Command { [weak self] in
                    self?.showLoading(with: "Загрузка...", descr: "Немного подождите")
                    self?.checkUserSubStatus()
                }
                self.showError(with: error.errorTitle, descr: error.errorDescription, onRetry: onRetry)
            }
        }
    }
    
    private func showLoading(with title: String, descr: String) {
        let loading = M_ResultView.ViewState.Loading(
            title: title,
            descr: descr
        )
        nestedView.viewState = .init(
            dataState: .loading(loading),
            logo: nil,
            onAction: nil,
            actionTitle: "",
            onClose: nil,
            loadState: true
        )
    }
    
    private func showError(with title: String, descr: String, onRetry: Command<Void>) {
        let onClose = Command { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        let error = M_ResultView.ViewState.Error(
            title: title,
            descr: descr,
            onClose: onClose,
            onRetry: onRetry
        )
        nestedView.viewState = .init(
            dataState: .error(error),
            logo: nil,
            onAction: nil,
            actionTitle: "",
            onClose: nil,
            loadState: false
        )
    }
    
    private func makeState() {
        switch resultModel {
        case .none:
            break
        case .failureSub(let id):
            setListeners()
            let onAction = Command { [weak self] in
                self?.fetchSupportUrl(with: id)
            }
            let onClose = Command { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            let error = M_ResultView.ViewState.Action(
                title: "Что-то пошло не так",
                descr: "Мы уже разбираемся в причине, попробуйте еще раз или напишите нам"
            )
            nestedView.viewState = .init(
                dataState: .failure(error),
                logo: UIImage.getAssetImage(image: "error"),
                onAction: onAction,
                actionTitle: "Написать нам",
                onClose: onClose
            )
        case .successSub(let sub):
            NotificationCenter.default.post(name: .maasUpdateUserInfo, object: nil, userInfo: nil)
            let onAction = Command { [weak self] in
                // open onboarding
            }
            let onClose = Command { [weak self] in
                guard let self = self else { return }
                switch sub.status {
                case .active:
                    let activeSubController = M_ActiveSubController()
                    activeSubController.needReload = true
                    self.navigationController?.viewControllers[0] = activeSubController
                    self.navigationController?.popToRootViewController(animated: true)
                case .unknow:
                    self.dismiss(animated: true)
                default:
                    break
                }
            }
            let descr = sub.status == .active ?
            "Мы привязали подписку \(sub.name.ru) к вашей карте" :
            "Мы привязали подписку \(sub.name.ru) к вашей карте, профиль будет доступен позже"
            let success = M_ResultView.ViewState.Action(
                title: "Успешно",
                descr: descr
            )
            nestedView.viewState = .init(
                dataState: .success(success),
                logo: UIImage.getAssetImage(image: "checkmark"),
                onAction: onAction,
                actionTitle: "Еще раз о том, как пользоваться",
                onClose: onClose
            )
        case .successCard(let userInfo):
            NotificationCenter.default.post(name: .maasUpdateUserInfo, object: ["card": userInfo.maskedPan])
            let onClose = Command { [weak self] in
                guard
                    let self = self,
                    let firstVC = self.navigationController?.viewControllers.first as? M_ActiveSubController else { return }
                firstVC.oldMaskedPan = userInfo.maskedPan
                self.navigationController?.popToRootViewController(animated: true)
            }
            let success = M_ResultView.ViewState.Action(
                title: "Успешно",
                descr: "Мы поменяли номер вашей карты, а подписку сохранили 😉"
            )
            nestedView.viewState = .init(
                dataState: .success(success),
                logo: UIImage.getAssetImage(image: "checkmark"),
                onAction: nil,
                actionTitle: "",
                onClose: onClose,
                hideAction: true
            )
        case .failureCard:
            let onAction = Command { [weak self] in
                self?.fetchSupportUrl()
            }
            let onClose = Command { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            let error = M_ResultView.ViewState.Action(
                title: "Что-то пошло не так",
                descr: "Мы уже разбираемся в причине, попробуйте еще раз или напишите нам"
            )
            nestedView.viewState = .init(
                dataState: .failure(error),
                logo: UIImage.getAssetImage(image: "error"),
                onAction: onAction,
                actionTitle: "Написать нам",
                onClose: onClose
            )
        }
    }
}

// MARK: Support form

extension M_ResultController: SFSafariViewControllerDelegate {
    
   func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.makeState()
    }
    
    private func fetchSupportUrl(with id: String = "") {
        self.showLoading(with: "Загрузка...", descr: "Немного подождите")
        M_SupportResponse.sendSupportRequest(payId: id, redirectUrl: MaaS.shared.supportForm) { result in
            switch result {
            case .success(let supportForm):
                self.handleSupportUrl(path: supportForm.url)
            case .failure(let error):
                let onRetry = Command { [weak self] in
                    self?.showLoading(with: "Загрузка...", descr: "Немного подождите")
                    self?.checkUserSubStatus()
                }
                self.showError(with: error.errorTitle, descr: error.errorDescription, onRetry: onRetry)
            }
        }
    }
    
    private func handleSupportUrl(path: String) {
        guard let url = URL(string: path) else { return }
        safariController = SFSafariViewController(url: url)
        safariController?.delegate = self
        DispatchQueue.main.async {
            self.present(self.safariController!, animated: true)
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
