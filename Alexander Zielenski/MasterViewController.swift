//
//  MasterViewController.swift
//  Alexander Zielenski
//
//  Created by Alexander Zielenski on 4/14/15.
//  Copyright (c) 2015 Alex Zielenski. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    @IBOutlet var header: UIView!
    private let content = NSDictionary(contentsOfURL: NSBundle.mainBundle().URLForResource("Content", withExtension: "plist")!)!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationController?.navigationBar.barTintColor = UIColor(red: 166.0/255.0, green: 46.0/255.0, blue: 29.0/255.0, alpha: 1.0)
        navigationController?.navigationBar.barStyle = .Black
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.tableHeaderView = header
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layoutMargins = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
    }
    
    @IBAction func openGitHub(sender: UIBarButtonItem?) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://github.com/alexzielenski")!)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "projects" || segue.identifier == "about" {
            (segue.destinationViewController as! UIViewController).title = segue.identifier?.capitalizedString
            let items = content[segue.identifier!] as! [AnyObject]
            (segue.destinationViewController as! ProjectsTableViewController).items = items
        }
    }
}

