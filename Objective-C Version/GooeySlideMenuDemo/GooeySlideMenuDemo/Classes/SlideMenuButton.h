//
//  SlideMenuButton.h
//  GooeySlideMenuDemo
//
//  Created by Kitten Yang on 15/8/13.
//  Copyright (c) 2015年 Kitten Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideMenuButton : UIView


/**
 *  onvenient init method
 *
 *  @param title title
 *
 *  @return object
 */
-(id)initWithTitle:(NSString *)title;


/**
 *  The button color
 */
@property(nonatomic,strong)UIColor *buttonColor;



/**
 *  button clicked block
 */
@property(nonatomic,copy)void(^buttonClickBlock)(void);



@end
