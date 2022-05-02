//
//  SubSectionRow.swift
//  
//
//  Created by Слава Платонов on 29.04.2022.
//

import UIKit
import CoreTableView

protocol _SubSectionRow: CellData {
    var title: String { get }
    var price: String { get }
    var isSelect: Bool { get }
    var taxiCount: String { get }
    var trasnportTariff: String { get }
    var bikeTariff: String { get }
}

extension _SubSectionRow {
    var height: CGFloat {
        return 200
    }
    
    func hashValues() -> [Int] {
        return [
            title.hashValue,
            price.hashValue,
            isSelect.hashValue,
            taxiCount.hashValue,
            trasnportTariff.hashValue,
            bikeTariff.hashValue
        ]
    }
    
    func prepare(cell: UITableViewCell, for tableView: UITableView, indexPath: IndexPath) {
        guard let cell = cell as? SubSectionRow else { return }
        cell.configure(with: self)
    }
    
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        tableView.register(SubSectionRow.nib, forCellReuseIdentifier: SubSectionRow.identifire)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SubSectionRow.identifire, for: indexPath) as? SubSectionRow else { return .init() }
        return cell
    }
}

class SubSectionRow: UITableViewCell {
    
    var gradient: CAGradientLayer?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var taxiCountLabel: UILabel!
    @IBOutlet weak var taxiLabel: UILabel!
    @IBOutlet weak var transportTariffLabel: UILabel!
    @IBOutlet weak var transportLabel: UILabel!
    @IBOutlet weak var bikeTariffLabel: UILabel!
    @IBOutlet weak var bikeLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var selectImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.layer.cornerRadius = 15
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = UIColor.systemGray.cgColor
        addGradient()
    }

    private func addGradient() {
        self.gradient = CAGradientLayer()
        guard let gradient = gradient else {
            return
        }
        gradient.frame =  CGRect(origin: CGPoint(x: 0, y: 0), size: .init(width: UIScreen.main.bounds.width - 40, height: frame.height))
        gradient.colors = [UIColor.from(hex: "#4AC7FA").cgColor, UIColor.from(hex: "#E649F5").cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 1)

        let shape = CAShapeLayer()
        shape.lineWidth = 1.5
        shape.path =  UIBezierPath(roundedRect: CGRect(origin: .zero, size: gradient.frame.size).insetBy(dx: 1, dy: 1.5), cornerRadius: 15).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape

        cardView.layer.addSublayer(gradient)
    }
    
    public func configure(with data: _SubSectionRow) {
        titleLabel.text = data.title
        priceLabel.text = data.price
        taxiCountLabel.text = data.taxiCount
        transportTariffLabel.text = data.trasnportTariff
        bikeTariffLabel.text = data.bikeTariff
        selectImage.image = data.isSelect ? UIImage.getAssetImage(image: "select") : UIImage.getAssetImage(image: "unselect")
        gradient?.isHidden = data.isSelect ? false : true
        cardView.layer.borderWidth = data.isSelect ? 0 : 1
    }
}
