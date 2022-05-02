//
//  CardInfoCell.swift
//  
//
//  Created by Слава Платонов on 01.05.2022.
//

import UIKit
import CoreTableView

protocol _CardInfo: CellData {
    var cardImage: UIImage { get }
    var cardNumber: String { get }
    var cardDescription: String { get }
}

extension _CardInfo {
    var height: CGFloat {
        return 80
    }
    
    func hashValues() -> [Int] {
        return [cardImage.hashValue, cardNumber.hashValue, cardDescription.hashValue]
    }
    
    func prepare(cell: UITableViewCell, for tableView: UITableView, indexPath: IndexPath) {
        guard let cell = cell as? CardInfoCell else { return }
        cell.configure(with: self)
    }
    
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        tableView.register(CardInfoCell.nib, forCellReuseIdentifier: CardInfoCell.identifire)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CardInfoCell.identifire, for: indexPath) as? CardInfoCell else { return .init() }
        return cell
    }
}

class CardInfoCell: UITableViewCell {

    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var cardDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    public func configure(with data: _CardInfo) {
        cardImage.image = data.cardImage
        cardNumberLabel.text = data.cardNumber
        cardDescriptionLabel.text = data.cardDescription
    }
    
}
