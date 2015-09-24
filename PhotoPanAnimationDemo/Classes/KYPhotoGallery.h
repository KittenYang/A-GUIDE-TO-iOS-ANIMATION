//
//  KYPhotoGallery.h
//  KYElegantPhotoGallery-Demo
//
//  Created by Kitten Yang on 5/31/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KYPhotoGallery : UIViewController


+ (KYPhotoGallery *)sharedKYPhotoGallery;

/*
 *
   @parm:  tappedImageView 当前点击的图片视图
   @parm:  imagesUrls   所有图片的URL链接
   @parm:  currentIndex 当前图片的序号，第一张图请传入1，第二张为2，以此类推...
*
*/
-(void)tappedImageView:(UIImageView *)tappedImageView andImageUrls:(NSMutableArray *)imagesUrls andInitialIndex:(NSInteger )currentIndex;


/*
 *
   @property 所有需要显示的UIImageView
 *
 */
@property(nonatomic,strong)NSMutableArray *imageViewArray;


-(void)dismissPhotoGalleryAnimated:(BOOL)animated;
-(void)finishAsynDownload:(void(^)(void))finishAsynDownloadBlock;


@end
