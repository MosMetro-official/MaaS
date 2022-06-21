//
//  CardInfoCell.swift
//  
//
//  Created by Слава Платонов on 01.05.2022.
//

import UIKit
import CoreTableView

protocol _CardInfo: CellData {
    var cardImage: PaySystem { get }
    var cardNumber: String { get }
    var cardDescription: String { get }
    var leftCountChangeCard: String { get }
}

extension _CardInfo {
    func hashValues() -> [Int] {
        return [
            cardImage.hashValue,
            cardNumber.hashValue,
            cardDescription.hashValue,
            leftCountChangeCard.hashValue
        ]
    }
    
    func prepare(cell: UITableViewCell, for tableView: UITableView, indexPath: IndexPath) {
        guard let cell = cell as? M_CardInfoCell else { return }
        cell.configure(with: self)
    }
    
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        tableView.register(M_CardInfoCell.nib, forCellReuseIdentifier: M_CardInfoCell.identifire)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: M_CardInfoCell.identifire, for: indexPath) as? M_CardInfoCell else { return .init() }
        return cell
    }
}

class M_CardInfoCell: UITableViewCell {
    
    @IBOutlet private weak var cardImage: UIImageView!
    @IBOutlet private weak var cardNumberLabel: UILabel!
    @IBOutlet private weak var cardDescriptionLabel: UILabel!
    @IBOutlet private weak var leftCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public func configure(with data: _CardInfo) {
        cardImage.image = UIImage.getCardHolderImage(for: data.cardImage)
        cardNumberLabel.text = data.cardNumber
        cardDescriptionLabel.text = data.cardDescription
        leftCountLabel.text = data.leftCountChangeCard
    }
}
