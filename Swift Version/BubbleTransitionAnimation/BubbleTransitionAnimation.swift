//
//  BubbleTransitionAnimation.swift
//  Cosmos
//
//  Created by KittenYang on 16/4/3.
//  Copyright © 2016年 KittenYang. All rights reserved.
//

import UIKit

enum BubbleTranisionMode {
  case Present, Dismiss
}

class BubbleTransitionAnimation: NSObject {

  var duration: NSTimeInterval = 0.0
  var startPoint: CGPoint = CGPointZero
  var transitionMode: BubbleTranisionMode = .Present
  var bubbleColor: UIColor = UIColor.whiteColor()
  
  private var bubbleView: UIView!
  
}

extension BubbleTransitionAnimation: UIViewControllerAnimatedTransitioning {

  func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return duration
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    guard let containerView = transitionContext.containerView() else {
      return
    }
    
    var radius: CGFloat = 0.0
    //判断触发点在那个象限
    if(startPoint.x > (containerView.width / 2)){
      if (startPoint.y < (containerView.height / 2)) {
        //第一象限
        radius = sqrt((startPoint.x * startPoint.x) + (containerView.height-startPoint.y)*(containerView.height-startPoint.y))
      }else{
        //第四象限
        radius = sqrt((startPoint.x * startPoint.x) + (startPoint.y*startPoint.y))
      }
    }else{
      if (startPoint.y < (containerView.height / 2)) {
        //第二象限
        radius = sqrt((containerView.width - startPoint.x) * (containerView.width - startPoint.x) + (containerView.height - startPoint.y)*(containerView.height - startPoint.y));
      }else{
        //第三象限
        radius = sqrt((containerView.width - startPoint.x) * (containerView.width - startPoint.x) + (startPoint.y*startPoint.y))
      }
    }
    
    let size = CGSize(width: radius*2, height: radius*2)
    bubbleView = UIView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
    bubbleView.center = startPoint
    bubbleView.layer.cornerRadius = size.width / 2
    bubbleView.backgroundColor = bubbleColor
    
    guard let toView = transitionContext.viewForKey(UITransitionContextToViewKey), let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey) else {
      return
    }
    if (transitionMode == .Present) {
      let originalCenter = toView.center
      bubbleView.transform = CGAffineTransformMakeScale(0.001, 0.001)
      toView.center = startPoint
      toView.transform = bubbleView.transform
      toView.alpha = 0.0
      bubbleView.alpha = 1.0
      containerView.addSubview(bubbleView)
      containerView.addSubview(toView)
      UIView.animateWithDuration(duration, animations: {
        self.bubbleView.transform = CGAffineTransformIdentity
        toView.transform = CGAffineTransformIdentity
        toView.alpha = 1.0
        toView.center = originalCenter
        }, completion: { (finished) in
          self.bubbleView.removeFromSuperview()
          self.bubbleView = nil
          transitionContext.completeTransition(true)
      })
    } else {
      containerView.addSubview(toView)
      containerView.addSubview(bubbleView)
      containerView.addSubview(fromView)
      UIView.animateWithDuration(duration, animations: { 
        self.bubbleView.transform = CGAffineTransformMakeScale(0.001, 0.001)
        fromView.transform = self.bubbleView.transform
        fromView.center = self.startPoint
        fromView.alpha = 0.0
        }, completion: { (finished) in
          transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
          if !transitionContext.transitionWasCancelled() {
            fromView.removeFromSuperview()
            self.bubbleView.removeFromSuperview()
            self.bubbleView = nil
          }
      })
    }
    
  }
  
}
