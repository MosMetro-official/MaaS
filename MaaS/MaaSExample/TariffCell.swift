//
//  TariffCell.swift
//  MaaSExample
//
//  Created by Слава Платонов on 17.06.2022.
//

import UIKit
import MaaS

class TariffCell: UICollectionViewCell {
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tariffLabel: UILabel!
    @IBOutlet weak var roundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.roundView.clipsToBounds = true
        self.roundView.layer.cornerRadius = 10
        self.logoImage.layer.cornerRadius = 10
        self.logoImage.clipsToBounds = true
    }

    public func configure(with tariff: M_Tariff) {
        if tariff.name.ru.contains("Общественный") {
            self.titleLabel.text = "Общ. транспорт"
        } else {
            self.titleLabel.text = tariff.name.ru
        }
        guard let url = URL(string: tariff.imageURL) else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                if let data = data {
                    self.logoImage.image = UIImage(data: data)
                }
            }
        }.resume()
//        switch tariff.serviceId {
//        case "TAXI":
//            logoImage.image = UIImage(named: "YG 2")
//        default:
//            logoImage.image = UIImage(named: "YG 1")
//        }
        switch tariff.trip.count {
        case -1:
            tariffLabel.text = "Безлимит"
        default:
            tariffLabel.text = "\(tariff.trip.count) поездок"
        }
    }
}
