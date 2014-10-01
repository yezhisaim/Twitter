//
//  NewTweetViewController.swift
//  Twitter
//
//  Created by isai on 9/29/14.
//  Copyright (c) 2014 isai. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController {
    
    var tweet: Tweet!
    var user: User!
    var reply_userID = "" as String!
    
    @IBOutlet weak var TweetTextView: UITextView!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 208/255, green: 246/255, blue: 255/255, alpha: 1.0)
        
        println("Twitter USER:\(self.user)")
        self.namelabel.text = user.name
        self.handleLabel.text = user.screenname
        if let profile_pic = user.profileImageURL
        {
            self.profilePicture.setImageWithURL(NSURL(string: profile_pic as String!))
            self.profilePicture.clipsToBounds = true;
            self.profilePicture.layer.cornerRadius = 7
        }
        
        if(!self.reply_userID.isEmpty)
        {
            TweetTextView.text = "\(self.reply_userID!) "
        }
        
        TweetTextView.becomeFirstResponder()
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTweet(sender: AnyObject) {
        
        var tweet_text = self.TweetTextView.text
        
        if (!self.TweetTextView.text.isEmpty) {
            TwitterClient.sharedInstance.tweet(tweet_text, callback: {(response, error) -> () in
                if(error != nil) {
                    println("Error: Cannot post tweet now!")
                } else {
                    println("Tweeted!")
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            })
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
