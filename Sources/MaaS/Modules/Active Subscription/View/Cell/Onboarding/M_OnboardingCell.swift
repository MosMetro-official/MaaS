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
    
    func hashValues() -> [Int] {
        return []
    }
    
    var id: String {
        return "onboarding"
    }
    
    func prepare(cell: UITableViewCell, for tableView: UITableView, indexPath: IndexPath) {
        guard let cell = cell as? M_OnboardingCell else { return }
        cell.configure(with: self)
    }
    
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        tableView.register(M_OnboardingCell.nib, forCellReuseIdentifier: M_OnboardingCell.identifire)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: M_OnboardingCell.identifire, for: indexPath) as? M_OnboardingCell else { return .init() }
        return cell
    }
}

class M_OnboardingCell: UITableViewCell {
    
    @IBOutlet private weak var onboardingLabel: UILabel!
    @IBOutlet private weak var historyLabel: UILabel!
    
    private var onboardTapped: Command<Void>?
    private var onHistoryTapped: Command<Void>?

    override func awakeFromNib() {
        super.awakeFromNib()
        onboardingLabel.setLineSpacing(lineSpacing: 5, lineHeightMultiple: 1)
        historyLabel.setLineSpacing(lineSpacing: 5, lineHeightMultiple: 1)
        onboardingLabel.text = "Как это \nработает?"
        historyLabel.text = "История \nпоездок"
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
