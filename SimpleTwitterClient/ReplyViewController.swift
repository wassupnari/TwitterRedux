//
//  ReplyViewController.swift
//  SimpleTwitterClient
//
//  Created by Nari Shin on 10/31/16.
//  Copyright © 2016 Nari Shin. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController {
    
    @IBOutlet weak var replyBody: UITextView!
    
    var targetHandel: String?
    var tweetId: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
        replyBody.text = targetHandel
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelClicked(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onReplyClicked(_ sender: AnyObject) {
        TwitterClient.sharedInstance?.reply(tweetMessage: self.replyBody.text, tweetId: tweetId!, success: {
            print("reply success")
            self.dismiss(animated: true, completion: nil)
            }, failure: { (error: Error) in
                print("Error : \(error.localizedDescription)")
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
