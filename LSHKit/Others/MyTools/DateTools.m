//
//  DateTools.m
//  product1
//
//  Created by 西安旺豆电子信息有限公司 on 16/8/30.
//  Copyright © 2016年 西安旺豆电子信息有限公司. All rights reserved.
//

#import "DateTools.h"
#import "MyTools.h"

@implementation DateTools

#pragma mark - DateFormatter
+ (NSDateFormatter *)getDateFormatterWithFormatterString:(NSString *) formatterStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatterStr];
    return formatter;
}

+ (NSDateFormatter *)getDetailDateFormatter
{
    return [DateTools getDateFormatterWithFormatterString:@"yyyy-MM-dd HH:mm:ss"];
}


#pragma mark - Date

+ (NSUInteger)year:(NSDate *)date
{
    NSDateFormatter *formatter = [DateTools getDateFormatterWithFormatterString:@"yyyy"];
    NSString *str = [formatter stringFromDate:date];
    return [str integerValue];
}

+ (NSUInteger)month:(NSDate *)date
{
    NSDateFormatter *formatter = [DateTools getDateFormatterWithFormatterString:@"MM"];
    NSString *str = [formatter stringFromDate:date];
    return [str integerValue];
}

+ (NSInteger)day:(NSDate *)date
{
    NSDateFormatter *formatter = [DateTools getDateFormatterWithFormatterString:@"dd"];
    NSString *str = [formatter stringFromDate:date];
    return [str integerValue];
}

+ (NSUInteger)hour:(NSDate *)date{
    NSDateFormatter *formatter = [DateTools getDateFormatterWithFormatterString:@"HH"];
    NSString *str = [formatter stringFromDate:date];
    return [str integerValue];
}

+ (NSUInteger)minute:(NSDate *)date{
    NSDateFormatter *formatter = [DateTools getDateFormatterWithFormatterString:@"mm"];
    NSString *str = [formatter stringFromDate:date];
    return [str integerValue];
}

+ (NSUInteger)second:(NSDate *)date{
    NSDateFormatter *formatter = [DateTools getDateFormatterWithFormatterString:@"ss"];
    NSString *str = [formatter stringFromDate:date];
    return [str integerValue];
}

+ (NSString *)detailTimeAgoString:(NSDate *)date
{
    if ([MyTools checkIsNullObject:date])
    {
        return nil;
    }
    long long timeNow = [date timeIntervalSince1970];
 
    NSInteger year = [DateTools year:date];
    NSInteger month = [DateTools month:date];
    NSInteger day = [DateTools day:date];
    
    NSDate * today= [NSDate date];
    
    NSInteger t_year= [DateTools year:today];
    
    NSString* string=nil;
    
    long long now = [today timeIntervalSince1970];
    
    long long  distance= now - timeNow;
    if(distance<60)
        string=@"刚刚";
    else if(distance<60*60)
        string=[NSString stringWithFormat:@"%lld分钟前",distance/60];
    else if(distance<60*60*24)
        string=[NSString stringWithFormat:@"%lld小时前",distance/60/60];
    else if(distance<60*60*24*7)
        string=[NSString stringWithFormat:@"%lld天前",distance/60/60/24];
    else if(year==t_year)
        string=[NSString stringWithFormat:@"%ld月%ld日",(long)month,(long)day];
    else
        string=[NSString stringWithFormat:@"%ld年%ld月%ld日",(long)year,(long)month,(long)day];
    
    return string;
}

+ (NSString *)detailTimeAgoStringByInterval:(long long)timeInterval
{
    return [DateTools detailTimeAgoString:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
}

+ (NSUInteger)weekDay:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];

    NSDateComponents *weekdayComponents = [calendar components:NSCalendarUnitWeekday fromDate:date];
    //我们的习惯是周一为第一天，那么我们改一下就OK了
    NSUInteger wDay = [weekdayComponents weekday];
    //将第一天设为周日
    if (wDay == 1) {
        wDay = 7;
    }else{
        wDay = wDay - 1;
    }
    return wDay;
}

+ (NSString *)weekDayString:(NSDate *)date
{
    NSArray *weekArray =nil;
    if ([MyTools isEnglish]) {
        weekArray = @[@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday", @"Saturday", @"Sunday"];
    }else{
        weekArray = @[@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期天"];
    }
    
    return weekArray[[DateTools weekDay:date] - 1];
}


/**
 *  从字符串获得时间
 */
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format
{
    NSDateFormatter *formatter = [DateTools getDateFormatterWithFormatterString:format];
    return [formatter dateFromString:string];
}

/**
 *  从时间获得字符串
 */
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)string
{
    return [[DateTools getDateFormatterWithFormatterString:string] stringFromDate:date];
}

+ (NSString *) stringWithDetailFormatterFromDate:(NSDate *)date {
    return [DateTools stringFromDate:date withFormat:@"yyyy-MM-dd HH:mm:ss"];
}

//  /Date(1477297275594+0800)/ ----> 1477297275594
+(NSTimeInterval)timeIntervalWithString:(NSString *)dateStr
{
    if (dateStr.length == 0) {
        return 0;
    }
    NSArray *strArr = [dateStr componentsSeparatedByString:@"("];
    NSString *str = strArr.lastObject;
    strArr = [str componentsSeparatedByString:@"+"];
    return [strArr.firstObject doubleValue]/1000.0f;
}






@end
