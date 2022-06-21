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
    
    enum ResultModel {
        case successSub(M_Subscription)
        case failureSub
        case successCard(M_UserInfo)
        case failureCard
        case none
    }
    
    public var resultModel: ResultModel = .none {
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
    
    private func makeState() {
        switch resultModel {
        case .none:
            break
        case .failureSub:
            let onAction = Command { [weak self] in
                // send form
            }
            let onClose = Command { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            let error = M_ResultView.ViewState.Action(
                title: "Что-то пошло не так",
                descr: "Мы уже разбираемся в причине, попробуйте еще раз или напишите нам"
            )
            nestedView.viewState = .init(
                hideAction: nil,
                dataState: .failure(error),
                logo: UIImage.getAssetImage(image: "error"),
                onAction: onAction,
                onClose: onClose
            )
        case .successSub(let sub):
            guard let subName = sub.name?.ru else { return }
            let onAction = Command { [weak self] in
                // open onboarding
            }
            let onClose = Command { [weak self] in
                guard let self = self else { return }
                let activeSubController = M_ActiveSubController()
                activeSubController.needReload = true
                self.navigationController?.viewControllers[0] = activeSubController
                self.navigationController?.popToRootViewController(animated: true)
            }
            let success = M_ResultView.ViewState.Action(
                title: "Успешно",
                descr: "Мы привязали подписку \(subName) к вашей карте"
            )
            nestedView.viewState = .init(
                hideAction: nil,
                dataState: .success(success),
                logo: UIImage.getAssetImage(image: "checkmark"),
                onAction: onAction,
                onClose: onClose
            )
        case .successCard(let userInfo):
            let onAction = Command { [weak self] in
                // show onboarding
            }
            let onClose = Command { [weak self] in
                guard
                    let self = self,
                    let firstVC = self.navigationController?.viewControllers.first as? M_ActiveSubController else { return }
                firstVC.userInfo = userInfo
                firstVC.needReload = true
                self.navigationController?.popToRootViewController(animated: true)
            }
            let success = M_ResultView.ViewState.Action(
                title: "Успешно",
                descr: "Мы поменяли номер вашей карты, а подписку сохранили"
            )
            nestedView.viewState = .init(
                hideAction: true,
                dataState: .success(success),
                logo: UIImage.getAssetImage(image: "checkmark"),
                onAction: onAction,
                onClose: onClose
            )
        case .failureCard:
            let onAction = Command {
                // send form
            }
            let onClose = Command { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            let error = M_ResultView.ViewState.Action(
                title: "Что-то пошло не так",
                descr: "Мы уже разбираемся в причине, попробуйте еще раз или напишите нам"
            )
            nestedView.viewState = .init(
                hideAction: nil,
                dataState: .failure(error),
                logo: UIImage.getAssetImage(image: "error"),
                onAction: onAction,
                onClose: onClose
            )
        }
    }
}
