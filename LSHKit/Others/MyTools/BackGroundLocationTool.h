//
//  BackGroundLocationTool.h
//  YiTie
//
//  Created by 西安旺豆电子信息有限公司 on 17/1/19.
//  Copyright © 2017年 西安旺豆电子信息有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface BackGroundLocationTool : NSObject

/** 定位管理器 */
@property (nonatomic , strong) CLLocationManager *manager;
/** 地理位置数据列表 */
@property (nonatomic , strong) NSMutableArray *datas;

@property (nonatomic , assign) NSInteger datasCount;

//minSpeed 如果当前运动速度大于此值 则满足需求(1) 以时间为更新依据 如果当前运动速度小于此值 则满足需求(2) 以范围为更新依据
//minFilter 最小的触发范围 用于需求(1)
//minInteval 更新间隔 用于需求(2)

/** 最小速度 */
@property (nonatomic, assign) CGFloat minSpeed;
/** 最小范围 */
@property (nonatomic, assign) CGFloat minFilter;
/** 更新间隔 */
@property (nonatomic, assign) CGFloat minInteval;

@end
