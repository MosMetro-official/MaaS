//
//  ChangeCardController.swift
//  MaaS
//
//  Created by Слава Платонов on 13.06.2022.
//

import UIKit
import CoreTableView

class ChangeCardController: UIViewController {
    
    private let fakeCard = FakeCard(type: "MIR", number: "1234", count: 3)
    
    private let nestedView = ChangeCardView.loadFromNib()
    
    override func loadView() {
        super.loadView()
        self.view = nestedView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        makeState()
        setupNavigationTitle()
        setupBackButton()
    }
    
    private func setupNavigationTitle() {
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont(name: "MoscowSans-medium", size: 20) ?? UIFont.systemFont(ofSize: 20)
        ]
        title = "Карта"
    }
    
    private func makeState() {
        let onChangeButton = Command {
            print("open change url")
        }
        let finalState = ChangeCardView.ViewState(
            cardType: fakeCard.type.lowercased(),
            cardNumber: fakeCard.number,
            countOfChangeCard: fakeCard.count,
            onChangeButton: fakeCard.count == 0 ? nil : onChangeButton
        )
        self.nestedView.viewState = finalState
    }

}

struct FakeCard {
    let type: String
    let number: String
    let count: Int
}
