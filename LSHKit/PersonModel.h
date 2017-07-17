//
//  PersonModel.h
//  LSHKit
//
//  Created by 西安旺豆电子信息有限公司 on 17/4/28.
//  Copyright © 2017年 西安旺豆电子信息有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonModel : NSObject


@property (nonatomic , assign) NSInteger userID;

@property (nonatomic , assign) NSInteger parentID;

@property (nonatomic , copy) NSString *name;

@property (nonatomic , copy) NSString *peiou;

@property (nonatomic , copy) NSArray *childs;


@end
