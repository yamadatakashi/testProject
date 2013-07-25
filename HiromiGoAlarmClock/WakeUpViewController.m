//
//  WakeUpViewController.m
//  HiromiGoAlarmClock
//
//  Created by 山田 卓史 on 2013/04/18.
//  Copyright (c) 2013年 SWEET ROOM. All rights reserved.
//

#import "WakeUpViewController.h"
#import "FinishViewController.h"
#import "AlarmAppDelegate.h"
@interface WakeUpViewController ()

@end

static const NSInteger kTagAlert1 = 1;
static const NSInteger kTagAlert2 = 2;


@implementation WakeUpViewController
@synthesize timer = _timer;
@synthesize alarmVoiceID;
@synthesize finishVoiceID;
@synthesize fromNotifFlag;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.pushButton.userInteractionEnabled = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSLog(@"%d, %d, %d", alarmVoiceID, finishVoiceID, fromNotifFlag);
    
    touchCount = 55;
    startTime = [NSDate timeIntervalSinceReferenceDate];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    NSString *soundName;
    
    if (alarmVoiceID == 4) {
        //        srand((unsigned int)time(NULL));
        alarmVoiceID = arc4random() % 2;
    }
    soundName = [NSString stringWithFormat:@"alarm0%d" ,alarmVoiceID + 1];

    
    NSString *alarmPath = [[NSBundle mainBundle]pathForResource:soundName ofType:@"caf"];
    NSURL *alarmURL = [NSURL fileURLWithPath:alarmPath];
    alarmPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:alarmURL error:nil];
    alarmPlayer.numberOfLoops = -1;
//
//    NSLog(@"再生開始");
    [alarmPlayer play];
//
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"touchsound" ofType:@"caf"];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &touchSoundID);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults boolForKey:@"PUSH_ONOFF_FIRSTSET"]) {
        [defaults setBool:YES forKey:@"PUSH_ONOFF_FIRSTSET"];
        [defaults setInteger:1 forKey:@"PUSH_ONOFF"];
    }
        
    if ([defaults integerForKey:@"PUSH_ONOFF"] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"アラームを停止します" message:@"よろしいですか？" delegate:self cancelButtonTitle:@"いいえ" otherButtonTitles:@"はい",nil];
        alert.tag = kTagAlert2;
        [alert show];
    }
    
    displayWidth = self.view.bounds.size.width;
    displayHeight = self.view.bounds.size.height;
    
    tenValue = 5;
	oneValue = 5;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    NSArray* objects=[touches allObjects];
    CGPoint pos=[[objects objectAtIndex:0] locationInView:self.view];
    
    if (pos.x >= 40 && pos.x <= 280 && pos.y >= 214) {
        self.pushButton.image = [UIImage imageNamed:@"button_alert_on.png"];
        [self.view setNeedsDisplay];
        AudioServicesPlaySystemSound(touchSoundID);
        
        touchCount -= 1;
        oneValue -= 1;
        
        if (touchCount == 54) {
            self.push55Txt.hidden = YES;
        }
        
        self.pushNumImg01.image = [UIImage imageNamed:[NSString stringWithFormat:@"num%d.png", tenValue]];
        self.pushNumImg02.image = [UIImage imageNamed:[NSString stringWithFormat:@"num%d.png", oneValue]];

        if(oneValue == 0) {
            oneValue = 10;
            tenValue -= 1;
            if (tenValue <= 0) {
                tenValue = 0;
            }
        }
        
    }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSArray* objects=[touches allObjects];
    CGPoint pos=[[objects objectAtIndex:0] locationInView:self.view];
    self.pushButton.image = [UIImage imageNamed:@"button_alert_off.png"];
    
    if (pos.y >= 0 && pos.y < displayHeight * 0.5) {
        UIActionSheet *sheet = [[UIActionSheet alloc] init];
        sheet.delegate = self;
        
        [sheet addButtonWithTitle:@"5分後に再通知"];
        [sheet addButtonWithTitle:@"10分後に再通知"];
        [sheet addButtonWithTitle:@"30分後に再通知"];
        [sheet addButtonWithTitle:@"TOP画面に戻る"];
        [sheet addButtonWithTitle:@"キャンセル"];
        sheet.cancelButtonIndex = 4;
        
        [sheet showFromRect:CGRectMake(0, 100, 320, 480) inView:self.view animated:YES];
    }
    
    if (touchCount <= 0) {
        [alarmPlayer stop];
        [alarmPlayer prepareToPlay];
            
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        int pushOnoffFlag = [defaults integerForKey:@"PUSH_ONOFF"];
            
        if (pushOnoffFlag == 1) {
            int endTime = [NSDate timeIntervalSinceReferenceDate] - startTime;
                
            [defaults setInteger:endTime forKey:@"TODAY_GETUP_TIME"];
                
            if (![defaults integerForKey:@"GETUP_COUNT"]) {
                [defaults setInteger:1 forKey:@"GETUP_COUNT"];
            } else {
                int wakeupCount = [defaults integerForKey:@"GETUP_COUNT"];
                [defaults setInteger:wakeupCount + 1 forKey:@"GETUP_COUNT"];
            }
                
            if (![defaults integerForKey:@"TOTAL_GETUP_TIME"]) {
                [defaults setInteger:[defaults integerForKey:@"TODAY_GETUP_TIME"] forKey:@"TOTAL_GETUP_TIME"];
            } else {
                int totalTime = [defaults integerForKey:@"TOTAL_GETUP_TIME"];
                [defaults setInteger:totalTime + endTime forKey:@"TOTAL_GETUP_TIME"];
            }
                
            if (![defaults synchronize]) {
                NSLog(@"WakeUp UserDefaults ERROR");
            }
                
            NSLog(@"TODAY_GETUP_TIME => %d GETUP_COUNT => %d TOTAL_GETUP_TIME => %d", [defaults integerForKey:@"TODAY_GETUP_TIME"], [defaults integerForKey:@"GETUP_COUNT"], [defaults integerForKey:@"TOTAL_GETUP_TIME"]);
        }
            
        FinishViewController *finishCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"FinishView"];
            
        [finishCtl setFromNotifFlag:fromNotifFlag];
        [finishCtl setFinishVoiceID:finishVoiceID];
        [finishCtl setPushFlag:1];

//            if (fromNotifFlag == 1) {
//                [self.view removeFromSuperview];
//            } else {
//                [self.navigationController setNavigationBarHidden:YES animated:YES];
//            }
        [[self navigationController] pushViewController:finishCtl animated:YES];
        
        //      [touchButton setImage:[UIImage imageNamed:@"wakeup_touch_off.png]"]];
        
        [self.view setNeedsDisplay];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    int snoozeTime;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"TOP画面に戻ります" message:@"よろしいですか？" delegate:self cancelButtonTitle:@"いいえ" otherButtonTitles:@"はい",nil];
    
    
    switch (buttonIndex) {
        case 0:
            snoozeTime = 300;
            [alarmPlayer stop];
            [alarmPlayer prepareToPlay];
            break;
            
        case 1:
            snoozeTime = 600;
            [alarmPlayer stop];
            [alarmPlayer prepareToPlay];
            break;
            
        case 2:
            snoozeTime = 1800;
            [alarmPlayer stop];
            [alarmPlayer prepareToPlay];
            
            break;
            
        case 3:
            snoozeTime = -1;
            alert.tag = kTagAlert1;
            [alert show];
            break;
            
        default:
            snoozeTime = -1;
            break;
    }
    
    if (snoozeTime != -1) {
        [self setSnoozeNotification:snoozeTime];
    }
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            break;
            
        case 1:
            if (alertView.tag == kTagAlert1) {
                if (fromNotifFlag == 1) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    AlarmAppDelegate *appDelegate = (AlarmAppDelegate *)[[UIApplication sharedApplication]delegate];
                    [appDelegate hideTabBar:NO];
//                    [self.view removeFromSuperview];
                    fromNotifFlag = 0;
                } else {
                    [self.navigationController popViewControllerAnimated:YES];
                    NSLog(@"TOP画面から");
                }
            }
            else if (alertView.tag == kTagAlert2) {
                FinishViewController *finishCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"FinishView"];
                
                [finishCtl setFromNotifFlag:fromNotifFlag];
                [finishCtl setFinishVoiceID:finishVoiceID];
                [finishCtl setPushFlag:0];
                
                if (fromNotifFlag == 1) {
                    [self.view removeFromSuperview];
                } else {
                    [self.navigationController setNavigationBarHidden:YES animated:YES];
                }
                [[self navigationController] pushViewController:finishCtl animated:YES];
            }
            
            [alarmPlayer stop];
            [alarmPlayer prepareToPlay];
//            exitTime = [NSDate timeIntervalSinceReferenceDate];
//            _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(exitTimer:) userInfo:nil repeats:YES];
            break;
            
        default:
            break;
    }
}

- (void)setSnoozeNotification:(int)value
{
    UIApplication *app = [UIApplication sharedApplication];
    UILocalNotification *notify = [[UILocalNotification alloc] init];
    
    notify.fireDate = [NSDate dateWithTimeIntervalSinceNow:value];
    notify.timeZone = [NSTimeZone defaultTimeZone];
    notify.repeatInterval = NSMinuteCalendarUnit;
    notify.hasAction = YES;
    
    NSString *soundName;
    if (alarmVoiceID == 4) {
        //        srand((unsigned int)time(NULL));
        alarmVoiceID = arc4random() % 2;
    }
    soundName = [NSString stringWithFormat:@"alarm0%d.caf" ,alarmVoiceID + 1];
    
    notify.soundName = soundName;
    notify.alertBody = @"再通知です。";
    notify.alertAction = @"アラーム停止";
    app.applicationIconBadgeNumber = value / 60;
    NSArray *notifArray = [NSArray arrayWithObjects:[NSNumber numberWithInt:alarmVoiceID], [NSNumber numberWithInt:finishVoiceID], nil];
    notify.userInfo = [NSDictionary dictionaryWithObject:notifArray forKey:@"key_id"];
    
    [app scheduleLocalNotification:notify];
    
    exitTime = [NSDate timeIntervalSinceReferenceDate];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(exitTimer:) userInfo:nil repeats:YES];
}

- (void)exitTimer:(NSTimer *)timer
{
    NSTimeInterval time = [NSDate timeIntervalSinceReferenceDate] - exitTime;
    double timeLeft = 0.7 - time;
    self.view.alpha -= 0.03;
    
    if (timeLeft <= 0) {
        exit(0);
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
