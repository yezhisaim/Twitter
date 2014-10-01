//
//  TwitterClient.swift
//  Twitter
//
//  Created by isai on 9/28/14.
//  Copyright (c) 2014 isai. All rights reserved.
//

import Foundation
import UIKit

let twitter_consumer_key = "8eNpEcG1uZoFWfoBekgK2nAZl"
let twitter_consumer_secret = "Cr4Xi08RZEGjRkabF09iIduGyoHJeRU8Mxan6ncMeQOCnvzVG4"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {

    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitter_consumer_key, consumerSecret: twitter_consumer_secret)
        }
        return Static.instance
    }
    
    func homeTimeLineWithParams(params: NSDictionary?,
        completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
            GET("1.1/statuses/home_timeline.json" ,
                parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                    var tweets = Tweet.tweetsWithArray(response as [NSDictionary])
                    completion(tweets: tweets, error: nil)
                }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    println("error getting home timeline")
                    completion(tweets: nil, error: error)
            })
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        
        loginCompletion = completion
        
        // Fetch request token & redirect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuthToken!) -> Void in
            println("Got the request token")
            
            var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            
            UIApplication.sharedApplication().openURL(authURL)
            
            }) { (error: NSError!) -> Void in
                println("Failed to get request token")
                
                self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func openURL(url: NSURL) {
        
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuthToken(queryString: url.query), success: { (access_token: BDBOAuthToken!) -> Void in
            println("Got the access token!")
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(access_token)
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation:AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                
                var user = User(dictionary: response as NSDictionary)
                User.currentUser = user
                println("user: \(user.name)")
                
                self.loginCompletion?(user: user, error: nil)
                }, failure: { (operation: AFHTTPRequestOperation!, error:NSError!) -> Void in
                    
                    println("Error getting current user")
                    
                    self.loginCompletion?(user: nil, error: error)
            })
            
            TwitterClient.sharedInstance.GET("1.1/statuses/home_timeline.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                
                var tweets = Tweet.tweetsWithArray(response as [NSDictionary])
                
                for tweet in tweets {
                    
                    println("text: \(tweet.text) created: \(tweet.createdAt)")
                }
                }, failure: { (operation: AFHTTPRequestOperation!, error:NSError!) -> Void in
                    
                    println("Error getting current user home timeline")
            })
            }) { (error: NSError!) -> Void in
                
                println("Failed to receive access token")
                self.loginCompletion?(user: nil, error: error)
        }
    }
    
    
    func sendPostRequest(endpoint: String, parameters: [String: String]!, callback: (response: AnyObject!, error: NSError!) -> Void) {
        POST(endpoint,
            parameters: parameters,
            success: {
                (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                callback(response: response, error: nil)
            },
            failure: {
                (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                callback(response: nil, error: error)
        })
    }
    
    func sendGetRequest(endpoint: String, parameters: [String: String]!, callback: (response: AnyObject!, error: NSError!) -> Void) {
        GET(endpoint,
            parameters: parameters,
            success: {
                (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                callback(response: response, error: nil)
            },
            failure: {
                (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                callback(response: nil, error: error)
        })
    }
    
    //TWEET
    func tweet(status: String, callback: (response: AnyObject!, error: NSError!) -> Void) {
        sendPostRequest("1.1/statuses/update.json",
            parameters: [ "status": status ],
            callback: callback)
    }

    //RETWEET
    func retweet(tweet_id: String, callback: (response: AnyObject!, error: NSError!) -> Void) {
        sendPostRequest("1.1/statuses/retweet/\(tweet_id).json",
            parameters: nil,
            callback: callback)
    }
    
    //FAVORITE
    func favorite(tweet_id: String, callback: (response: AnyObject!, error: NSError!) -> Void) {
        sendPostRequest("1.1/favorites/create.json",
            parameters: [ "id": tweet_id ],
            callback: callback)
    }
    
    //DESTROY
    func destroy(tweet_id: String, callback: (response: AnyObject!, error: NSError!) -> Void) {
        sendPostRequest("1.1/statuses/destroy/\(tweet_id).json",
            parameters: nil,
            callback: callback)
    }
    
    
    
}
