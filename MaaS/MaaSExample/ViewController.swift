//
//  ViewController.swift
//  MaaSExample
//
//  Created by Слава Платонов on 13.05.2022.
//

import UIKit
import MaaS

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let refreshControl = UIRefreshControl()

    @objc func refresh() {
       fetchUserInfo()
    }
    
    private var user: M_UserInfo? {
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    private var error: String = "" {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Личный кабинет"
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        setupTableView()
        fetchUserInfo()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = .leastNormalMagnitude
        tableView.register(UINib(nibName: "MaaSCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    private func fetchUserInfo() {
        MaaS.shared.getUserSubStatus { user, error in
            self.user = user
            if let errorTitle = error {
                self.error = errorTitle
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MaaSCell else { return .init() }
        cell.loadConfigure()
        if let user = user {
            if user.subscription?.id != "" {
                cell.authConfig(with: user) {
                    let active = MaaS.shared.showActiveFlow()
                    let nav = UINavigationController(rootViewController: active)
                    nav.modalPresentationStyle = .fullScreen
                    self.present(nav, animated: true)
                }
            } else {
                cell.nonAuthConfigure {
                    let choose = MaaS.shared.showChooseFlow()
                    let nav = UINavigationController(rootViewController: choose)
                    nav.modalPresentationStyle = .fullScreen
                    self.present(nav, animated: true)
                }
            }
        }
        
        if error != "" {
            cell.errorConfigure(title: "Ошибочка 😢") {
                cell.loadConfigure()
                self.fetchUserInfo()
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            if error != "" {
                break
            }
            if MaaS.shared.userHasSub {
                let active = MaaS.shared.showActiveFlow()
                let nav = UINavigationController(rootViewController: active)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            } else {
                let choose = MaaS.shared.showChooseFlow()
                let nav = UINavigationController(rootViewController: choose)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }
        default:
            break
        }
    }
}
