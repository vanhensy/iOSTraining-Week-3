//
//  ComposeViewController.swift
//  Twitter Clone
//
//  Created by Nguyễn Vương Anh Vỹ on 9/15/15.
//  Copyright (c) 2015 Nguyễn Vương Anh Vỹ. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {
    let MaxInput = 140
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var remainingCountLabel: UILabel!
    @IBOutlet weak var buttonTweetHolder: UIView!
    @IBOutlet weak var buttonTweet: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonTweetHolder.layer.cornerRadius = 5
        buttonTweetHolder.clipsToBounds = true
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardDidShowNotification, object: nil, queue: nil) { (notification: NSNotification!) -> Void in
            let userInfo = notification.userInfo!
            let keyboardFrameEnd = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
            self.view.frame = CGRectMake(0, 0, keyboardFrameEnd.size.width, keyboardFrameEnd.origin.y)
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardDidHideNotification, object: nil, queue: nil) { (notification: NSNotification!) -> Void in
            let userInfo = notification.userInfo!
            let keyboardFrameEnd = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
            self.view.frame = CGRectMake(0, 0, keyboardFrameEnd.size.width, keyboardFrameEnd.origin.y)
        }
        self.remainingCountLabel.text = "\(MaxInput)"
        self.textView.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        self.adjustScrollViewContentSize()
    }
    
    func textViewDidChange(textView: UITextView) {
        let tweet = self.textView.text
        let charactersRemaining = MaxInput - count(tweet)
        self.remainingCountLabel.text = "\(charactersRemaining)"
        self.remainingCountLabel.textColor = charactersRemaining >= 0 ? .lightGrayColor() : .redColor()
        self.adjustScrollViewContentSize()
    }
    
    
    func adjustScrollViewContentSize() {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.textView.frame.origin.y + self.textView.frame.size.height)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    @IBAction func cancelButtonTaped(sender: UIBarButtonItem) {
        self.view.endEditing(true)
        self.delay(1, closure: { () -> () in
        self.dismissViewControllerAnimated(true, completion: nil)
        })
        
    }
    @IBAction func onTweetButtonTaped(sender: UIButton) {
        
        let tweet = self.textView.text
        if (count(tweet) == 0) {
            return
        }
        
        var params: NSDictionary = [
            "status": tweet
        ]
        
        TwitterClient.sharedInstance.postStatusUpdateWithParams(params, completion: { (tweet, error) -> () in
            if error != nil {
                NSLog("error posting status: \(error)")
                return
            }
            NSNotificationCenter.defaultCenter().postNotificationName(TwitterEvents.StatusPosted, object: tweet)
            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
}
