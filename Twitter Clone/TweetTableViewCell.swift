//
//  TweetTableViewCell.swift
//  Twitter Clone
//
//  Created by Nguyễn Vương Anh Vỹ on 9/14/15.
//  Copyright (c) 2015 Nguyễn Vương Anh Vỹ. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    
    @IBOutlet weak var headerHolder: UIView!
    @IBOutlet weak var contentHolder: UIView!
    @IBOutlet weak var userImageHolder: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var retweetsCountLabel: UILabel!
    @IBOutlet weak var favoritesCountLabel: UILabel!
    
    var tweet: Tweet? {
        willSet(renderValue) {
        self.userImage.setImageWithURL(renderValue?.user.profileImageURL)
        self.nameLabel.text = renderValue?.user.name
            var screenNameString: String! = renderValue?.user.screenname!
        self.screenName.text = "@\(screenNameString)"
            var timeAgoString: String! = renderValue?.createdAt?.timeAgo()!
        self.timeLabel.text = "\(timeAgoString) ago"
        self.tweetTextLabel.text = renderValue?.text
        self.retweetsCountLabel.text = renderValue?.retweetsCount!
        self.favoritesCountLabel.text = renderValue?.favoritesCount!
        //println(renderValue!.retweetsCount)
        
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Customize UI
        userImageHolder.layer.cornerRadius = (userImageHolder.frame.size.height)*0.5
        userImageHolder.clipsToBounds = true
        userImage.layer.cornerRadius = ( userImage.frame.size.height)*0.5
        userImage.clipsToBounds = true
        headerHolder.layer.cornerRadius = 5
        contentHolder.layer.cornerRadius = 5
        headerHolder.clipsToBounds = true
        contentHolder.clipsToBounds = true
        userImage.layer.borderWidth = 2
        userImage.layer.borderColor = UIColor(white: 1, alpha: 1).CGColor
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
