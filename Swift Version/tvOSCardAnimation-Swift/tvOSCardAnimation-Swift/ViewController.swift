//
//  ViewController.swift
//  tvOSCardAnimation-Swift
//
//  Created by Kitten Yang on 1/15/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let cardView = tvOSCardView()
        cardView.center = view.center
        cardView.bounds = CGRect(x: 0, y: 0, width: 150, height: 200)
        view.addSubview(cardView)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

