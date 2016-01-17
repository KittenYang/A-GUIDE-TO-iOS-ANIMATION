//
//  ViewController.swift
//  AnimatedCurveDemo-Swift
//
//  Created by Kitten Yang on 1/18/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let contentOffset = 50.0
    let targetHeight  = 500.0
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "testCell")
        tableView.layoutIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let headerView = CurveRefreshHeaderView(associatedScrollView: self.tableView, withNavigationBar: true)
        headerView.triggerPulling()
        headerView.refreshingBlock = { ()->() in
            let delayInSeconds = 2.0
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()){ _ in
                headerView.stopRefreshing()
            }
        }
        
        let footerView = CurveRefreshFooterView(associatedScrollView: self.tableView, withNavigationBar: true)
        footerView.refreshingBlock = { ()->() in
            let delayInSeconds = 2.0
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()){ _ in
                headerView.stopRefreshing()
            }
        }
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let testCell = tableView.dequeueReusableCellWithIdentifier("testCell", forIndexPath: indexPath)
        testCell.textLabel?.text = "第\(indexPath.row)条"
        return testCell
    }
}