//
//  LocationTool.m
//  Apartment
//
//  Created by 西安旺豆电子信息有限公司 on 16/12/16.
//  Copyright © 2016年 西安旺豆电子信息有限公司. All rights reserved.
//

#import "LocationTool.h"

#ifndef kLocStr
#define kLocStr(str) NSLocalizedString(str, @"")
#endif


@interface LocationTool () <CLLocationManagerDelegate>

@property (nonatomic , strong) CLGeocoder *geocoder;

@end


@implementation LocationTool

-(CLGeocoder *)geocoder{
    if (!_geocoder) {
        _geocoder=[[CLGeocoder alloc]init];
    }
    return _geocoder;
}

-(CLLocationManager *)manager
{
    if (!_manager) {
        _manager = [[CLLocationManager alloc] init];
        _manager.delegate = self;
        //设置定位的精度
        _manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        //控制定位服务更新频率。单位是“米”
        _manager.distanceFilter = 100;
        
        if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=8.0)
        {
            //[_manager requestWhenInUseAuthorization];   //前台定位
            
            [_manager requestAlwaysAuthorization];// 前后台同时定位
        }
    }
    return _manager;
}

-(void)start
{
    [self.manager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([ CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) { //定位服务没有打开
        NSLog(@"定位服务没有打开");
        
        if (_vc) {
            [self showAlertWithTitle:kLocStr(@"提示") andContent:kLocStr(@"定位服务没有打开,是否前往打开?") andSureBlock:^{
                
                if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=8.0) {
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url];
                    }
                } else {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
                }
                
            } andCancelBlock:nil andSureTitle:kLocStr(@"是") andCancelTitle:kLocStr(@"否") atController:_vc];
        }
        
    }else{
        if(error){
            if (_vc) {
                [self showAlertWithTitle:kLocStr(@"提示") andContent:kLocStr(@"定位失败") andBlock:nil atController:_vc];
            }
            
            //self.manager = nil;
        }
    }
     [manager stopUpdatingLocation];
    if (_didEndUpdate) {
        _didEndUpdate();
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    //获取最新的位置
    CLLocation * currentLocation = [locations lastObject];
    
    if (_didUpdateLocation) {
        _didUpdateLocation(currentLocation);
    }
    
    [self.geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
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
            //停止定位
            if (locationStr.length) {
                NSLog(@"停止更新");
                if (_didUpdateAddr) {
                    _didUpdateAddr(locationStr,currentLocation,placemark);
                }
                [self.manager stopUpdatingLocation];
                self.manager = nil;
                if (_didEndUpdate) {
                    _didEndUpdate();
                }
            }
        }
    }];
}


-(void)showAlertWithTitle:(NSString *)title andContent:(NSString *)content andBlock:(void (^)())todo atController:(__weak UIViewController *)vc{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:kLocStr(@"OK") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (todo) {
            todo();
        }
    }];
    
    [controller addAction:action];
    
    [vc presentViewController:controller animated:YES completion:nil];
}

-(void)showAlertWithTitle:(NSString *)title andContent:(NSString *)content andSureBlock:(void (^)())sureTodo andCancelBlock:(void (^)())cancelTodo andSureTitle:(NSString *)sureTitle andCancelTitle:(NSString *)cancelTitle atController:(__weak UIViewController *)vc{
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    sureTitle = sureTitle.length ? sureTitle : @"确定";
    cancelTitle = cancelTitle.length ? cancelTitle : @"取消";
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:sureTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (sureTodo) {
            sureTodo();
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (cancelTodo) {
            cancelTodo();
        }
    }];
    
    [controller addAction:sureAction];
    [controller addAction:cancelAction];
    
    [vc presentViewController:controller animated:YES completion:nil];
}



@end
