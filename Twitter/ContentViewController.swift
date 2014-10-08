//
//  ContentViewController.swift
//  Twitter
//
//  Created by isai on 10/6/14.
//  Copyright (c) 2014 isai. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {
    
    var user: User!
    @IBOutlet weak var numTweets: UILabel!
    @IBOutlet weak var numFollowing: UILabel!
    @IBOutlet weak var numFollowers: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileBGImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var handle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileName.text = User.currentUser?.name
        handle.text = User.currentUser?.screenname
        if let profileImageURL = User.currentUser?.profileImageURL
        {
            profileImage.setImageWithURL(NSURL(string: profileImageURL))
            profileImage.clipsToBounds = true
            profileImage.layer.cornerRadius = 7
            profileImage.layer.borderWidth = 2
            profileImage.layer.borderColor = UIColor.blackColor().CGColor

        }
        if let profileBGImageURL = User.currentUser?.profileBGImageURL
        {
            profileBGImage.setImageWithURL(NSURL(string: profileBGImageURL))
        }
        numTweets.text = User.currentUser?.numTweets?.description
        numFollowing.text = User.currentUser?.numFollowing?.description
        numFollowers.text = User.currentUser?.numFollowers?.description
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
