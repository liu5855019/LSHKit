//
//  VideoAndAudioTool.h
//  Apartment
//
//  Created by 西安旺豆电子信息有限公司 on 16/12/26.
//  Copyright © 2016年 西安旺豆电子信息有限公司. All rights reserved.
//

/*
 *  1.alloc >> init
 *  2.self.view.layer addlayer : previedLayer
 *  3.设置didGetVideoData / didGetAudioData
 *  4.start
 */



#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface VideoAndAudioTool : NSObject

/** 协调输入与输出之间传输数据 */
@property (nonatomic ,strong) AVCaptureSession *session;
/** 用来输出video的layer */
@property (nonatomic ,strong) AVCaptureVideoPreviewLayer *previedLayer;
/** 得到视频数据 */
@property (nonatomic , strong) void (^didGetVideoData)();
/** 得到音频数据 */
@property (nonatomic , strong) void (^didGetAudioData)();

/** 开始 */
-(void) start;

/** 停止 */
-(void) stop;

/** 切换摄像头 */
-(void) changeVideoDevice;



@end
