//
//  PhotoZoomScrollView.h
//  KYElegantPhotoGallery-Demo
//
//  Created by Kitten Yang on 6/5/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KYPhotoGallery.h"
#import "PhotoGalleryImageView.h"

@interface PhotoZoomScrollView : UIScrollView


@property (nonatomic,strong)PhotoGalleryImageView *currentPhoto;


-(id)initWithPhotoGallery:(KYPhotoGallery *)photoGallery;
- (void)layout;

@end
