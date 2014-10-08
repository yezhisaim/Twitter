//
//  LeftSlideMenuViewController.swift
//  Twitter
//
//  Created by isai on 10/4/14.
//  Copyright (c) 2014 isai. All rights reserved.
//

import UIKit

class LeftSlideMenuViewController: AMSlideMenuLeftTableViewController {

    var leftMenuItems = ["My profile","Timeline","Mentions"] as NSArray
    
    var current_storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    
        // Do any additional setup after loading the view.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leftMenuItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCellWithIdentifier("leftMenuCell", forIndexPath: indexPath) as leftMenuCell
        
            cell.cellText?.text = leftMenuItems[indexPath.row] as? String
        
            return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if(indexPath.row == 0)
        {
            self.performSegueWithIdentifier("contentSegue", sender: AnyObject?())
        }
        else if(indexPath.row == 1)
        {
         self.performSegueWithIdentifier("tweetsViewSegue", sender: AnyObject?())
        }
        else if(indexPath.row == 2)
        {
        self.performSegueWithIdentifier("mentionsViewSegue", sender: AnyObject?())
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if(segue.identifier == "mentionsViewSegue")
        {
            println("Mentions segue entered!")
            if (segue.identifier == "mentionsViewSegue") {
                var nav = segue.destinationViewController as UINavigationController
                if nav.viewControllers[0] is TweetsTableViewController {
                    var tweetsVC = nav.viewControllers[0] as TweetsTableViewController
                    tweetsVC.viewMode = "Mentions"
        }
                
            }
        }

        
    }


}
