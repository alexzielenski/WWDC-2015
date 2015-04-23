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
    
    @IBAction func pressHat(sender: UIButton?) {
        if let button = sender {
            let layer = button.layer
            let current = layer.valueForKey("transform.rotation") as? NSNumber ?? NSNumber(float: 0.0)
            let rotation = CATransform3DRotate(layer.transform, CGFloat(2.0 * M_PI), 0, 0, 1.0)
            layer.transform = rotation
            let animation = CABasicAnimation(keyPath: "transform.rotation")
            animation.fromValue = current
            animation.duration = 0.5
            animation.toValue = NSNumber(float: current.floatValue + Float(2 * M_PI))
            layer.addAnimation(animation, forKey: "transform.rotation")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController is ProjectsTableViewController {
            (segue.destinationViewController as! UIViewController).title = segue.identifier?.capitalizedString
            let items = content[segue.identifier!] as! [AnyObject]
            (segue.destinationViewController as! ProjectsTableViewController).items = items
        }
    }
}

