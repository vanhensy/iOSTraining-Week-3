//
//  TweetsViewController.swift
//  Twitter Clone
//
//  Created by Nguyễn Vương Anh Vỹ on 9/14/15.
//  Copyright (c) 2015 Nguyễn Vương Anh Vỹ. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tweets: [Tweet]?
    var tweetCellShown = [Bool]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitleImage()
        tableView.reloadData()
        tableView.delegate = self
        tableView.dataSource = self
        JTProgressHUD.show()
        NSNotificationCenter.defaultCenter().addObserverForName(TwitterEvents.StatusPosted, object: nil, queue: nil) { (notification: NSNotification!) -> Void in
            let tweet = notification.object as! Tweet
            self.tweets?.insert(tweet, atIndex: 0)
            self.tableView.reloadData()
        }
        loadTweets()
        
        
        //---   Add Custom Left Bar Button Item   ---//
        
        self.addLeftNavItemOnView()
        self.addRightNavItemOnView()
        
        
        
        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.addPullToRefreshWithActionHandler {
            TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) -> () in
                self.loadTweets()
            })
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if tweetCellShown[indexPath.row] == false {
            let rotateAnimation = CATransform3DTranslate(CATransform3DIdentity, +500, 10, -5)
            cell.layer.transform = rotateAnimation
            UIView.animateWithDuration(0.5, animations: { () -> Void in
            cell.layer.transform = CATransform3DIdentity
            })
            tweetCellShown[indexPath.row] = true
        }
    }
    
    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}
    
    // Define TableView 
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
    var cell = tableView.dequeueReusableCellWithIdentifier("tweetCell", forIndexPath: indexPath) as! TweetTableViewCell
    cell.tweet = self.tweets?[indexPath.row]
    return cell
    
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
   
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets?.count ?? 0
    }

    func loadTweets() {
        
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) -> () in
            if self.tableView.pullToRefreshView != nil {
                self.tableView.pullToRefreshView.stopAnimating()
            }
            self.tweets = tweets

            self.tableView.reloadData()
            self.delay(1, closure: { () -> () in JTProgressHUD.hide()})
            if tweets != nil {
            var totalTweet: Int = tweets!.count
            for indexNumber in 0...totalTweet {
                self.tweetCellShown.append(false)
            }
            }
        })
        
    }
    
//    @IBAction func onLogout(sender: AnyObject) {
//        User.currentUser?.logOut()
//    }
    
    // Additonal function
    
    func setNavigationTitleImage() {
        var titleView: UIImageView
        titleView = UIImageView(frame:CGRectMake(0, 0, 25, 25))
        titleView.contentMode = .ScaleAspectFit
        titleView.image = UIImage(named: "twitter1.png")
        self.navigationItem.titleView = titleView
    }
    
    func setNavigationItemImage() {
        var leftItem: UIImageView
        leftItem = UIImageView(frame: CGRectMake(0, 0, 25, 25))
        leftItem.contentMode = .ScaleAspectFit
        leftItem.image = UIImage(named: "alarm52.png")
//        self.navigationItem.leftBarButtonItem?.image = leftItem
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "TweetDetailsSegue" {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)!
            let tweetDetailsViewController = segue.destinationViewController as! TweetDetailsViewController
            tweetDetailsViewController.tweet = self.tweets![indexPath.row]
            //println(indexPath)
        }
    }
    
    
    func addLeftNavItemOnView ()
    {
        
        // hide default navigation bar button item
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.hidesBackButton = true;
        
        
        let buttonBack: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        buttonBack.frame = CGRectMake(0, 0, 23, 23)
        buttonBack.setImage(UIImage(named:"log-in.png"), forState: UIControlState.Normal)
        buttonBack.addTarget(self, action: "leftNavButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        
        var leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: buttonBack)
        
        self.navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: false)
        
        
    }
    
    
    func addRightNavItemOnView ()
    {
        
        // hide default navigation bar button item
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.hidesBackButton = true;
        
        
        let buttonCompose: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        buttonCompose.frame = CGRectMake(0, 0, 23, 23)
        buttonCompose.setImage(UIImage(named:"feather15.png"), forState: UIControlState.Normal)
        buttonCompose.addTarget(self, action: "rightNavButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        var rightBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: buttonCompose)
        self.navigationItem.setRightBarButtonItem(rightBarButtonItem, animated: true)
        
        
    }
    
    
    
    func leftNavButtonClick(sender:UIButton!)
    {
        User.currentUser?.logOut()
    }
    func rightNavButtonClick(sender:UIButton!)
    {
        self.performSegueWithIdentifier("composeTweetSegue", sender: self)
    }

}
