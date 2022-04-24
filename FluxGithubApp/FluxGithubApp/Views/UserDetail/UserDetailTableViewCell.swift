//
//  UserDetailTableViewCell.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/24.
//

import UIKit
import Kingfisher

class UserDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var followerAndFollowingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
    }
    
    func configure(user: UserDetail?) {
        if let user = user {
            avatarImageView.kf.setImage(
                with: URL(string: user.avatarUrl),
                placeholder: UIImage(systemName: "person.circle.fill")
            )
            userNameLabel.text = user.name
            fullNameLabel.text = user.fullName
            followerAndFollowingLabel.text = String.init(format: "%dフォロワー・%dフォロー中", user.followerCount, user.followingCount)
        } else {
            avatarImageView.image = UIImage(systemName: "person.circle.fill")
            userNameLabel.text = nil
            fullNameLabel.text = nil
            followerAndFollowingLabel.text = nil
        }
    }
}
