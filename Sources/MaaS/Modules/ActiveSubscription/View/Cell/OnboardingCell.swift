//
//  OnboardingCell.swift
//  
//
//  Created by Слава Платонов on 01.05.2022.
//

import UIKit
import CoreTableView

protocol _Onboarding: CellData {
    var onOnboardingSelect: Command<Void> { get }
    var onHistorySelect: Command<Void> { get }
}

extension _Onboarding {
    var height: CGFloat {
        return 120
    }
    
    func prepare(cell: UITableViewCell, for tableView: UITableView, indexPath: IndexPath) {
        guard let cell = cell as? OnboardingCell else { return }
        cell.configure(with: self)
    }
    
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        tableView.register(OnboardingCell.nib, forCellReuseIdentifier: OnboardingCell.identifire)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OnboardingCell.identifire, for: indexPath) as? OnboardingCell else { return .init() }
        return cell
    }
}

class OnboardingCell: UITableViewCell {
    
    @IBOutlet weak var onboardingLabel: UILabel!
    @IBOutlet weak var historyLabel: UILabel!
    
    var onboardTapped: Command<Void>?
    var onHistoryTapped: Command<Void>?

    override func awakeFromNib() {
        super.awakeFromNib()
        onboardingLabel.text = "Как это \nработает?"
        historyLabel.text = "История \nпоездок"
        onboardingLabel.font = UIFont(name: "MoscowSans-medium", size: 18)
        historyLabel.font = UIFont(name: "MoscowSans-medium", size: 18)
    }

    @IBAction func onboardingTapped() {
        onboardTapped?.perform(with: ())
    }
    
    @IBAction func historyTapped() {
        onHistoryTapped?.perform(with: ())
    }
    
    public func configure(with data: _Onboarding) {
        onboardTapped = data.onOnboardingSelect
        onHistoryTapped = data.onHistorySelect
    }
    
}
