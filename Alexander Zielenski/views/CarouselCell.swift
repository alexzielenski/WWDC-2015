//
//  CarouselCell.swift
//  Alexander Zielenski
//
//  Created by Alexander Zielenski on 4/14/15.
//  Copyright (c) 2015 Alex Zielenski. All rights reserved.
//

import UIKit

class CarouselCell: UITableViewCell, CarouselDelegate {
    @IBOutlet var carousel: Carousel!
    @IBOutlet var leftArrowButton: UIButton!
    @IBOutlet var rightArrowButton: UIButton!
    var callBack: ((cell: CarouselCell, didPage: Int) -> ())?
    var previewsEnabled = true
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        _setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _setup()
    }
    
    deinit {
        callBack = nil
    }
    
    private func _setup() {
        contentView.preservesSuperviewLayoutMargins = false
        contentView.layoutMargins = UIEdgeInsetsZero
        
        preservesSuperviewLayoutMargins = false
        separatorInset = UIEdgeInsetsZero
        layoutMargins = UIEdgeInsetsZero
        
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        leftArrowButton.gestureRecognizers = nil
        rightArrowButton.gestureRecognizers = nil
        
        var doubleTap = UITapGestureRecognizer(target: self, action: "doubleTap:")
        doubleTap.numberOfTapsRequired = 2
        leftArrowButton.addGestureRecognizer(doubleTap)
        
        doubleTap = UITapGestureRecognizer(target: self, action: "doubleTap:")
        doubleTap.numberOfTapsRequired = 2
        rightArrowButton.addGestureRecognizer(doubleTap)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        carousel.currentPage = 0
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        leftArrowButton.layer.shadowColor = UIColor.blackColor().CGColor
        leftArrowButton.layer.shadowRadius = 6.0
        leftArrowButton.layer.shadowOpacity = 0.5
        leftArrowButton.layer.shadowOffset = CGSizeZero
        leftArrowButton.alpha = 0.65
        
        rightArrowButton.layer.shadowColor = UIColor.blackColor().CGColor
        rightArrowButton.layer.shadowRadius = 6.0
        rightArrowButton.layer.shadowOpacity = 0.5
        rightArrowButton.layer.shadowOffset = CGSizeZero
        rightArrowButton.alpha = 0.65
        carousel.carouselDelegate = self
        
        // Make sure the buttons are on top of the carousel
        self.contentView.addSubview(leftArrowButton)
        self.contentView.addSubview(rightArrowButton)
        
        recomputeArrows()
    }
    
    func carousel(carousel: Carousel, didSelectEntry entry: CarouselEntry) {
        callBack?(cell: self, didPage: carousel.currentPage)
        recomputeArrows()
    }
    
    private func recomputeArrows() {
        leftArrowButton.hidden = carousel.currentPage == 0
        rightArrowButton.hidden = carousel.currentPage >= carousel.totalPages - 1
    }
    
    private dynamic func doubleTap(recognizer: UITapGestureRecognizer) {
        if recognizer.view == leftArrowButton {
            carousel.currentPage = 0
        } else if recognizer.view == rightArrowButton {
            carousel.currentPage = carousel.totalPages - 1
        }
    }
    
    @IBAction func changePage(sender: UIButton) {
        carousel.currentPage += sender.tag
    }
    
}
