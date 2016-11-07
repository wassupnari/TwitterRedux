//
//  User.swift
//  SimpleTwitterClient
//
//  Created by Nari Shin on 10/29/16.
//  Copyright © 2016 Nari Shin. All rights reserved.
//

import UIKit

class User: NSObject {
    
    static let userDidLogoutNotification = "UserDidLogout"
    
    var name: String?
    var screenname: String?
    var profileUrl: URL?
    var backgroundImageUrl: URL?
    var numOfFollowing: Int = 0
    var numOfFollowers: Int = 0
    var tagline: String?
    var dictionary: NSDictionary?

    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        // Execute this line if the profileUrlString is not nil
        if let profileUrlString = profileUrlString {
            profileUrl = URL(string: profileUrlString)
        }
        let backgroundImageUrlString = dictionary["profile_background_image_url_https"] as? String
        if let backgroundImageUrlString = backgroundImageUrlString {
            backgroundImageUrl = URL(string: backgroundImageUrlString)
        }
        tagline = dictionary["description"] as? String
        numOfFollowers = (dictionary["followers_count"] as? Int)!
        numOfFollowing = (dictionary["friends_count"] as? Int)!
    }
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        // Create computed properties
        get {
            if _currentUser == nil {
            
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUserData") as? Data
        
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        
        set(user) {
            _currentUser = user
            let defaults = UserDefaults.standard
            
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.removeObject(forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }
}
