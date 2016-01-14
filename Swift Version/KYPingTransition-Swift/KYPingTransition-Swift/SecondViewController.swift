//
//  SecondViewController.swift
//  KYPingTransition-Swift
//
//  Created by Kitten Yang on 1/8/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    private var percentTransition: UIPercentDrivenInteractiveTransition?
    
    // MARK : Lift Circle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let edgeGes = UIScreenEdgePanGestureRecognizer(target: self, action: "edgePan:")
        edgeGes.edges = .Left
        view.addGestureRecognizer(edgeGes)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK : Gesture Method
    
    @objc private func edgePan(recognizer: UIPanGestureRecognizer) {

        var per = recognizer.translationInView(view).x / view.bounds.size.width
        per = min(1.0, max(0.0, per))
        
        if recognizer.state == .Began {
            percentTransition = UIPercentDrivenInteractiveTransition()
            navigationController?.popViewControllerAnimated(true)
        } else if recognizer.state == .Changed {
            percentTransition?.updateInteractiveTransition(per)
        } else if recognizer.state == .Cancelled || recognizer.state == .Ended {
            if per > 0.3 {
                percentTransition?.finishInteractiveTransition()
            } else {
                percentTransition?.cancelInteractiveTransition()
            }
            percentTransition = nil
        }
    }
    
    
    @IBAction func didTapBackButton(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
}

extension SecondViewController: UINavigationControllerDelegate {
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return percentTransition
    }

    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .Pop {
            let pingInvert = PingInvertTransition()
            return pingInvert
        } else {
            return nil
        }
    }
}


