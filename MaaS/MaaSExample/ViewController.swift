//
//  ViewController.swift
//  MaaSExample
//
//  Created by Слава Платонов on 13.05.2022.
//

import UIKit
import MaaS

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = MaaS.shared.showMaaSFlow()
        self.present(vc, animated: true)
    }


}

