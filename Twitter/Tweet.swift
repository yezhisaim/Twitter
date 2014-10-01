//
//  Tweet.swift
//  Twitter
//
//  Created by isai on 9/28/14.
//  Copyright (c) 2014 isai. All rights reserved.
//

import Foundation

class Tweet: NSObject {
    
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var twitterTimeStampString: String?
    var id: NSNumber?
    var id_str: String?
    var retweet_count: NSNumber?
    var favorite_count: NSNumber?
    var retweeted: Bool?
    var favorited: NSNumber?
    
    
    class func formatCreatedTimeToUserReadableTime(createdAt: NSDate) -> String {
        
        var timeSinceCreation = createdAt.timeIntervalSinceNow
        
        var timeSinceCreationInt =  Int(timeSinceCreation) * -1
        
        var timeSinceCreationMins = timeSinceCreationInt/60 as Int
        
        if (timeSinceCreationMins == 0) {
            
            return "now"
            
        } else if (timeSinceCreationMins >= 1 && timeSinceCreationMins < 60) {
            
            return "\(timeSinceCreationMins)m"
            
        } else if (timeSinceCreationMins < 1440) {
            
            return "\(timeSinceCreationMins/60)h"
            
        } else if (timeSinceCreationMins >= 1440) {
            
            return "\(timeSinceCreationMins/1440)d"
            
        }
        
        return "now"
    }

    
    init(dictionary: NSDictionary) {
        self.user = User(dictionary: dictionary["user"] as NSDictionary)
        self.text = dictionary["text"] as? String
        self.createdAtString = dictionary["created_at"] as? String
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        self.createdAt = formatter.dateFromString(createdAtString!)
        self.twitterTimeStampString = Tweet.formatCreatedTimeToUserReadableTime(createdAt!)
        self.id = dictionary["id"] as? NSNumber
        self.id_str = dictionary["id_str"] as? String
        self.retweet_count = dictionary["retweet_count"] as? NSNumber
        self.favorite_count = dictionary["favorite_count"] as? NSNumber
        self.retweeted = dictionary["retweeted"] as? Bool
        self.favorited = dictionary["favorited"] as? NSNumber
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        
        var tweets = [Tweet]()
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        return tweets
    }
}