//
//  ProjectsTableViewController+Triggers.swift
//  Alexander Zielenski
//
//  Created by Alexander Zielenski on 4/14/15.
//  Copyright (c) 2015 Alex Zielenski. All rights reserved.
//

import Foundation

extension ProjectsTableViewController {
    dynamic func themeStatusbar() {
        ZeppelinPreview.sharedInstance().turnOn()
    }
    
    dynamic func unthemeStatusbar() {
        ZeppelinPreview.sharedInstance().turnOff()
    }
}