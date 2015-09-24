//
//  PhotoGalleryScrollView.m
//  KYElegantPhotoGallery-Demo
//
//  Created by Kitten Yang on 5/31/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import "PhotoGalleryScrollView.h"
#import "PhotoZoomScrollView.h"
#import "PhotoGalleryImageView.h"
#import "Macro.h"
#import "KYPhotoGallery.h"


@interface PhotoGalleryScrollView()<UIScrollViewDelegate,UITableViewDataSource>

@property (nonatomic,copy)void (^DidScrollBlock)(NSInteger currentIndex);
@property (nonatomic,copy)void (^DidEndDecelerateBlock)(NSInteger currentIndex);
@property (nonatomic,strong)KYPhotoGallery *photoGallery;

@end


@implementation PhotoGalleryScrollView{
    
    NSInteger currentIndex;
    BOOL isFirst;
    
}


-(id)initWithFrame:(CGRect)frame imageViews:(NSMutableArray *)imageViewArray initialPageIndex:(NSInteger)initialPageIndex withPhotoGallery:(KYPhotoGallery *)photoGallery{
    self =  [super initWithFrame:frame];
    if (self) {
        
        currentIndex = initialPageIndex;
        isFirst = YES;
        self.photoGallery = photoGallery;
        self.hidden = YES;
        self.pagingEnabled = YES;
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator   = NO;
        self.backgroundColor = [UIColor clearColor];
        [self setUp:imageViewArray frame:frame];
        [self setContentOffset:CGPointMake((initialPageIndex-1)*frame.size.width, 0)];
        
        
    }
    
    return self;
}

-(void)dealloc{

    _photos = nil;
    
}

#pragma mark -- init helper method
-(void)setUp:(NSMutableArray *)imageViewArray  frame:(CGRect)frame {
    
    self.photos = [NSMutableArray array];
    
    @autoreleasepool {
        for (int i=0; i<imageViewArray.count; i++) {
            
            //用于缩放的子Scroll View
            PhotoZoomScrollView *scroll = [[PhotoZoomScrollView alloc]initWithPhotoGallery:self.photoGallery];
            scroll.center = CGPointMake(self.center.x- PHOTOS_SPACING/2+self.frame.size.width*i, self.center.y);
            scroll.bounds = CGRectMake(0, 0, frame.size.width - PHOTOS_SPACING, frame.size.height);
            [self addSubview:scroll];
            
            
            //放在子Scroll View上的图片视图
            UIImageView *igv = (UIImageView *)imageViewArray[i];
            PhotoGalleryImageView *image = [[PhotoGalleryImageView alloc]initWithImage:igv.image];
            image.tapDelegate =  (id<DetectingImageViewDelegate>)scroll;
            image.contentMode = UIViewContentModeScaleAspectFit;

            image.center = CGPointMake(scroll.bounds.size.width/2,scroll.bounds.size.height/2);
            image.bounds = CGRectMake(0, 0, SCREENWIDTH, igv.image.size.height*SCREENWIDTH/igv.image.size.width);
            
            image.layer.masksToBounds = YES;
            image.layer.cornerRadius  = 8.0f;
            [self.photos addObject:image];
            scroll.currentPhoto = image;
        
            
            [scroll addSubview:image];
            [scroll layout];
        }        
    }

    self.contentSize = CGSizeMake(frame.size.width * imageViewArray.count, frame.size.height);

}



#pragma mark -- Public method
-(NSInteger)currentIndex{
    return currentIndex;
}

-(PhotoGalleryImageView *)currentPhoto{
    PhotoGalleryImageView *currentPhoto = (PhotoGalleryImageView *)[self.photos objectAtIndex:currentIndex-1];
    return currentPhoto;
    
}


-(void)DidScrollBlock:(void(^)(NSInteger currentIndex))didEndScrollBlock{

    self.DidScrollBlock = didEndScrollBlock;
    
}

-(void)DidEndDecelerateBlock:(void(^)(NSInteger currentIndex))didEndDeceleratBlock{
    self.DidEndDecelerateBlock = didEndDeceleratBlock;
}


#pragma UIScrollViewDelegate method
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (isFirst) {
        isFirst = NO;
    }else{
        currentIndex = scrollView.contentOffset.x / scrollView.bounds.size.width + 1;
        currentIndex = MAX(1, currentIndex);
        self.DidScrollBlock(currentIndex-1);
    }
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (isFirst) {
        isFirst = NO;
    }else{
        currentIndex = scrollView.contentOffset.x / scrollView.bounds.size.width + 1;
        currentIndex = MAX(1, currentIndex);
        self.DidEndDecelerateBlock(currentIndex-1);
    
        for (UIScrollView *scrollView in self.subviews) {
            [scrollView setZoomScale:self.minimumZoomScale animated:YES];
        }
    }
}








@end
