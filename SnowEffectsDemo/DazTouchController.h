//
//  DazFireController.h
//  Dazzle
//
//  Created by Leonhard Lichtschlag on 11/Feb/12.
//  Copyright (c) 2012 Leonhard Lichtschlag. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CAEmitterLayer;

// ===============================================================================================================
@interface DazTouchController : UIViewController
// ===============================================================================================================

@property (strong) CAEmitterLayer *ringEmitter;

- (void) touchAtPosition:(CGPoint)position;

@end