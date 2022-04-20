//
//  UserListViewController.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/20.
//

import UIKit
import SwiftUI

class UserListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "User List"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        
        self.tableView.reloadData()
    }

    private func createItemCell() -> UITableViewCell {
        let cell = UITableViewCell()
        cell.accessoryType = .disclosureIndicator
        
        // TODO: datasourceは後で追加する
        let vc = UserListItemView()
        guard let view = UIHostingController(rootView: vc).view else {
            return cell
        }
        
        cell.contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 0.0),
            view.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: 0.0),
            view.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 0.0),
            view.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: 0.0)
        ])
        
        return cell
    }
}

extension UserListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return createItemCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
