//
//  M_ResScreenInteractor.swift
//  Pods
//
//  Created by Слава Платонов on 30.08.2022.
//

import Foundation

protocol M_ResScreenBusinessLogic: AnyObject {
    func requestState()
    func requestSupportUrl(with id: String)
}

protocol M_ResScreenDataStore: AnyObject {
    var resultModel: M_ResultModel { get set }
}

final class M_ResScreenInteractor: M_ResScreenBusinessLogic, M_ResScreenDataStore {
    
    var presenter: M_ResScreenPresentationLogic?
    var resultModel: M_ResultModel = .none
    
    init(presenter: M_ResScreenPresentationLogic? = nil) {
        self.presenter = presenter
    }
    
    func requestState() {
        switch resultModel {
        case .successSub(let subscription):
            let response = M_ResScreenModels.Response.ResultState(res: .sub(.success(subscription)))
            presenter?.prepareViewModel(response)
        case .failureSub(let id):
            let response = M_ResScreenModels.Response.ResultState(res: .sub(.failure(id: id)))
            presenter?.prepareViewModel(response)
        case .successCard(let userInfo):
            let card = M_ResScreenModels.Response.ResultState.CardState.Card(maskedPan: userInfo.maskedPan)
            let response = M_ResScreenModels.Response.ResultState(res: .card(.success(card)))
            presenter?.prepareViewModel(response)
        case .failureCard:
            let response = M_ResScreenModels.Response.ResultState(res: .card(.failure))
            presenter?.prepareViewModel(response)
        case .none:
            break
        }
    }
    
    func requestSupportUrl(with id: String) {
        let response = M_ResScreenModels.Response.Loading(title: "Загрузка...", descr: "Немного подождите")
        presenter?.prepareLoadingState(response)
        Task {
            do {
                let supportForm = try await M_SupportResponse.sendSupportRequest(payId: id, redirectUri: MaaS.supportForm)
                let response = M_ResScreenModels.Response.SupportForm(urlString: supportForm.url)
                presenter?.prepareSupportForm(response)
            } catch {
                let response = M_ResScreenModels.Response.Error(
                    title: "Произошла ошибка 🥲",
                    descr: error.localizedDescription,
                    id: id
                )
                presenter?.prepareErrorState(response)
            }
        }
    }
}
