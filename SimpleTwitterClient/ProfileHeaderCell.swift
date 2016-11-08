//
//  ProfileHeaderCell.swift
//  SimpleTwitterClient
//
//  Created by Nari Shin on 11/6/16.
//  Copyright © 2016 Nari Shin. All rights reserved.
//

import UIKit

class ProfileHeaderCell: UITableViewCell {
    
    @IBOutlet weak var userBackgroundImage: UIImageView!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userHandle: UILabel!
    @IBOutlet weak var numOfFollowing: UILabel!
    @IBOutlet weak var numOfFollowers: UILabel!
    @IBOutlet weak var numOfTweets: UILabel!
    
    var user: User? {
        didSet {
            
            if let user = user {
                if let backgroundImageUrl = user.backgroundImageUrl {
                    self.userBackgroundImage.setImageWith( backgroundImageUrl)
                } else {
                    self.userBackgroundImage.image = nil
                }
                if let imageUrl = user.profileUrl {
                    self.userProfileImage.setImageWith(imageUrl)
                }
                self.userName.text = user.name
                if let screenName = user.screenname {
                    self.userHandle.text = "@ \(screenName)"
                }
                
                self.numOfFollowing.text = String(user.numOfFollowing)
                self.numOfFollowers.text = String(user.numOfFollowers)
                self.numOfTweets.text = String(user.tweetCount!)
                
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
