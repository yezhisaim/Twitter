//
//  DetailedTweetViewController.swift
//  Twitter
//
//  Created by isai on 9/29/14.
//  Copyright (c) 2014 isai. All rights reserved.
//

import UIKit

class DetailedTweetViewController: UIViewController {

    var tweet: Tweet!
    var user: User!
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var screenname: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 208/255, green: 246/255, blue: 255/255, alpha: 1.0)
        
        self.name.text = tweet?.user?.name
        self.screenname.text = tweet?.user?.screenname
        self.tweetLabel.text = tweet?.text
        if let profile_pic = tweet?.user?.profileImageURL
        {
            self.profilePicture.setImageWithURL(NSURL(string: profile_pic as String!))
            self.profilePicture.clipsToBounds = true;
            self.profilePicture.layer.cornerRadius = 7
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        
        println("TWEET ID: \(tweet.id_str)")
        TwitterClient.sharedInstance.retweet(tweet.id_str!, callback: {(response, error) -> () in
            if(error != nil) {
                TwitterClient.sharedInstance.destroy(self.tweet.id_str!, callback: {(response, error) -> () in
                    if(error != nil) {
                    } else {
                        sender.setImage(UIImage(named: "retweet.png"), forState: .Normal)
                        
                    }
                })
            } else {
                self.tweet.retweet_count = self.tweet.retweet_count! + 1
                self.tweet.retweeted = true
                sender.setImage(UIImage(named: "retweet_on.png"), forState: .Normal)
            }
        })
    }
    
    
    @IBAction func onFavorite(sender: AnyObject) {
        
        var tweet_id = tweet.id_str!
        println("TWEET ID: \(tweet_id)")
        TwitterClient.sharedInstance.favorite(tweet.id_str!, callback: {(response, error) -> () in
            if(error != nil) {
                TwitterClient.sharedInstance.favorite(tweet_id, callback: {(response_cb, error_cb) -> () in
                    if(error_cb != nil) {
                    } else {
                        self.tweet.favorite_count = self.tweet.favorite_count! - 1
                        self.tweet.favorited = 0
                    }
                })
            } else {
                self.tweet.favorite_count = self.tweet.favorite_count! + 1
                self.tweet.favorited = 1
                sender.setImage(UIImage(named: "favorite_on.png"), forState: .Normal)
            }
        })
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "replyTweetSegue") {
            var navigation = segue.destinationViewController as UINavigationController
            if navigation.viewControllers[0] is NewTweetViewController {
                var newVC = navigation.viewControllers[0] as NewTweetViewController
                newVC.reply_userID = tweet?.user?.screenname
                newVC.user = User.currentUser
            }
        }
        else if (segue.identifier == "homeTweetsSegue") {
            var navigation = segue.destinationViewController as UINavigationController
            if navigation.viewControllers[0] is TweetsTableViewController {
                var newVC = navigation.viewControllers[0] as TweetsTableViewController
            }
        }
    
    }

}
