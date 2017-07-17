//
//  UITools.m
//  product1
//
//  Created by 西安旺豆电子信息有限公司 on 16/8/30.
//  Copyright © 2016年 西安旺豆电子信息有限公司. All rights reserved.
//

#import "UITools.h"
#import "MyTools.h"
#import <AVFoundation/AVFoundation.h>

@implementation UITools


/** 根据类名加载xib ---> View */
+ (__kindof UIView *) getViewWithClassName:(NSString *)className
{
    return [[NSBundle mainBundle] loadNibNamed:className owner:nil options:nil][0];
}

+ (UIImage *)roundImage:(UIImage *)aImage
{
    if ([MyTools checkIsNullObject:aImage]) {
        return nil;
    }
    
    /* 取最小边，否则会出现椭圆 */
    CGFloat itemWidth = MIN(aImage.size.width, aImage.size.height);
    
    //取中心
    CGFloat originX = (aImage.size.width - itemWidth)/2;
    CGFloat originY = (aImage.size.height - itemWidth)/2;
    CGRect imageRect = (CGRect){originX,originY,itemWidth,itemWidth};
    aImage = [UITools partImage:aImage withRect:imageRect];
    imageRect.origin = CGPointZero;//恢复
    
    UIGraphicsBeginImageContextWithOptions((CGSize){itemWidth,itemWidth}, 1.0, 0.0f);
    
    CGColorSpaceRef maskColorSpaceRef = CGColorSpaceCreateDeviceGray();
    CGContextRef mainMaskContextRef = CGBitmapContextCreate(NULL,
                                                            imageRect.size.width,
                                                            imageRect.size.height,
                                                            8,
                                                            imageRect.size.width,
                                                            maskColorSpaceRef,
                                                            0);
    CGContextFillRect(mainMaskContextRef, imageRect);
    CGContextSetFillColorWithColor(mainMaskContextRef,[UIColor whiteColor].CGColor);
    
    // Create main mask shape
    CGContextMoveToPoint(mainMaskContextRef, 0, 0);
    CGContextAddEllipseInRect(mainMaskContextRef, imageRect);
    CGContextFillPath(mainMaskContextRef);
    
    CGImageRef mainMaskImageRef = CGBitmapContextCreateImage(mainMaskContextRef);
    CGContextRelease(mainMaskContextRef);
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSaveGState(contextRef);
    
    CGImageRef imageRef = CGImageCreateWithMask(aImage.CGImage, mainMaskImageRef);
    
    CGContextTranslateCTM(contextRef, 0, imageRect.size.height);
    CGContextScaleCTM(contextRef, 1.0, -1.0);
    
    CGContextSaveGState(contextRef);
    
    
    UIImage* image = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    CGImageRelease(mainMaskImageRef);
    
    UIGraphicsEndImageContext();
    
    return image;
}
+ (UIImage *)partImage:(UIImage *)aImage withRect:(CGRect)partRect
{

    if ([MyTools checkIsNullObject:aImage]) {
        return nil;
    }
    
    CGImageRef imager = CGImageCreateWithImageInRect(aImage.CGImage,partRect);
    
    UIImage *partImage = [UIImage imageWithCGImage:imager];
    
    CGImageRelease(imager);
    
    return partImage;
    
}
+ (UIImage *)imageWithString:(NSString *)string
{
    NSData *stringData=[string dataUsingEncoding:NSUTF8StringEncoding];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    //  coreImage的一个类过滤器，通过kvc过滤参数.//创建一个CIFilter类对象 指定名字为CIQRCodeGenerator
    
    //接下来设置两个类 key确定
    
    [filter setValue:stringData forKey:@"inputMessage"];//二维码图片所需要展示的NSdata
    
    [filter setValue:@"M" forKey:@"inputCorrectionLevel"];//二维码等级（跟二维码大小有关）
    
    //纠错等级M是0.15纠错等级    L：0.07 Q：0.25 H0.30
    
    //设置好属性之后得到一个过滤器的输出图像，是一个1pt的最小分辨率的CIImage对象，也就是二维码图片，转换成UIiimage
    
    UIImage *image =[self creatNonInterpolatedUIimageFormCIImage:filter.outputImage withSize:300];
    
    return image;
    

}
+(UIImage *)creatNonInterpolatedUIimageFormCIImage:(CIImage *)image withSize:(CGFloat)size{
    
    CGRect exent = CGRectIntegral(image.extent);
    
    CGImageRef cgimage = [[CIContext contextWithOptions:nil]createCGImage:image fromRect:exent];
    
    CGFloat scale = MIN(size/CGRectGetWidth(exent), size/CGRectGetHeight(exent));
    
    size_t width = CGRectGetWidth(exent)*scale;
    
    size_t heigh = CGRectGetHeight(exent)*scale;
    
    UIGraphicsBeginImageContext(CGSizeMake(width, heigh));
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgimage);
    
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    CGImageRelease(cgimage);
    
    return scaledImage;
    
}

/**
 *  根据两个图片,合成一个大图片
 *
 *  @param bigImage   大图的背景图片
 *  @param smallImage 小图标(居中)
 *  @param sizeWH     小图标的尺寸
 *
 *  @return 合成后的图片
 */
+ (UIImage *)createImageBigImage:(UIImage *)bigImage smallImage:(UIImage *)smallImage sizeWH:(CGFloat)sizeWH
{
    CGSize size = bigImage.size;
    
    // 1.开启一个图形上下文
    UIGraphicsBeginImageContext(size);
    
    // 2.绘制大图片
    [bigImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 3.绘制小图片
    CGFloat x = (size.width - sizeWH) * 0.5;
    CGFloat y = (size.height - sizeWH) * 0.5;
    [smallImage drawInRect:CGRectMake(x, y, sizeWH, sizeWH)];
    
    // 4.取出合成图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 5.关闭图形上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}


/**
 *  识别一个图片中所有的二维码, 获取二维码内容
 *
 *  @param sourceImage       需要识别的图片
 *  @param isDrawWRCodeFrame 是否绘制识别到的边框
 *  @param completeBlock     (识别出来的结果数组, 识别出来的绘制二维码图片)
 */
+ (void)detectorQRCodeImageWithSourceImage:(UIImage *)sourceImage isDrawWRCodeFrame:(BOOL)isDrawWRCodeFrame completeBlock:(void(^)(NSArray *resultArray, UIImage *resultImage))completeBlock
{
    // 0.创建上下文
    CIContext *context = [[CIContext alloc] init];
    // 1.创建一个探测器
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{CIDetectorAccuracy: CIDetectorAccuracyLow}];
    
    // 2.直接开始识别图片,获取图片特征
    CIImage *imageCI = [[CIImage alloc] initWithImage:sourceImage];
    NSArray<CIFeature *> *features = [detector featuresInImage:imageCI];
    
    // 3.读取特征
    UIImage *tempImage = sourceImage;
    NSMutableArray *resultArray = [NSMutableArray array];
    for (CIFeature *feature in features) {
        
        CIQRCodeFeature *tempFeature = (CIQRCodeFeature *)feature;
        
        [resultArray addObject:tempFeature.messageString];
        
        if (isDrawWRCodeFrame) {
            tempImage = [UITools drawQRCodeFrameFeature:tempFeature toImage:tempImage];
        }
    }
    
    // 4.使用block传递数据给外界
    completeBlock(resultArray, tempImage);
}

/**
 *  根据一个特征, 对给定图片, 进行绘制边框
 *
 *  @param feature 特征对象
 *  @param toImage 需要绘制的图片
 *
 *  @return 绘制好边框的图片
 */
+ (UIImage *)drawQRCodeFrameFeature:(CIQRCodeFeature *)feature toImage:(UIImage *)toImage
{
    // bounds,相对于原图片的一个大小
    // 坐标系是以左下角为(0, 0)
    CGRect bounds = feature.bounds;
    
    CGSize size = toImage.size;
    // 1.开启图形上下文
    UIGraphicsBeginImageContext(size);
    
    // 2.绘制图片
    [toImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 3.反转上下文坐标系
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -size.height);
    
    // 4.绘制边框
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:bounds];
    path.lineWidth = 12;
    [[UIColor redColor] setStroke];
    [path stroke];
    
    // 4.取出图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 5.关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

/** 根据原图获得改变大小后的图片 */
+ (UIImage*) getImageWithOriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片

}

/** 图片加水印    (可以多行显示,按比例加水印) */
+(UIImage *)writeTexts:(NSArray <NSString *> *)texts AtImage:(UIImage *)image
{
    
    if (texts.count < 1) {
        return image;
    }
    
    //缩放基数是960来的
    UIFont *font=[UIFont fontWithName:@"Arial-BoldItalicMT" size:30 * image.size.width / 960];
    //设置水印字体
    NSDictionary* dict=@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor redColor]};
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    int border = 16; //边框宽度
    border = border * image.size.width / 960; //按比例缩放
    
    int textSpace = 16; //行间距
    textSpace = textSpace * image.size.width / 960; //按比例缩放
    
    int textBeginHeight = image.size.height -textSpace; //开始写的左下角总高度
    
    //写入
    for (int i = (int)texts.count-1; i >= 0; i--) {
        NSString *str = texts[i];
        CGSize strSize = [str boundingRectWithSize:CGSizeMake(image.size.width - 2 * border, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
        //NSLog(@"w:%f---h:%f",strSize.width,strSize.height);
        
        CGRect rect = CGRectMake(border, textBeginHeight-strSize.height, strSize.width, strSize.height);
        
        [str drawWithRect:rect options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dict context:nil];
        
        textBeginHeight -= (textSpace + strSize.height);
    }
    
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

/** 修正图片方向 */
+ (UIImage *)fixOrientationWithImage:(UIImage *)oImage
{
    // No-op if the orientation is already correct
    if (oImage.imageOrientation == UIImageOrientationUp) return oImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (oImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, oImage.size.width, oImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, oImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, oImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (oImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, oImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, oImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, oImage.size.width, oImage.size.height,
                                             CGImageGetBitsPerComponent(oImage.CGImage), 0,
                                             CGImageGetColorSpace(oImage.CGImage),
                                             CGImageGetBitmapInfo(oImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (oImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,oImage.size.height,oImage.size.width), oImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,oImage.size.width,oImage.size.height), oImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


/** 修改图片方向为竖向 */
+ (UIImage *)changeOrientationToVerticalWithImage:(UIImage *)oImage
{
    CGContextRef ctx = CGBitmapContextCreate(NULL, oImage.size.width, oImage.size.height,
                                             CGImageGetBitsPerComponent(oImage.CGImage), 0,
                                             CGImageGetColorSpace(oImage.CGImage),
                                             CGImageGetBitmapInfo(oImage.CGImage));
    
    
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

/** 从视频中获得image */
+ (void)getScreenShotImageFromVideoPath:(NSString *)filePath image:(void (^)(UIImage *image))getimage;{
    BACK(^{
    
   
    UIImage *shotImage;
    //视频路径URL
    NSURL *fileURL = [NSURL URLWithString:filePath];
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:fileURL options:nil];
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;
    
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    shotImage = [[UIImage alloc] initWithCGImage:image];
    
    CGImageRelease(image);

    MAIN(^{
        if (getimage) {
            getimage(shotImage);
        }
    });
        
    });
    
}

@end
