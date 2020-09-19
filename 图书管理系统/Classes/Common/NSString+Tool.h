//
//  NSString+Tool.h
//  图书管理系统
//
//  Created by Lingyu on 15/12/16.
//  Copyright © 2015年 Lingyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Tool)

+(NSDate*) convertDateFromString:(NSString*)uiDate;
+(NSString *)stringFromDate:(NSDate *)date;
@end
