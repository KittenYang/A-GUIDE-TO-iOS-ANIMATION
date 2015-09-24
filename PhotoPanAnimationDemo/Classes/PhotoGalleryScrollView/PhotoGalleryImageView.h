//
//  PhotoGalleryImageView.h
//  KYElegantPhotoGallery-Demo
//
//  Created by Kitten Yang on 5/31/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DetectingImageViewDelegate <NSObject>
@optional
- (void)imageView:(UIImageView *)imageView singleTapDetected:(UITouch *)touch;
- (void)imageView:(UIImageView *)imageView doubleTapDetected:(UITouch *)touch;
@end

@interface PhotoGalleryImageView : UIImageView

@property (nonatomic, assign) id <DetectingImageViewDelegate> tapDelegate;

@end
