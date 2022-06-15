//
//  File.swift
//  
//
//  Created by Слава Платонов on 30.04.2022.
//

import UIKit

extension UIViewController {
    internal func setupBackButton() {
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = UIColor.getAssetColor(name: "backButton")
    }
    
    // for check screen
    internal func showActiveSubTest() {
        let activeButton = UIBarButtonItem(
            image: UIImage(systemName: "creditcard.fill"),
            style: .plain,
            target: self,
            action: #selector(showActiveSub)
        )
        navigationItem.rightBarButtonItem = activeButton
    }
    
    @objc
    private func showActiveSub() {
        guard let navigation = self.navigationController else { return }
        let activeSubController = M_ActiveSubController()
        navigation.pushViewController(activeSubController, animated: true)
    }
    
    internal func showAlert(with title: String, and message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
}
