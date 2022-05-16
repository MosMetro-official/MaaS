//
//  M_ChooseSubView.swift
//  
//
//  Created by Слава Платонов on 29.04.2022.
//

import UIKit
import CoreTableView

class M_ChooseSubView: UIView {

    struct ViewState {
        let state: [State]
        let dataState: DataState
        let payButtonEnable: Bool
        let payButtonTitle: String
        let payCommand: Command<Void>?
        
        enum DataState {
            case loading(_Loading)
            case loaded
            case error(_Error)
        }
        
        struct Loading: _Loading {
            let title: String
            let descr: String
        }
        
        struct Error: _Error {
            let title: String
            let descr: String
            let onRetry: Command<Void>
            let onClose: Command<Void>
        }
        
        struct SubSectionRow: _SubSectionRow {
            let title: String
            let price: String
            let isSelect: Bool
            let showSelectImage: Bool
            let tariffs: [SubTariffs]
            let onItemSelect: Command<Void>
            let height: CGFloat
        }
        
        struct MakeMySubRow: _MakeMySubRow {
            let title: String
            let descr: String
            let isSelect: Bool
            let onItemSelect: Command<Void>
            let height: CGFloat
        }
        
        static let initial = ViewState(state: [], dataState: .loaded, payButtonEnable: false, payButtonTitle: "", payCommand: nil)
    }
    
    public var viewState: ViewState = .initial {
        didSet {
            DispatchQueue.main.async {
                self.render()
            }
        }
    }
    
    @IBOutlet weak var titleLabel: GradientLabel!
    @IBOutlet weak var changeLabel: UILabel!
    @IBOutlet weak var tableView: BaseTableView!
    @IBOutlet weak var payButton: UIButton!
    
    private var buttonGradient: CAGradientLayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 100, right: 0)
        tableView.shouldUseReload = true
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        payButton.layer.cornerRadius = 10
        titleLabel.gradientColors = [UIColor.from(hex: "#4AC7FA").cgColor, UIColor.from(hex: "#E649F5").cgColor]
        addHorizontalGradientLayer()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let buttonGradient = buttonGradient else { return }
        buttonGradient.frame = CGRect(x: 0, y: 0, width: payButton.bounds.width, height: payButton.bounds.height)
    }
    
    @IBAction func payButtonTapped() {
        viewState.payCommand?.perform(with: ())
    }
    
    private func addHorizontalGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: payButton.bounds.width, height: payButton.bounds.height)
        gradientLayer.cornerRadius = 10
        gradientLayer.colors = [UIColor.from(hex: "#4AC7FA").cgColor, UIColor.from(hex: "#E649F5").cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        self.buttonGradient = gradientLayer
        self.payButton.layer.insertSublayer(self.buttonGradient!, at: 0)
    }
    
    private func render() {
        self.payButton.isHidden = !viewState.payButtonEnable
        self.payButton.titleLabel?.font = Appearance.customFonts[.button]
        self.payButton.setTitle(viewState.payButtonTitle, for: .normal)
        self.tableView.viewStateInput = viewState.state
        switch viewState.dataState {
        case .loaded:
            self.removeLoading(from: self)
            self.removeError(from: self)
        case .loading(let data):
            self.removeError(from: self)
            showLoading(on: self, data: data)
        case .error(let data):
            self.removeLoading(from: self)
            showError(on: self, data: data)
        }
    }
    
}