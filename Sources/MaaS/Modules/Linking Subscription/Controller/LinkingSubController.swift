//
//  LinkingSubController.swift
//  MaaS
//
//  Created by Слава Платонов on 13.06.2022.
//

import UIKit
import SafariServices

class LinkingSubController: UIViewController {
    
    let nestedView = LinkingSubView.loadFromNib()
    
    var paymentUrl: String!
    
    private func showPaymentController() {
        guard
            let paymentUrl = paymentUrl,
            let url = URL(string: paymentUrl) else { return }
        let sfc = SFSafariViewController(url: url)
        self.present(sfc, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    var maasId: String?
    
    override func loadView() {
        super.loadView()
        self.view = nestedView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        showPaymentController()
        
    }
    

    

}
