//
//  BGLogation.m
//  locationdemo
//
//  Created by yebaojia on 16/2/24.
//  Copyright © 2016年 mjia. All rights reserved.
//

#import "BGLogation.h"
#import "BGTask.h"

#import "LocationModel.h"

@interface BGLogation()
{
    BOOL _isCollect; //是否正在采集地理位置
    BOOL _isEnd;     //是否不在定位
}
@property (strong , nonatomic) BGTask *bgTask; //后台任务

/** 用来解析位置字符串 */
@property (nonatomic , strong) CLGeocoder *geocoder;
/** 用来过滤定位十秒钟数据,取最优值 */
@property (nonatomic , strong) NSMutableArray *locations;
/** 用来记录开始定位的时间,如果当前重新定位的时间超过开始时间日期的23:59:59则停止定位 */
@property (nonatomic , strong) NSDate *startDate;

@end
@implementation BGLogation
//初始化
-(instancetype)init
{
    if(self == [super init])
    {
        //
        _bgTask = [BGTask shareBGTask];
        _isCollect = NO;
        _isEnd = YES; //默认为结束状态
        _locations = [NSMutableArray array];
        //监听进入后台通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}
+(CLLocationManager *)shareBGLocation
{
    static CLLocationManager *_locationManager;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
            _locationManager = [[CLLocationManager alloc] init];
            _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
            _locationManager.allowsBackgroundLocationUpdates = YES;
            _locationManager.pausesLocationUpdatesAutomatically = NO;
    });
    return _locationManager;
}
//后台监听方法
-(void)applicationEnterBackground
{
    if (_isEnd) {
        CLLocationManager *locationManager = [BGLogation shareBGLocation];
        locationManager.delegate = nil;
        [self stopLocation];
        return;
    }
    
    NSLog(@"come in background");
//    CLLocationManager *locationManager = [BGLogation shareBGLocation];
//    locationManager.delegate = self;
//    locationManager.distanceFilter = kCLDistanceFilterNone; // 不移动也可以后台刷新回调
//    if ([[UIDevice currentDevice].systemVersion floatValue]>= 8.0) {
//        [locationManager requestAlwaysAuthorization];
//    }
//    [locationManager startUpdatingLocation];
    [_bgTask beginNewBackgroundTask];
}
//重启定位服务
-(void)restartLocation
{
    //判断当前时间是否超过开始时间日期的23:59:59  如果超过的话就停止定位
    NSString *todayStr = [DateTools stringFromDate:_startDate withFormat:yyyyMMdd];
    todayStr = [todayStr stringByAppendingString:@" 23:59:59"];
    NSDate *endDate = [DateTools dateFromString:todayStr withFormat:yyyyMMddHHmmss];
    
    if ([endDate timeIntervalSinceNow] <= 0) {
        _isEnd = YES;
    }
    
    if (_isEnd) {
        NSLog(@"终止定位");
        CLLocationManager *locationManager = [BGLogation shareBGLocation];
        locationManager.delegate = nil;
        [self stopLocation];
    }else{
        NSLog(@"重新启动定位");
        CLLocationManager *locationManager = [BGLogation shareBGLocation];
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLDistanceFilterNone; // 不移动也可以后台刷新回调
        if ([[UIDevice currentDevice].systemVersion floatValue]>= 8.0) {
            [locationManager requestAlwaysAuthorization];
        }
        [locationManager startUpdatingLocation];
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
             [self.bgTask beginNewBackgroundTask];
        }
    }
}
//开启服务
- (void)startLocation {
    //重置开始时间;  //即便是正在定位中也重置时间
    _startDate = [NSDate date];
    
    if (_isEnd == NO) {
        NSLog(@"定位已经开启,无需再次开启");
        return;
    }
     NSLog(@"开启定位");
    _isEnd = NO;
    if ([CLLocationManager locationServicesEnabled] == NO) {//定位服务禁用
        NSLog(@"locationServicesEnabled false");

    } else {
        CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
        
        if(authorizationStatus == kCLAuthorizationStatusDenied || authorizationStatus == kCLAuthorizationStatusRestricted){
            NSLog(@"授权状态:失败");
        } else {
            NSLog(@"授权状态:授权"); 
            CLLocationManager *locationManager = [BGLogation shareBGLocation];
            locationManager.delegate = self;
            locationManager.distanceFilter = kCLDistanceFilterNone; //即使不移动也能定位
            
            if([[UIDevice currentDevice].systemVersion floatValue]>= 8.0) {
                [locationManager requestAlwaysAuthorization];
            }
            [locationManager startUpdatingLocation];
        }
    }
}

//停止后台定位
-(void)stopLocation
{
    NSLog(@"停止定位");
    _isCollect = NO;
    CLLocationManager *locationManager = [BGLogation shareBGLocation];
    [locationManager stopUpdatingLocation];
    
    if (_locations.count) {
        [self manageLocations];
    }
    
}

//不在定位 即不在执行后台任务
-(void)noLocationAgain
{
    _isEnd = YES;
}

#pragma mark --delegate
//定位回调里执行重启定位和关闭定位
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = locations.lastObject;
    
    if (location.horizontalAccuracy > 0) {
        [_locations addObject:location];
    }
    //如果正在10秒定时收集的时间，不需要执行延时开启和关闭定位
    if (_isCollect) {
        return;
    }
    [self performSelector:@selector(restartLocation) withObject:nil afterDelay:121];
    [self performSelector:@selector(stopLocation) withObject:nil afterDelay:10];
    
    _isCollect = YES;//标记正在定位
}
- (void)locationManager: (CLLocationManager *)manager didFailWithError: (NSError *)error
{
    // NSLog(@"locationManager error:%@",error);
    
    switch([error code])
    {
        case kCLErrorNetwork: // general, network-related error
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络错误" message:@"请检查网络连接" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        case kCLErrorDenied:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请开启后台服务" message:@"应用没有不可以定位，需要在在设置/通用/后台应用刷新开启" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        default:
        {
            
        }
            break;
    }
}

#pragma mark - 写入文件
-(CLGeocoder *)geocoder{
    if (!_geocoder) {
        _geocoder=[[CLGeocoder alloc]init];
    }
    return _geocoder;
}
//管理定位到的数据>>>找出精度最高的一个,获取其locationStr,然后保存,其余的全部删除
-(void)manageLocations
{
    CLLocation *location = _locations.firstObject;
    
    for (CLLocation *location1 in _locations) {
        if (location1.horizontalAccuracy <= location.horizontalAccuracy) {
            location = location1;
        }
    }
    
    [_locations removeAllObjects];
    
    [self makeLocationStringWith:location];
    
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
                //省-市-区-name
                locationStr = [NSString stringWithFormat:@"%@%@%@%@",placemark.addressDictionary[@"State"],placemark.addressDictionary[@"City"],placemark.addressDictionary[@"SubLocality"],placemark.name];
            }
            NSLog(@"%@",locationStr);
            [selfWeak makeLocationModelWith:location andLocationStr:locationStr];
            
        }else{
            [selfWeak makeLocationModelWith:location andLocationStr:@""];
        }
        
    }];
}
//生成model并且存到数据库
-(void)makeLocationModelWith:(CLLocation *)location andLocationStr:(NSString *)locationStr
{
    LocationModel *model = [[LocationModel alloc] init];
    model.locationStr = locationStr;
    model.time = [DateTools stringWithDetailFormatterFromDate:[NSDate date]];
    model.locationX = [@(location.coordinate.latitude) stringValue];
    model.locationY = [@(location.coordinate.longitude) stringValue];
    model.speed = [@(location.speed) stringValue];
    model.range = [@(location.horizontalAccuracy) stringValue];
    model.isBackGround = [@([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) stringValue];
    model.isSend = [@(NO) stringValue];
    
    
    //写入数据库
    [[DBManager shareDB] insertLocationWithLocationModel:model];
}


-(void)dealloc{
    MyLog(@" Game Over ... ");
}

@end
