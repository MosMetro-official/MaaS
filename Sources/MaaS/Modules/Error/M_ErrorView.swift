//
//  M_ErrorView.swift
//  
//
//  Created by Слава Платонов on 06.05.2022.
//

import UIKit
import CoreTableView

protocol _Error {
    var title: String { get }
    var descr: String { get }
    var onRetry: Command<Void> { get }
    var onClose: Command<Void> { get }
}

class M_ErrorView: UIView {
    
    var onRetry: Command<Void>?
    var onClose: Command<Void>?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descrLabel: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        retryButton.layer.cornerRadius = 10
        retryButton.titleLabel?.font = Appearance.customFonts[.button]
        closeButton.layer.cornerRadius = 10
        closeButton.titleLabel?.font = Appearance.customFonts[.button]
    }
    
    @IBAction func onRetryTapped() {
        onRetry?.perform(with: ())
    }
    
    @IBAction func onCloseTapped() {
        onClose?.perform(with: ())
    }
    
    public func configure(with data: _Error) {
        titleLabel.text = data.title
        descrLabel.text = data.descr
        onRetry = data.onRetry
        onClose = data.onClose
    }
}

extension UIView {
    func showError(on view: UIView, data: _Error) {
        let errorView = M_ErrorView.loadFromNib()
        errorView.frame = view.frame
        errorView.tag = 222
        errorView.configure(with: data)
        let animator = UIViewPropertyAnimator(duration: 0.25, curve: .easeInOut) {
            view.addSubview(errorView)
        }
        animator.startAnimation()
    }
    
    func removeError(from view: UIView) {
        view.subviews.forEach { _view in
            if _view.tag == 222 {
                let animator = UIViewPropertyAnimator(duration: 0.25, curve: .easeInOut) {
                    _view.removeFromSuperview()
                }
                animator.startAnimation()
            }
        }
    }
}
