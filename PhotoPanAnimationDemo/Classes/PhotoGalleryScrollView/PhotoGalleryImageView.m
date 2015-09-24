//
//  PhotoGalleryImageView.m
//  KYElegantPhotoGallery-Demo
//
//  Created by Kitten Yang on 5/31/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import "PhotoGalleryImageView.h"

@interface PhotoGalleryImageView()

- (void)handleSingleTap:(UITouch *)touch;
- (void)handleDoubleTap:(UITouch *)touch;

@end

@implementation PhotoGalleryImageView

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (id)initWithImage:(UIImage *)image {
    if ((self = [super initWithImage:image])) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (id)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage {
    if ((self = [super initWithImage:image highlightedImage:highlightedImage])) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

#pragma mark -- UIResponder method
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    NSUInteger tapCount = touch.tapCount;


    switch (tapCount) {
        case 1:
            [self handleSingleTap:touch];
            break;
        case 2:
            [self handleDoubleTap:touch];
            break;
        default:
            break;
    }

}




#pragma mark -- Private method
- (void)handleSingleTap:(UITouch *)touch {
    if ([self.tapDelegate respondsToSelector:@selector(imageView:singleTapDetected:)])
        [self.tapDelegate imageView:self singleTapDetected:touch];
    
}

- (void)handleDoubleTap:(UITouch *)touch {
    if ([self.tapDelegate respondsToSelector:@selector(imageView:doubleTapDetected:)])
        [self.tapDelegate imageView:self doubleTapDetected:touch];
    
}




@end
