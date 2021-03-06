//
//  M_LoadingView.swift
//  
//
//  Created by Слава Платонов on 06.05.2022.
//

import UIKit

protocol _Loading {
    var title: String { get }
    var descr: String { get }
}

class M_LoadingView: UIView {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descrLabel: UILabel!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    
    public func configure(with data: _Loading) {
        titleLabel.text = data.title
        descrLabel.text = data.descr
    }
}

extension UIView {
    func showLoading(on view: UIView, data: _Loading) {
        let loadingView = M_LoadingView.loadFromNib()
        loadingView.frame = view.frame
        loadingView.alpha = 0
        loadingView.tag = 111
        loadingView.configure(with: data)
        let animator = UIViewPropertyAnimator(duration: 0.25, curve: .easeInOut) {
            view.addSubview(loadingView)
            loadingView.alpha = 1
        }
        animator.startAnimation()
    }
    
    func removeLoading(from view: UIView) {
        view.subviews.forEach { _view in
            if _view.tag == 111 {
                UIView.animate(withDuration: 0.4) {
                    _view.alpha = 0
                } completion: { success in
                    if success {
                        _view.removeFromSuperview()
                    }
                }
            }
        }
    }
    
}
