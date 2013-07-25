//
//  SongData.h
//  HiromiGoAlarmClock
//
//  Created by 山田 卓史 on 2013/07/18.
//  Copyright (c) 2013年 SWEET ROOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SongData : NSManagedObject

@property (nonatomic, retain) NSNumber * songID;
@property (nonatomic, retain) NSString * songName;
@property (nonatomic, retain) NSNumber * times;

@end
