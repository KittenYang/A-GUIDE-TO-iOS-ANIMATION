//
//  JumpStarView.h
//  CoreAnimations
//
//  Created by Kitten Yang on 9/17/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    NONMark,
    Mark,
}STATE;


@interface JumpStarView : UIView

-(void)animate;

@property(nonatomic,assign,setter=setState:)STATE state;

@property(nonatomic,strong)UIImage *markedImage;

@property(nonatomic,strong)UIImage *non_markedImage;


@end
