//
//  LocationModel.m
//  YiTie
//
//  Created by 西安旺豆电子信息有限公司 on 17/1/19.
//  Copyright © 2017年 西安旺豆电子信息有限公司. All rights reserved.
//

#import "LocationModel.h"

@implementation LocationModel

-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        
        [self setValuesForKeysWithDictionary:dict];
        
    }
    return self;
}

+(instancetype)modelWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}


@end
