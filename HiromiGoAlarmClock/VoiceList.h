//
//  VoiceList.h
//  HiromiGoAlarmClock
//
//  Created by 山田 卓史 on 2013/06/11.
//  Copyright (c) 2013年 SWEET ROOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoiceList : NSObject {
    NSMutableArray *_alarmVoiceList;
    NSMutableArray *_finishVoiceList;
}

+ (NSMutableArray *)alarmVoiceSet;
+ (NSMutableArray *)finishVoiceSet;
+ (NSString *)alarmVoiceNameToString:(int)num;
+ (NSString *)finishVoiceNameToString:(int)num;


@end
