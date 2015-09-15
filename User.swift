//
//  User.swift
//  Twitter Clone
//
//  Created by Nguyễn Vương Anh Vỹ on 9/13/15.
//  Copyright (c) 2015 Nguyễn Vương Anh Vỹ. All rights reserved.
//

import UIKit

let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"
var _currentUser: User?
class User: NSObject {
    var name: String?
    var screenname: String!
    var profileImageURL: NSURL!
    var tagline: String?
    var dictionary: NSDictionary
    init(dictionary: NSDictionary){
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as! String
        profileImageURL = NSURL(string: (dictionary["profile_image_url"] as! String).stringByReplacingOccurrencesOfString("_normal", withString: "_bigger", options: nil, range: nil))

        tagline = dictionary["description"] as? String
    }
    
    func logOut() {
            User.currentUser = nil
            TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
            NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                var data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                if data != nil {
                var dictionary = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as! NSDictionary
                _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        set(user) {
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
