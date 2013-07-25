//
//  AlarmViewController.m
//  HiromiGoAlarmClock
//
//  Created by 山田 卓史 on 2013/04/08.
//  Copyright (c) 2013年 SWEET ROOM. All rights reserved.
//

#import "AlarmViewController.h"
#import "AlarmData.h"
#import "SuggestionCell.h"
#import "AlarmAppDelegate.h"
#import "DaysOfWeek.h"
#import "SettingViewController.h"
#import "WakeUpViewController.h"

@interface AlarmViewController ()

@end

#define DEFAULT_DATA_NUM 1
#define MAX_DATA_NUM 5

@implementation AlarmViewController

@synthesize toolBar = _toolBar;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize suggestionCell = _suggestionCell;
@synthesize suggestionTableView = _suggestionTableView;

- (void)viewDidLoad
{
//    //タブバーの文字色を設定(選択前)
//    [item1 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:0.31 green:0.25 blue:0.17 alpha:1.0], UITextAttributeTextColor,nil] forState:UIControlStateNormal];
//    //タブバーの文字色を設定(選択中)
//    [item1 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,nil] forState:UIControlStateSelected];
    
    appDelegate = (AlarmAppDelegate *)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    
    NSInteger count = [self countForEntityName:@"AlarmData"];
	if (count == 0) {
		
		for (int i=0; i < DEFAULT_DATA_NUM; i++) {
            
            AlarmData *newManagedObject = (AlarmData *)[NSEntityDescription insertNewObjectForEntityForName:@"AlarmData" inManagedObjectContext:self.managedObjectContext];
            
            NSDate *nowDate = [NSDate date];
            NSCalendar *calendar = [NSCalendar currentCalendar];
            
            NSDateComponents *comp = [calendar
                                      components:(NSYearCalendarUnit|
                                                  NSMonthCalendarUnit|
                                                  NSDayCalendarUnit|
                                                  NSHourCalendarUnit|
                                                  NSMinuteCalendarUnit|
                                                  NSSecondCalendarUnit) fromDate:nowDate];
            comp.hour = 7;
            comp.minute = 0;
            comp.day += 1;
            comp.second = 0;
            
            [newManagedObject setValue:[calendar dateFromComponents:comp] forKey:@"time"];
            
            [newManagedObject setValue:[NSNumber numberWithInt:0] forKey:@"id"];
            [newManagedObject setValue:[NSNumber numberWithInt:1] forKey:@"alarmvoice"];
            [newManagedObject setValue:[NSNumber numberWithInt:1] forKey:@"finishvoice"];
            [newManagedObject setValue:[NSNumber numberWithBool:YES]  forKeyPath:@"on"];
            [newManagedObject setValue:[NSNumber numberWithInt:127]  forKeyPath:@"repeat"];
            [newManagedObject setValue:nil forKeyPath:@"label"];
            
            
            NSError *error = nil;
            if (![self.managedObjectContext save:&error]) {
                NSLog(@"add Event エラー");
                abort();
            }
        }
        
	}
    
    self.suggestionTableView.dataSource = self;
	self.suggestionTableView.delegate = self;
    
    displayWidth = self.view.bounds.size.width;
    displayHeight = self.view.bounds.size.height;

    defaults = [NSUserDefaults standardUserDefaults];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:YES];
        
    if(![self.timer isValid]){
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(digitalClock:) userInfo:nil repeats:YES];
        
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AlarmData" inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:entity];
    [request setFetchBatchSize:20];
    
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResult = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    if (error) {
        NSLog(@"Error %@, %@", error, [error userInfo]);
        abort();
    }
    
    if (mutableFetchResult == nil) {
        array = [[NSMutableArray alloc] init];
    }
    else {
        array = mutableFetchResult;
    }

    [self.suggestionTableView reloadData];
}

//- (void)viewWillDisappear:(BOOL)animated {
//    
//    if([self.timer isValid]){
//        [self.timer invalidate];
//    }
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [array count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // ここで、カスタムセルのレイアウト時に設定した Reuse Identifier を指定します。
    static NSString* CellIdentifier = @"Cell";
    
    // まずは Reuse Identifier を使用して、利用可能なセルのインスタンスがあればそれを取得します。
    SuggestionCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
		[[NSBundle mainBundle] loadNibNamed:@"SuggestionCell" owner:self options:nil];
		cell = self.suggestionCell;
		self.suggestionCell = nil;
    }
    
    // カスタムセルのプロパティを設定します。
    SuggestionCell* scell = (SuggestionCell*)cell;
    
    //    NSDate *date = (NSDate *)[array objectAtIndex:[indexPath row]];
    AlarmData *alarmData = [array objectAtIndex: indexPath.row];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc]init];
    [outputFormatter setDateFormat:@"HH:mm"];
    NSString *newDateString = [outputFormatter stringFromDate:alarmData.time];
    
    [scell.timeLabel setText:[NSString stringWithFormat:@"%@", newDateString]];
    
    
    NSString *label = [DaysOfWeek repeatDataToString:[alarmData.repeat intValue]];
    if ([alarmData.label length] > 0) {
        label = [label stringByAppendingFormat:@" (%@)", alarmData.label];
    }
    [scell.detailLabel setText:label];
    
    UISwitch *switchObj = [[UISwitch alloc] initWithFrame:CGRectMake(1.0, 1.0, 20.0, 20.0)];
    switchObj.on = [alarmData.on boolValue];
    switchObj.tag = [indexPath row];
    [switchObj addTarget:self
                  action:@selector(switchTapped:)
        forControlEvents:UIControlEventValueChanged];
    cell.accessoryView = switchObj;
    
    // カスタムセルを返します。
    return cell;
}

/*
 アラーム項目の一つが選ばれた。
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SettingViewController *settingCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingView"];
    settingCtl.detailItem = indexPath;
    settingCtl.managedObjectContext = self.managedObjectContext;
    settingCtl.alarmData = [array objectAtIndex:indexPath.row];
    [[self navigationController] pushViewController:settingCtl animated:YES];
}


/*
 項目削除。
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"editingStyle == UITableViewCellEditingStyleDelete");
        
        //選択されたイベントを削除する
        NSManagedObject *eventToDelete = [array objectAtIndex:indexPath.row];
        [self.managedObjectContext deleteObject:eventToDelete];
        
        
        //配列とTable Viewを更新する。
        [array removeObjectAtIndex:indexPath.row];
        
        NSLog(@"%@", array);
        
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"add Event エラー");
            abort();
        }
        
        
        //テーブルのビューを更新
        [self.suggestionTableView reloadData];
        
        
        
    }
    
}


/*
 自分が登録したアラームの編集可能にする
 */
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    //	return own;
    return YES;
    
}

- (NSUInteger)countForEntityName:(NSString*)entitylName
{
	NSFetchRequest* request = [[NSFetchRequest alloc] init];
	[request setEntity:[NSEntityDescription entityForName:entitylName
								   inManagedObjectContext:self.managedObjectContext]];
	[request setIncludesSubentities:NO];
	
	NSError* error = nil;
	NSUInteger count =
    [self.managedObjectContext countForFetchRequest:request error:&error];
	if (count == NSNotFound) {
		count = 0;
	}
	
	return count;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSArray* objects=[touches allObjects];
    CGPoint pos=[[objects objectAtIndex:0] locationInView:self.view];
    
    if (pos.y >= 0 && pos.y < displayHeight * 0.5) {
        UIActionSheet *sheet = [[UIActionSheet alloc] init];
        sheet.delegate = self;
        
        if ([defaults integerForKey:@"PUSH_ONOFF"] == 1) {
            [sheet addButtonWithTitle:@"連打機能:ON"];
            sheet.destructiveButtonIndex = 0;
        }
        else {
            [sheet addButtonWithTitle:@"連打機能:OFF"];
            sheet.destructiveButtonIndex = 2;
        }
        [sheet addButtonWithTitle:@"キャンセル"];
        sheet.cancelButtonIndex = 1;
        
        [sheet showFromRect:CGRectMake(0, 100, 320, 480) inView:self.view animated:YES];
    }

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString* message;
    
    if (buttonIndex == 0) {
        switch ([defaults integerForKey:@"PUSH_ONOFF"]) {
            case 0:
                message = @"連打機能をONにします";
                break;
            
            case 1:
                message = @"連打機能をOFFにします";
                break;
                
            default:
                break;
        }
    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message message:@"よろしいですか？" delegate:self cancelButtonTitle:@"いいえ" otherButtonTitles:@"はい",nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if ([defaults integerForKey:@"PUSH_ONOFF"] == 1) {
            [defaults setInteger:0 forKey:@"PUSH_ONOFF"];
        } else {
            [defaults setInteger:1 forKey:@"PUSH_ONOFF"];
        }
    }
}


- (void)addAlarm
{
    if ([array count] >= 5) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"アラームの最大設定数は5つまでです。" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
//        self.listPlate.image = [UIImage imageNamed:@"waku01.png"];
        [self.view setNeedsDisplay];
        return;
    }
    
    AlarmData *newManagedObject = (AlarmData *)[NSEntityDescription insertNewObjectForEntityForName:@"AlarmData" inManagedObjectContext:self.managedObjectContext];
    
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *comp = [calendar
                              components:(NSYearCalendarUnit|
                                          NSMonthCalendarUnit|
                                          NSDayCalendarUnit|
                                          NSHourCalendarUnit|
                                          NSMinuteCalendarUnit|
                                          NSSecondCalendarUnit) fromDate:nowDate];
    
    comp.hour = 7;
    comp.minute = 0;
    comp.day += 1;
    comp.second = 0;
    
    [newManagedObject setValue:[calendar dateFromComponents:comp] forKey:@"time"];
    
    int newId = [self countForEntityName:@"AlarmData"] -1;
    [newManagedObject setValue:[NSNumber numberWithInt:newId] forKey:@"id"];
    [newManagedObject setValue:[NSNumber numberWithInt:1] forKey:@"alarmvoice"];
    [newManagedObject setValue:[NSNumber numberWithInt:1] forKey:@"finishvoice"];
    [newManagedObject setValue:[NSNumber numberWithBool:YES]  forKeyPath:@"on"];
    [newManagedObject setValue:[NSNumber numberWithInt:127]  forKeyPath:@"repeat"];
    
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"add Event エラー");
        abort();
    }
    
    [array addObject:newManagedObject];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AlarmData" inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:entity];
    [request setFetchBatchSize:20];
    
    for (int i = 0; i < [array count]; i++) {
        AlarmData *alarmData = [array objectAtIndex:i];
        NSLog(@"AlarmData all=>%@", alarmData.time);
    }
    
    
    //テーブルのビューを更新
    [self.suggestionTableView reloadData];
}


- (void)digitalClock:(NSTimer *)timer
{
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned flags = NSWeekdayCalendarUnit| NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *todayComponents = [calendar components:flags fromDate:today];
    int hour = [todayComponents hour];
    int min = [todayComponents minute];
    int sec = [todayComponents second];    
    
    if ([array count] != 0) {
        for (int i = 0; i <= [array count] -1; i++) {
            
            AlarmData *alarmData = [array objectAtIndex:i];
            
            NSDateComponents *alarmComponents = [calendar components:flags fromDate:alarmData.time];
            int alarmhour = [alarmComponents hour];
            int alarmmin = [alarmComponents minute];
            int alarmsec = [alarmComponents second];
            
            NSArray *selectedWeek = [DaysOfWeek getNotifDaysArray:[alarmData.repeat intValue]];
            BOOL weekdayFlag = [selectedWeek containsObject:[NSNumber numberWithInteger:todayComponents.weekday - 1]];
            
            
            if (hour == alarmhour && min == alarmmin && sec == alarmsec && [alarmData.on boolValue] && weekdayFlag) {
                    
                WakeUpViewController *wakeupCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"WakeUpView"];
                [wakeupCtl setFromNotifFlag:1];
                [wakeupCtl setAlarmVoiceID:[alarmData.alarmvoice intValue]];
                [wakeupCtl setFinishVoiceID:[alarmData.finishvoice intValue]];
                [appDelegate hideTabBar:YES];
                [appDelegate.tabBarController setSelectedIndex:0];
                [[self navigationController] pushViewController:wakeupCtl animated:YES];
                [self.navigationController setNavigationBarHidden:YES];
            }
        }
    }
}


- (IBAction)switchTapped:(id)sender;
{
    UISwitch *tableSwitch = (UISwitch *)sender;
    UITableViewCell *switchCell = (UITableViewCell *)[tableSwitch superview];
    //    UISwitch *switchNum = (UISwitch *)[switchCell viewWithTag:kSwitchTag];
    BOOL swOn = tableSwitch.on;
    NSUInteger switchRow = [[self.suggestionTableView indexPathForCell:switchCell] row];
    NSLog(@"switchNum=>%d switchRow=>%d switch=>%d", tableSwitch.tag, switchRow, swOn);
    
    AlarmData *data = [array objectAtIndex:tableSwitch.tag];
    data.on = [NSNumber numberWithBool:tableSwitch.on];
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"add Event エラー");
        abort();
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AlarmData" inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:entity];
    [request setFetchBatchSize:20];
    
    for (int i = 0; i < [array count]; i++) {
        AlarmData *alarmData = [array objectAtIndex:i];
        NSLog(@"AlarmData all=>%@", alarmData);
    }
    
    //    [request release];
    
}


- (IBAction)pushAddAlarmBtn:(id)sender {
    [self addAlarm];
}

- (IBAction)moveWakeUpView:(id)notificaion {
    WakeUpViewController *wakeupCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"WakeUpView"];
    [wakeupCtl setAlarmVoiceID:1];
    [wakeupCtl setFinishVoiceID:1];
    [[self navigationController] pushViewController:wakeupCtl animated:YES];
}
@end
