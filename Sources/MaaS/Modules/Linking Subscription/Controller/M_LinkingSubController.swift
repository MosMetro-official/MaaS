//
//  M_LinkingSubController.swift
//  MaaS
//
//  Created by Слава Платонов on 13.06.2022.
//

import UIKit
import SafariServices
import CoreTableView

class M_LinkingSubController: UIViewController {
    
    enum ResultModel {
        case success
        case failure
        case loading
    }
    
    public var resultModel: ResultModel = .loading {
        didSet {
            makeState()
        }
    }
    
    let nestedView = M_LinkingSubView.loadFromNib()
    
    override func loadView() {
        super.loadView()
        self.view = nestedView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    private func makeState() {
        switch resultModel {
        case .loading:
            nestedView.viewState = .init(dataState: .loading, onAction: nil, onClose: nil)
        case .failure:
            let onAction = Command {
                // send form
            }
            let onClose = Command {
                self.navigationController?.popViewController(animated: true)
            }
            let error = M_LinkingSubView.ViewState.Action(
                title: "Что-то пошло не так",
                descr: "Мы уже разбираемся в причине, попробуйте еще раз или напишите нам"
            )
            nestedView.viewState = .init(dataState: .failure(error), onAction: onAction, onClose: onClose)
        case .success:
            let onAction = Command {
                // open onboarding
            }
            let onClose = Command {
                self.navigationController?.viewControllers[0] = M_ActiveSubController()
                self.navigationController?.popToRootViewController(animated: true)
            }
            let success = M_LinkingSubView.ViewState.Action(
                title: "Успешно",
                descr: "Мы привязали подписку МультиТранспорт Мини к вашей карте"
            )
            nestedView.viewState = .init(dataState: .success(success), onAction: onAction, onClose: onClose)
        }
    }
    

    

}
