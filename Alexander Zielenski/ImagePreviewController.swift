//
//  ImagePreviewController.swift
//  Alexander Zielenski
//
//  Created by Alexander Zielenski on 4/15/15.
//  Copyright (c) 2015 Alex Zielenski. All rights reserved.
//

import UIKit

class ImagePreviewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    private var tapGestureRecognizer: UITapGestureRecognizer!
    private var doubleTapGestureRecognizer: UITapGestureRecognizer!
    private var imageViews: [UIImageView] = []
    private var scrollViews: [UIScrollView] = []
    var images: [UIImage] = []
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.pagingEnabled = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.alpha = 1.0
    
        UIView.animateWithDuration(0.5, animations: {
            [weak self]
            () -> Void in
            UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Fade)
            })
    }
    
    var currentImage: UIImage?
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for v in scrollViews {
            v.removeFromSuperview()
        }
        scrollViews = []
        
        scrollView.contentOffset = CGPointZero
        scrollView.contentSize = CGSizeMake(CGFloat(images.count) * scrollView.frame.size.width, scrollView.frame.size.height)
        for i in 0..<images.count {
            let sv = UIScrollView(frame: CGRect(x: CGFloat(i) * (scrollView.frame.size.width),
                y: 0,
                width: scrollView.frame.size.width,
                height: scrollView.frame.size.height))
            
            let image = images[i]
            let iv = UIImageView(image: image)
            iv.frame.size = image.size ?? CGSizeZero
            iv.contentMode = .ScaleToFill
            
            let minimumScale = sv.frame.size.width / iv.frame.size.width
            sv.maximumZoomScale = 6.0
            sv.minimumZoomScale = minimumScale
            sv.zoomScale = minimumScale
            
            sv.delegate = self
            sv.tag = i
            sv.contentSize = iv.frame.size
            sv.addSubview(iv)
            
            scrollView.addSubview(sv)
            scrollViews.append(sv)
            imageViews.append(iv)
        }
        
        if let currentImage = currentImage {
            if let idx = find(images, currentImage) {
                scrollView.contentOffset.x = CGFloat(idx) * scrollView.frame.size.width
            }
        }
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
                })
        }
    }
    
    dynamic func doubleTap(gesture: UITapGestureRecognizer?) {
        println("dubtap")
        let idx = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        let iv = imageViews[idx]
        let sv = scrollViews[idx]
        var pt = gesture!.locationInView(scrollView)
        
        if !(scrollView.hitTest(pt, withEvent: nil) is UIScrollView) {
            return
        }
        
        if sv.zoomScale >= sv.maximumZoomScale {
            sv.zoomScale = sv.minimumZoomScale
        } else {
            // MARK: FIX THIS
            pt = gesture!.locationInView(sv)
            let step:CGFloat = 1.5
            let newScale = sv.zoomScale * step
            let h = sv.frame.size.height / step
            let w = sv.frame.size.width / step
            let rect = CGRect(x: pt.x - w / 2, y: pt.y - h / 2, width: w, height: h)
            sv.zoomToRect(rect, animated: true)
        }
        
    }

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        if (scrollView != self.scrollView) {
            return imageViews[scrollView.tag]
        }
        return nil
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return otherGestureRecognizer != doubleTapGestureRecognizer &&
            otherGestureRecognizer != tapGestureRecognizer
    }
}
