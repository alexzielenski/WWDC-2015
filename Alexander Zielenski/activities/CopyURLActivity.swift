//
//  CopyURLActivity.swift
//  Alexander Zielenski
//
//  Created by Alexander Zielenski on 4/22/15.
//  Copyright (c) 2015 Alex Zielenski. All rights reserved.
//

import UIKit

class CopyURLActivity: UIActivity {
    var url: NSURL?
    override func activityType() -> String? {
        return "com.alexzielenski.activity.copy_url";
    }
    
    override func activityImage() -> UIImage? {
        return UIImage(named: "CopyURL")
    }
    
    override func activityTitle() -> String? {
        return "Copy Link"
    }
    
    override func canPerformWithActivityItems(activityItems: [AnyObject]) -> Bool {
        for obj in activityItems {
            if obj is NSURL {
                return true
            }
        }
        
        return false;
    }
    
    override func prepareWithActivityItems(activityItems: [AnyObject]) {
        for obj in activityItems {
            if obj is NSURL {
                url = obj as? NSURL
                return
            }
        }
    }
    
    override func performActivity() {
        if let url = url {
            UIPasteboard.generalPasteboard().URL = url
        }
        
        activityDidFinish(true)
    }
}
