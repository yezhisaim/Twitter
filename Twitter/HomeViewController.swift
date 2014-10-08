//
//  HomeViewController.swift
//  Twitter
//
//  Created by isai on 10/4/14.
//  Copyright (c) 2014 isai. All rights reserved.
//

import UIKit

class HomeViewController: AMSlideMenuMainViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.enableSlidePanGestureForLeftMenu()
        //self.disableSlidePanGestureForRightMenu()
        // Do any additional setup after loading the view.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func segueIdentifierForIndexPathInLeftMenu(indexPath: NSIndexPath!) -> String! {
        var identifier = "contentSegue" as String
        return identifier;
    }
    
    override func leftMenuWidth() -> CGFloat {
        return 250
    }
    
    override func primaryMenu() -> AMPrimaryMenu {
        return AMPrimaryMenuLeft
    }
    
    override func deepnessForLeftMenu() -> Bool {
        return true
    }
    
    override func maxDarknessWhileLeftMenu() -> CGFloat {
        return 0.5
    }
    
    @IBAction func tapGestureRecognizer(sender: AnyObject) {
        println("leftmenu segue entered")
        
        performSegueWithIdentifier("leftMenu", sender: sender)
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
