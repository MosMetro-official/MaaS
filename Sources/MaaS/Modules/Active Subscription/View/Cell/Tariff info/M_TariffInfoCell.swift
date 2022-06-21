//
//  TariffInfoCell.swift
//  
//
//  Created by Слава Платонов on 01.05.2022.
//

import UIKit
import CoreTableView

protocol _TariffInfo: CellData {
    var transportTitle: String { get }
    var tariffType: String { get }
    var showProgress: Bool { get }
    var currentProgress: CGFloat? { get }
}

extension _TariffInfo {
    var currentProgress: CGFloat? {
        return nil
    }
    
    func hashValues() -> [Int] {
        return [
            transportTitle.hashValue,
            tariffType.hashValue,
            showProgress.hashValue,
        ]
    }
    
    func prepare(cell: UITableViewCell, for tableView: UITableView, indexPath: IndexPath) {
        guard let cell = cell as? M_TariffInfoCell else { return }
        cell.configure(with: self)
    }
    
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        tableView.register(M_TariffInfoCell.nib, forCellReuseIdentifier: M_TariffInfoCell.identifire)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: M_TariffInfoCell.identifire, for: indexPath) as? M_TariffInfoCell else { return .init() }
        return cell
    }
}

class M_TariffInfoCell: UITableViewCell {

    @IBOutlet private weak var transportTitleLabel: UILabel!
    @IBOutlet private weak var tariffLabel: UILabel!
    @IBOutlet private weak var gradientProgress: GradientProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public func configure(with data: _TariffInfo) {
        transportTitleLabel.text = data.transportTitle
        tariffLabel.text = data.tariffType
        gradientProgress.isHidden = !data.showProgress
        if let value = data.currentProgress {
            gradientProgress.progress = value
        }
    }
}
