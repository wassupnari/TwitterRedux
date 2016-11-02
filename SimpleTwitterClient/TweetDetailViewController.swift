//
//  TweetDetailViewController.swift
//  SimpleTwitterClient
//
//  Created by Nari Shin on 10/30/16.
//  Copyright © 2016 Nari Shin. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userHandle: UILabel!
    @IBOutlet weak var tweetBody: UILabel!
    
    var tweet: Tweet!
    var tweetId: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tweetId = tweet.id
        if let imageUrl = tweet.user?.profileUrl {
            userImageView.setImageWith(imageUrl)
        }
        userName.text = tweet.user?.name
        userHandle.text = "@" + (tweet.user?.screenname)!
        tweetBody.text = tweet.text
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onCancelClicked(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onReplyClicked(_ sender: AnyObject) {
        
    }
    
    @IBAction func onRetweetClicked(_ sender: AnyObject) {
        TwitterClient.sharedInstance?.retweet(tweetId: self.tweetId, success: {
            print("RT success")
            self.dismiss(animated: true, completion: nil)
            }, failure: { (error: Error) in
                print("Error: \(error.localizedDescription)")
        })
    }
    
    @IBAction func onFavoriteClicked(_ sender: AnyObject) {
        TwitterClient.sharedInstance?.favorite(tweetId: self.tweetId, success: {
            print("Favorite success")
            self.dismiss(animated: true, completion: nil)
            }, failure: { (error:Error) in
                print("Error: \(error.localizedDescription)")
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "replySegue" {
            let navigationViewController = segue.destination as! UINavigationController
            let targetController = navigationViewController.viewControllers[0] as! ReplyViewController
            
            targetController.targetHandel = "@" + (tweet.user?.screenname)! + " "
            targetController.tweetId = tweet.id
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
