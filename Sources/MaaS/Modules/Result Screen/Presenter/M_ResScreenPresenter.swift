//
//  M_ResScreenPresenter.swift
//  Pods
//
//  Created by Слава Платонов on 30.08.2022.
//

import CoreTableView

protocol M_ResScreenPresentationLogic: AnyObject {
    func prepareViewModel(_ response: M_ResScreenModels.Response.ResultState)
    func prepareLoadingState(_ response: M_ResScreenModels.Response.Loading)
    func prepareErrorState(_ response: M_ResScreenModels.Response.Error)
    func prepareSupportForm(_ response: M_ResScreenModels.Response.SupportForm)
}

final class M_ResScreenPresenter: M_ResScreenPresentationLogic {
    
    weak var controller: M_ResScreenDisplayLogic?
    
    init(controller: M_ResScreenDisplayLogic? = nil) {
        self.controller = controller
    }
    
    func prepareViewModel(_ response: M_ResScreenModels.Response.ResultState) {
        let viewState = makeViewState(from: response)
        let viewModel = M_ResScreenModels.ViewModel(viewState: viewState)
        controller?.displayResultState(viewModel)
    }
    
    func prepareLoadingState(_ response: M_ResScreenModels.Response.Loading) {
        let loading = M_ResultView.ViewState.Loading(
            title: response.title,
            descr: response.descr
        )
        let viewState = M_ResultView.ViewState(
            dataState: .loading(loading),
            logo: nil,
            onAction: nil,
            actionTitle: "",
            onClose: nil
        )
        let viewModel = M_ResScreenModels.ViewModel(viewState: viewState)
        controller?.displayResultState(viewModel)
    }
    
    func prepareErrorState(_ response: M_ResScreenModels.Response.Error) {
        let onClose = Command {
            self.controller?.popViewController()
        }
        let onRetry = Command {
            self.controller?.requestSupportUrl(with: response.id)
        }
        let error = M_ResultView.ViewState.Error(
            title: response.title,
            descr: response.descr,
            onClose: onClose,
            onRetry: onRetry
        )
        let viewState = M_ResultView.ViewState(
            dataState: .error(error),
            logo: nil,
            onAction: nil,
            actionTitle: "",
            onClose: nil
        )
        let viewModel = M_ResScreenModels.ViewModel(viewState: viewState)
        controller?.displayResultState(viewModel)
    }
    
    func prepareSupportForm(_ response: M_ResScreenModels.Response.SupportForm) {
        guard let url = URL(string: response.urlString) else { return }
        controller?.showSupportForm(url)
    }
    
    private func makeViewState(from response: M_ResScreenModels.Response.ResultState) -> M_ResultView.ViewState {
        switch response.res {
        case .sub(let subState):
            switch subState {
            case .success(let sub):
                NotificationCenter.default.post(name: .maasUpdateUserInfo, object: nil, userInfo: nil)
                let onAction = Command {
                    self.controller?.showOnboarding()
                }
                let onClose = Command {
                    self.controller?.popToActiveController()
                }
                let descr = sub.status == .active ?
                "Мы привязали подписку \(sub.name.ru) к вашей карте" :
                "Мы привязали подписку \(sub.name.ru) к вашей карте, профиль будет доступен позже"
                let success = M_ResultView.ViewState.Action(
                    title: "Успешно",
                    descr: descr
                )
                let viewState = M_ResultView.ViewState(
                    dataState: .success(success),
                    logo: UIImage.getAssetImage(image: "checkmark"),
                    onAction: onAction,
                    actionTitle: "Как пользоваться",
                    onClose: onClose
                )
                return viewState
            case .failure(let id):
                let onAction = Command {
                    self.controller?.requestSupportUrl(with: id)
                }
                let onClose = Command {
                    self.controller?.popViewController()
                }
                let error = M_ResultView.ViewState.Action(
                    title: "Что-то пошло не так",
                    descr: "Мы уже разбираемся в причине, попробуйте еще раз или напишите нам"
                )
                let viewState = M_ResultView.ViewState(
                    dataState: .failure(error),
                    logo: UIImage.getAssetImage(image: "error"),
                    onAction: onAction,
                    actionTitle: "Написать нам",
                    onClose: onClose
                )
                return viewState
            }
        case .card(let cardState):
            switch cardState {
            case .success(let card):
                NotificationCenter.default.post(name: .maasUpdateUserInfo, object: nil)
                let onClose = Command {
                    self.controller?.popToActiveControllerWith(maskedPan: card.maskedPan)
                }
                let success = M_ResultView.ViewState.Action(
                    title: "Успешно",
                    descr: "Мы поменяли номер вашей карты, а подписку сохранили 😉"
                )
                let viewState = M_ResultView.ViewState(
                    dataState: .success(success),
                    logo: UIImage.getAssetImage(image: "checkmark"),
                    onAction: nil,
                    actionTitle: "",
                    onClose: onClose,
                    hideAction: true
                )
                return viewState
            case .failure:
                let onAction = Command {
                    self.controller?.requestSupportUrl(with: "")
                }
                let onClose = Command {
                    self.controller?.popViewController()
                }
                let error = M_ResultView.ViewState.Action(
                    title: "Что-то пошло не так",
                    descr: "Мы уже разбираемся в причине, попробуйте еще раз или напишите нам"
                )
                let viewState = M_ResultView.ViewState(
                    dataState: .failure(error),
                    logo: UIImage.getAssetImage(image: "error"),
                    onAction: onAction,
                    actionTitle: "Написать нам",
                    onClose: onClose
                )
                return viewState
            }
        }
        return .initial
    }
}
