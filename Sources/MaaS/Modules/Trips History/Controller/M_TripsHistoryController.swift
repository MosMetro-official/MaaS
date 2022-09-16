//
//  M_TripsHistoryController.swift
//  MaaS
//
//  Created by Слава Платонов on 16.06.2022.
//

import UIKit
import CoreTableView

class M_TripsHistoryController: UIViewController {
    
    private let nestedView = M_TripsHistoryView.loadFromNib()
    
    private var limit = 15
    private var offset = 0
    private var isLoadingMore = false {
        didSet {
            makeState()
        }
    }
    
    private var trips: [M_HistoryTrips] = [] {
        didSet {
            makeState()
        }
    }
    
    override func loadView() {
        super.loadView()
        self.view = nestedView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [
            .font: Appearance.getFont(.navTitle)
        ]
        title = "История поездок"
        setupBackButton()
        self.showLoading()
        fetchUserHistoryTrips(by: limit, offset: 0)
    }
    
    private func fetchUserHistoryTrips(by limit: Int, offset: Int) {
        M_HistoryTrips.fetchHistoryTrips(by: limit, offset: offset) { result in
            switch result {
            case .success(let trips):
                self.trips += trips
                self.offset = self.offset == 0 ? self.trips.count : (self.offset + self.trips.count)
                self.isLoadingMore = false
            case.failure(let error):
                self.showError(with: error.errorTitle, and: error.errorSubtitle)
            }
        }
    }
    
    private func showLoading() {
        let loadingState = M_TripsHistoryView.ViewState.Loading(title: "Загрузка...", descr: "Немного подождите")
        nestedView.viewState = .init(state: [], dataState: .loading(loadingState))
    }
    
    private func showError(with title: String, and descr: String) {
        let onRetry = Command {
            self.fetchUserHistoryTrips(by: self.limit, offset: 0)
        }
        let onClose = Command {
            self.navigationController?.popViewController(animated: true)
        }
        let errorState = M_TripsHistoryView.ViewState.Error(
            title: title,
            descr: descr,
            onRetry: onRetry,
            onClose: onClose
        )
        nestedView.viewState = .init(state: [], dataState: .error(errorState))
    }
    
    
    private func makeState() {
        var states = [State]()
        if !trips.isEmpty {
            trips.forEach { trip in
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
                let imageURL = trip.subscription.tariffs.first(where: { $0.serviceId == trip.trip.serviceId })
                imageURL?.imageURL
                let serviceName: String = {
                    if let name = trip.subscription.tariffs.first(where: { $0.serviceId == trip.trip.serviceId } )?.name.ru {
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
                self.isLoadingMore = true
                self.fetchUserHistoryTrips(by: self.limit, offset: self.limit + self.offset)
            }
            let loadMore = M_TripsHistoryView.ViewState.LoadMore(state: isLoadingMore ? .loading : .normal, onLoad: onLoad).toElement()
            states.append(.init(model: .init(id: "loadmore"), elements: [loadMore]))
            
        } else {
            let empty = M_TripsHistoryView.ViewState.Empty(id: "empty", height: UIScreen.main.bounds.height / 2).toElement()
            let state = State(model: SectionState(id: "empty", header: nil, footer: nil), elements: [empty])
            states.append(state)
        }
        nestedView.viewState = .init(state: states, dataState: .loaded)
    }
}
