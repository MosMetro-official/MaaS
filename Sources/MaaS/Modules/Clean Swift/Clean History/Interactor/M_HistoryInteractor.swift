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
        M_HistoryTrips.fetchHistoryTrips(by: limit, offset: offset) { result in
            switch result {
            case .success(let trips):
                self.trips += trips
                self.offset = self.offset == 0 ? self.trips.count : (self.offset + self.trips.count)
                let response = M_HistoryModels.Response.Trips(trips: self.trips, isLoadingMore: false)
                self.presenter?.prepareViewModel(response)
            case .failure(let error):
                self.requestError(title: error.errorTitle, descr: error.localizedDescription)
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
