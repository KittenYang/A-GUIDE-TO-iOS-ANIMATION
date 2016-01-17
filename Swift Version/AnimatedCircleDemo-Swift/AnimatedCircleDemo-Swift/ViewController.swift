//
//  ViewController.swift
//  AnimatedCircleDemo-Swift
//
//  Created by Kitten Yang on 1/18/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var slider: UISlider!

    private var circleView: CircleView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        circleView = CircleView(frame: CGRectMake(view.frame.size.width/2 - 320/2, view.frame.size.height/2 - 320/2, 320, 320))
        view.addSubview(circleView)
        
        circleView.circleLayer.progress = CGFloat(slider.value)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    @IBAction func didValueChanged(sender: AnyObject) {
        if let slider = sender as? UISlider {
            progressLabel.text = "Current: \(slider.value)"
            circleView.circleLayer.progress = CGFloat(slider.value)
        }
    }

}

