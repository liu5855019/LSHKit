//
//  Common.h
//  product1
//
//  Created by 西安旺豆电子信息有限公司 on 16/7/12.
//  Copyright © 2016年 西安旺豆电子信息有限公司. All rights reserved.
//

#ifndef Common_h
#define Common_h


#import "AppDelegate.h"


#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "Masonry.h"
#import "UIView+Toast.h"

#import "MyTools.h"
#import "DateTools.h"
#import "UserInfo.h"
#import "UITools.h"
#import "DBManager.h"


#import "BaseViewController.h"








#pragma mark - NSLog
#ifndef __OPTIMIZE__
# define NSLog(...) NSLog(__VA_ARGS__)
#else
# define NSLog(...)
#endif


#ifdef DEBUG
#define MyLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define MyLog(...)
#endif




#pragma mark - Screen/Frame 屏幕尺寸

#define kScreenH [UIScreen mainScreen].bounds.size.height
#define kScreenW [UIScreen mainScreen].bounds.size.width

#define kLineH (1.0f / [UIScreen mainScreen].scale)

#define kScale(value) ((value) * [UserInfo shareUser].screenScale)
#define kScaleW(value) ((value) * [UserInfo shareUser].screenScaleW)


#define kGetX(v)            (v).frame.origin.x
#define kGetY(v)            (v).frame.origin.y
#define kGetW(v)            (v).frame.size.width
#define kGetH(v)            (v).frame.size.height

#define kGetMinX(v)            CGRectGetMinX((v).frame) // 获得控件屏幕的x坐标
#define kGetMinY(v)            CGRectGetMinY((v).frame) // 获得控件屏幕的Y坐标

#define kGetMidX(v)            CGRectGetMidX((v).frame) //横坐标加上到控件中点坐标
#define kGetMidY(v)            CGRectGetMidY((v).frame) //纵坐标加上到控件中点坐标

#define kGetMaxX(v)            CGRectGetMaxX((v).frame) //横坐标加上控件的宽度
#define kGetMaxY(v)            CGRectGetMaxY((v).frame) //纵坐标加上控件的高度

#define kGetTEXTSIZE(text, font) [text length] > 0 ? [text sizeWithAttributes:@{NSFontAttributeName:font}] : CGSizeZero






#pragma mark - 判断当前的iPhone设备/系统版本

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPOD ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"])


#define IS_iPhone4S ([[UIScreen mainScreen] bounds].size.width == 320.0f && [[UIScreen mainScreen] bounds].size.height == 480.0f)
#define IS_iPhone5S ([[UIScreen mainScreen] bounds].size.width == 320.0f && [[UIScreen mainScreen] bounds].size.height == 568.0f)
#define IS_iPhone6_6s ([[UIScreen mainScreen] bounds].size.width == 375.0f && [[UIScreen mainScreen] bounds].size.height == 667.0f)
#define IS_iPhone6Plus_6sPlus ([[UIScreen mainScreen] bounds].size.width == 414.0f && [[UIScreen mainScreen] bounds].size.height == 736.0f)


//获取系统版本
#define IOS_SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
//判断 iOS 8 或更高的系统版本
#define IOS_VERSION_8_OR_LATER (([[[UIDevice currentDevice] systemVersion] floatValue] >=8.0)? (YES):(NO))
//获得app build号
#define kAppBuild [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey]
//获得app Version 号
#define kAppVerison [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]



// 赋值
#define HB_STRING(object) (((object == nil) || ([object isEqual:[NSNull null]])) ? @"":[NSString stringWithFormat:@"%@", object])

#define HB_INTEGER(object)    ( ((object == nil) || ([object isEqual:[NSNull null]])) ? 0 : [object integerValue])

#define HB_FLOAT(object)    ( ((object == nil) || ([object isEqual:[NSNull null]])) ? 0.0f : [object floatValue])

#define HB_DOUBLE(object)    ( ((object == nil) || ([object isEqual:[NSNull null]])) ? 0.0f : [object doubleValue])

#define HB_BOOL(object)    ( ((object == nil) || ([object isEqual:[NSNull null]])) ? NO : [object boolValue])

#define HB_ARRAY(object)    ( ((object == nil) || ([object isEqual:[NSNull null]])) ? @[] : object )

#define HB_DICTIONARY(object)  ( ((object == nil) || ([object isEqual:[NSNull null]])) ? @{} : object )

#define HB_DIC_VALUE(dic, key) ( (!dic || ![dic isKindOfClass:[NSDictionary class]] || [dic valueForKey:key] == nil || [dic valueForKey:key] == [NSNull null]) ? @"" : [dic valueForKey:key] )

#pragma mark - Color
//homePage用的灰色
#define kHomePageLineViewColor [UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1]
//导航栏颜色
//#define kNavigationBarBackGroundColor [UIColor colorWithRed:51.0/255.0 green:87.0/255.0 blue:164.0/255.0 alpha:1.0f]
#define kNavigationBarBackGroundColor [UIColor colorWithRed:35.0/255.0 green:76.0/255.0 blue:164.0/255.0 alpha:1.0f]


// 随机色
#define kRandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]


//快速获取颜色
#define kGetColorRGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define kGetColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define kGetColorRgbValue(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kMyLightGayColor kGetColorRGB(199, 199, 205)
#define kMyRedColor kGetColorRGB(255, 79, 56)
#define kMyBlueColor kGetColorRGB(141, 189, 244)
#define kMyBGColor kGetColorRGB(240, 246, 250)
#define kMyLightGayBGColor kGetColorRGB(241, 244, 245)





#pragma mark - Image
/**
 *  加载本地图片,不缓存
 */
#define kLoadImage(fileName,extName) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:fileName ofType:extName]]
/**
 *  加载本地图片,缓存
 */
#define kGetImage(fileName) [UIImage imageNamed: fileName]
/** 加载xib */
#define kLoadView(className) [[NSBundle mainBundle] loadNibNamed:className owner:nil options:nil][0]





#pragma mark - G－C－D
#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)

#define WeakObj(self) __weak typeof(self) self##Weak = self;





//由角度获取弧度 有弧度获取角度
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define radianToDegrees(radian) (radian*180.0)/(M_PI)





#pragma mark - 消除@selector警告
#define CleanPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)






#pragma mark - 国际化
//获取字符串
#define kLocStr(str) NSLocalizedString(str, nil)
#define kLocStrTab(str,file) NSLocalizedStringFromTable(str, file, nil)

//获取当前语言
#define kCurrentLanguage [[NSLocale preferredLanguages] firstObject]






#pragma mark - config




#define kServerIP @"http://192.168.100.190:8080/TTSM"

//#define kServerIP @"http://192.168.100.100:8080/TTSM"
//#define kServerIP @"http://192.168.100.136:8080/TTSM"
//#define kServerIP @"http://192.168.100.222:9001/TTSM"
//#define kServerIP @"http://192.168.100.124:8080/TTSM"
//#define kServerIP @"http://116.62.64.26:8080/TTSM"


#define kBigImageAnimationTime 0.25

/** 删除过期数据:过期时间(s) */
#define kDeleteDatasTime (3*24*3600)
//是否写入日志
#define kIsInsertLogs 0



//typedef enum : NSUInteger {
//    NO_PAY,         //未支付
//    MAKE_ING,       //制作中
//    MAKE_END,       //制作完
//    MAKE_RE,        //重新制作
//    PLAY_BEFORE,    //待播放
//    PLAY_ING,       //播放中
//    PLAY_PAUSE,     //暂停播放
//    PLAY_END,       //播放完成
//    REFUND_ING,     //退款中
//    REFUND_END      //退款完成
//} OrderState;

typedef enum : NSUInteger {
    ORDER_All,          //全部订单 0
    PAY_NO,             //未支付
    PAY_END,            //已支付
    MAKE_ING,           //制作中
    MAKE_END,           //待确认
    PLAY_BEFORE,        //待播放 5
    PLAY_ING,           //播放中
    PAUSE_APPLY,       //暂停申请
    PAUSE_ING,          //暂停播放
    ORDER_END,          //订单关闭
    ORDER_CANCEL,       //订单取消 10
    REFUND_ING          //申请退款
} OrderState;


#define wx_appid @"wxb1b470de26460825"
#define wx_mch_id @"1461473802"
#define wx_device_info @"WEB"


#endif /* Common_h */
