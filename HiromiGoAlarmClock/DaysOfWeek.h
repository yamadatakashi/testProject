//
//  DaysOfWeek.h
//  Alarm
//
//  Created by 卓史 山田 on 12/02/24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DaysOfWeek : NSObject

+ (int)set:(int)day checkBool:(BOOL)check  repeatData:(int)mDays;
+ (int)isSet:(int)day repeatData:(int)mDays;
+ (NSMutableArray *)getBooleanArray:(int)mDays;
+ (NSMutableArray *)getNotifDaysArray:(int)mDays;
+ (NSString *)repeatDataToString:(int)repeatdata;

@end
