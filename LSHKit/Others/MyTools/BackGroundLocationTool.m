//
//  BackGroundLocationTool.m
//  YiTie
//
//  Created by 西安旺豆电子信息有限公司 on 17/1/19.
//  Copyright © 2017年 西安旺豆电子信息有限公司. All rights reserved.
//

#import "BackGroundLocationTool.h"
#import "LocationModel.h"

@interface BackGroundLocationTool ()  <CLLocationManagerDelegate>

@property (nonatomic , strong) CLGeocoder *geocoder;

@end

@implementation BackGroundLocationTool

-(instancetype)init
{
    self = [super init];
    if ( self )
    {
        self.minSpeed = 3;
        self.minFilter = 50;
        self.minInteval = 10;
        
        [self manager];
        [self loadDatas];
    }
    return self;
}


-(CLLocationManager *)manager
{
    if (!_manager) {
        _manager = [[CLLocationManager alloc] init];
        _manager.delegate = self;
        //设置定位的精度
        _manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        //控制定位服务更新频率。单位是“米”
        _manager.distanceFilter = _minFilter;
        
        if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=8.0)
        {
            //[_manager requestWhenInUseAuthorization];   //前台定位
            
            [_manager requestAlwaysAuthorization];// 前后台同时定位
        }
        //这是iOS9中针对后台定位推出的新属性 不设置的话 可是会出现顶部蓝条的哦(类似热点连接)
        if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=9.0)
        {
            _manager.allowsBackgroundLocationUpdates = YES;
        }
        
        [_manager startUpdatingLocation];
        
    }
    return _manager;
}

-(CLGeocoder *)geocoder{
    if (!_geocoder) {
        _geocoder=[[CLGeocoder alloc]init];
    }
    return _geocoder;
}


#pragma mark - delegate


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    
    CLLocation *location = locations.lastObject;

    [self adjustDistanceFilter:location];
    
    [self makeLocationStringWith:location];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([ CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) { //定位服务没有打开
        NSLog(@"定位服务没有打开");
    }else{
        NSLog(@"定位失败");
    }
    [manager stopUpdatingLocation];
}


/** 生成地理位置字符串 */
- (void)makeLocationStringWith:(CLLocation *)location
{
    WeakObj(self);
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error==nil) {
            
            CLPlacemark *placemark = placemarks.firstObject;
            NSString *locationStr = nil;
            NSString *formatStr = [placemark.addressDictionary[@"FormattedAddressLines"] firstObject];
            NSString *nameStr = placemark.name;
            if ([nameStr isEqualToString:formatStr]) {
                locationStr = nameStr;
            }else{
                locationStr = [NSString stringWithFormat:@"%@%@",placemark.addressDictionary[@"City"],placemark.name];
            }
            
            if (locationStr.length) {
                NSLog(@"%@",locationStr);
                LocationModel *model = [[LocationModel alloc] init];
                model.locationStr = locationStr;
                model.time = [DateTools stringWithDetailFormatterFromDate:[NSDate date]];
                model.locationX = [@(location.coordinate.latitude) stringValue];
                model.locationY = [@(location.coordinate.longitude) stringValue];
                model.speed = [@(location.speed) stringValue];
                model.isBackGround = [@([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) stringValue];
                
                
                [selfWeak.datas addObject:model];
                
                selfWeak.datasCount = selfWeak.datas.count;
                
                if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
                    
                    NSString *body = [NSString stringWithFormat:@"%@--(%@m/s)\n%@---%@",model.locationStr,model.speed,model.locationX,model.locationY];
                    [selfWeak sendNotificationWithBody:body andTitle:@"位置信息"];
                }
                [selfWeak writeDatasToFile];
            }
        }
    }];
    
}


/**
 *  规则: 如果速度小于minSpeed m/s 则把触发范围设定为50m
 *  否则将触发范围设定为minSpeed*minInteval
 *  此时若速度变化超过10% 则更新当前的触发范围(这里限制是因为不能不停的设置distanceFilter,
 *  否则uploadLocation会不停被触发)
 */
- (void)adjustDistanceFilter:(CLLocation*)location
{
    NSLog(@"adjust:%f",location.speed);
    
    if ( location.speed < self.minSpeed )
    {
        //fabs:求浮点数的绝对值
        if ( fabs(_manager.distanceFilter-self.minFilter) > 0.1f )
        {
            _manager.distanceFilter = self.minFilter;
        }
    }
    else
    {
        CGFloat lastSpeed = _manager.distanceFilter/self.minInteval;
        
        if ( (fabs(lastSpeed-location.speed)/lastSpeed > 0.1f) || (lastSpeed < 0) )
        {
            CGFloat newSpeed  = (int)(location.speed+0.5f);
            CGFloat newFilter = newSpeed*self.minInteval;
            
            _manager.distanceFilter = newFilter;
        }
    }
}




-(void)sendNotificationWithBody:(NSString *)body andTitle:(NSString *)title
{
    // 1.创建本地通知
    UILocalNotification *localNote = [[UILocalNotification alloc] init];
    
    // 2.设置本地通知的内容
    // 2.1.设置通知发出的时间
    localNote.fireDate = [NSDate dateWithTimeIntervalSinceNow:0.1];
    // 2.2.设置通知的内容
    localNote.alertBody = body;//@"正在呼叫你...";
    // 2.3.设置滑块的文字（锁屏状态下：滑动来“解锁”）
    //localNote.alertAction = @"回复";
    // 2.4.决定alertAction是否生效
    //localNote.hasAction = NO;
    // 2.6.设置alertTitle
    localNote.alertTitle = title;//@"你有一条新通知";
    // 2.7.设置有通知时的音效
    localNote.soundName = @"call.wav";
    // 2.8.设置应用程序图标右上角的数字
    localNote.applicationIconBadgeNumber = -1;
    // 2.9.设置额外信息
    localNote.userInfo = @{@"type" : @"call"};
    
    
    // 3.调用通知
    [[UIApplication sharedApplication] scheduleLocalNotification:localNote];
}


- (void)loadDatas
{
    NSString *filePath = [MyTools filePathInDocuntsWithFile:@"LocationList"];
    if ([MyTools fileExist:filePath]) {
        NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
        NSMutableArray *muarray = [NSMutableArray array];
        for (NSDictionary *dict in array) {
            LocationModel *model = [LocationModel modelWithDictionary:dict];
            [muarray addObject:model];
        }
        _datas = muarray ;
    }else{
        _datas = [@[] mutableCopy];
    }
}

- (void)writeDatasToFile
{
    NSMutableArray *muarray = [NSMutableArray array];
    for (LocationModel *model in _datas) {
        [muarray addObject:[MyTools getDictFromObject:model]];
    }
    [muarray writeToFile:[MyTools filePathInDocuntsWithFile:@"LocationList"] atomically:YES];
}

@end
