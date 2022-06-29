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
        fetchUserHistoryTrips(by: limit)
    }
    
    private func fetchUserHistoryTrips(by limit: Int) {
        self.showLoading()
        M_HistoryTrips.fetchHistoryTrips(by: limit) { result in
            switch result {
            case .success(let trips):
                self.trips = trips
                self.limit *= 2 // for load more button
            case.failure(let error):
                self.showError(with: error.errorTitle, and: error.errorDescription)
            }
        }
    }
    
    private func showLoading() {
        let loadingState = M_TripsHistoryView.ViewState.Loading(title: "Загрузка...", descr: "Немного подождите")
        nestedView.viewState = .init(state: [], dataState: .loading(loadingState))
    }
    
    private func showError(with title: String, and descr: String) {
        let onRetry = Command {
            self.fetchUserHistoryTrips(by: self.limit)
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
                        dateTitle = M_DateConverter.validateStringFrom(date: start)
                    }
                case .done:
                    if let end = trip.trip.time.end {
                        dateTitle = M_DateConverter.validateStringFrom(date: end)
                    }
                case .canceled:
                    dateTitle = "Поездка отменена"
                default:
                    dateTitle = "Ошибка"
                }
                let history = M_TripsHistoryView.ViewState.History(
                    title: trip.trip.route.ru,
                    image: UIImage.getAssetImage(image: "transport"),
                    date: dateTitle,
                    height: 70
                ).toElement()
                let historyState = State(model: SectionState(header: nil, footer: nil), elements: [history])
                states.append(historyState)
            }
        } else {
            let empty = M_TripsHistoryView.ViewState.Empty(height: UIScreen.main.bounds.height / 2).toElement()
            let state = State(model: SectionState(header: nil, footer: nil), elements: [empty])
            states.append(state)
        }
        nestedView.viewState = .init(state: states, dataState: .loaded)
    }
}
