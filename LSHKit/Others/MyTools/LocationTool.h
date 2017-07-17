//
//  LocationTool.h
//  Apartment
//
//  Created by 西安旺豆电子信息有限公司 on 16/12/16.
//  Copyright © 2016年 西安旺豆电子信息有限公司. All rights reserved.
//

//@property (nonatomic , strong) LocationTool *locationTool;
//-(void)setupLocation
//{
//    LocationTool *tool = [[LocationTool alloc] init];
//    _locationTool = tool;
//    tool.vc = self;
//    tool.didUpdateLocation = ^(CLLocation * location){
//        NSLog(@"%f---%f",location.coordinate.latitude,location.coordinate.longitude);
//    };
//    WeakObj(self);
//    tool.didUpdateAddr = ^(NSString *addr,CLLocation *location){
//        NSLog(@"%@",addr);
//        NSLog(@"%f---%f",location.coordinate.latitude,location.coordinate.longitude);
//    };
//}

//懒加载
//@property (nonatomic , strong) LocationTool *locationTool;
//-(LocationTool *)locationTool
//{
//    if (_locationTool == nil) {
//        LocationTool *tool = [[LocationTool alloc] init];
//        _locationTool = tool;
//        tool.vc = self;
//        WeakObj(self);
//        tool.didUpdateAddr = ^(NSString *addr,CLLocation *location){
//            NSLog(@"%@",addr);
//            NSLog(@"%f---%f",location.coordinate.latitude,location.coordinate.longitude);
//            selfWeak.locationLabel.text = addr;
//        };
//        tool.didEndUpdate = ^{
//            [selfWeak stopUpdateUI];
//        };
//    }
//    return _locationTool;
//}





#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationTool : NSObject

/** 定位管理器 */
@property (nonatomic , strong) CLLocationManager *manager;


/** 用来弹出失败提示的vc,一般是当前最上层vc */
@property (nonatomic , weak) UIViewController *vc;



/** 获取到最新经纬度block */
@property (nonatomic , strong) void (^didUpdateLocation)(CLLocation *);
/** 获取到最新地理位置block */
@property (nonatomic , strong) void (^didUpdateAddr)(NSString *,CLLocation *,CLPlacemark *);

/** 定位结束(当定位失败/定位到地址名称时) */
@property (nonatomic , strong) void (^didEndUpdate)();



-(void)start;






@end
