//
//  GooeySlideMenu.swift
//  GooeySlideMenuDemo-Swift
//
//  Created by Kitten Yang on 1/3/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import UIKit

typealias MenuButtonClickedBlock = (index: Int, title: String, titleCounts: Int)->()

struct MenuOptions {
    var titles: [String]
    var buttonHeight: CGFloat
    var menuColor: UIColor
    var blurStyle: UIBlurEffectStyle
    var buttonSpace: CGFloat
    var menuBlankWidth: CGFloat
    var menuClickBlock: MenuButtonClickedBlock
}

class GooeySlideMenu: UIView {

    private var keyWindow: UIWindow?
    
    init(options: MenuOptions) {
        if let keyWindow = UIApplication.sharedApplication().keyWindow{
            let frame = CGRect(
                x: -keyWindow.frame.size.width/2 - options.menuBlankWidth,
                y: 0,
                width: keyWindow.frame.size.width/2 + options.menuBlankWidth,
                height: keyWindow.frame.size.height)
            super.init(frame:frame)
        } else {
            super.init(frame:CGRectZero)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
