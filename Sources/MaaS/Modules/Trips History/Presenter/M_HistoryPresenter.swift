//
//  M_HistoryPresenter.swift
//  Pods
//
//  Created by Слава Платонов on 08.09.2022.
//

import CoreTableView

protocol M_HistoryPresentationLogic: AnyObject {
    func prepareViewModel(_ response: M_HistoryModels.Response.Trips)
    func prepareLoadingState(_ response: M_HistoryModels.Response.Loading)
    func prepareErrorState(_ response: M_HistoryModels.Response.Error)
}

final class M_HistoryPresenter: M_HistoryPresentationLogic {
    
    weak var controller: M_HistoryDisplayLogic?
    
    init(controller: M_HistoryDisplayLogic? = nil) {
        self.controller = controller
    }
    
    func prepareViewModel(_ response: M_HistoryModels.Response.Trips) {
        let states = makeState(from: response)
        let viewState = M_TripsHistoryView.ViewState(state: states, dataState: .loaded)
        let viewModel = M_HistoryModels.ViewModel(viewState: viewState)
        controller?.displayTrips(viewModel)
    }
    
    func prepareLoadingState(_ response: M_HistoryModels.Response.Loading) {
        let loading = M_TripsHistoryView.ViewState.Loading(
            title: response.title,
            descr: response.descr
        )
        let viewState = M_TripsHistoryView.ViewState(
            state: [],
            dataState: .loading(loading)
        )
        let viewModel = M_HistoryModels.ViewModel(viewState: viewState)
        controller?.displayTrips(viewModel)
    }
    
    func prepareErrorState(_ response: M_HistoryModels.Response.Error) {
        let onRetry = Command {
            self.controller?.requestTrips()
        }
        let onClose = Command {
            self.controller?.popViewController()
        }
        let error = M_TripsHistoryView.ViewState.Error(
            title: response.title,
            descr: response.descr,
            onRetry: onRetry,
            onClose: onClose
        )
        let viewState = M_TripsHistoryView.ViewState(
            state: [],
            dataState: .error(error)
        )
        let viewModel = M_HistoryModels.ViewModel(viewState: viewState)
        controller?.displayTrips(viewModel)
    }
    
    private func makeState(from response: M_HistoryModels.Response.Trips) -> [State] {
        var states: [State] = []
        if !response.trips.isEmpty {
            response.trips.forEach { trip in
                var dateTitle = ""
                switch trip.trip.status {
                case .started:
                    if let start = trip.trip.time.start {
                        dateTitle = M_DateConverter.validateStringFrom(date: start, format: "dd MMMM yyyy: HH:mm")
                    }
                case .done:
                    if let end = trip.trip.time.end {
                        dateTitle = M_DateConverter.validateStringFrom(date: end, format: "dd MMMM yyyy: HH:mm")
                    }
                case .canceled:
                    dateTitle = "Поездка отменена"
                default:
                    dateTitle = "Ошибка"
                }
                let serviceName: String = {
                    if let name = trip.subscription.tariffs.first(where: { $0.serviceId == trip.trip.serviceId } )?.name?.ru {
                        return name
                    } else {
                        return "Поездка MaaS"
                    }
                }()
                let route = trip.trip.route.ru == "" ? "" : "Маршрут: \(trip.trip.route.ru)"
                let titleHeight = serviceName.height(
                    withConstrainedWidth: UIScreen.main.bounds.width - 64,
                    font: Appearance.getFont(.card)
                )
                let dateHeight = dateTitle.height(
                    withConstrainedWidth: UIScreen.main.bounds.width - 64,
                    font: Appearance.getFont(.body)
                )
                let routeHeight = route == "" ? 10 : route.height(
                    withConstrainedWidth: UIScreen.main.bounds.width - 64,
                    font: Appearance.getFont(.body)) + 18
                let history = M_TripsHistoryView.ViewState.History(
                    id: trip.trip.serviceTripId + trip.trip.serviceId,
                    title: serviceName,
                    imageURL: trip.imageURL,
                    date: dateTitle,
                    route: route,
                    height: titleHeight + dateHeight + routeHeight + 20
                ).toElement()
                let historyState = State(model: SectionState(id: "history", header: nil, footer: nil), elements: [history])
                states.append(historyState)
            }
            let onLoad = Command { [weak self] in
                guard let self = self else { return }
                self.controller?.requestMoreTrips()
            }
            let loadMore = M_TripsHistoryView.ViewState.LoadMore(state: response.isLoadingMore ? .loading : .normal, onLoad: onLoad).toElement()
            states.append(.init(model: .init(id: "loadmore"), elements: [loadMore]))
        } else {
            let empty = M_TripsHistoryView.ViewState.Empty(
                id: "empty",
                height: UIScreen.main.bounds.height / 2
            ).toElement()
            let state = State(model: .init(id: "Empty"), elements: [empty])
            states.append(state)
        }
        return states
    }
}
