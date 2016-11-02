//
//  NewTweetViewController.swift
//  SimpleTwitterClient
//
//  Created by Nari Shin on 10/30/16.
//  Copyright © 2016 Nari Shin. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var tweetMessage: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tweetMessage.layer.cornerRadius = 3
        tweetMessage.layer.borderColor = UIColor.gray.cgColor
        tweetMessage.layer.borderWidth = 1
        tweetMessage.setContentOffset(CGPoint.zero, animated: false)
        tweetMessage.delegate = self
        self.automaticallyAdjustsScrollViewInsets = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelClicked(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTweetClicked(_ sender: AnyObject) {
        print("New tweet clicked, msg : \(tweetMessage.text!)")
        TwitterClient.sharedInstance?.composeNewTweet(tweetMessage: tweetMessage.text!, success: {
            print("new tweet success")
            self.dismiss(animated: true, completion: nil)
            }, failure: { (error: Error) in
                print("Error: \(error.localizedDescription)")
        })
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
