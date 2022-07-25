//
//  UserReposTableViewCell.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/25.
//

import UIKit

class UserReposTableViewCell: UITableViewCell {
    @IBOutlet private weak var languageTextView: UIView!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var starCountLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    func configure(repos: Repos) {
        languageTextView.isHidden = repos.language == nil
        languageLabel.text = repos.language
        starCountLabel.text = "\(repos.stargazersCount)"

        titleLabel.text = repos.name

        descriptionLabel.isHidden = repos.description == nil
        descriptionLabel.text = repos.description
    }
}
