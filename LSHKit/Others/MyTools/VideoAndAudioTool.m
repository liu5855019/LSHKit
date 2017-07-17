//
//  VedioAndAudioTool.m
//  Apartment
//
//  Created by 西安旺豆电子信息有限公司 on 16/12/26.
//  Copyright © 2016年 西安旺豆电子信息有限公司. All rights reserved.
//

#import "VideoAndAudioTool.h"
#import <CoreVideo/CoreVideo.h>

@interface VideoAndAudioTool () <AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate>

@property (nonatomic ,strong) AVCaptureDeviceInput *currentVideoDeviceInput;

@property (nonatomic ,strong) AVCaptureDeviceInput *audioDeviceInput;

@property (nonatomic ,strong) AVCaptureConnection *audioConnection;

@end

@implementation VideoAndAudioTool


-(instancetype)init
{
    if (self = [super init]) {
        [self setupCaputureVideo];
    }
    return self;
}

-(void) setupCaputureVideo
{
    // 1.创建捕获会话,必须要强引用，否则会被释放
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    _session = session;
    
    // 2.获取摄像头设备，默认是后置摄像头
    AVCaptureDevice *videoDevice = [self getVideoDevice:AVCaptureDevicePositionBack];
    
    // 3.获取声音设备
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    
    // 4.创建对应视频设备输入对象
    AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];
    _currentVideoDeviceInput = videoDeviceInput;
    
    // 5.创建对应音频设备输入对象
    AVCaptureDeviceInput *audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:nil];
    _audioDeviceInput = audioDeviceInput;
    
    // 6.添加到会话中
    // 注意“最好要判断是否能添加输入，会话不能添加空的
    // 6.1 添加视频
    if ([session canAddInput:videoDeviceInput]) {
        [session addInput:videoDeviceInput];
    }
    // 6.2 添加音频
    if ([session canAddInput:audioDeviceInput]) {
        [session addInput:audioDeviceInput];
    }
    
    // 7.获取视频数据输出设备
    AVCaptureVideoDataOutput *videoOutPut = [[AVCaptureVideoDataOutput alloc] init];

    // 7.1 设置代理，捕获视频样品数据
    // 注意：队列必须是串行队列，才能获取到数据，而且不能为空
    dispatch_queue_t videoQueue = dispatch_queue_create("Video Capture Queue", DISPATCH_QUEUE_SERIAL);
    [videoOutPut setSampleBufferDelegate:self queue:videoQueue];
    
    if ([session canAddOutput:videoOutPut]) {
        [session addOutput:videoOutPut];
    }
    
    
    // 8.获取音频数据输出设备
    AVCaptureAudioDataOutput *audioOutput = [[AVCaptureAudioDataOutput alloc] init];
    // 8.2 设置代理，捕获视频样品数据
    // 注意：队列必须是串行队列，才能获取到数据，而且不能为空
    dispatch_queue_t audioQueue = dispatch_queue_create("Audio Capture Queue", DISPATCH_QUEUE_SERIAL);
    [audioOutput setSampleBufferDelegate:self queue:audioQueue];
    if ([session canAddOutput:audioOutput]) {
        [session addOutput:audioOutput];
    }
    
    
    // 9.获取音频输入与输出连接，用于分辨音视频数据
    _audioConnection = [audioOutput connectionWithMediaType:AVMediaTypeAudio];
    
    // 10.添加视频预览图层
    AVCaptureVideoPreviewLayer *previedLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    previedLayer.frame = [UIScreen mainScreen].bounds;
//    [self.view.layer insertSublayer:previedLayer atIndex:0];
    _previedLayer = previedLayer;
    
    // 11.启动会话
//    [captureSession startRunning];
}

// 指定摄像头方向获取摄像头
- (AVCaptureDevice *)getVideoDevice:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}

//切换摄像头
-(void) changeVideoDevice
{
    // 获取当前设备方向
    AVCaptureDevicePosition curPosition = _currentVideoDeviceInput.device.position;
    
    // 获取需要改变的方向
    AVCaptureDevicePosition togglePosition = curPosition == AVCaptureDevicePositionFront?AVCaptureDevicePositionBack:AVCaptureDevicePositionFront;
    
    // 获取改变的摄像头设备
    AVCaptureDevice *toggleDevice = [self getVideoDevice:togglePosition];
    
    // 获取改变的摄像头输入设备
    AVCaptureDeviceInput *toggleDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:toggleDevice error:nil];
    
    // 移除之前摄像头输入设备
    [_session removeInput:_currentVideoDeviceInput];
    
    // 添加新的摄像头输入设备
    [_session addInput:toggleDeviceInput];
    
    // 记录当前摄像头输入设备
    _currentVideoDeviceInput = toggleDeviceInput;
}

//采集到的数据(通过代理得到数据)
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    if (_audioConnection == connection) {
        NSLog(@"采集到音频数据");
    } else {
        NSLog(@"采集到视频数据");
    }
    NSLog(@"%@",connection);
}




-(void)start
{
    [_session startRunning];
}

-(void)stop
{
    [_session stopRunning];
}



#pragma mark - 转码
//通过下面的方法将CMSampleBufferRef转为yuv420(NV12)。
-(NSData *) convertVideoSmapleBufferToYuvData:(CMSampleBufferRef) videoSample{
    // 获取yuv数据
    // 通过CMSampleBufferGetImageBuffer方法，获得CVImageBufferRef。
    // 这里面就包含了yuv420(NV12)数据的指针
    CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(videoSample);
    
    //表示开始操作数据
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    
    //图像宽度（像素）
    size_t pixelWidth = CVPixelBufferGetWidth(pixelBuffer);
    //图像高度（像素）
    size_t pixelHeight = CVPixelBufferGetHeight(pixelBuffer);
    //yuv中的y所占字节数
    size_t y_size = pixelWidth * pixelHeight;
    //yuv中的uv所占的字节数
    size_t uv_size = y_size / 2;
    
    uint8_t *yuv_frame = malloc(uv_size + y_size);  //aw_alloc(uv_size + y_size);
    
    //获取CVImageBufferRef中的y数据
    uint8_t *y_frame = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);
    memcpy(yuv_frame, y_frame, y_size);
    
    //获取CMVImageBufferRef中的uv数据
    uint8_t *uv_frame = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 1);
    memcpy(yuv_frame + y_size, uv_frame, uv_size);
    
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    
    //返回数据
    return [NSData dataWithBytesNoCopy:yuv_frame length:y_size + uv_size];
}

//从CMSampleBufferRef中提取PCM数据
-(NSData *) convertAudioSmapleBufferToPcmData:(CMSampleBufferRef) audioSample{
    //获取pcm数据大小
    NSInteger audioDataSize = CMSampleBufferGetTotalSampleSize(audioSample);
    
    //分配空间
    int8_t *audio_data = malloc((int32_t)audioDataSize); //aw_alloc((int32_t)audioDataSize);
    
    //获取CMBlockBufferRef
    //这个结构里面就保存了 PCM数据
    CMBlockBufferRef dataBuffer = CMSampleBufferGetDataBuffer(audioSample);
    //直接将数据copy至我们自己分配的内存中
    CMBlockBufferCopyDataBytes(dataBuffer, 0, audioDataSize, audio_data);
    
    //返回数据
    return [NSData dataWithBytesNoCopy:audio_data length:audioDataSize];
}




@end
