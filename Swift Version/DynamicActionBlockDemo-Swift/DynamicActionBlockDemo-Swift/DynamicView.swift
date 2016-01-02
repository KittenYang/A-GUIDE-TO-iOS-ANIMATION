//
//  DynamicView.swift
//  DynamicActionBlockDemo-Swift
//
//  Created by Kitten Yang on 1/2/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import UIKit

class DynamicView: UIView {
    
    private var panView: UIView?
    private var ballImageView: UIImageView?
    private var topView: UIView?
    private var middleView: UIView?
    private var bottomView: UIView?
    private var animator: UIDynamicAnimator?
    private var panGravity: UIGravityBehavior?
    private var viewsGravity: UIGravityBehavior?
    private var shapeLayer: CAShapeLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews(){
        panView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height/2))
        panView?.alpha = 0.5
        addSubview(panView!)
        
        panView?.layer.shadowOffset = CGSize(width: -1, height: 2)
        panView?.layer.shadowOpacity = 0.5
        panView?.layer.shadowRadius = 5.0
        panView?.layer.shadowColor = UIColor.blackColor().CGColor
        panView?.layer.masksToBounds = false
        panView?.layer.shadowPath = UIBezierPath(rect: (panView?.bounds)!).CGPath
        
        let pan = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        panView?.addGestureRecognizer(pan)
        
        let grd = CAGradientLayer()
        grd.frame = (panView?.frame)!
        grd.colors = [UIColor(red: 0.0, green: 191/255.0, blue: 255/255.0, alpha: 1.0).CGColor,UIColor.whiteColor().CGColor]
        panView?.layer.addSublayer(grd)
        
        ballImageView = UIImageView(frame: CGRect(x: bounds.width/2 - 30, y: bounds.height/1.5, width: 60, height: 60))
        ballImageView?.image = UIImage(named: "ball")
        addSubview(ballImageView!)
        ballImageView?.layer.shadowOffset = CGSize(width: -4, height: 4)
        ballImageView?.layer.shadowOpacity = 0.5
        ballImageView?.layer.shadowRadius = 5.0
        ballImageView?.layer.shadowColor = UIColor.blackColor().CGColor
        ballImageView?.layer.masksToBounds = false
        
        // middleView
        middleView = UIView(frame: CGRect(x: (ballImageView?.center.x)!-15, y: 200, width: 30, height: 30))
        middleView?.backgroundColor = UIColor.grayColor()
        addSubview(middleView!)
        middleView?.center = CGPoint(x: (middleView?.center.x)!, y: (ballImageView?.center.y)! - (panView?.center.y)! + 15)

        // topView
        topView = UIView(frame: CGRect(x: (ballImageView?.center.x)! - 15, y: 200, width: 30, height: 30))
        topView?.backgroundColor = UIColor.grayColor()
        addSubview(topView!)
        topView?.center = CGPoint(x: (topView?.center.x)!, y: (middleView?.center.y)! - (panView?.center.y)! + (panView?.center.y)!/2)
        
        // bottomView
        bottomView = UIView(frame: CGRect(x: (ballImageView?.center.x)! - 15, y: 200, width: 30, height: 30))
        bottomView?.backgroundColor = UIColor.grayColor()
        addSubview(bottomView!)
        bottomView?.center = CGPoint(x: (bottomView?.center.x)!, y: (middleView?.center.y)! - (panView?.center.y)! + (panView?.center.y)! * 1.5)

        setUpBehaviors()
    }
    
    private func setUpBehaviors(){
        animator = UIDynamicAnimator(referenceView: self)
        panGravity = UIGravityBehavior(items: [panView!])
        animator?.addBehavior(panGravity!)
        
        viewsGravity = UIGravityBehavior(items: [ballImageView!,topView!,bottomView!])
        animator?.addBehavior(viewsGravity!)
        
        viewsGravity?.action = { [weak self] () in
            print("Acton!")
            if let strongSelf = self{
                let path = UIBezierPath()
                path.moveToPoint((strongSelf.panView?.center)!)
                path.addCurveToPoint((strongSelf.ballImageView?.center)!, controlPoint1: (strongSelf.topView?.center)!, controlPoint2: (strongSelf.bottomView?.center)!)
                
                if strongSelf.shapeLayer == nil{
                    strongSelf.shapeLayer = CAShapeLayer()
                    strongSelf.shapeLayer?.fillColor = UIColor.clearColor().CGColor
                    strongSelf.shapeLayer?.strokeColor = UIColor(red: 224.0/255.0, green: 0.0, blue: 35.0/255.0, alpha: 1.0).CGColor
                    strongSelf.shapeLayer?.lineWidth = 5.0
                    
                    strongSelf.shapeLayer?.shadowOffset = CGSize(width: -1, height: 2)
                    strongSelf.shapeLayer?.shadowOpacity = 0.5
                    strongSelf.shapeLayer?.shadowRadius = 5.0
                    strongSelf.shapeLayer?.shadowColor = UIColor.blackColor().CGColor
                    strongSelf.shapeLayer?.masksToBounds = false
                    strongSelf.layer.insertSublayer(strongSelf.shapeLayer!, below: strongSelf.ballImageView?.layer)
                }
                strongSelf.shapeLayer?.path = path.CGPath
            }
        }
        
        // MARK : UICollisionBehavior
        
        let collision = UICollisionBehavior(items: [panView!])
        collision.addBoundaryWithIdentifier("Left", fromPoint: CGPoint(x: -1, y: 0), toPoint: CGPoint(x: -1, y: bounds.size.height))
        collision.addBoundaryWithIdentifier("Right", fromPoint: CGPoint(x: bounds.width+1, y: 0), toPoint:CGPoint(x: bounds.width+1, y: bounds.height))
        collision.addBoundaryWithIdentifier("Middle", fromPoint: CGPoint(x: 0, y: bounds.height/2), toPoint: CGPoint(x: bounds.width, y: bounds.height/2))
        animator?.addBehavior(collision)
        
        // MARK : UIAttachmentBehaviors
        
        let attach1 = UIAttachmentBehavior(item: panView!, attachedToItem: topView!)
        animator?.addBehavior(attach1)
        
        let attach2 = UIAttachmentBehavior(item: topView!, attachedToItem: bottomView!)
        animator?.addBehavior(attach2)
        
        let attach3 = UIAttachmentBehavior(item: bottomView!, offsetFromCenter: UIOffset(horizontal: 0, vertical: 0), attachedToItem: ballImageView!, offsetFromCenter: UIOffset(horizontal: 0, vertical: -ballImageView!.bounds.height/2))
        animator?.addBehavior(attach3)

        // MARK : UIDynamicItemBehavior
        
        let panItem = UIDynamicItemBehavior(items: [panView!,topView!,bottomView!,ballImageView!])
        panItem.elasticity = 0.5
        animator?.addBehavior(panItem)
    }
    
    @objc private func handlePanGesture(gesture: UIPanGestureRecognizer){
        let translation = gesture.translationInView(gesture.view)
        if !((gesture.view?.center.y)! + translation.y > bounds.height/2 - (gesture.view?.bounds.height)!/2){
            gesture.view?.center = CGPoint(x: (gesture.view?.center.x)!, y: (gesture.view?.center.y)! + translation.y)
            gesture.setTranslation(CGPoint(x:0, y:0), inView: gesture.view)
        }
        
        if let animator = animator{
            switch gesture.state {
            case .Began: animator.removeBehavior(panGravity!)
            case .Changed:break;
            case .Ended: animator.addBehavior(panGravity!)
            default:break
            }
            animator.updateItemUsingCurrentState(gesture.view!)
        }
    }
    
}
