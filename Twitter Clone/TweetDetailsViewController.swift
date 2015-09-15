//
//  TweetDetailsViewController.swift
//  Twitter Clone
//
//  Created by Nguyễn Vương Anh Vỹ on 9/14/15.
//  Copyright (c) 2015 Nguyễn Vương Anh Vỹ. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController {
    var indexPath: NSIndexPath?
    var tweet: Tweet?
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var userPlusHolder: UIView!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitleImage()
        customStyle()
        self.nameLabel.text = self.tweet?.user.name!
        var screenNameString: String! = self.tweet?.user.screenname!
        self.screenName.text = "@ \(screenNameString)"
        self.userImageView.setImageWithURL(self.tweet?.user.profileImageURL!)
        self.tweetTextLabel.text = self.tweet?.text
        self.contentImageView.layer.cornerRadius = 3
        self.contentImageView.clipsToBounds = true
        if self.tweet?.mediaLink != nil {
        var mediaURL: String! = toString(self.tweet!.mediaLink!.firstObject!)
        self.contentImageView.setImageWithURL(NSURL(string: mediaURL))
        } else {
            var media_url: String! = nil
            contentImageView.layer.frame.size.height = 0
        }
        
        self.timeLabel.text = self.tweet?.createdAtString

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setNavigationTitleImage() {
        var titleView: UIImageView
        titleView = UIImageView(frame:CGRectMake(0, 0, 25, 25))
        titleView.contentMode = .ScaleAspectFit
        titleView.image = UIImage(named: "twitter1.png")
        self.navigationItem.titleView = titleView
    }
    
    func customStyle() {
        userImageView.layer.cornerRadius = 3
        userImageView.clipsToBounds = true
        userPlusHolder.layer.cornerRadius = 3
        userPlusHolder.clipsToBounds = true
        userPlusHolder.layer.borderWidth = 1
        userPlusHolder.layer.borderColor = UIColor(red: 33.0/255.0, green: 150.0/255.0, blue: 243.0/255.0, alpha: 1.0).CGColor
    }
    

}
