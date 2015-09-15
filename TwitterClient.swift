//
//  TwitterClient.swift
//  Twitter Clone
//
//  Created by Nguyễn Vương Anh Vỹ on 9/12/15.
//  Copyright (c) 2015 Nguyễn Vương Anh Vỹ. All rights reserved.
//

import UIKit

let twitterConsumerKey = "OEg7uXuH12LPoSvkeblIi3K0w"
let twitterConsumerSecret = "OSIEVQqto3uHWSJUOn07ntICCXxKQC7VeMABfaPsCLXC95snhi"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
    var loginCompletion: ((user:User?, error: NSError!) -> ())?
    class var sharedInstance: TwitterClient{
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey , consumerSecret: twitterConsumerSecret )
        }
        return Static.instance
    }
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        self.GET("1.1/statuses/home_timeline.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            //println("Home timeline: \(response)")
            var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            //println(response)
            completion(tweets: tweets, error: nil)
            println("Loading Data Success")
            }, failure: { (operation:AFHTTPRequestOperation!, error: NSError!) -> Void in
            println("Faile to get user home_timeline")
            completion(tweets: nil, error: error)
        })
    }
    
    func postStatusUpdateWithParams(params: NSDictionary?, completion: (status: Tweet?, error: NSError?) -> ()) {
        self.POST("1.1/statuses/update.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var status = Tweet(dictionary: response as! NSDictionary)
            completion(status: status, error: nil)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("error posting status update")
                completion(status: nil, error: error)
        }
    }
    
    func loginWithCompletion (completion: (user: User?, error: NSError!) -> ()) {
        loginCompletion = completion
        
        // Fetch request token & redirect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken:BDBOAuth1Credential!) -> Void in
            println("Get the request token")
            var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            }) { (error:NSError!) -> Void in
                println("Failed to get request token")
                self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func openURL(url: NSURL) {
            fetchAccessTokenWithPath("oauth/access_token", method: "GET", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            println("Got the access token")
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation:AFHTTPRequestOperation!, response: AnyObject!) -> Void in
//                println("user: \(response)")
                var user = User(dictionary: response as! NSDictionary)
                User.currentUser = user
                println("Got the user: \(user.name!)")
                self.loginCompletion?(user: user, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    println("Failed to get the current user.")
                    self.loginCompletion?(user: nil, error: error)
            })
                
            
            }) { (error: NSError!) -> Void in
                println("Failed to receive the access token")
                self.loginCompletion?(user: nil, error: error)
        }
        
    }
    
    }

