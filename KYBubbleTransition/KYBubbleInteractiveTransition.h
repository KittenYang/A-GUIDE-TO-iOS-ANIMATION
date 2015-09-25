//
//  KYBubbleInteractiveTransition.h
//  guji
//
//  Created by Kitten Yang on 5/16/15.
//  Copyright (c) 2015 Guji Tech Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KYBubbleInteractiveTransition : UIPercentDrivenInteractiveTransition

@property(nonatomic,assign)BOOL interacting;
-(void)addPopGesture:(UIViewController *)viewController;

@end
