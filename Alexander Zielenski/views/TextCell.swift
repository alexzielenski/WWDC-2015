//
//  TextCell.swift
//  Alexander Zielenski
//
//  Created by Alexander Zielenski on 4/14/15.
//  Copyright (c) 2015 Alex Zielenski. All rights reserved.
//

import UIKit

class TextCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    
    override var textLabel:UILabel? {
        return titleLabel
    }
    
    override var detailTextLabel:UILabel? {
        return detailLabel
    }
    
}
