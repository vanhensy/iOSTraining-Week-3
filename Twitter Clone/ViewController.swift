//
//  ViewController.swift
//  Twitter Clone
//
//  Created by Nguyễn Vương Anh Vỹ on 9/12/15.
//  Copyright (c) 2015 Nguyễn Vương Anh Vỹ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let colors = Colors()
    
    
    
    @IBOutlet weak var sloganLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var launchLogo: UIImageView!
    @IBOutlet weak var loadingState: UIActivityIndicatorView!
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var buttonHolder: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshBackground()
        self.buttonHolder.layer.cornerRadius = 5
        self.buttonHolder.clipsToBounds = true
        self.loadingState.alpha = 0
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func refreshBackground() {
        view.backgroundColor = UIColor.clearColor()
        var backgroundLayer = colors.gl
        backgroundLayer.frame = view.frame
        view.layer.insertSublayer(backgroundLayer, atIndex: 0)
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    @IBAction func onLogin(sender: AnyObject) {
        self.buttonLogin.alpha = 0
        self.loadingState.alpha = 1
        self.delay(0.2, closure: { () -> () in
            TwitterClient.sharedInstance.loginWithCompletion() {
                (user: User?, error: NSError!) in
                if user != nil {
                    UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                        self.loadingState.center.y = 1000
                        self.buttonHolder.center.y = 1000
                        self.welcomeLabel.center.x = 500
                        self.sloganLabel.center.x = -300
                        self.launchLogo.center.y = 250
                        }, completion: { (finished) -> Void in
                            self.performSegueWithIdentifier("loginSegue", sender: self)
                    })
                } else {
                    println("Can't get your access token")
                }
            }
        })
        
        
    }
}
class Colors {
    let colorTop = UIColor(red: 0.0/255.0, green: 210.0/255.0, blue: 255.0/255.0, alpha: 1.0).CGColor
    let colorBottom = UIColor(red: 58.0/255.0, green: 123.0/255.0, blue: 213.0/255.0, alpha: 1.0).CGColor
    
    let gl: CAGradientLayer
    
    init() {
        gl = CAGradientLayer()
        gl.colors = [ colorTop, colorBottom]
        gl.locations = [ 0.0, 1.0]
    }
}

