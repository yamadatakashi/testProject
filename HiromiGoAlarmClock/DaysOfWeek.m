//
//  DaysOfWeek.m
//  Alarm
//
//  Created by 卓史 山田 on 12/02/24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DaysOfWeek.h"

@implementation DaysOfWeek


+ (int)set:(int)day checkBool:(BOOL)check  repeatData:(int)mDays{
    int data = mDays;
    
    if (check) {
        data =  (mDays |= (1 << day));
    } else {
        data =  mDays &= ~(1 << day);
    }
    
    return data;
}

+ (int)isSet:(int)day repeatData:(int)mDays{
    if ((mDays & (1 << day)) > 0) {
        return day;
        NSLog(@"isSet => %d", day);
    } else {
        return -1;
    }
}

+ (NSMutableArray *)getBooleanArray:(int)mDays{
    NSMutableArray *selectData = [[NSMutableArray alloc] init];
    for (int i = 0; i < 7; i++) {
        if ([DaysOfWeek isSet:i repeatData:mDays] != -1) {
            [selectData addObject:[NSNumber numberWithInteger:[DaysOfWeek isSet:i repeatData:mDays]]];
        }
    }    
    return selectData;
}

+ (NSMutableArray *)getNotifDaysArray:(int)mDays {
    NSMutableArray *notifDaysArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 7; i++) {
        if ([DaysOfWeek isSet:i repeatData:mDays] != -1) {
            int result = [DaysOfWeek isSet:i repeatData:mDays];
            
            if(result == 6) {
                result = 0;
            } else {
                result += 1;
            }
            [notifDaysArray addObject:[NSNumber numberWithInteger:result]];
        }
    }    
    return notifDaysArray;
}

+ (NSString *)repeatDataToString:(int)repeatdata
{
    NSString *repeatString = @"";
    
    for (int i = 0; i < 7; i++) {
        if (repeatdata == 127) {
            repeatString = @"毎日";
            return repeatString;
        } else if ((repeatdata & (1 << i)) > 0) {
            NSArray  *daysArray = [[NSArray alloc] initWithObjects:@"月", @"火", @"水", @"木", @"金", @"土", @"日", nil];
            repeatString = [repeatString stringByAppendingString:[daysArray objectAtIndex:i]];
        } 
    }
    return repeatString;
}

@end
