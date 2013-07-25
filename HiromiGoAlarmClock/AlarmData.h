//
//  AlarmData.h
//  HiromiGoAlarmClock
//
//  Created by 山田 卓史 on 2013/07/12.
//  Copyright (c) 2013年 SWEET ROOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AlarmData : NSManagedObject

@property (nonatomic, retain) NSNumber * alarmvoice;
@property (nonatomic, retain) NSNumber * finishvoice;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) NSNumber * on;
@property (nonatomic, retain) NSNumber * repeat;
@property (nonatomic, retain) NSDate * time;

@end
