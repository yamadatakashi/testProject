//
//  FinishViewController.h
//  HiromiGoAlarmClock
//
//  Created by 山田 卓史 on 2013/04/23.
//  Copyright (c) 2013年 SWEET ROOM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlarmData.h"
#import <AVFoundation/AVFoundation.h>

@interface FinishViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>{
    AVAudioPlayer *clearVoicePlayer;
    NSTimer *_timer;
    NSTimeInterval exitTime;
    
    SystemSoundID scratchSoundID;
    
    BOOL firstAction, toLeftFlg, toRightFlg, toUpFlg, toDownFlg;
    float lowX, highX, lowY, highY;
    int scratchTimes;
    
    NSMutableArray *songDataArray;
}

@property (nonatomic) int finishVoiceID;
@property (nonatomic) int pushFlag;
@property (nonatomic) int fromNotifFlag;

@property (weak, nonatomic) IBOutlet UIImageView *scratchImage;
@property (weak, nonatomic) IBOutlet UILabel *todayTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *averageTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *rankLbl;
@property (weak, nonatomic) IBOutlet UITextView *songNameTextView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
- (IBAction)finishButton:(id)sender;
@end
