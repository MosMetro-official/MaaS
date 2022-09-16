//
//  M_TripsHistoryController.swift
//  Pods
//
//  Created by Слава Платонов on 08.09.2022.
//

import UIKit

protocol M_HistoryDisplayLogic: AnyObject {
    func requestTrips()
    func requestMoreTrips()
    func popViewController()
    func displayTrips(_ viewModel: M_HistoryModels.ViewModel.ViewState)
}

final class M_TripsHistoryController: UIViewController {
    
    private let nestedView = M_TripsHistoryView.loadFromNib()
    
    private var interactor: M_HistoryBusinessLogic?
    private var router: M_HistoryRoutingLogic?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
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
        let request = M_HistoryModels.Request.Trips(isLoadingMore: false)
        interactor?.fetchTrips(request)
    }
    
    private func setup() {
        let presenter = M_HistoryPresenter(controller: self)
        let interactor = M_HistoryInteractor(presenter: presenter)
        let router = M_HistoryRouter(controller: self)
        self.interactor = interactor
        self.router = router
    }
}

extension M_TripsHistoryController: M_HistoryDisplayLogic {
    
    func displayTrips(_ viewModel: M_HistoryModels.ViewModel.ViewState) {
        nestedView.viewModel = viewModel
    }
    
    func requestMoreTrips() {
        let request = M_HistoryModels.Request.Trips(isLoadingMore: true)
        interactor?.fetchTrips(request)
    }
    
    func requestTrips() {
        let request = M_HistoryModels.Request.Trips(isLoadingMore: false)
        interactor?.fetchTrips(request)
    }
    
    func popViewController() {
        router?.popViewController()
    }
}
