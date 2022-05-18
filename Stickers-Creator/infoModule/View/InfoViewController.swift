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
    var presenter: InfoPresenterProtocol?
    
    private let groupSections = ["Developer", "Suggestions and help", "Donate"]
    private let itemRows = [["cybshot"], ["helpchat0", "helpchat1"], ["donatechat0"]]
    
    private let cellIdentifier = "Cell"
    private struct Images {
        static let telegramIcon = "tg-icon"
    }
    
    override func viewDidLoad() {
        self.title = "Info"
        createTable()
    }
}

// MARK: - UITableViewDataSource
extension InfoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemRows[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! InfoCell
        let username = "@" + itemRows[indexPath.section][indexPath.row]
        cell.set(username: username, imageName: Images.telegramIcon)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = self.groupSections[section].localizedUppercase
        return section
    }
}

// MARK: - UITableViewDelegate
extension InfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let username = itemRows[indexPath.section][indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        presenter?.followTheLink(username: username)
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
