//
//  AppDelegate.swift
//  SplashAnimiationDemo-Swift
//
//  Created by Kitten Yang on 1/15/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        window?.makeKeyAndVisible()
        window?.backgroundColor = UIColor(red: 128.0/255.0, green: 0.0, blue: 0.0, alpha: 1.0)
        
        guard let navigationController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() else {
            return true
        }
        window?.rootViewController = navigationController
        
        //logo mask
        let maskLayer = CALayer()
        maskLayer.contents = UIImage(named: "logo")?.CGImage
        maskLayer.position = navigationController.view.center
        maskLayer.bounds = CGRect(x: 0, y: 0, width: 60, height: 60)
        navigationController.view.layer.mask = maskLayer
        
        //logo mask background view
        let maskBackgroundView = UIView(frame: navigationController.view.bounds)
        maskBackgroundView.backgroundColor = UIColor.whiteColor()
        navigationController.view.addSubview(maskBackgroundView)
        navigationController.view.bringSubviewToFront(maskBackgroundView)
        
        //logo mask animation
        let logoMaskAnimaiton = CAKeyframeAnimation(keyPath: "bounds")
        logoMaskAnimaiton.duration = 1.0
        logoMaskAnimaiton.beginTime = CACurrentMediaTime() + 1.0
        
        let initalBounds = maskLayer.bounds
        let secondBounds = CGRectMake(0, 0, 50, 50)
        let finalBounds  = CGRectMake(0, 0, 2000, 2000)
        logoMaskAnimaiton.values = [NSValue(CGRect: initalBounds), NSValue(CGRect: secondBounds), NSValue(CGRect: finalBounds)]
        logoMaskAnimaiton.keyTimes = [0.0, 0.5, 1.0]
        logoMaskAnimaiton.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut), CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut), CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)]
        logoMaskAnimaiton.removedOnCompletion = false
        logoMaskAnimaiton.fillMode = kCAFillModeForwards
        navigationController.view.layer.mask?.addAnimation(logoMaskAnimaiton, forKey: "logoMaskAnimaiton")
    
        UIView.animateWithDuration(0.1, delay: 1.35, options: .CurveEaseIn, animations: { () -> Void in
            maskBackgroundView.alpha = 0.0
            }) { (finished) -> Void in
                maskBackgroundView.removeFromSuperview()
        }
        
        UIView.animateWithDuration(0.25, delay: 1.3, options: .TransitionNone, animations: { () -> Void in
            navigationController.view.transform = CGAffineTransformMakeScale(1.05, 1.05)
            }) { (finished) -> Void in
                UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
                    navigationController.view.transform = CGAffineTransformIdentity
                    }, completion: { (finished) -> Void in
                        navigationController.view.layer.mask = nil
                })
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

