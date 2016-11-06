//
//  TweetsViewController.swift
//  SimpleTwitterClient
//
//  Created by Nari Shin on 10/29/16.
//  Copyright © 2016 Nari Shin. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let alertController = UIAlertController(title: nil, message: "Please wait\n\n", preferredStyle: UIAlertControllerStyle.alert)
    let errorAlertController = UIAlertController(title: "Error", message: "An error occurred. Please try it again", preferredStyle: UIAlertControllerStyle.alert)

    var isTimeLine: Bool = true

    var tweets = [Tweet]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 160
        
        getTweets(fromRefresh: false, success: nil, failure: nil)
        
        // For pull-to-refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(TweetsViewController.refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogoutClicked(_ sender: AnyObject) {
        TwitterClient.sharedInstance?.logout()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetTableViewCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count ?? 0
    }
    
    func getTweets(fromRefresh: Bool, success: (() -> ())?, failure: ((Error) -> ())?) {
        if self.isTimeLine {
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
            if fromRefresh {
                success!()
            }
            }, failure: { (error: Error) in
                if fromRefresh {
                    failure!(error)
                }
                print("error: \(error.localizedDescription)")
        })
        } else {
            TwitterClient.sharedInstance?.mentions(success: { (tweets: [Tweet]) in
                self.tweets = tweets
                self.tableView.reloadData()
                if fromRefresh {
                    success!()
                }
                }, failure: { (error: Error?) in
                    if fromRefresh {
                        failure!(error!)
                    }
                    print("error: \(error?.localizedDescription)")
            })
        }
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        self.present(alertController, animated: false, completion: nil)
        
        getTweets(fromRefresh: true, success: {
            self.dismiss(animated: false, completion: nil)
            refreshControl.endRefreshing()
        }) { (error: Error) in
                // Do nothing
        }
        
    }
    
    /*
     * Pass data to another viewController
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tweetDetailSegue" {
            let navigationViewController = segue.destination as! UINavigationController
            let detailViewController = navigationViewController.viewControllers[0] as! TweetDetailViewController
        
            if let indexPath = self.tableView.indexPathForSelectedRow {
                // do the work here
                detailViewController.tweet = tweets[indexPath.row]
            }
        }
    }
    
    public func setIsTimeline(isTimeLine: Bool) {
        self.isTimeLine = isTimeLine
        
        getTweets(fromRefresh: false, success: nil, failure: nil)
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
