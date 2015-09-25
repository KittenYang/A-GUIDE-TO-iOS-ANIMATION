//
//  KYBubbleTransition.h
//  guji
//
//  Created by Kitten Yang on 5/15/15.
//  Copyright (c) 2015 Guji Tech Ltd. All rights reserved.
//

typedef enum BubbleTranisionMode{
    Present,
    Dismiss
}BubbleTranisionMode;


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KYBubbleTransition : NSObject<UIViewControllerAnimatedTransitioning>

/**
 *  The duration of transition
 */
@property(nonatomic,assign)CGFloat duration;

/**
 *  The startPoint of transition
 */
@property(nonatomic,assign)CGPoint startPoint;

/**
 *  Mode:Present/Dismiss
 */
@property(nonatomic,assign)BubbleTranisionMode transitionMode;

/**
 *  The color of the bubble
 */
@property(nonatomic,strong)UIColor *bubbleColor;


@end
