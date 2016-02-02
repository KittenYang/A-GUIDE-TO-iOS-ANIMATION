//
//  ViewController.swift
//  PulseLoader-Swift
//
//  Created by Kitten Yang on 2/2/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pulseLoader = PulseLoader(frame: CGRect(origin: view.center, size: CGSize(width: 100, height: 100)), color: UIColor.redColor())
        pulseLoader.center = view.center
        view.addSubview(pulseLoader)
        
        pulseLoader.startToPluse()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

