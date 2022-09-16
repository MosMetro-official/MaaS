//
//  M_CardChangePresenter.swift
//  MaaS
//
//  Created by Слава Платонов on 02.08.2022.
//

import CoreTableView

protocol CardChangePresenter: AnyObject {
    func prepareState(_ response: M_CardChangeModels.Response.UserInfo)
    func prepareError(_ response: M_CardChangeModels.Response.Error)
    func prepareLoading(_ response: M_CardChangeModels.Response.Loading)
    func prepareSafariController(_ response: M_CardChangeModels.Response.ChangeCardUrl)
}

final class M_CardChangePresenter: CardChangePresenter {
    
    weak var controller: CardChangeDisplayLogic?
    
    init(controller: CardChangeDisplayLogic? = nil) {
        self.controller = controller
    }
    
    func prepareState(_ response: M_CardChangeModels.Response.UserInfo) {
        let viewModel = makeViewModel(from: response)
        controller?.displayCardState(viewModel)
    }
    
    func prepareSafariController(_ response: M_CardChangeModels.Response.ChangeCardUrl) {
        guard let url = URL(string: response.urlPath) else { return }
        controller?.displaySafariController(with: url)
    }
    
    func prepareLoading(_ response: M_CardChangeModels.Response.Loading) {
        let loading = M_CardChangeModels.ViewModel.ViewState.Loading(
            title: response.title,
            descr: response.descr
        )
        let viewModel = M_CardChangeModels.ViewModel.ViewState(
            dataState: .loading(loading),
            cardType: .unknown,
            cardNumber: "",
            countOfChangeCard: 0,
            onChangeButton: nil
        )
        controller?.displayCardState(viewModel)
    }
    
    func prepareError(_ response: M_CardChangeModels.Response.Error) {
        let onClose = Command {
            self.controller?.popViewController()
        }
        let onRetry = Command {
            self.controller?.requestChangeCard()
        }
        let error = M_CardChangeModels.ViewModel.ViewState.Error(
            title: response.title,
            descr: response.descr,
            onRetry: onRetry,
            onClose: onClose
        )
        let viewModel = M_CardChangeModels.ViewModel.ViewState(
            dataState: .error(error),
            cardType: .unknown,
            cardNumber: "",
            countOfChangeCard: 0,
            onChangeButton: nil
        )
        controller?.displayCardState(viewModel)
    }
    
    private func makeViewModel(from response: M_CardChangeModels.Response.UserInfo) -> M_CardChangeModels.ViewModel.ViewState {
        let onChangeCard = Command {
            self.controller?.requestChangeCard()
        }
        let state = M_CardChangeModels.ViewModel.ViewState(
            dataState: .loaded,
            cardType: response.user.paySystem ?? .unknown,
            cardNumber: "\(response.user.maskedPan)",
            countOfChangeCard: response.user.keyChangeLeft,
            onChangeButton: response.user.keyChangeLeft == 0 ? nil : onChangeCard
        )
        return state
    }
    
    deinit {
        print("🥰🥰🥰 CardChangePresenter deinited")
    }
}
