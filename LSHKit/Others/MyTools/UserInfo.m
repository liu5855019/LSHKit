//
//  Userid.m
//  product1
//
//  Created by 西安旺豆电子信息有限公司 on 16/6/30.
//  Copyright © 2016年 西安旺豆电子信息有限公司. All rights reserved.
//

#import "UserInfo.h"
#import "Common.h"

#define kUserInfo @"Userinfo"

@interface UserInfo ()

@property (nonatomic , assign) CGFloat scale;
@property (nonatomic , assign) CGFloat scaleW;

@end


@implementation UserInfo
+(instancetype) shareUser{
    static UserInfo *userInfo;
    if (userInfo) {
        return userInfo;
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *filePath = [MyTools filePathInDocuntsWithFile:kUserInfo];
        userInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        
        if (!userInfo) {
            userInfo = [[self alloc] init];
        }
    });
    
    return userInfo;
}

-(void)saveDatas{
    NSString *filePath = [MyTools filePathInDocuntsWithFile:kUserInfo];
    
    [NSKeyedArchiver archiveRootObject:self toFile:filePath];
}

-(void)removeDatas{
    //删除归档的文件
    NSString *filePath = [MyTools filePathInDocuntsWithFile:kUserInfo];
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}

#pragma mark - NSCoding


/**
 *  解档协议方法
 */
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.userName = [coder decodeObjectForKey:@"userName"];
        self.password = [coder decodeObjectForKey:@"password"];
        self.userID = [coder decodeIntegerForKey:@"userID"];
        self.email = [coder decodeObjectForKey:@"email"];
        self.companyName = [coder decodeObjectForKey:@"companyName"];
        self.companyAddress = [coder decodeObjectForKey:@"companyAddress"];
        
        self.isRemember = [coder decodeBoolForKey:@"isRemember"];
    }
    return self;
}

/**
 *  归档协议方法
 */
-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:_userName forKey:@"userName"];
    [aCoder encodeObject:_password forKey:@"password"];
    [aCoder encodeInteger:_userID forKey:@"userID"];
    [aCoder encodeObject:_email forKey:@"email"];
    [aCoder encodeObject:_companyName forKey:@"companyName"];
    [aCoder encodeObject:_companyAddress forKey:@"companyAddress"];
    
    
    [aCoder encodeBool:_isRemember forKey:@"isRemember"];

}

-(CGFloat)screenScale
{
    if (_scale == 0) {
        _scale = kScreenH / 736.0f;
    }
    return _scale;
}

-(CGFloat)screenScaleW
{
    if (_scaleW == 0) {
        _scaleW = kScreenW / 375.0f;
    }
    return _scaleW;
}


@end
