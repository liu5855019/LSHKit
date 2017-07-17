//
//  LocationModel.h
//  YiTie
//
//  Created by 西安旺豆电子信息有限公司 on 17/1/19.
//  Copyright © 2017年 西安旺豆电子信息有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationModel : NSObject

@property (nonatomic , copy) NSString *time;
@property (nonatomic , copy) NSString *locationStr;
@property (nonatomic , copy) NSString *locationX;
@property (nonatomic , copy) NSString *locationY;
@property (nonatomic , copy) NSString *speed;
@property (nonatomic , copy) NSString *range;
@property (nonatomic , copy) NSString *isBackGround;
@property (nonatomic , copy) NSString *isSend;


+ (instancetype)modelWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
