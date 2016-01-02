//
//  ViewController.swift
//  DynamicActionBlockDemo-Swift
//
//  Created by Kitten Yang on 1/2/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let dynamicView = DynamicView(frame: view.bounds)
        view.addSubview(dynamicView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

