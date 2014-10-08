//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by isai on 9/28/14.
//  Copyright (c) 2014 isai. All rights reserved.
//

import UIKit

protocol TweetTableViewCellDelegate {
    func onTap(#tweetCell: TweetTableViewCell)
}

class TweetTableViewCell: UITableViewCell {

    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!

    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    
    var delegate: TweetTableViewCellDelegate?
    
    var viewControllers: [UIViewController]?
    
    var tweet: Tweet!
    {
        willSet(tweet){
            self.nameLabel.text = tweet?.user?.name
            self.tweetLabel.text = tweet?.text
          if let profile_pic = tweet?.user?.profileImageURL
          {
            self.profilePicture.setImageWithURL(NSURL(string: profile_pic as String!))
            self.profilePicture.clipsToBounds = true;
            self.profilePicture.layer.cornerRadius = 7
            
            self.profilePicture.userInteractionEnabled = true
           }
            self.handleLabel.text = tweet?.user?.screenname
            self.timeStampLabel.text = tweet?.twitterTimeStampString
        }
    }
    
    
    @IBAction func onRetweet(sender: AnyObject) {

    }
    
    
    @IBAction func onFavorite(sender: AnyObject) {

    }

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        var tap = UITapGestureRecognizer(target: self, action: "onTap")
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        self.profilePicture.addGestureRecognizer(tap)
    }
    
    func onTap() {
        delegate?.onTap(tweetCell: self)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
