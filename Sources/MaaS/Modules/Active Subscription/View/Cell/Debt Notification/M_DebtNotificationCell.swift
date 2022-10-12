//
//  M_DebtNotificationCell.swift
//  MaaS
//
//  Created by Слава Платонов on 19.07.2022.
//

import UIKit
import CoreTableView

protocol _DebtNotification: CellData {
    var notificationDescr: String { get }
}

extension _DebtNotification {
    
    func hashValues() -> [Int] {
        return [notificationDescr.hashValue]
    }
    
    func prepare(cell: UITableViewCell, for tableView: UITableView, indexPath: IndexPath) {
        guard let cell = cell as? M_DebtNotificationCell else { return }
        cell.configure(with: self)
    }
    
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        tableView.register(M_DebtNotificationCell.nib, forCellReuseIdentifier: M_DebtNotificationCell.identifire)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: M_DebtNotificationCell.identifire, for: indexPath) as? M_DebtNotificationCell else { return .init() }
        return cell
    }
}

class M_DebtNotificationCell: UITableViewCell {

    @IBOutlet private var countDescrLabel: UILabel!
    @IBOutlet private var notificationView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        notificationView.layer.cornerRadius = 10
    }
    
    public func configure(with data: _DebtNotification) {
        notificationView.isHidden = data.notificationDescr == ""
        countDescrLabel.text = data.notificationDescr
    }
}
