//
//  M_LoadMoreTableViewCell.swift
//  MaaS
//
//  Created by Гусейн on 27.07.2022.
//

import UIKit
import CoreTableView

protocol M_LoadMoreCell: CellData {
    var state: M_LoadMoreTableViewCell.State { get set }
    var onLoad: Command<Void> { get set }
}

extension M_LoadMoreCell {
    var id: String {
        return "loading"
    }
    
    var height: CGFloat {
        return 54
    }
    func hashValues() -> [Int] {
        return [state.hashValue]
    }
    
    func prepare(cell: UITableViewCell, for tableView: UITableView, indexPath: IndexPath) {
        guard let cell = cell as? M_LoadMoreTableViewCell else { return }
        cell.configure(data: self)
    }
    
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        tableView.register(M_LoadMoreTableViewCell.nib, forCellReuseIdentifier: M_LoadMoreTableViewCell.identifire)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: M_LoadMoreTableViewCell.identifire, for: indexPath) as? M_LoadMoreTableViewCell else { return .init() }
        return cell
    }
}

class M_LoadMoreTableViewCell: UITableViewCell {
    
    @IBOutlet private var loadButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    private var onLoad: Command<Void>?
    
    enum State {
        case loading
        case normal
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func handleLoad(_ sender: Any) {
        self.onLoad?.perform(with: ())
    }
    
    func configure(data: M_LoadMoreCell) {
        self.onLoad = data.onLoad
        switch data.state {
        case .loading:
            self.loadButton.isHidden = true
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
        case .normal:
            self.loadButton.isHidden = false
            self.activityIndicator.isHidden = true
        }
    }
    
}
