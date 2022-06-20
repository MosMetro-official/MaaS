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
    
    internal func hideNavBar() {
        DispatchQueue.main.async {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    internal func showNavBar() {
        DispatchQueue.main.async {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    internal func showAlert(with title: String, and message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
}
