//
//  M_DebtInfoCell.swift
//  MaaS
//
//  Created by Слава Платонов on 11.06.2022.
//

import UIKit
import CoreTableView

protocol _DebtInfoCell: CellData {
    var totalDebt: String { get }
    var onButton: Command<Void> { get }
}

extension _DebtInfoCell {
    func hashValues() -> [Int] {
        return [totalDebt.hashValue]
    }
    
    func prepare(cell: UITableViewCell, for tableView: UITableView, indexPath: IndexPath) {
        guard let cell = cell as? M_DebtInfoCell else { return }
        cell.configure(with: self)
    }
    
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        tableView.register(M_DebtInfoCell.nib, forCellReuseIdentifier: M_DebtInfoCell.identifire)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: M_DebtInfoCell.identifire, for: indexPath) as? M_DebtInfoCell else { return .init() }
        return cell
    }
}

class M_DebtInfoCell: UITableViewCell {
    
    var onButtonTapped: Command<Void>?

    @IBOutlet private weak var moreButton: UIButton!
    @IBOutlet private weak var debtLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func moreButtonPressed() {
        onButtonTapped?.perform(with: ())
    }
    
    public func configure(with data: _DebtInfoCell) {
        debtLabel.text = data.totalDebt
        onButtonTapped = data.onButton
    }
}
