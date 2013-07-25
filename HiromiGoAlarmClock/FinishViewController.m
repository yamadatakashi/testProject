//
//  FinishViewController.m
//  HiromiGoAlarmClock
//
//  Created by 山田 卓史 on 2013/04/23.
//  Copyright (c) 2013年 SWEET ROOM. All rights reserved.
//

#import "FinishViewController.h"
#import "AlarmAppDelegate.h"
#import "SongData.h"

@interface FinishViewController ()

@end

@implementation FinishViewController

@synthesize finishVoiceID;
@synthesize pushFlag;
@synthesize fromNotifFlag;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    NSString *soundName;
    
    if (finishVoiceID == 8) {
        //        srand((unsigned int)time(NULL));
        finishVoiceID = arc4random() % 7 + 1;
    }
    soundName = [NSString stringWithFormat:@"clear0%d" ,finishVoiceID];
    
    NSString *clearVoicePath = [[NSBundle mainBundle]pathForResource:soundName ofType:@"caf"];
    NSURL *alarmURL = [NSURL fileURLWithPath:clearVoicePath];
    clearVoicePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:alarmURL error:nil];
    clearVoicePlayer.numberOfLoops = 0;
    [clearVoicePlayer play];
    
    NSString *todayTime;
    NSString *averageTime;
    NSString *rankText;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (pushFlag == 1) {
        todayTime = [NSString stringWithFormat:@"%d秒", [defaults integerForKey:@"TODAY_GETUP_TIME"]];
        
        int average =[defaults integerForKey:@"TOTAL_GETUP_TIME"] / [defaults integerForKey:@"GETUP_COUNT"];
        averageTime = [NSString stringWithFormat:@"%d秒", average];
        
        if ( average > 60 ) rankText = @"圏外";
        else if (45 < average && average <= 60) rankText = @"C";
        else if (35 < average && average <= 45) rankText = @"B";
        else if (25 < average && average <= 35) rankText = @"A";
        else if (average <= 25 ) rankText = @"S";
    } else {
        todayTime = @"0秒";
        averageTime = @"0秒";
        rankText = @"圏外";
    }
    self.todayTimeLbl.text = todayTime;
    self.averageTimeLbl.text = averageTime;
    self.rankLbl.text = rankText;
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"scratch01" ofType:@"caf"];
    NSURL *url = [NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &scratchSoundID);
    scratchTimes = 0;
    
    UIScreen *screen = [UIScreen mainScreen];
    int width = screen.applicationFrame.size.width;
    int height = screen.applicationFrame.size.height;
    
    lowX = width * 0.4f;
    highX = width * 0.6f;
    lowY = height * 0.75f;
    highY = height * 0.85f;
    
    
    AlarmAppDelegate *appDelegate = (AlarmAppDelegate *)[[UIApplication sharedApplication]delegate];    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SongData" inManagedObjectContext:appDelegate.managedObjectContext];
    
    [request setEntity:entity];
    [request setFetchBatchSize:20];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"songID" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    NSError *error = nil;

    NSMutableArray *mutableFetchResult = [[appDelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    if (mutableFetchResult == nil) {
        songDataArray = [[NSMutableArray alloc] init];
    }
    songDataArray = mutableFetchResult;
    
    int songID;
    NSDate* date = [NSDate date];
    NSDate* mDate = [defaults objectForKey:@"DATE"];
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.dateFormat = @"yyyy/MM/dd";
    NSString *date1 = [df stringFromDate:date];
    NSString *date2 = [df stringFromDate:mDate];

    if ([date1 isEqualToString:date2]) {
        songID = [defaults integerForKey:@"SONG_ID"];
    }
    else {
        songID = arc4random() % 97 + 1;
        [defaults setObject:date forKey:@"DATE"];
        [defaults setInteger:songID forKey:@"SONG_ID"];
        [defaults synchronize];
    }
    
    SongData *songData = [songDataArray objectAtIndex:songID];
    NSString *songName = songData.songName;
    self.songNameTextView.text = songName;
    
    NSString *songNameStr = self.songNameTextView.text;
    NSInteger byteLnegth = [songNameStr lengthOfBytesUsingEncoding:NSShiftJISStringEncoding];
    
    if ( byteLnegth < 23) {
        self.songNameTextView.center = CGPointMake(self.songNameTextView.center.x, self.songNameTextView.center.y + 13);
    }

    int times = [songData.times intValue] + 1;
    songData.times = [NSNumber numberWithInt:times];

    NSLog(@"songName:%@", songName);
    NSLog(@"songData.times:%@", songData.times);
    
    if (![appDelegate.managedObjectContext save:&error]) {
        NSLog(@"add Event エラー");
        abort();
    }
    
    self.logoImage.alpha = 0;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    toLeftFlg = true;
    toRightFlg = true;
    toUpFlg = true;
    toDownFlg = true;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

    NSArray* objects=[touches allObjects];
    CGPoint pos=[[objects objectAtIndex:0] locationInView:self.view];
    
    int x = pos.x;
    int y = pos.y;
//    NSLog(@"x:%i y:%i", x, y);

    if (scratchTimes < 30) {

        if(x < lowX && toLeftFlg && [self checkScratchHeightPosition:y]) {
            AudioServicesPlaySystemSound(scratchSoundID);
            toLeftFlg = false;
            toRightFlg = true;
            scratchTimes += 1;
        }
            
        if(x > highX && toRightFlg && [self checkScratchHeightPosition:y]) {
            AudioServicesPlaySystemSound(scratchSoundID);
            toLeftFlg = true;
            toRightFlg = false;
            scratchTimes += 1;
        }
            
        if(y > highY && toDownFlg && [self checkScratchWidthPosition:x]) {
            AudioServicesPlaySystemSound(scratchSoundID);
            toUpFlg = true;
            toDownFlg = false;
            scratchTimes += 1;
        }
            
        if(y < lowY && toUpFlg && [self checkScratchWidthPosition:x]) {
            AudioServicesPlaySystemSound(scratchSoundID);
            toUpFlg = false;
            toDownFlg = true;
            scratchTimes += 1;
        }
    }
            
    switch (scratchTimes) {
        case 5:
            self.scratchImage.image = [UIImage imageNamed:@"scratch_2.png"];
//
//					editor.putString("TODAY", today);
//				   	editor.putInt("TODAY_SONG_ID", songId);
//					editor.commit();
//					
//					if (songCsr.getInt(1) == 0) {
//						AlphaAnimation alpha = new AlphaAnimation(0.1f, 1.0f);
//						alpha.setDuration(2000);
//						ImageView newLogo = (ImageView)findViewById(R.id.NEW_LOGO);
//						newLogo.startAnimation(alpha);
//						newLogo.setImageResource(R.drawable.new_logo);
//					}
//					android.util.Log.w("times", String.valueOf(songCsr.getInt(1)));
//					ContentValues cv = new ContentValues();
//					cv.put("times", songCsr.getInt(1) + 1);
//					db.update("songData", cv, "_id =" + songId, null);
					
            break;
                    
        case 10:
            self.scratchImage.image = [UIImage imageNamed:@"scratch_3.png"];
            break;
                    
        case 15:
            self.scratchImage.image = [UIImage imageNamed:@"scratch_4.png"];
            break;
					
        case 20:
            self.scratchImage.image = [UIImage imageNamed:@"scratch_5.png"];
            break;
					
        case 25:
            self.scratchImage.image = [UIImage imageNamed:@"scratch_6.png"];
            break;
					
        case 27:
            [UIView beginAnimations:@"fadeIn" context:nil];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:1.0];
            self.logoImage.alpha = 1;
            [UIView commitAnimations];
            self.scratchImage.hidden = YES;
//					scratchImageView.setOnTouchListener(null);
//					
//			    	Cursor c = db.query("songData", new String[] {"_id", "songname", "times"}, null, null, null, null, "_id ASC",  null);
//			        int totalTimes = 0;
//			        boolean isEof = c.moveToFirst();
//			    	while(isEof){
//			    		totalTimes += c.getInt(2);
//			    		isEof = c.moveToNext();
//			    	}
//			    	if (totalTimes % 3 == 0 && totalTimes > 1 && totalTimes < 66) {
//						Toast.makeText(ClearDisplayActivity.this, "新しい画像が閲覧可能になりました！", Toast.LENGTH_LONG).show();
//			    	}
//			    	c.close();
            break;
					
        case 28:
            self.scratchImage.hidden = YES;
            break;
            
        case 29:
            self.scratchImage.hidden = YES;
            break;
					
        default:
            break;
    }
}

- (IBAction)finishButton:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"TOP画面に戻ります" message:@"よろしいですか？" delegate:self cancelButtonTitle:@"いいえ" otherButtonTitles:@"はい",nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    
    switch (buttonIndex) {
        case 0:
            break;
            
        case 1:
            [clearVoicePlayer stop];
            if (fromNotifFlag == 1) {
                [self.navigationController popToRootViewControllerAnimated:YES];
                AlarmAppDelegate *appDelegate = (AlarmAppDelegate *)[[UIApplication sharedApplication]delegate];
                [appDelegate hideTabBar:NO];
//                [self.view removeFromSuperview];
            }
            else {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
            
            break;
            
        default:
            break;
    }
}

- (BOOL)checkScratchWidthPosition:(int)x {
    
    if (x < highX + 100 && x > lowX - 100)
        return YES;
    else
        return NO;
    
}

- (BOOL)checkScratchHeightPosition:(int)y {
    
    if (y < highY + 100  && y > lowY - 100)
        return YES;
    else
        return NO;
    
}

@end
