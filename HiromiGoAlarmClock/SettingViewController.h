//
//  SettingViewController.h
//  HiromiGoAlarmClock
//
//  Created by 山田 卓史 on 2013/04/15.
//  Copyright (c) 2013年 SWEET ROOM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlarmData.h"

@interface SettingViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    IBOutlet UIDatePicker *datePicker;
    
    AlarmData *_alarmData;
    NSManagedObjectContext *_managedObjectContext;
    UITableView*	_settingTable;
    UINavigationItem* navigationItem;
    UITextField *timeField;
    UITextField *field;
}

@property (strong, nonatomic) IBOutlet UINavigationBar *naviBar;
@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) AlarmData *alarmData;
@property (strong, nonatomic) IBOutlet UITableView *settingTable;


- (IBAction)setAlarm;
- (IBAction)pushDeleteBtn:(id)sender;


@end
