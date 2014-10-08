//
//  User.swift
//  Twitter
//
//  Created by isai on 9/28/14.
//  Copyright (c) 2014 isai. All rights reserved.
//

import Foundation

var _currentUser: User?
let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
//let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    
    var dictionary: NSDictionary
    var name: String?
    var screenname: String?
    var profileImageURL: String?
    var profileBGImageURL: String?
    var tagline: String?
    var numTweets: UInt?
    var numFollowing: UInt?
    var numFollowers: UInt?
    
    init(dictionary: NSDictionary) {
        
        println("dictionary: \(dictionary)")
        self.dictionary = dictionary
        self.name = dictionary["name"] as? String
        let atString = "@" as String
        let handle = dictionary["screen_name"] as? String
        self.screenname =  "\(atString)\(handle!)"
        self.profileImageURL = dictionary["profile_image_url"] as? String
        self.profileBGImageURL = dictionary["profile_banner_url"] as? String
        self.tagline = dictionary["description"] as? String
        self.numFollowing = dictionary["followers_count"] as? NSNumber
        self.numFollowers = dictionary["friends_count"] as? NSNumber
        self.numTweets = dictionary["statuses_count"] as? NSNumber
    }
    
/*    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }*/
    
    class var currentUser: User? {
        
        get {
        if _currentUser == nil {
        var data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
        
        if data != nil {
        var dictionary = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as NSDictionary
        
        _currentUser = User(dictionary: dictionary)
        }
        }
        return _currentUser
        }
        
        set (user) {
            
            _currentUser = user
            if _currentUser != nil {
                var data = NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: nil, error: nil)
                
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
}