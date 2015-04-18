//
//  Carousel.swift
//  Alexander Zielenski
//
//  Created by Alexander Zielenski on 4/14/15.
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
        imageView.contentMode = UIViewContentMode.ScaleToFill
        
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

@objc protocol CarouselDelegate {
    func carousel(carousel: Carousel, didSelectEntry entry: CarouselEntry)
}

class Carousel: UIScrollView, UIScrollViewDelegate {
    @IBOutlet var carouselDelegate: CarouselDelegate?
    var entries: [CarouselEntry] = []
    var ratio:CGFloat = 1.0
    var tapHandler: ((entry: CarouselEntry) -> ())?

    var cellWidth: CGFloat {
        return frame.size.width * ratio
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        self.layoutIfNeeded()
        delegate = self
        
        pagingEnabled = true
        contentSize = CGSizeMake(0, frame.size.height)
        clipsToBounds = true
        
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "carouselTapped:")
        addGestureRecognizer(tapGesture)
    }
    
    override func layoutSubviews() {
        var x:CGFloat = 0
        let width = cellWidth

        for entry in entries {
            entry.frame = CGRect(x: x,
                y: 0,
                width: width,
                height: frame.size.height)
            x += entry.frame.size.width
            addSubview(entry)
        }
        
        contentSize.width = CGFloat(entries.count) * width
        super.layoutSubviews()
    }
    
    dynamic func carouselTapped(recognizer: UITapGestureRecognizer) {
        let view = hitTest(recognizer.locationInView(self), withEvent: nil)
        if let view = view {
            if view is CarouselEntry {
                tapHandler?(entry: view as! CarouselEntry)
            }
        }
    }
    
    var totalPages:Int {
        if cellWidth > 0 {
            return Int(round(contentSize.width / cellWidth * ratio))
        }
        
        return 0
    }
    
    var currentPage:Int {
        get {
            if frame.size.width > 0 {
                return Int(round(contentOffset.x / frame.size.width))
            }
            return 0
        }
        set {
            if entries.count == 0 ||
            newValue >= totalPages {
                return
            }
            
            var dest = newValue
            dest = max(0, dest)
            dest = min(dest, entries.count - 1)

            let cell = entries[dest]
            self.setContentOffset(CGPointMake(CGFloat(dest) * frame.size.width, 0), animated: true)
        }
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        carouselDelegate?.carousel(self, didSelectEntry: entries[currentPage])
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        carouselDelegate?.carousel(self, didSelectEntry: entries[self.currentPage])
    }
    
}
