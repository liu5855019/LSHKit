//
//  product1
//
//  Created by 西安旺豆电子信息有限公司 on 16/6/30.
//  Copyright © 2016年 西安旺豆电子信息有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject


@property (nonatomic , copy) NSString *userName;
@property (nonatomic , copy) NSString *password;

@property (nonatomic , assign) NSInteger userID;
@property (nonatomic , copy) NSString *email;
@property (nonatomic , copy) NSString *companyName;
@property (nonatomic , copy) NSString *companyAddress;

@property (nonatomic , assign) BOOL isRemember;
//用来登录的个人标识符
@property (nonatomic , copy) NSString *tokenNo;
//用来推送的设备token
@property (nonatomic , copy) NSString *deviceToken;

@property (nonatomic , assign) NSInteger cityID;
@property (nonatomic , assign) NSInteger districtID;




+(instancetype) shareUser;

-(void)saveDatas;
-(void)removeDatas;

- (CGFloat)screenScale;
- (CGFloat)screenScaleW;


@end
