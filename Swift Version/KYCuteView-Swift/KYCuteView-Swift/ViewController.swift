//
//  ViewController.swift
//  KYCuteView-Swift
//
//  Created by Kitten Yang on 1/19/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        var option = BubbleOptions()
        option.viscosity = 20.0
        option.bubbleWidth = 35.0
        option.bubbleColor = UIColor(red: 0.0, green: 0.722, blue: 1.0, alpha: 1.0)
        
        let cuteView = CuteView(point: CGPointMake(25, UIScreen.mainScreen().bounds.size.height - 65), superView: view, options: option)
        option.text = "20"
        cuteView.bubbleOptions = option

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }


}

