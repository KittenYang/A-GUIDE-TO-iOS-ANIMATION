//
//  ViewController.swift
//  JumpStarDemo-Swift
//
//  Created by Kitten Yang on 1/6/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var jumpStarView: JumpStarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        jumpStarView.layoutIfNeeded()
        let option = JumpStarOptions(markedImage: UIImage(named: "icon_star_incell")!, notMarkedImage: UIImage(named: "blue_dot")!, jumpDuration: 0.125, downDuration: 0.215)
        jumpStarView.option = option
        jumpStarView.state = .NotMarked
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func jumpButtonDidTapped(sender: AnyObject) {
        jumpStarView.animate()
    }

}

