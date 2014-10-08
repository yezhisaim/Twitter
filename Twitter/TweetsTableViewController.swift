//
//  TweetsTableViewController.swift
//  Twitter
//
//  Created by isai on 9/28/14.
//  Copyright (c) 2014 isai. All rights reserved.
//

import UIKit

class TweetsTableViewController: UITableViewController, UITableViewDataSource, UIGestureRecognizerDelegate {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var tweets: [Tweet]?
    var user: User?
    var viewMode: String?
    
  /*  @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 208/255, green: 246/255, blue: 255/255, alpha: 1.0)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl?.addTarget(self, action: "refreshView:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.insertSubview(refreshControl!, atIndex: 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if(self.viewMode == "Mentions")
        {
            TwitterClient.sharedInstance.mentionsWithParams(nil, completion: { (tweets, error) -> () in
                self.tweets = tweets
                println(tweets)
                self.tableView.reloadData()
            })
        }
        else
        {
            TwitterClient.sharedInstance.homeTimeLineWithParams(nil, completion: { (tweets, error) -> () in
                self.tweets = tweets
                self.tableView.reloadData()
            })
        }
        
    }

    func onTap(recognizer: UITapGestureRecognizer) {
        performSegueWithIdentifier("profileImageSegue", sender: self)
    }
  
    func refreshView(refreshControl: UIRefreshControl)
    {
        
        TwitterClient.sharedInstance.homeTimeLineWithParams(nil, completion: {(tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.tweets?.count ?? 0
    }

   override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetTableViewCell", forIndexPath: indexPath) as TweetTableViewCell
    
        var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("onTap:"))
        cell.profilePicture.tag = indexPath.row
        tapGestureRecognizer.delegate = self
        cell.profilePicture.addGestureRecognizer(tapGestureRecognizer)
    
        var tweet = self.tweets?[indexPath.row]
        cell.tweet = tweet
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "newTweetSegue") {
            var nav = segue.destinationViewController as UINavigationController
            if nav.viewControllers[0] is NewTweetViewController {
                var newVC = nav.viewControllers[0] as NewTweetViewController
                let indexPath = self.tableView.indexPathForSelectedRow()?.row
                newVC.user = User.currentUser
            }
        }
        
        if (segue.identifier == "detailedTweetSegue") {
                var nav = segue.destinationViewController as UINavigationController
                if nav.viewControllers[0] is DetailedTweetViewController {
                    var detailedVC = nav.viewControllers[0] as DetailedTweetViewController
                    let indexPath = self.tableView.indexPathForSelectedRow()?.row
                    detailedVC.tweet = self.tweets?[indexPath!]
                }
            }
        if (segue.identifier == "profileImageSegue") {
            println("Profile page!")
            var nav = segue.destinationViewController as UINavigationController
            if nav.viewControllers[0] is ContentViewController {
                var contentVC = nav.viewControllers[0] as ContentViewController
                let indexPath = self.tableView.indexPathForSelectedRow()?.row
                contentVC.user = User.currentUser?
            }
        }

        
    }
    

}
