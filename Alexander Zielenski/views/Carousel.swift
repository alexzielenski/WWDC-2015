//
//  Carousel.swift
//  Alexander Zielenski
//
//  Created by Alexander Zielenski on 4/14/15.
//  Copyright (c) 2015 Alex Zielenski. All rights reserved.
//


import UIKit

@objc protocol CarouselDelegate {
    func carousel(carousel: Carousel, didSelectEntry entry: CarouselEntry)
}

class Carousel: UIScrollView, UIScrollViewDelegate {
    @IBOutlet var carouselDelegate: CarouselDelegate?
    var entries: [CarouselEntry] = [] {
        didSet {
            for entry in oldValue {
                entry.removeFromSuperview()
            }
        }
    }
    var ratio:CGFloat = 1.0
    var tapHandler: ((entry: CarouselEntry) -> ())?
    
    var images:[UIImage] {
        get {
            return (entries as NSArray).valueForKey("image") as! [UIImage]
        }
    }
    
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
            return Int(ceil(contentSize.width / cellWidth * ratio))
        }
        
        return 0
    }
    
    var animationsEnabled = true
    var currentPage:Int {
        get {
            if frame.size.width > 0 {
                return Int(ceil(contentOffset.x / frame.size.width))
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

            let amt = Int(ceil(1 / ratio))
            let idx = Int(ceil(CGFloat(dest) / ratio))
            var diff:CGFloat = 0;
            if (newValue == totalPages - 1) {
                diff = CGFloat(amt - (entries.count - idx))
            } else {
                
            }

            self.setContentOffset(CGPointMake(CGFloat(dest) * frame.size.width - cellWidth * diff, 0), animated: animationsEnabled)
        }
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        carouselDelegate?.carousel(self, didSelectEntry: entries[currentPage])
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        carouselDelegate?.carousel(self, didSelectEntry: entries[self.currentPage])
    }
    
}
