//
//  LabelView.h
//  AnimatedCurveDemo
//
//  Created by yangqitao on 15/7/8.
//  Copyright (c) 2015年 Kitten Yang. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    UP,
    DOWN,
} PULLINGSTATE;

@interface LabelView : UIView


/**
 *  LabelView的进度 0~1
 */
@property(nonatomic,assign)CGFloat progress;


/**
 *  是否正在刷新
 */
@property(nonatomic,assign)BOOL loading;


/**
 *  上拉还是下拉
 */
@property(nonatomic,assign)PULLINGSTATE state;


@end
