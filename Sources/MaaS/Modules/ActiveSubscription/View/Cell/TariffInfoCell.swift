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
    var tariffType: String? { get }
    var totalTripCount: String? { get }
    var leftTripCount: String? { get }
    var showProgress: Bool { get }
}

extension _TariffInfo {
    func hashValues() -> [Int] {
        return [
            transportTitle.hashValue,
            showProgress.hashValue
        ]
    }
    
    func prepare(cell: UITableViewCell, for tableView: UITableView, indexPath: IndexPath) {
        guard let cell = cell as? TariffInfoCell else { return }
        cell.configure(with: self)
    }
    
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        tableView.register(TariffInfoCell.nib, forCellReuseIdentifier: TariffInfoCell.identifire)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TariffInfoCell.identifire, for: indexPath) as? TariffInfoCell else { return .init() }
        return cell
    }
}

class TariffInfoCell: UITableViewCell {

    @IBOutlet weak var transportTitleLabel: UILabel!
    @IBOutlet weak var tariffLabel: UILabel!
    @IBOutlet weak var gradientProgress: GradientProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        transportTitleLabel.font = UIFont(name: "MoscowSans-regular", size: 15)
        tariffLabel.font = UIFont(name: "MoscowSans-regular", size: 15)
        
    }
    
    private func getCurrentTariffLabel(from data: _TariffInfo) -> String {
        var result = ""
        if let type = data.tariffType {
            result = type
        } else if let totalTrip = data.totalTripCount, let leftTrip = data.leftTripCount {
            result = "Осталось \(leftTrip) поезкди из \(totalTrip)"
        }
        return result
    }
    
    private func getCurrentProgress(from data: _TariffInfo) -> CGFloat {
        var progress: Float = 0
        if let leftTrip = data.leftTripCount {
            progress = 1 - (Float(leftTrip) ?? 0) / 10
        }
        return CGFloat(progress)
    }
    
    public func configure(with data: _TariffInfo) {
        transportTitleLabel.text = data.transportTitle
        tariffLabel.text = getCurrentTariffLabel(from: data)
        if data.totalTripCount == nil {
            gradientProgress.isHidden = true
        }
        gradientProgress.progress = getCurrentProgress(from: data)
    }
}
