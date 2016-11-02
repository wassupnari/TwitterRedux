//
//  TwitterClient.swift
//  SimpleTwitterClient
//
//  Created by Nari Shin on 10/29/16.
//  Copyright © 2016 Nari Shin. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {

    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com")!, consumerKey: "ai5aEFQiMw61P02dayIRRKD46", consumerSecret: "UkVWo97ThxNd0ABAEiYZKEeE3UnJoOPcUxuWAH0k08s2TgFr2O")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            success(user)
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                failure(error)
        })
    }
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.TweetsWithArray(dictionaries: dictionaries)
            
            success(tweets)
            
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                failure(error)
        })
    }
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        deauthorize()
        fetchRequestToken(withPath: "/oauth/request_token", method: "GET", callbackURL: URL(string: "twitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            // Setup the authorization url with requestToken
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\((requestToken?.token)!)")!
            
            // Open the url in mobile safari
            UIApplication.shared.openURL(url)
            
            
            }, failure: { (error: Error?) in
                self.loginFailure?(error!)
        })
    }
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            
            self.currentAccount(success: { (user: User) in
                User.currentUser = user
                self.loginSuccess?()
                }, failure: { (error: Error) in
                    self.loginFailure?(error)
            })
            
            }, failure: { (error: Error?) in
                self.loginFailure?(error!)
        })
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    }
    
    func composeNewTweet(tweetMessage : String, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        let params: NSDictionary = [
            "status" : tweetMessage
        ]
        
        post("1.1/statuses/update.json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response:Any?) in
                success()
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                print("error: \(error.localizedDescription)")
                failure(error)
        });

//        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
//            print("I got tweets")
//            
//            }, failure: { (task: URLSessionDataTask?, error: Error) in
//                failure(error)
//        })
    }
    
    func reply(tweetMessage : String, tweetId: Int, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        let params: NSDictionary = [
            "status" : tweetMessage,
            "in_reply_to_status_id": tweetId
        ]
        self.post("1.1/statuses/update.json", parameters: params, success: { (task:URLSessionDataTask, response:Any?) in
                let tweet = response as! NSDictionary
                print("post success \(tweet)")
                success()
            }, failure: { (task:URLSessionDataTask?, error:Error) in
                print("error: \(error.localizedDescription)")
                failure(error)
        });
    }
    
    func retweet(tweetId: Int, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        let params: NSDictionary = [
            "id" : tweetId
        ]
        self.post("1.1/statuses/retweet/\(tweetId).json", parameters: params, success: { (task:URLSessionDataTask, response:Any?) in
                success()
            }, failure: { (task:URLSessionDataTask?, error:Error) in
                print("error: \(error.localizedDescription)")
                failure(error)
        });
    }
    
    func favorite(tweetId: Int, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        let params: NSDictionary = [
            "id" : tweetId
        ]
        self.post("1.1/favorites/create.json", parameters: params, success: { (task:URLSessionDataTask, response:Any?) in
                success()
            }, failure: { (task:URLSessionDataTask?, error:Error) in
                print("error: \(error.localizedDescription)")
                failure(error)
        });
    }
}
