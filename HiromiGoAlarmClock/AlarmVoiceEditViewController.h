//
//  AlarmVoiceEditViewController.h
//  HiromiGoAlarmClock
//
//  Created by 山田 卓史 on 2013/06/11.
//  Copyright (c) 2013年 SWEET ROOM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlarmData.h"
#import <AVFoundation/AVFoundation.h>

@interface AlarmVoiceEditViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, AVAudioPlayerDelegate>{
    
    NSManagedObjectContext *_managedObjectContext;
    AlarmData *_alarmData;
    int mDays;
    
    NSMutableArray *_tableData;
    int selectedNum;
    
    AVAudioPlayer* _soundPlayer[2];
    NSString *alarmPath;
    NSURL *alarmURL;
    //    int selectedSoundRow;
    
}

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) AlarmData *alarmData;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, assign) int selectedSoundRow;

@end
