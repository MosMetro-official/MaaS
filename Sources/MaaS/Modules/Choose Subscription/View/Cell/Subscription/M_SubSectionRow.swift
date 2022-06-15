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
    var showSelectImage: Bool { get }
    var tariffs: [M_Service] { get }
}

extension _SubSectionRow {
    func hashValues() -> [Int] {
        return [
            title.hashValue,
            price.hashValue,
            isSelect.hashValue,
            showSelectImage.hashValue
        ]
    }
    
    func prepare(cell: UITableViewCell, for tableView: UITableView, indexPath: IndexPath) {
        guard let cell = cell as? M_SubSectionRow else { return }
        cell.configure(with: self)
    }
    
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        tableView.register(M_SubSectionRow.nib, forCellReuseIdentifier: M_SubSectionRow.identifire)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: M_SubSectionRow.identifire, for: indexPath) as? M_SubSectionRow else { return .init() }
        return cell
    }
}

class M_SubSectionRow: UITableViewCell {
    
    var gradient: CAGradientLayer?
    var gradientHeight: CGFloat?
    var tariffs: [M_Service]? {
        didSet {
            setupStackView(with: tariffs ?? [])
        }
    }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var selectImage: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.layer.cornerRadius = 15
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = UIColor.systemGray.cgColor
    }
    
    private func addGradient() {
        gradient?.removeFromSuperlayer()
        self.gradient = CAGradientLayer()
        guard let gradient = gradient else {
            return
        }
        gradient.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: UIScreen.main.bounds.width - 40, height: gradientHeight ?? 0))
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
    
    private func createLineStackView(with image: UIImage) -> UIStackView {
        let lineStack = UIStackView()
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.image = image
        imageView.contentMode = .center
        lineStack.axis = .horizontal
        lineStack.distribution = .fill
        lineStack.spacing = 10
        lineStack.alignment = .center
        lineStack.addArrangedSubview(imageView)
        return lineStack
    }
    
    private func createTextStackView() -> UIStackView {
        let textStack = UIStackView()
        textStack.axis = .vertical
        textStack.spacing = 2
        textStack.distribution = .fillEqually
        textStack.alignment = .fill
        return textStack
    }
    
    private func createTextLabel(with text: String, textColor: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = Appearance.customFonts[.smallBody]
        label.textColor = UIColor.getAssetColor(name: textColor)
        return label
    }
    
    private func setupStackView(with tariffs: [M_Service]) {
        stackView.removeFullyAllArrangedSubviews()
        tariffs.forEach { tariff in
            let imageName = getServiceImage(by: tariff.serviceId)
            let lineStack = createLineStackView(with: UIImage.getAssetImage(image: imageName))
            let textStackView = createTextStackView()
            let tariffTitleLabel = createTextLabel(with: tariff.name.ru, textColor: "secondaryText")
            let tariffDescrLabel = createTextLabel(with: tariff.trip.countDescr, textColor: "primaryText")
            textStackView.addArrangedSubview(tariffTitleLabel)
            textStackView.addArrangedSubview(tariffDescrLabel)
            lineStack.addArrangedSubview(textStackView)
            stackView.addArrangedSubview(lineStack)
        }
    }
    
    private func getServiceImage(by serviceId: String) -> String {
        switch serviceId {
        case "YANDEX_TAXI":
            return "taxi"
        case "MOSCOW_SUBWAY":
            return "transport"
        case "VELOBIKE":
            return "transport"
        default:
            return ""
        }
    }
        
    public func configure(with data: _SubSectionRow) {
        titleLabel.text = data.title
        priceLabel.text = data.price
        tariffs = data.tariffs
        gradientHeight = data.height
        selectImage.isHidden = !data.showSelectImage
        selectImage.image = data.isSelect ? UIImage.getAssetImage(image: "select") : UIImage.getAssetImage(image: "unselect")
        gradient?.isHidden = !data.isSelect
        cardView.layer.borderWidth = data.isSelect ? 0 : 1
        if data.isSelect {
            addGradient()
        }
    }
}
