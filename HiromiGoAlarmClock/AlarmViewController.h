//
//  AlarmViewController.h
//  HiromiGoAlarmClock
//
//  Created by 山田 卓史 on 2013/04/08.
//  Copyright (c) 2013年 SWEET ROOM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <QuartzCore/CALayer.h>
#import <AVFoundation/AVAudioPlayer.h>
#import "AlarmAppDelegate.h"

@class SuggestionCell;

@interface AlarmViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>{
    NSManagedObjectContext *_managedObjectContext;
    UIToolbar *_toolBar;
    
    SuggestionCell*			_suggestionCell;			//	アラーム用セル
    UITableView*	_suggestionTableView;
    NSMutableArray *array;  //時間配列
    
    int cnt;
    int displayWidth;
    int displayHeight;
    
    NSUserDefaults *defaults;
    AlarmAppDelegate *appDelegate;
}

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) int notifFlag;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet SuggestionCell*  suggestionCell;
@property (strong, nonatomic) IBOutlet UITableView *suggestionTableView;
@property (strong, nonatomic) IBOutlet UIImageView *listPlate;
@property (weak, nonatomic) IBOutlet UIButton *addAlarmBtn;
- (IBAction)pushAddAlarmBtn:(id)sender;

@end
