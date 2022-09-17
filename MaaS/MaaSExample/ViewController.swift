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
    private let maas = MaaS()
    
    private var oldMaskedPan: String?
    private var newMaskedPan: String?

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
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: .maasUpdateUserInfo, object: nil)
    }
    
    @objc private func updateUI(from notification: Notification) {
        if let newMask = notification.userInfo?["card"] as? String {
            self.newMaskedPan = newMask
        }
        fetchUserInfo()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = .leastNormalMagnitude
        tableView.register(UINib(nibName: "MaaSCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    private func fetchUserInfo() {
        maas.getUserInfo { [weak self] user, error in
            guard let self = self else { return }
            if let user = user {
                self.user = user
            }
            if let error = error {
                self.error = error.errorTitle
            }
        }
    }
    
    private func showActiveFlow() {
        let active = maas.showActiveFlow()
        let nav = UINavigationController(rootViewController: active)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
    }
    
    private func showChooseFlow() {
        let choose = maas.showChooseFlow()
        let nav = UINavigationController(rootViewController: choose)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
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
            switch user.subscription?.status {
            case .active:
                cell.authConfig(with: user) { [weak self] in
                    self?.showActiveFlow()
                }
            case .unknow:
                cell.nonAuthConfigure(message: "Нужно оформить подписку") { [weak self] in
                    self?.showChooseFlow()
                }
            case .created, .processing:
                cell.authProccessingConfig(message: "Ваша подписка оформляется") { [weak self] in
                    cell.loadConfigure()
                    self?.fetchUserInfo()
                }
            case .expired:
                cell.nonAuthConfigure(message: "Ваша подписка закончилась") { [weak self] in
                    self?.showChooseFlow()
                }
            case .canceled:
                cell.nonAuthConfigure(message: "Ваша подписка была аннулиорована") { [weak self] in
                    self?.showChooseFlow()
                }
            case .blocked:
                cell.nonAuthConfigure(message: "Ваша подписка была заблокирована") { [weak self] in
                    self?.showChooseFlow()
                }
            default:
                break
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
            switch user?.subscription?.status {
            case .active:
                self.showActiveFlow()
            case .created, .processing, .blocked:
                break
            case .expired, .canceled:
                self.showChooseFlow()
            case .unknow:
                self.showChooseFlow()
            default:
                break
            }
        default:
            break
        }
    }
}
