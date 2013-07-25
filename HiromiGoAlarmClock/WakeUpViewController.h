//
//  WakeUpViewController.h
//  HiromiGoAlarmClock
//
//  Created by 山田 卓史 on 2013/04/18.
//  Copyright (c) 2013年 SWEET ROOM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>


@interface WakeUpViewController : UIViewController <UIActionSheetDelegate, UIAlertViewDelegate> {
    AVAudioPlayer *alarmPlayer;
    SystemSoundID touchSoundID;
    int touchCount;
    
    NSTimer *_timer;
    NSTimeInterval startTime, exitTime;
    
    int displayWidth;
    int displayHeight;
    
    int tenValue;
	int oneValue;
}
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) int alarmVoiceID;
@property (nonatomic) int finishVoiceID;
@property (nonatomic) int fromNotifFlag;
@property (strong, nonatomic) IBOutlet UIImageView *pushButton;
@property (weak, nonatomic) IBOutlet UIImageView *pushNumImg01;
@property (weak, nonatomic) IBOutlet UIImageView *pushNumImg02;
@property (weak, nonatomic) IBOutlet UIImageView *push55Txt;
@end
