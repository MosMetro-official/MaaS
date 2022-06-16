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
            .font: UIFont(name: "MoscowSans-medium", size: 20) ?? UIFont.systemFont(ofSize: 20)
        ]
        title = "История поездок"
        setupBackButton()
        fetchUserHistoryTrips()
    }
    
    private func fetchUserHistoryTrips() {
        M_HistoryTrips.getHistoryTrips(by: 15, and: 0, from: "", to: "") { result in
            switch result {
            case .success(let trips):
                self.trips = trips
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
            
        }
        let onClose = Command {
            self.navigationController?.popViewController(animated: true)
        }
        let errorState = M_TripsHistoryView.ViewState.Error(title: title, descr: descr, onRetry: onRetry, onClose: onClose)
        nestedView.viewState = .init(state: [], dataState: .error(errorState))
    }
    
    
    private func makeState() {
        var states = [State]()
        if !trips.isEmpty {
            trips.forEach { trip in
                var dateTitle = ""
                switch trip.trip.status {
                case "STARTED":
                    dateTitle = trip.trip.time.start
                case "DONE":
                    dateTitle = trip.trip.time.end
                case "CANCELED":
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
