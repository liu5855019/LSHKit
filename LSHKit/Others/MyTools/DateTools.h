//
//  DateTools.h
//  product1
//
//  Created by 西安旺豆电子信息有限公司 on 16/8/30.
//  Copyright © 2016年 西安旺豆电子信息有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DateTools : NSObject

#define yyyyMMddHHmm  @"yyyy-MM-dd HH:mm"
#define yyyyMMdd @"yyyy-MM-dd"
#define yyyyMMddHHmmss @"yyyy-MM-dd HH:mm:ss"
#define HHmmss @"HH:mm:ss"

#pragma mark - formatter

/**
 *  根据传入的Str生成formatter
 */
+ (NSDateFormatter *)getDateFormatterWithFormatterString:(NSString *) formatterStr;
/**
 *  dateformatter : @"yyyy-MM-dd HH:mm:ss"
 */
+ (NSDateFormatter *)getDetailDateFormatter;


#pragma  mark - date

+ (NSUInteger)hour:(NSDate *)date;

+ (NSUInteger)minute:(NSDate *)date;

+ (NSUInteger)second:(NSDate *)date;

+ (NSUInteger)month:(NSDate *)date;

+ (NSUInteger)year:(NSDate *)date;

+ (NSInteger)day:(NSDate *)date;

/**
 *  相对现在日期得间隔天数
 */
+ (NSString *)detailTimeAgoString:(NSDate *)date;

/**
 *  相对现在日期得间隔天数
 */
+ (NSString *)detailTimeAgoStringByInterval:(long long)timeInterval;

/**
 *  获取星期几
 */
+ (NSUInteger)weekDay:(NSDate *)date;

/**
 *  获取星期几
 */
+ (NSString *)weekDayString:(NSDate *)date;

/**
 *  从字符串获得时间
 */
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;

/**
 *  从时间获得字符串
 */
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)string;

/**
 *  从时间获得字符串: @"yyyy-MM-dd HH:mm:ss"
 */
+ (NSString *) stringWithDetailFormatterFromDate:(NSDate *)date;


#pragma mark - NSTimeInterval
/**
 *  /Date(1477297275594+0800)/ ----> 1477297275594
 */
+(NSTimeInterval)timeIntervalWithString:(NSString *)dateStr;

@end
