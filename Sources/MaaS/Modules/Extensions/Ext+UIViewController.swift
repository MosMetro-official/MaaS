//
//  File.swift
//  
//
//  Created by Слава Платонов on 30.04.2022.
//

import UIKit

extension UIViewController {
    internal func setupBackButton() {
        navigationItem.hidesBackButton = true
        let backItem = UIBarButtonItem(
            image: UIImage.getAssetImage(image: "backButton"),
            style: .plain,
            target: self,
            action: #selector(backButtonPressed)
        )
        navigationItem.leftBarButtonItem = backItem
    }
    
    @objc
    private func backButtonPressed() {
        guard let navigation = self.navigationController else { return }
        navigation.popViewController(animated: true)
    }
    
    // for check screen
    func showActiveSubTest() {
        let activeButton = UIBarButtonItem(
            image: UIImage.getAssetImage(image: "mir"),
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
}
