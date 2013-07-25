//
//  FinishVoiceEditViewController.h
//  HiromiGoAlarmClock
//
//  Created by 山田 卓史 on 2013/06/11.
//  Copyright (c) 2013年 SWEET ROOM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlarmData.h"
#import <AVFoundation/AVFoundation.h>


@interface FinishVoiceEditViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, AVAudioPlayerDelegate>{
    
    NSManagedObjectContext *_managedObjectContext;
    AlarmData *_alarmData;
    int mDays;
    
    NSMutableArray *_tableData;
    
    AVAudioPlayer* _soundPlayer[7];
    NSString *alarmPath;
    NSURL *alarmURL;
    int selectedSoundRow;
    
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) AlarmData *alarmData;

@end
