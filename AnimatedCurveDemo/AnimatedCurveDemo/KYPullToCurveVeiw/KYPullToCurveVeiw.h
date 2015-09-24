//
//  KYPullToCurveVeiw.h
//  AnimatedCurveDemo
//
//  Created by yangqitao on 15/7/8.
//  Copyright (c) 2015年 Kitten Yang. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface KYPullToCurveVeiw : UIView

/**
 *  需要滑动多大距离才能松开
 */
@property(nonatomic,assign)CGFloat pullDistance;


/**
 *  初始化方法
 *
 *  @param scrollView 关联的滚动视图
 *
 *  @return self
 */
-(id)initWithAssociatedScrollView:(UIScrollView *)scrollView withNavigationBar:(BOOL)navBar;

/**
 *  立即触发下拉刷新
 */
-(void)triggerPulling;

/**
 *  停止旋转，并且滚动视图回弹到顶部
 */
-(void)stopRefreshing;


/**
 *  刷新执行的具体操作
 *
 *  @param block 操作
 */

-(void)addRefreshingBlock:(void (^)(void))block;


@end
