//
//  M_HistoryInteractor.swift
//  Pods
//
//  Created by Слава Платонов on 08.09.2022.
//

import Foundation

protocol M_HistoryBusinessLogic: AnyObject {
    func fetchTrips(_ request: M_HistoryModels.Request.Trips)
}

final class M_HistoryInteractor: M_HistoryBusinessLogic {
    
    var presenter: M_HistoryPresentationLogic?
    
    private var trips: [M_HistoryTrips] = []
    private var offset = 0
    private var limit = 15
    
    init(presenter: M_HistoryPresentationLogic? = nil) {
        self.presenter = presenter
    }
    
    func fetchTrips(_ request: M_HistoryModels.Request.Trips) {
        requestLoading()
        if request.isLoadingMore {
            let response = M_HistoryModels.Response.Trips(trips: self.trips, isLoadingMore: request.isLoadingMore)
            presenter?.prepareViewModel(response)
        }
        Task {
            do {
                let newTrips = try await M_HistoryTrips.fetchHistoryTrips(by: limit, offset: offset)
                trips += newTrips
                offset = offset == 0 ? trips.count : (offset + trips.count)
                let response = M_HistoryModels.Response.Trips(trips: trips, isLoadingMore: false)
                presenter?.prepareViewModel(response)
            } catch {
                requestError(title: "Произошла ошибка 🥲", descr: error.localizedDescription)
            }
        }
    }
    
    private func requestLoading() {
        let response = M_HistoryModels.Response.Loading(title: "Загрузка...", descr: "Немного подождите")
        presenter?.prepareLoadingState(response)
    }
    
    private func requestError(title: String, descr: String) {
        let response = M_HistoryModels.Response.Error(title: title, descr: descr)
        presenter?.prepareErrorState(response)
    }
}
