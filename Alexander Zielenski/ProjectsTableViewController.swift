//
//  ProjectsTableViewController.swift
//  Alexander Zielenski
//
//  Created by Alexander Zielenski on 4/14/15.
//  Copyright (c) 2015 Alex Zielenski. All rights reserved.
//

import UIKit

class ProjectsTableViewController: UITableViewController {
    private static let content = NSDictionary(contentsOfURL: NSBundle.mainBundle().URLForResource("CarouselContent", withExtension: "plist")!)!
    private let items = content["items"] as! [AnyObject]
    private var currentCells: [Dictionary<String, AnyObject>] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.tableFooterView = UIView(frame: CGRectZero)
        changeToPage(0)
    }

    private var oldPage = -1
    func changeToPage(page: Int) {
        if (oldPage == page) {
            return
        }
        
        let oldPageItem: AnyObject = oldPage >= 0 ? items[oldPage] : []
        let pageItem: AnyObject = items[page]
        
        tableView.beginUpdates()
        var deletePaths: [NSIndexPath] = []
        for i in 0..<currentCells.count {
            deletePaths.append(NSIndexPath(forRow: i+1, inSection: 0))
        }
        
        currentCells = pageItem["cells"] as! [Dictionary<String, AnyObject>]
        var insertPaths: [NSIndexPath] = []
        for i in 0..<currentCells.count {
            insertPaths.append(NSIndexPath(forRow: i+1, inSection: 0))
        }
        
        var deleteDirection = UITableViewRowAnimation.Right
        var insertDirection = UITableViewRowAnimation.Left
        
        if (oldPage < page) {
            deleteDirection = .Left
            insertDirection = .Right
        }
        
        tableView.deleteRowsAtIndexPaths(deletePaths, withRowAnimation: deleteDirection)
        tableView.insertRowsAtIndexPaths(insertPaths, withRowAnimation: insertDirection)
        
        tableView.endUpdates()
        oldPage = page
        
        let on = pageItem["on"] as? String
        let off = oldPageItem["off"] as? String
        
        if let on = on {
            let sel = Selector(on)
            if respondsToSelector(sel) && count(on) > 0 {
                NSTimer.scheduledTimerWithTimeInterval(0.1,
                    target: self,
                    selector: sel,
                    userInfo: nil,
                    repeats: false)
            }
        }
        
        if let off = off {
            let sel = Selector(off)
            if respondsToSelector(sel) && count(off) > 0 {
                NSTimer.scheduledTimerWithTimeInterval(0.1,
                    target: self,
                    selector: sel,
                    userInfo: nil,
                    repeats: false)
            }
        }
        
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return 1 + currentCells.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("carousel", forIndexPath: indexPath) as! CarouselCell
            var entries:[CarouselEntry] = []
            for item in items {
                entries.append(CarouselEntry(title: item["title"] as? String, image: UIImage(named: item["image"]! as! String)))
            }
            
            cell.carousel.entries = entries
            cell.carousel.tapHandler = nil
            cell.callBack = {
                [weak self]
                (cell, page) in
                
                self?.changeToPage(page)
            }
            
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            return cell

        }
        
        let currentItem = currentCells[indexPath.row - 1]
        let cls = currentItem["class"] as! String
        let cell = tableView.dequeueReusableCellWithIdentifier(cls, forIndexPath: indexPath) as! UITableViewCell
        
        if (cls == "link") {
            cell.textLabel?.text = currentItem["title"] as? String
            cell.detailTextLabel?.text = currentItem["detail"] as? String
        } else if (cls == "carousel") {
            (cell as! CarouselCell).callBack = nil
            var images: AnyObject? = currentItem["detail"]
            
            var cells:[CarouselEntry] = []
            for i in 0..<images!.count {
                let image: AnyObject = images![i]!
                cells.append(CarouselEntry(title: image["title"]! as? String, image: UIImage(named: image["image"]! as! String)!))
            }
            
            (cell as! CarouselCell).carousel.entries = cells
            (cell as! CarouselCell).carousel.ratio = 1.0 / 3.0
            
            (cell as! CarouselCell).carousel.tapHandler = {
                [weak self]
                (entry) in
                self?.performSegueWithIdentifier("imagePreview", sender: entry.image)
                
            }
        } else if (cls == "text") {
            cell.textLabel?.text = currentItem["title"] as? String
            cell.detailTextLabel?.text = currentItem["detail"] as? String
        } else if (cls == "detail") {
            cell.textLabel?.text = currentItem["title"] as? String
            cell.detailTextLabel?.text = currentItem["detail"] as? String
        }
        
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsetsZero
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if cell is LinkCell {
            let current = currentCells[indexPath.row - 1]
            let str = current["url"] as? String
            if let str = str {
                let url = NSURL(string: str)
                if let url = url {
                    let actions = [ url ]
                    //!TODO: create custom UIActivity subclass for open in safari
                    let activityController = UIActivityViewController(activityItems: actions, applicationActivities: nil)
                    presentViewController(activityController, animated: true, completion: { () -> Void in
                        println("done")
                    })
                }
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if let identifier = segue.identifier {
            if identifier == "imagePreview" {
                let imagePreview:ImagePreviewController! = (segue.destinationViewController as! UINavigationController).topViewController as! ImagePreviewController
                
                imagePreview.image = sender as? UIImage
            }
        }
    }
    
    @IBAction func unwindToProjectsTable(segue: UIStoryboardSegue) {
        // Aaaand we're back
    }


}
