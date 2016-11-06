//
//  MenuViewController.swift
//  SimpleTwitterClient
//
//  Created by Nari Shin on 11/1/16.
//  Copyright © 2016 Nari Shin. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var profileNavigationController: UIViewController!
    private var timelineNavigationController: UIViewController!
    private var mentionNavigationController: UIViewController!
    
    var viewControllers: [UIViewController] = []
    
    var hamburgerViewController: HamburgerViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 250
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        profileNavigationController = storyboard.instantiateViewController(withIdentifier: "ProfileNavigationController")
        timelineNavigationController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
        mentionNavigationController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
        
        
        viewControllers.append(profileNavigationController)
        viewControllers.append(timelineNavigationController)
        viewControllers.append(mentionNavigationController)
        
        hamburgerViewController.contentViewController = timelineNavigationController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hamburgerMenuCell", for: indexPath) as! HamburgerMenuTableViewCell
        
        let titles = ["Profile", "Timeline", "Mention"]
        cell.menuTitleLabel.text = titles[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 1 {
            ((viewControllers[indexPath.row] as! UINavigationController).topViewController as! TweetsViewController).setIsTimeline(isTimeLine: true)
        } else if indexPath.row == 2 {
            ((viewControllers[indexPath.row] as! UINavigationController).topViewController as! TweetsViewController).setIsTimeline(isTimeLine: false)
        }
        hamburgerViewController.contentViewController = viewControllers[indexPath.row]
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 170.0;//Choose your custom row height
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
