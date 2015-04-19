//
//  CarouselEntry.swift
//  Alexander Zielenski
//
//  Created by Alexander Zielenski on 4/18/15.
//  Copyright (c) 2015 Alex Zielenski. All rights reserved.
//

import UIKit

class CarouselEntry: UIView {
    var title: String?
    var image: UIImage?
    private let titleLabel = UILabel(frame: CGRectZero)
    private let imageView  = UIImageView(frame: CGRectZero)
    private (set) var currentPage = 0
    
    init(title: String?, image: UIImage?) {
        super.init(frame: CGRectZero)
        self.title = title
        self.image = image
        addSubview(titleLabel)
        addSubview(imageView)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.font = UIFont(name: "Helvetica", size: 14.0)
        titleLabel.textColor = UIColor.whiteColor()
        
        titleLabel.text = title
        titleLabel.textAlignment = .Center
        imageView.image = image
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        var intrinsicSize = titleLabel.intrinsicContentSize()
        
        if title == nil || count(title!) == 0 {
            intrinsicSize = CGSizeZero
        }
        
        titleLabel.frame = CGRect(x: CGRectGetMidX(bounds) - intrinsicSize.width,
            y: CGRectGetMaxY(bounds) - intrinsicSize.height - 4,
            width: intrinsicSize.width,
            height: intrinsicSize.height)
        
        let height = intrinsicSize.height == 0 ? bounds.size.height :
            bounds.size.height - intrinsicSize.height - 16.0 - 4
        imageView.frame = CGRect(x: 0,
            y: 0,
            width: bounds.size.width,
            height: height)
    }
}
