//
//  LoadingHUD.swift
//  Cosmos
//
//  Created by KittenYang on 16/3/12.
//  Copyright © 2016年 KittenYang. All rights reserved.
//

import UIKit

class LoadingHUD: UIVisualEffectView {
  
  private var ball_1: UIView!
  private var ball_2: UIView!
  private var ball_3: UIView!
  private var timer: NSTimer?
  
  let BALL_RADIUS: CGFloat = 20
  
  static let sharedHUD = LoadingHUD(effect: UIBlurEffect(style: .Dark))
  private init(effect: UIVisualEffect) {
    super.init(effect: effect)
    self.frame = UIScreen.mainScreen().bounds
    ball_2 = UIView(frame: CGRect(x: width/2 - BALL_RADIUS/2, y: height/2 - BALL_RADIUS/2, width: BALL_RADIUS, height: BALL_RADIUS))
    ball_2.backgroundColor = ThemeColor
    ball_2.layer.cornerRadius = ball_2.width / 2
    
    ball_1 = UIView(frame: CGRect(x: ball_2.origin.x - BALL_RADIUS, y: ball_2.origin.y, width: BALL_RADIUS, height: BALL_RADIUS))
    ball_1.backgroundColor = ThemeColor
    ball_1.layer.cornerRadius = ball_1.width / 2
    
    ball_3 = UIView(frame: CGRect(x: ball_2.origin.x + BALL_RADIUS, y: ball_2.origin.y, width: BALL_RADIUS, height: BALL_RADIUS))
    ball_3.backgroundColor = ThemeColor
    ball_3.layer.cornerRadius = ball_3.width / 2
    
    addSubview(ball_1)
    addSubview(ball_2)
    addSubview(ball_3)

  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }

  
  class func showHUD() {
    let hud = LoadingHUD.sharedHUD
    if let window = UIApplication.sharedApplication().keyWindow {
      hud.alpha = 0.0
      window.addSubview(hud)
      UIView.animateWithDuration(0.3, animations: { () -> Void in
        hud.alpha = 0.9
        }, completion: { (finished) -> Void in
          hud.alpha = 0.9
          hud.startLoadingAnimation()
      })
    }
  }
  
  class func dismissHUD() {
    let hud = LoadingHUD.sharedHUD
    hud.stopLoadingAnimation()
    if let timer = hud.timer {
      timer.invalidate()
    }
    UIView.animateWithDuration(0.3, animations: { () -> Void in
      hud.alpha = 0.0
      }) { (finished) -> Void in
        hud.removeFromSuperview()
    }
  }
}


extension LoadingHUD {
  
  private func stopLoadingAnimation() {
    ball_1.layer.removeAllAnimations()
    ball_2.layer.removeAllAnimations()
    ball_3.layer.removeAllAnimations()
  }
  
  private func startLoadingAnimation() {
    //-----1--------
    let circlePath_1 = UIBezierPath()
    circlePath_1.moveToPoint(CGPointMake(width/2-BALL_RADIUS, height/2))
    circlePath_1.addArcWithCenter(CGPointMake(width/2, height/2), radius: BALL_RADIUS, startAngle: CGFloat((180*M_PI)/180), endAngle: CGFloat((360*M_PI)/180), clockwise: false)
    
    let circlePath_1_2 = UIBezierPath()
    circlePath_1_2.addArcWithCenter(CGPointMake(width/2, height/2), radius: BALL_RADIUS, startAngle: 0.0, endAngle: CGFloat((180*M_PI)/180), clockwise: false)
    circlePath_1.appendPath(circlePath_1_2)
    
    let animation = CAKeyframeAnimation(keyPath: "position")
    animation.path = circlePath_1.CGPath
    animation.removedOnCompletion = true
    animation.duration = 1.4
    animation.repeatCount = MAXFLOAT
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    ball_1.layer.addAnimation(animation, forKey: "ball_1_rotation_animation")
    
    //------2--------
    let circlePath_2 = UIBezierPath()
    circlePath_2.moveToPoint(CGPointMake(width/2+BALL_RADIUS, height/2))
    circlePath_2.addArcWithCenter(CGPointMake(width/2, height/2), radius: BALL_RADIUS, startAngle: 0, endAngle: CGFloat((180*M_PI)/180), clockwise: false)
    
    let circlePath_2_2 = UIBezierPath()
    circlePath_2_2.addArcWithCenter(CGPointMake(width/2, height/2), radius: BALL_RADIUS, startAngle: CGFloat((180*M_PI)/180), endAngle: CGFloat((360*M_PI)/180), clockwise: false)
    circlePath_2.appendPath(circlePath_2_2)
    
    let animation_2 = CAKeyframeAnimation(keyPath: "position")
    animation_2.path = circlePath_2.CGPath
    animation_2.removedOnCompletion = true
    animation_2.repeatCount = MAXFLOAT
    animation_2.duration = 1.4
    animation_2.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    ball_3.layer.addAnimation(animation_2, forKey: "ball_2_rotation_animation")
    
    timer = NSTimer.scheduledTimerWithTimeInterval(0.7, block: { (timer) -> Void in
      UIView.animateWithDuration(0.3, delay: 0.1, options: [.CurveEaseOut,.BeginFromCurrentState], animations: { () -> Void in
        self.ball_1.transform = CGAffineTransformMakeTranslation(-self.BALL_RADIUS, 0)
        self.ball_1.transform = CGAffineTransformScale(self.ball_1.transform, 0.7, 0.7)
        
        self.ball_3.transform = CGAffineTransformMakeTranslation(self.BALL_RADIUS, 0)
        self.ball_3.transform = CGAffineTransformScale(self.ball_3.transform, 0.7, 0.7)
        
        self.ball_2.transform = CGAffineTransformScale(self.ball_2.transform, 0.7, 0.7)
        
        }, completion: { (finished) -> Void in
          UIView.animateWithDuration(0.3, delay: 0.0, options: [.CurveEaseIn, .BeginFromCurrentState], animations: { () -> Void in
            self.ball_1.transform = CGAffineTransformIdentity
            self.ball_3.transform = CGAffineTransformIdentity
            self.ball_2.transform = CGAffineTransformIdentity
            }, completion: nil)
      })
      }, repeats: true)
    NSRunLoop.mainRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
  }
}




