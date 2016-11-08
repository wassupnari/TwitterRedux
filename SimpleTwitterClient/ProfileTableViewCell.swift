//
//  ProfileTableViewCell.swift
//  SimpleTwitterClient
//
//  Created by Nari Shin on 11/5/16.
//  Copyright © 2016 Nari Shin. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userHandle: UILabel!
    @IBOutlet weak var tweetContent: UILabel!
    
    var tweet: Tweet! {
        didSet {
            
            userName.text = tweet.user?.name
            if let handle = tweet.user?.screenname {
                userHandle.text = "@" + handle
            }
            tweetContent.text = tweet.text
            
            if let imageUrl = tweet.user?.profileUrl {
                userImage.setImageWith(imageUrl)
            }
            
//            if let time = tweet.timestamp {
//                let localTime = Calendar.current.dateComponents(in: TimeZone.current, from: time)
//                let cal =  Calendar(identifier: .gregorian)
//                let date1 = cal.date(from: DateComponents(year: localTime.year, month:  localTime.month, day: localTime.day, hour: localTime.hour, minute: localTime.minute, second: localTime.second))!
//                timeStamp.text = "\(Date().offset(from: date1)) ago"
//            }
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
