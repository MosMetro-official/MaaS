//
//  M_ActiveSubController.swift
//  
//
//  Created by Слава Платонов on 30.04.2022.
//

import UIKit
import CoreTableView

class M_ActiveSubController: UIViewController {
    
    let nestedView = M_ActiveSubView.loadFromNib()
    
    override func loadView() {
        super.loadView()
        self.view = nestedView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButton()
        makeState()
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont(name: "MoscowSans-medium", size: 20) ?? UIFont.systemFont(ofSize: 20)
        ]
        title = "Подписка"
    }
    
    // TODO: а для чего данная функция? 
    private func setState(with states: [State]) {
        let viewState = M_ActiveSubView.ViewState(timeLeft: "Активна до 22 марта 2022", state: states, dataState: .loaded)
        nestedView.viewState = viewState
    }
    
    private func makeState() {
        let bigHeight: CGFloat = 100
        let normalHeight: CGFloat = 70
        var states: [State] = []
        let cardInfo = M_ActiveSubView.ViewState.CardInfo(cardImage: UIImage.getAssetImage(image: "mir"), cardNumber: "МИР •••• 2267", cardDescription: "Для прохода в транспорте").toElement()
        let cardState = State(model: SectionState(header: nil, footer: nil), elements: [cardInfo])
        states.append(cardState)
        
        let tariffSection = M_ActiveSubView.ViewState.HeaderCell().toElement()
        let tariffOne = M_ActiveSubView.ViewState.TariffInfo(transportTitle: "Такси", tariffType: nil, totalTripCount: "10", leftTripCount: "2", showProgress: true, height: bigHeight).toElement()
        let tariffTwo = M_ActiveSubView.ViewState.TariffInfo(transportTitle: "Общественный транспорт", tariffType: "Безлимит", totalTripCount: nil, leftTripCount: nil, showProgress: false, height: normalHeight).toElement()
        let tariffState = State(model: SectionState(header: nil, footer: nil), elements: [tariffSection, tariffOne, tariffTwo])
        states.append(tariffState)
        
        
        // TODO: camel case
        let onboardSelect = Command {
            print("show onboarding controller")
        }
        
        let onHistorySelect = Command {
            print("show history controller")
        }
        let onboarding = M_ActiveSubView.ViewState.Onboarding(onOnboardingSelect: onboardSelect, onHistorySelect: onHistorySelect).toElement()
        let onboardingState = State(model: SectionState(header: nil, footer: nil), elements: [onboarding])
        states.append(onboardingState)
        setState(with: states)
    }
    

   

}
