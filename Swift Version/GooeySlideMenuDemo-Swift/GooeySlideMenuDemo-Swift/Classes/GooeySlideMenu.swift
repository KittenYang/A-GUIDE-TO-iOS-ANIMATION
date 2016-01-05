//
//  GooeySlideMenu.swift
//  GooeySlideMenuDemo-Swift
//
//  Created by Kitten Yang on 1/3/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import UIKit

typealias MenuButtonClickedBlock = (index: Int, title: String, titleCounts: Int)->()

struct MenuOptions {
    var titles: [String]
    var buttonHeight: CGFloat
    var menuColor: UIColor
    var blurStyle: UIBlurEffectStyle
    var buttonSpace: CGFloat
    var menuBlankWidth: CGFloat
    var menuClickBlock: MenuButtonClickedBlock
}

class GooeySlideMenu: UIView {

    private var _option: MenuOptions
    private var keyWindow: UIWindow?
    private var blurView: UIVisualEffectView!
    private var helperSideView: UIView!
    private var helperCenterView: UIView!
    
    private var diff: CGFloat = 0.0
    private var triggered: Bool = false
    private var displayLink: CADisplayLink?
    private var animationCount: Int = 0
    
    init(options: MenuOptions) {
        _option = options
        if let kWindow = UIApplication.sharedApplication().keyWindow{
            keyWindow = kWindow
            let frame = CGRect(
                x: -kWindow.frame.size.width/2 - options.menuBlankWidth,
                y: 0,
                width: kWindow.frame.size.width/2 + options.menuBlankWidth,
                height: kWindow.frame.size.height)
            super.init(frame:frame)
        } else {
            super.init(frame:CGRectZero)
        }
        setUpViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 0, y: 0))
        path.addLineToPoint(CGPoint(x: frame.width-_option.menuBlankWidth, y: 0))
        path.addQuadCurveToPoint(CGPoint(x: frame.width-_option.menuBlankWidth, y: frame.height), controlPoint: CGPoint(x: frame.width-_option.menuBlankWidth+diff, y: frame.height/2))
        path.addLineToPoint(CGPoint(x: 0, y: frame.height))
        path.closePath()
        
        let context = UIGraphicsGetCurrentContext()
        CGContextAddPath(context, path.CGPath)
        _option.menuColor.set()
        CGContextFillPath(context)
    }
    
    func trigger() {
        if !triggered {
            if let keyWindow = keyWindow {
                keyWindow.insertSubview(blurView, belowSubview: self)
                UIView.animateWithDuration(0.3, animations: { [weak self] () -> Void in
                    self?.frame = CGRect(
                        x: 0,
                        y: 0,
                        width: keyWindow.frame.size.width/2 + _option.menuBlankWidth,
                        height: keyWindow.frame.size.height)
                })
                
                beforeAnimation()
                UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.9, options: [.BeginFromCurrentState,.AllowUserInteraction], animations: { [weak self] () -> Void in
                    self?.helperSideView.center = CGPointMake(keyWindow.center.x, helperSideView.frame.size.height/2);
                    }, completion: { [weak self] (finish) -> Void in
                        self?.finishAnimation()
                    })
                
                UIView.animateWithDuration(0.3, animations: { [weak self] () -> Void in
                    self?.blurView.alpha = 1.0
                })
                
                beforeAnimation()
                UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2.0, options: [.BeginFromCurrentState,.AllowUserInteraction], animations: { [weak self] () -> Void in
                    self?.helperCenterView.center = keyWindow.center
                    }, completion: { [weak self] (finished) -> Void in
                        if finished {
                            let tapGesture = UITapGestureRecognizer(target: self, action: "tapToUntrigger")
                            self?.blurView.addGestureRecognizer(tapGesture)
                            self?.finishAnimation()
                        }
                })
                animateButtons()
                triggered = true
            }
        } else {
            tapToUntrigger()
        }
    }
    
}

extension GooeySlideMenu {
    
    private func setUpViews() {
        if let keyWindow = keyWindow {
            blurView = UIVisualEffectView(effect: UIBlurEffect(style: _option.blurStyle))
            blurView.frame = keyWindow.frame
            blurView.alpha = 0.0
            
            helperSideView = UIView(frame: CGRect(x: -40, y: 0, width: 40, height: 40))
            helperSideView.backgroundColor = UIColor.redColor()
            helperSideView.hidden = true
            keyWindow.addSubview(helperSideView)
            
            helperCenterView = UIView(frame: CGRect(x: -40, y: CGRectGetHeight(keyWindow.frame)/2 - 20, width: 40, height: 40))
            helperCenterView.backgroundColor = UIColor.yellowColor()
            helperCenterView.hidden = true
            keyWindow.addSubview(helperCenterView)
            
            backgroundColor = UIColor.clearColor()
            keyWindow.insertSubview(self, belowSubview: helperSideView)
            addButton()
        }
    }
    
    private func addButton() {
        let titles = _option.titles
        if titles.count % 2 == 0 {
            var index_down = titles.count / 2
            var index_up = -1
            for i in 0..<titles.count {
                let title = titles[i]
                let buttonOption = MenuButtonOptions(title:title, buttonColor:_option.menuColor, buttonClickBlock:{ [weak self] () -> () in
                    self?.tapToUntrigger()
                    self?._option.menuClickBlock(index: i,title: title,titleCounts: titles.count)
                    })
                let home_button = SlideMenuButton(option: buttonOption)
                home_button.bounds = CGRectMake(0, 0, frame.width - _option.menuBlankWidth - 20*2, _option.buttonHeight);
                addSubview(home_button)
                if (i >= titles.count / 2) {
                    index_up++
                    let y = frame.height/2 + _option.buttonHeight*CGFloat(index_up) + _option.buttonSpace*CGFloat(index_up)
                    home_button.center = CGPoint(x: (frame.width - _option.menuBlankWidth)/2, y: y+_option.buttonSpace/2 + _option.buttonHeight/2)
                } else {
                    index_down--
                    let y = frame.height/2 - _option.buttonHeight*CGFloat(index_down) - _option.buttonSpace*CGFloat(index_down)
                    home_button.center = CGPoint(x: (frame.width - _option.menuBlankWidth)/2, y: y - _option.buttonSpace/2 - _option.buttonHeight/2)
                }
            }
        } else {
            var index = (titles.count-1) / 2 + 1
            for i in 0..<titles.count {
                index--
                let title = titles[i]
                let buttonOption = MenuButtonOptions(title: title, buttonColor: _option.menuColor, buttonClickBlock: { [weak self] () -> () in
                    self?.tapToUntrigger()
                    self?._option.menuClickBlock(index: i, title: title, titleCounts: titles.count)
                    })
                let home_button = SlideMenuButton(option: buttonOption)
                home_button.bounds = CGRect(x: 0, y: 0, width: frame.width - _option.menuBlankWidth - 20*2, height: _option.buttonHeight)
                home_button.center = CGPoint(x: (frame.width - _option.menuBlankWidth)/2, y: frame.height/2 - _option.buttonHeight*CGFloat(index) - 20*CGFloat(index))
                addSubview(home_button)
            }
        }
    }
    
    private func animateButtons() {
        for i in 0..<subviews.count {
            let menuButton = subviews[i]
            menuButton.transform = CGAffineTransformMakeTranslation(-90, 0)
            UIView.animateWithDuration(0.7, delay: Double(i)*(0.3/Double(subviews.count)), usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [.BeginFromCurrentState,.AllowUserInteraction], animations: { () -> Void in
                    menuButton.transform =  CGAffineTransformIdentity
                }, completion: nil)
        }
    }
    
   @objc private func tapToUntrigger() {
        UIView.animateWithDuration(0.3) { [weak self] () -> Void in
            self?.frame = CGRect(
                x: -keyWindow!.frame.size.width/2 - _option.menuBlankWidth,
                y: 0,
                width: keyWindow!.frame.size.width/2 + _option.menuBlankWidth,
                height: keyWindow!.frame.size.height)
        }
    
        beforeAnimation()
        UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.9, options: [.BeginFromCurrentState,.AllowUserInteraction], animations: { () -> Void in
            self.helperSideView.center = CGPoint(x: -self.helperSideView.frame.height/2, y: self.helperSideView.frame.height/2)
            }) { [weak self] (finish) -> Void in
                self?.finishAnimation()
        }
        
        UIView.animateWithDuration(0.3) { () -> Void in
            self.blurView.alpha = 0.0
        }
        
        beforeAnimation()
        UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 2.0, options: [.BeginFromCurrentState,.AllowUserInteraction], animations: { () -> Void in
            self.helperCenterView.center = CGPointMake(-self.helperSideView.frame.size.height/2, CGRectGetHeight(self.frame)/2)
            }) { (finish) -> Void in
                self.finishAnimation()
        }
        triggered = false
    }
    
    private func beforeAnimation() {
        if displayLink == nil {
            displayLink = CADisplayLink(target: self, selector: "handleDisplayLinkAction:")
            displayLink?.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        }
        animationCount++
    }
    
    private func finishAnimation() {
        animationCount--
        if animationCount == 0 {
            displayLink?.invalidate()
            displayLink = nil
        }
    }
    
    @objc private func handleDisplayLinkAction(displaylink: CADisplayLink) {
        let sideHelperPresentationLayer = helperSideView.layer.presentationLayer() as! CALayer
        let centerHelperPresentationLayer = helperCenterView.layer.presentationLayer() as! CALayer
        
        let centerRect = centerHelperPresentationLayer.valueForKeyPath("frame")?.CGRectValue
        let sideRect   = sideHelperPresentationLayer.valueForKeyPath("frame")?.CGRectValue
        
        if let centerRect = centerRect, sideRect = sideRect {
            diff = sideRect.origin.x - centerRect.origin.x
        }
        setNeedsDisplay()
    }
}


