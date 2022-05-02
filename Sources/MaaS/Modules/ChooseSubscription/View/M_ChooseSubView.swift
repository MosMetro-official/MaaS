//
//  M_ChooseSubView.swift
//  
//
//  Created by Слава Платонов on 29.04.2022.
//

import UIKit
import CoreTableView

class M_ChooseSubView: UIView {

    @IBOutlet weak var titleLabel: GradientLabel!
    @IBOutlet weak var changeLabel: UILabel!
    @IBOutlet weak var tableView: BaseTableView!
    @IBOutlet weak var payButton: UIButton!
    
    private var buttonGradient: CAGradientLayer?
    
    struct ViewState {
        let state: [State]
        let dataState: DataState
        let payButtonEnable: Bool
        let payButtonTitle: String
        let payCommand: Command<Void>?
        
        enum DataState {
            case loading
            case loaded
            case error
        }
        
        struct SubSectionRow: _SubSectionRow {
            let title: String
            let price: String
            let isSelect: Bool
            let taxiCount: String
            let trasnportTariff: String
            let bikeTariff: String
            let onItemSelect: Command<Void>
        }
        
        struct MakeMySubRow: _MakeMySubRow {
            let isSelect: Bool
            let onItemSelect: Command<Void>
        }
        
        static let initial = ViewState(state: [], dataState: .loading, payButtonEnable: false, payButtonTitle: "", payCommand: nil)
    }
    
    public var viewState: ViewState = .initial {
        didSet {
            DispatchQueue.main.async {
                self.render()
            }
        }
    }
    
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
        switch viewState.dataState {
        case .loaded:
            self.payButton.isHidden = !viewState.payButtonEnable
            self.payButton.titleLabel?.font = Appearance.customFonts[.button]
            self.tableView.viewStateInput = viewState.state
            self.payButton.setTitle(viewState.payButtonTitle, for: .normal)
        case .loading:
            print("loading")
        case .error:
            print("error")
        }
    }
    
}
