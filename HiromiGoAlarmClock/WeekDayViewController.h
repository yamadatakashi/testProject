//
//  WeekDayViewController.h
//  HiromiGoAlarmClock
//
//  Created by 山田 卓史 on 2013/06/05.
//  Copyright (c) 2013年 SWEET ROOM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlarmData.h"

@interface WeekDayViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>{
    
    NSManagedObjectContext *_managedObjectContext;
    AlarmData *_alarmData;
    int mDays;
    
    NSMutableArray *_tableData;
    NSMutableArray *_selectedData;
    
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) AlarmData *alarmData;
@property (retain, nonatomic) IBOutlet UINavigationBar *navigationBar;
@end
