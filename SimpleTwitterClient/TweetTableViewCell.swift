//
//  TweetTableViewCell.swift
//  SimpleTwitterClient
//
//  Created by Nari Shin on 10/30/16.
//  Copyright © 2016 Nari Shin. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userHandle: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var tweetBody: UILabel!
    
    var tweetTableViewCellDelegate: TweetTableViewCellDelegate?
    
    var tweet: Tweet! {
        didSet {
            
            userName.text = tweet.user?.name
            if let handle = tweet.user?.screenname {
                userHandle.text = "@" + handle
            }
            tweetBody.text = tweet.text

            if let imageUrl = tweet.user?.profileUrl {
                profileImage.setImageWith(imageUrl)
            }
            
            if let time = tweet.timestamp {
                let localTime = Calendar.current.dateComponents(in: TimeZone.current, from: time)
                let cal =  Calendar(identifier: .gregorian)
                let date1 = cal.date(from: DateComponents(year: localTime.year, month:  localTime.month, day: localTime.day, hour: localTime.hour, minute: localTime.minute, second: localTime.second))!
                timeStamp.text = "\(Date().offset(from: date1)) ago"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        print("awake from nib")
        
        self.profileImage.layer.cornerRadius = 5
        self.profileImage.clipsToBounds = true;
        
        let profileImageGesture = UITapGestureRecognizer(target: self, action: #selector(onProfileImageClicked(sender:)))
//        profileImageGesture.delegate = self
//        profileImageGesture.numberOfTapsRequired = 1
        self.profileImage.addGestureRecognizer(profileImageGesture)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func onProfileImageClicked(sender: UITapGestureRecognizer) {
        print("profile clicked")
        self.tweetTableViewCellDelegate?.onProfileClicked(tweetCell: self, didTapProfile: tweet.user!)
        
//        let point = sender.location(in: self.contentView)
//        if sender.state == .began {
//        } else if sender.state == .changed {
//        } else if sender.state == .ended {
//            if (point.x < 100) {
//                print("profile image clicked")
//                if let delegate = self.tweetTableViewCellDelegate {
//                    delegate.onProfileClicked(user: tweet.user!)
//                }
//            } else {
//                print("container clicked")
//                if let delegate = self.tweetTableViewCellDelegate {
//                    delegate.onContainerClicked(tweet: tweet!)
//                }
//            }
//        }
    }
}

protocol TweetTableViewCellDelegate {
    func onContainerClicked(user: User)
    func onProfileClicked(tweetCell: TweetTableViewCell, didTapProfile user: User)
}

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfYear], from: date, to: self).weekOfYear ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}
