//
//  CurveRefreshHeaderView.swift
//  AnimatedCurveDemo-Swift
//
//  Created by Kitten Yang on 1/18/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import UIKit

typealias RefreshingBlock = ()->()
class CurveRefreshHeaderView: UIView {

    /// 需要滑动多大距离才能松开
    var pullDistance: CGFloat = 0.0
    /// 刷新执行的具体操作    
    var refreshingBlock: RefreshingBlock?
    
    private var progress: CGFloat = 0.0 {
        didSet{
            if !_associatedScrollView.tracking {
                labelView.loading = true
            }
            
            if !willEnd && !loading {
                curveView.progress = progress
                labelView.progress = progress
            }
            
            center = CGPointMake(center.x, -fabs(_associatedScrollView.contentOffset.y + originOffset)/2);
            
            let diff = fabs(_associatedScrollView.contentOffset.y + originOffset) - self.pullDistance + 10;
            
            if diff > 0 {
                if !_associatedScrollView.tracking {
                    if !notTracking {
                        notTracking = true
                        loading = true
                        print("旋转")
                        
                        //旋转...
                        curveView.startInfiniteRotation()
                        UIView.animateWithDuration(0.3, animations: { [weak self] () -> Void in
                            if let strongSelf = self {
                                strongSelf._associatedScrollView.contentInset = UIEdgeInsetsMake(strongSelf.pullDistance + strongSelf.originOffset, 0, 0, 0)
                            }
                            }, completion: { [weak self] (_) -> Void in
                                if let strongSelf = self {
                                    strongSelf.refreshingBlock?()
                                }
                        })

                    }
                }
                
                if (!loading) {
                    curveView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI) * (diff*2/180));
                }
                
            }else{
                labelView.loading = false
                curveView.transform = CGAffineTransformIdentity
            }
        }
    }
    
    private var _associatedScrollView: UIScrollView!
    private var labelView: LabelView!
    private var curveView: CurveView!
    private var originOffset: CGFloat!
    private var willEnd: Bool = false
    private var notTracking: Bool = false
    private var loading: Bool = false
    
    init(associatedScrollView: UIScrollView, withNavigationBar: Bool) {
        super.init(frame: CGRectMake(associatedScrollView.frame.width/2-200/2, -100, 200, 100))
        if withNavigationBar {
            originOffset = 64.0
        }else{
            originOffset = 0.0
        }
        _associatedScrollView = associatedScrollView
        setUp()
        _associatedScrollView.addObserver(self, forKeyPath: "contentOffset", options: [.New, .Old], context: nil)
        _associatedScrollView.insertSubview(self, atIndex: 0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        _associatedScrollView.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    func triggerPulling() {
        _associatedScrollView.setContentOffset(CGPointMake(0, -pullDistance-originOffset), animated: true)
    }
    
    func stopRefreshing() {
        willEnd = true
        progress = 1.0
        UIView.animateWithDuration(0.1, delay: 0.0, options: .CurveEaseInOut, animations: { [weak self] () -> Void in
            if let strongSelf = self {
                strongSelf.alpha = 0.0
                strongSelf._associatedScrollView.contentInset = UIEdgeInsetsMake(strongSelf.originOffset+0.1, 0, 0, 0)
                
            }
            }) { [weak self] (_) -> Void in
                if let strongSelf = self {
                    strongSelf.alpha = 1.0
                    strongSelf.willEnd = false
                    strongSelf.notTracking = false
                    strongSelf.loading = false
                    strongSelf.labelView.loading = false
                    strongSelf.curveView.stopInfiniteRotation()
                }
        }
    }
    
}

extension CurveRefreshHeaderView {
    private func setUp() {
        pullDistance = 99;
        curveView = CurveView(frame: CGRectMake(20, 0, 30, frame.height))
        insertSubview(curveView, atIndex: 0)
        
        labelView = LabelView(frame: CGRectMake(curveView.frame.origin.x + curveView.frame.width + 10.0, curveView.frame.origin.y, 150, curveView.frame.height))
        insertSubview(labelView, aboveSubview: curveView)
    }
    
}

// MARK : KVO

extension CurveRefreshHeaderView {
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "contentOffset" {
            if let change = change {
                if let contentOffset = change[NSKeyValueChangeNewKey]?.CGPointValue {
                    if contentOffset.y + originOffset <= 0 {
                        progress = max(0.0, min(fabs(contentOffset.y+originOffset)/pullDistance, 1.0))
                    }
                }
            }
        }
    }
}

extension UIView {
    func startInfiniteRotation() {
        transform = CGAffineTransformIdentity
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = M_PI * 2.0
        rotationAnimation.duration = 0.5
        rotationAnimation.autoreverses = false
        rotationAnimation.repeatCount = HUGE
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        layer.addAnimation(rotationAnimation, forKey: "rotationAnimation")
    }
    
    func stopInfiniteRotation() {
        layer.removeAllAnimations()
    }
}