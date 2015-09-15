//
//  Tweet.swift
//  Twitter Clone
//
//  Created by Nguyễn Vương Anh Vỹ on 9/13/15.
//  Copyright (c) 2015 Nguyễn Vương Anh Vỹ. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var retweetsCount: String!
    var favoritesCount: String!
    var media: NSDictionary!
    var mediaLink: NSArray!

    
    
    init(dictionary: NSDictionary){
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        retweetsCount = toString(dictionary["retweet_count"]!)
        favoritesCount = toString(dictionary["favorite_count"]!)
        media = dictionary["entities"] as! NSDictionary
        mediaLink = media.valueForKeyPath("media.media_url") as? NSArray
        
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        return tweets
    }
}
