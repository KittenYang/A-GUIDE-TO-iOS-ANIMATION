//
//  ViewController.swift
//  CADemos-Swift
//
//  Created by Kitten Yang on 12/30/15.
//  Copyright © 2015 Kitten Yang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var downloadButton: DownloadButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadButton.progressBarWidth  = 200
        downloadButton.progressBarHeight = 30
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

