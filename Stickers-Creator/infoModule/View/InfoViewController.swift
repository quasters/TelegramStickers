//
//  View.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 17.05.2022.
//

import Foundation
import UIKit

class InfoViewController: UIViewController {
    private var infoTableView = UITableView()
    var presenter: InfoPresenterInputProtocol?
    
    private let cellIdentifier = "Cell"
    private struct Images {
        static let telegramIcon = "tg-icon"
    }
    
    override func viewDidLoad() {
        self.title = "Info"
        createTable()
    }
}


// MARK: - InfoViewPresenterOutputProtocol
extension InfoViewController: InfoViewPresenterOutputProtocol {
    func tappedOnCell(username: String) {
        presenter?.followTheLink(username: username)
    }
}

// MARK: - UITableViewDataSource
extension InfoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.getSectionsCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.getRowCount(section: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! InfoCell
        if let username = presenter?.getRowLabel(section: indexPath.section, row: indexPath.row) {
            cell.set(username: "@" + username, imageName: Images.telegramIcon)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = presenter?.getSectionLabel(section: section).localizedUppercase
        return section
    }
}

// MARK: - UITableViewDelegate
extension InfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let username = presenter?.getRowLabel(section: indexPath.section, row: indexPath.row) else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        tappedOnCell(username: username)
    }
}

// MARK: - CreateTable
extension InfoViewController {
    private func createTable() {
        self.infoTableView = UITableView(frame: view.bounds, style: .plain)
        configureTable()
        view.addSubview(infoTableView)
    }
    
    private func configureTable() {
        self.infoTableView.register(InfoCell.self, forCellReuseIdentifier: cellIdentifier)
        setTableDelegates()
    }
    
    private func setTableDelegates() {
        self.infoTableView.dataSource = self
        self.infoTableView.delegate = self
    }
}
