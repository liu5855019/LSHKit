//
//  HX_AlbumModel.h
//  测试
//
//  Created by 洪欣 on 16/8/20.
//  Copyright © 2016年 洪欣. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
@interface HX_AlbumModel : NSObject
/**  封面图  */
@property (strong, nonatomic) UIImage *coverImage;

/**  缩略图  */
@property (strong, nonatomic) UIImage *thumbnail;

/**  相册名称  */
@property (copy, nonatomic) NSString *albumName;
/**  相册内容数量  */
@property (assign, nonatomic) NSUInteger photosNum;

/**  图片数量  */
@property (assign, nonatomic) NSInteger imageNum;

/**  视频数量  */
@property (assign, nonatomic) NSInteger videoNum;

@property (strong, nonatomic) ALAssetsGroup *group;

@property (strong, nonatomic) PHAsset *PH_Asset;
@property (strong, nonatomic) PHAssetCollection *PH_AssetCollection;
@end
