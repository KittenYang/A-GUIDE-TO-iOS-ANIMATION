//
//  ViewController.swift
//  UIDynamicsDemo-Swift
//
//  Created by Kitten Yang on 1/16/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var restoreButton: UIButton!
    private var lockScreenView: UIImageView!
    private var animator: UIDynamicAnimator!
    private var gravityBehaviour: UIGravityBehavior!
    private var pushBehavior: UIPushBehavior!
    private var attachmentBehaviour: UIAttachmentBehavior!
    private var itemBehaviour: UIDynamicItemBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lockScreenView = UIImageView(frame: view.bounds)
        lockScreenView.image = UIImage(named: "lockScreen")
        lockScreenView.contentMode = .ScaleToFill
        lockScreenView.userInteractionEnabled = true
        view.addSubview(lockScreenView)

        let tapGesture = UITapGestureRecognizer(target: self, action: "tapOnIt:")
        lockScreenView.addGestureRecognizer(tapGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: "panOnIt:")
        lockScreenView.addGestureRecognizer(panGesture)
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        animator = UIDynamicAnimator(referenceView: view)
        let collisionBehaviour = UICollisionBehavior(items: [lockScreenView])
        collisionBehaviour.setTranslatesReferenceBoundsIntoBoundaryWithInsets(UIEdgeInsets(top: -lockScreenView.frame.height, left: 0, bottom: 0, right: 0))
        animator.addBehavior(collisionBehaviour)
        
        gravityBehaviour = UIGravityBehavior(items: [lockScreenView])
        gravityBehaviour.gravityDirection = CGVector(dx: 0.0, dy: 1.0)
        gravityBehaviour.magnitude = 2.6
        animator.addBehavior(gravityBehaviour)
        
        pushBehavior = UIPushBehavior(items: [lockScreenView], mode: .Instantaneous)
        pushBehavior.magnitude = 2.0
        pushBehavior.angle = CGFloat(M_PI)
        animator.addBehavior(pushBehavior)
        
        itemBehaviour = UIDynamicItemBehavior(items: [lockScreenView])
        itemBehaviour.elasticity = 0.35
        animator.addBehavior(itemBehaviour)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc private func tapOnIt(tapGes: UITapGestureRecognizer) {
        pushBehavior.pushDirection = CGVector(dx: 0.0, dy: -80.0)
        pushBehavior.active = true
    }
    
    @objc private func panOnIt(panGes: UIPanGestureRecognizer) {
        let location = CGPoint(x: CGRectGetMidX(lockScreenView.frame), y: panGes.locationInView(view).y)
        if panGes.state == .Began {
            animator.removeBehavior(gravityBehaviour)
            attachmentBehaviour = UIAttachmentBehavior(item: lockScreenView, attachedToAnchor: location)
            animator.addBehavior(attachmentBehaviour)
        } else if panGes.state == .Changed {
            attachmentBehaviour.anchorPoint = location
        } else if panGes.state == .Ended {
            let velocity = panGes.velocityInView(lockScreenView)
            animator.removeBehavior(attachmentBehaviour)
            attachmentBehaviour = nil
            if velocity.y < -1300 {
                animator.removeBehavior(gravityBehaviour)
                animator.removeBehavior(itemBehaviour)
                gravityBehaviour = nil
                itemBehaviour = nil

                //gravity
                gravityBehaviour = UIGravityBehavior(items: [lockScreenView])
                gravityBehaviour.gravityDirection = CGVector(dx: 0.0, dy: -1.0)
                gravityBehaviour.magnitude = 2.6
                animator.addBehavior(gravityBehaviour)
                
                //item
                itemBehaviour = UIDynamicItemBehavior(items: [lockScreenView])
                itemBehaviour.elasticity = 0.0
                animator.addBehavior(itemBehaviour)
                
                //push
                pushBehavior.pushDirection = CGVector(dx: 0.0, dy: -200.0)
                pushBehavior.active = true
            } else {
                restore(restoreButton)
            }
        
        }
        
    }
    
    @IBAction func restore(sender: AnyObject) {

        animator.removeBehavior(gravityBehaviour)
        animator.removeBehavior(itemBehaviour)
        gravityBehaviour = nil
        itemBehaviour  = nil
    
        //gravity
        gravityBehaviour = UIGravityBehavior(items: [lockScreenView])
        gravityBehaviour.gravityDirection = CGVector(dx: 0.0, dy: 1.0)
        gravityBehaviour.magnitude = 2.6
        
        //item
        itemBehaviour = UIDynamicItemBehavior(items: [lockScreenView])
        itemBehaviour.elasticity = 0.35
        animator.addBehavior(itemBehaviour)
        animator.addBehavior(gravityBehaviour)
        
    }

}
