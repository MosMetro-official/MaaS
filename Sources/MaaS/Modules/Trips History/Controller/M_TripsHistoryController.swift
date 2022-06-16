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
    
    let trips: [FakeHistory] = [
        FakeHistory(title: "Общественный транспорт", date: "Сегодня, в 17:00", image: UIImage.getAssetImage(image: "transport")),
        FakeHistory(title: "Велобайк", date: "Вчера, в 16:00", image: UIImage.getAssetImage(image: "transport")),
        FakeHistory(title: "Велобайк", date: "Поездка отменена", image: UIImage.getAssetImage(image: "transport"))
    ]
    
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
        makeState()
    }
    
    private func makeState() {
        var states = [State]()
        trips.forEach { trip in
            let history = M_TripsHistoryView.ViewState.History(
                title: trip.title,
                image: trip.image,
                date: trip.date,
                height: 70
            ).toElement()
            let historyState = State(model: SectionState(header: nil, footer: nil), elements: [history])
            states.append(historyState)
        }
        nestedView.viewState = .init(state: states, dataState: .loaded)
    }
}

struct FakeHistory {
    let title: String
    let date: String
    let image: UIImage
}
