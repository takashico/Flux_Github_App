//
//  UserListTableViewCell.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/21.
//

import Kingfisher
import UIKit

class UserListTableViewCell: UITableViewCell {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var avatarImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
    }

    func configure(user: User) {
        nameLabel.text = user.name
        avatarImageView.kf.setImage(
            with: URL(string: user.avatarUrl),
            placeholder: UIImage(systemName: "person.circle.fill")
        )
    }
}
