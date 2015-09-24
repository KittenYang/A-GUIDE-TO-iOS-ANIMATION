//
//  DazFireController.h
//  Dazzle
//
//  Created by Leonhard Lichtschlag on 9/Feb/12.
//  Copyright (c) 2012 Leonhard Lichtschlag. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CAEmitterLayer;

// ===============================================================================================================
@interface DazFireController : UIViewController
// ===============================================================================================================

@property (strong) CAEmitterLayer *fireEmitter;
@property (strong) CAEmitterLayer *smokeEmitter;

- (void) controlFireHeight:(id)sender;
- (void) setFireAmount:(float)zeroToOne;


@end
