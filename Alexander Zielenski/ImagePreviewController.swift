//
//  ImagePreviewController.swift
//  Alexander Zielenski
//
//  Created by Alexander Zielenski on 4/15/15.
//  Copyright (c) 2015 Alex Zielenski. All rights reserved.
//

import UIKit

class ImagePreviewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    var imageView = UIImageView(image: UIImage(named: "ZeppelinHeader"))
    private var tapGestureRecognizer: UITapGestureRecognizer!
    private var doubleTapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet var scrollView: UIScrollView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "singleTap:")
        doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "doubleTap:")
        
        tapGestureRecognizer.numberOfTapsRequired = 1
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        
        tapGestureRecognizer.delegate = self
        doubleTapGestureRecognizer.delegate = self
    }
    
    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            // force loading from the storyboard
            let v = view
            imageView.image = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.minimumZoomScale = 0.5
        scrollView.delegate = self
        scrollView.userInteractionEnabled = true
        scrollView.exclusiveTouch = true
        
        imageView.contentMode = .ScaleToFill;
        imageView.userInteractionEnabled = true;
        
        view.preservesSuperviewLayoutMargins = false
        view.layoutMargins = UIEdgeInsetsZero
        
        scrollView.preservesSuperviewLayoutMargins = false
        scrollView.layoutMargins = UIEdgeInsetsZero
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.alpha = 1.0
        
        if let image = self.image {
            let minimumScale = scrollView.frame.size.width / image.size.width;
            scrollView.maximumZoomScale = 6.0
            scrollView.minimumZoomScale = minimumScale;
            scrollView.zoomScale = minimumScale;
            
            imageView.frame.size = image.size
            imageView.frame.origin = CGPointZero
            scrollView.addSubview(imageView)
        }
        
        UIView.animateWithDuration(0.5, animations: {
            [weak self]
            () -> Void in
            UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Fade)
            })
    }
    
    override func viewWillDisappear(animated: Bool) {
        if !animated {
            UIApplication.sharedApplication().statusBarHidden = false
        } else {
            UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Fade)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        view.addGestureRecognizer(tapGestureRecognizer)
        view.addGestureRecognizer(doubleTapGestureRecognizer)
        
        UIView.animateWithDuration(0.5, animations: {
            [weak self]
            () -> Void in
            self?.navigationController?.navigationBar.alpha = 0.0
        })
    }
    
    dynamic func singleTap(gesture: UIGestureRecognizer?) {
        println("single tap")

        if (gesture?.state == .Ended) {
            UIView.animateWithDuration(0.5, animations: {
                [weak self]
                () -> Void in
                
                self?.navigationController?.navigationBar.alpha = (1 - self!.navigationController!.navigationBar.alpha)
//                UIApplication.sharedApplication().setStatusBarHidden(!UIApplication.sharedApplication().statusBarHidden, withAnimation: .Fade)

                })
        }
    }
    
    dynamic func doubleTap(gesture: UITapGestureRecognizer?) {
        if scrollView.zoomScale >= scrollView.maximumZoomScale {
            scrollView.zoomScale = scrollView.minimumZoomScale
        } else {
            let step:CGFloat = 1.5
            let newScale = scrollView.zoomScale * step
            let pt = gesture!.locationInView(scrollView)
            let h = scrollView.frame.size.height / step
            let w = scrollView.frame.size.width / step
            let rect = CGRect(x: pt.x - w / 2, y: pt.y - h / 2, width: w, height: h)
            scrollView.zoomToRect(rect, animated: true)
        }
        
    }

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return otherGestureRecognizer != doubleTapGestureRecognizer &&
            otherGestureRecognizer != tapGestureRecognizer
    }
}
