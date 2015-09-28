//
//  InteractiveView.h
//  InteractiveCardDemo
//
//  Created by Kitten Yang on 9/28/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InteractiveView : UIImageView

@property(nonatomic,weak)UIView *dimmingView;
@property(nonatomic,weak)UIView *gestureView;

@end
