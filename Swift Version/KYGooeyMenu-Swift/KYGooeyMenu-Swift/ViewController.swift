//
//  ViewController.swift
//  KYGooeyMenu-Swift
//
//  Created by Kitten Yang on 1/7/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var menu: Menu?
    @IBOutlet weak var debugSwitcher: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menu = Menu(frame: CGRectMake(view.center.x-50, view.frame.size.height - 200, 100, 100))
        view.addSubview(menu!)
        debugSwitcher.addTarget(self, action: "showDedug:", forControlEvents: .ValueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc private func showDedug(sender: UISwitch) {
        if sender.on {
            menu?.menuLayer.showDebug = true
        } else {
            menu?.menuLayer.showDebug = false
        }
        menu?.menuLayer.setNeedsDisplay()
    }

}

