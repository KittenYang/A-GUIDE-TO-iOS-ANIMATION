//
//  PhotoZoomScrollView.m
//  KYElegantPhotoGallery-Demo
//
//  Created by Kitten Yang on 6/5/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import "PhotoZoomScrollView.h"



@interface PhotoZoomScrollView() <DetectingImageViewDelegate,UIScrollViewDelegate>

@property (nonatomic,strong)KYPhotoGallery *photoGallery;

#pragma mark -- Private method
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;

@end

@implementation PhotoZoomScrollView

-(id)initWithPhotoGallery:(KYPhotoGallery *)photoGallery{
    self = [super init];
    if (self) {
        _photoGallery = photoGallery;
        self.delegate = self;
        self.maximumZoomScale = 4.0f;
    
    }
    
    return self;
}


#pragma private method
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    CGRect zoomRect;
    
    zoomRect.size.height = [self frame].size.height / scale;
    zoomRect.size.width  = [self frame].size.width  / scale;
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}


#pragma mark -- Public method
- (void)layout {
    
    // Center the image as it becomes smaller than the size of the screen
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = self.currentPhoto.frame;
    
    // Horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) / 2.0);
    } else {
        frameToCenter.origin.x = 0;
    }
    
    // Vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) / 2.0);
    } else {
        frameToCenter.origin.y = 0;
    }
    
    // Center
    if (!CGRectEqualToRect(self.currentPhoto.frame, frameToCenter))
        self.currentPhoto.frame = frameToCenter;
}



#pragma DetectingImageViewDelegate
- (void)imageView:(UIImageView *)imageView singleTapDetected:(UITouch *)touch{
    [self.photoGallery performSelector:@selector(dismissPhotoGalleryAnimated:) withObject:@(YES) afterDelay:0.2];
    NSLog(@"singleTap");
}

- (void)imageView:(UIImageView *)imageView doubleTapDetected:(UITouch *)touch{
    [NSObject cancelPreviousPerformRequestsWithTarget:self.photoGallery];
    
    NSLog(@"doubleTap");
    
    // Zoom
    if (self.zoomScale == self.maximumZoomScale) {
        
        // Zoom out
        [self setZoomScale:self.minimumZoomScale animated:YES];
        
    } else {
        CGPoint touchPoint = [touch locationInView:imageView];
        touchPoint = [self convertPoint:touchPoint fromView:imageView];
        
        // Zoom in
        CGRect zoomRect = [self zoomRectForScale:self.maximumZoomScale withCenter:touchPoint];
        [self zoomToRect:zoomRect animated:YES];
    
    }
    
}


#pragma UISrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.currentPhoto;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self layout];
}



@end
