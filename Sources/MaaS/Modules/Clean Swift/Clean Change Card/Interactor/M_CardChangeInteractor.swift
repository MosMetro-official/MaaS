//
//  M_CardChangeInteractor.swift
//  MaaS
//
//  Created by Слава Платонов on 02.08.2022.
//

import CoreTableView

protocol CardChangeInteractor: AnyObject {
    func makeRequset()
    func sendRequestCardKey()
    func requestLoading(_ request: M_CardChangeModels.Request.Loading)
}

protocol CardChangeDataStore: AnyObject {
    var userInfo: M_UserInfo? { get set }
}

final class M_CardChangeInteractor: CardChangeInteractor, CardChangeDataStore {
    
    var presenter: CardChangePresenter?
    var userInfo: M_UserInfo?
    
    init(presenter: CardChangePresenter? = nil) {
        self.presenter = presenter
    }
    
    func makeRequset() {
        if let user = userInfo {
            let response = M_CardChangeModels.Response.UserInfo(user: user)
            presenter?.prepareState(response)
        }
    }
    
    func sendRequestCardKey() {
        let loadingRequest = M_CardChangeModels.Request.Loading(title: "Загрузка...", descr: "Осталось совсем немного")
        requestLoading(loadingRequest)
        let request = M_UserCardRequest(
            payData: M_PayData(
                redirectUrl: M_RedirectUrl(
                    succeed: MaaS.succeedUrlCard,
                    declined: MaaS.declinedUrlCard,
                    canceled: MaaS.canceledUrlCard
                ),
                paymentMethod: .card
            )
        )
        let body = request.createRequestBody()
        M_UserCardResponse.sendRequsetToChangeUserCard(body: body) { result in
            switch result {
            case .success(let userResponse):
                if let path = userResponse.payment?.url {
                    let response = M_CardChangeModels.Response.ChangeCardUrl(urlPath: path)
                    self.presenter?.prepareSafariController(response)
                } else {
                    let response = M_CardChangeModels.Response.Error(
                        title: "Произошла ошибка 🥲",
                        descr: "Не удалось открыть страницу смены карты"
                    )
                    self.presenter?.prepareError(response)
                }
            case .failure(let error):
                let response = M_CardChangeModels.Response.Error(
                    title: "Произошла ошибка 🥲",
                    descr: error.localizedDescription
                )
                self.presenter?.prepareError(response)
            }
        }
    }
    
    func requestLoading(_ request: M_CardChangeModels.Request.Loading) {
        let response = M_CardChangeModels.Response.Loading(title: request.title, descr: request.descr)
        presenter?.prepareLoading(response)
    }
    
    deinit {
        print("🥰🥰🥰 CardChangeInteractor deinited")
    }
}
