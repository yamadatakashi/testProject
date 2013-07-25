//
//  SettingViewController.m
//  HiromiGoAlarmClock
//
//  Created by 山田 卓史 on 2013/04/15.
//  Copyright (c) 2013年 SWEET ROOM. All rights reserved.
//

#import "SettingViewController.h"
#import "WeekDayViewController.h"
#import "AlarmVoiceEditViewController.h"
#import "FinishVoiceEditViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController
@synthesize naviBar;
@synthesize detailItem;
@synthesize alarmData = _alarmData;
@synthesize settingTable = _settingTable;
@synthesize managedObjectContext = _managedObjectContext;


- (void)showPicker {
    CGRect r = [[UIScreen mainScreen] bounds];
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationDelegate:self];
	datePicker.center = CGPointMake(160, r.size.height - 190);
	[UIView commitAnimations];
	
	// 右上にdoneボタン

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"OK" style:UIBarButtonItemStyleBordered target:self action:@selector(done:)];
    doneButton.title = @"OK";
    [navigationItem setRightBarButtonItem:doneButton animated:YES];
}


- (void)hidePicker {
    CGRect r = [[UIScreen mainScreen] bounds];

    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationDelegate:self];
	datePicker.center = CGPointMake(160, r.size.height + 190);
	[UIView commitAnimations];
    
	// doneボタンを消す
	[navigationItem setRightBarButtonItem:nil animated:YES];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc]init];
    [outputFormatter setDateFormat:@"HH:mm"];
    timeField.text = [outputFormatter stringFromDate:self.alarmData.time];
}

- (void)done:(id)sender {
	// ピッカーしまう
	[self hidePicker];
	
	// doneボタン消す
    [self.navigationItem setRightBarButtonItem:nil animated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    datePicker.center = CGPointMake(160, 1000);
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned flags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    NSDateComponents *todayComponents = [calendar components:flags fromDate:today];
    
    int month = [todayComponents month];
    int day = [todayComponents day];
    
    
    NSDate *alarmData = self.alarmData.time;
    NSDateComponents *comp = [calendar
                              components:(NSYearCalendarUnit|
                                          NSMonthCalendarUnit|
                                          NSDayCalendarUnit|
                                          NSHourCalendarUnit|
                                          NSMinuteCalendarUnit|
                                          NSSecondCalendarUnit) fromDate:alarmData];
    [comp setMonth:month];
    [comp setDay:day];
    
    datePicker.date = [calendar dateFromComponents:comp];
    
    NSLog(@"datailItem => %d ,datePicker.date => %@, alarmData => %@", [detailItem row] , datePicker.date, self.alarmData);

    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AlarmData" inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:entity];
    [request setFetchBatchSize:20];
    
    
    [self.settingTable reloadData];

}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.settingTable.dataSource = self;
	self.settingTable.delegate = self;
    
    UIButton *backButton = [UIButton buttonWithType:101];
    backButton.showsTouchWhenHighlighted = NO;
    [backButton addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@"戻る" forState:UIControlStateNormal];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];

    
    navigationItem = [[UINavigationItem alloc] initWithTitle:@"アラーム設定"];
    
    //    UIBarButtonItem *button;
    //    button = [[[UIBarButtonItem alloc] initWithTitle:@"Back"
    //                                               style:UIBarButtonItemStyleBordered
    //                                              target:self
    //                                              action:@selector(closeButtonClicked)] autorelease];
    navigationItem.leftBarButtonItem = backBarButton;
    
    [self.naviBar pushNavigationItem:navigationItem animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"setting_back_image.png"]];
    tableView.backgroundView = imageView;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;
    
    
    switch (indexPath.row) {
        case 0:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"alarmLabel"];
            if ( cell == nil ) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"alarmLabel"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            timeField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 60, cell.frame.size.height)];
            timeField.adjustsFontSizeToFitWidth = YES;
            timeField.keyboardType = UIKeyboardTypeDefault;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
            
            timeField.textColor = [UIColor colorWithRed:59.0/255.0 green:85.0/255.0 blue:133.0/255.0 alpha:1.0];
            timeField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            //            field.textAlignment = UITextAlignmentLeft;
            timeField.returnKeyType = UIReturnKeyDone;
            timeField.delegate = self;
            timeField.tag = 0;
            
            NSDateFormatter *outputFormatter = [[NSDateFormatter alloc]init];
            [outputFormatter setDateFormat:@"HH:mm"];
            timeField.text = [outputFormatter stringFromDate:self.alarmData.time];
            
            cell.accessoryView = timeField;
            break;
        }
        
        case 1:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"alarmLabel"];
            if ( cell == nil ) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"alarmLabel"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            field = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 220, cell.frame.size.height)];
            field.adjustsFontSizeToFitWidth = YES;
            field.keyboardType = UIKeyboardTypeDefault;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
            
            field.textColor = [UIColor colorWithRed:59.0/255.0 green:85.0/255.0 blue:133.0/255.0 alpha:1.0];
            field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            //            field.textAlignment = UITextAlignmentLeft;
            field.returnKeyType = UIReturnKeyDone;
            field.delegate = self;
            field.tag = 1;
            field.text = self.alarmData.label;
            
            cell.accessoryView = field;
            break;
        }
            
        case 2:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"repeat"];
            if ( cell == nil ) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"repeat"];
            }
//            cell.detailTextLabel.text = [DaysOfWeek repeatDataToString:[self.alarmData.repeat intValue]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
            
        case 3:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"alarmVoiceSelect"];
            if ( cell == nil ) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"alarmVoiceSelect"];
            }
//            cell.detailTextLabel.text = [VoiceList alarmVoiceNameToString:[self.alarmData.alarmvoice intValue]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            break;
        }
            
        case 4:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"clearVoiceSelect"];
            if ( cell == nil ) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"clearVoiceSelect"];
            }
//            cell.detailTextLabel.text = [VoiceList finishVoiceNameToString:[self.alarmData.finishvoice intValue]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
            

            
        default:
        {
            break;
    
        }
    }
    
    NSArray *array = [[NSArray alloc] initWithObjects:@"アラーム時刻", @"ラベル", @"繰り返し", @"アラームボイス選択", @"クリアボイス選択", nil];
    [cell.textLabel setText:[array objectAtIndex:indexPath.row]];
    
    
    return cell;
}

// return YESしないと編集モードがON出来ない
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

// 削除総裁に対応させる
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeekDayViewController *weekDayCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"WeekDayView"];
    AlarmVoiceEditViewController *AlarmVoiceCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"AlarmVoiceEditView"];
    FinishVoiceEditViewController *FinishVoiceCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"FinishVoiceEditView"];
    [self hidePicker];
    
    switch (indexPath.row) {
        case 0:
            [self saveTimeLabel];
            [self showPicker];
            break;
            
        case 1:
            [field becomeFirstResponder];
            break;
            
        case 2:
            weekDayCtl.managedObjectContext = self.managedObjectContext;
            weekDayCtl.alarmData = self.alarmData;
            [[self navigationController] pushViewController:weekDayCtl animated:YES];
            [self.navigationController setNavigationBarHidden:NO animated:NO];
            break;
            
        case 3:
            AlarmVoiceCtl.managedObjectContext = self.managedObjectContext;
            AlarmVoiceCtl.alarmData = self.alarmData;
            [[self navigationController] pushViewController:AlarmVoiceCtl animated:YES];
            [self.navigationController setNavigationBarHidden:NO animated:NO];
            break;
            
        case 4:
            FinishVoiceCtl.managedObjectContext = self.managedObjectContext;
            FinishVoiceCtl.alarmData = self.alarmData;
            [[self navigationController] pushViewController:FinishVoiceCtl animated:YES];
            [self.navigationController setNavigationBarHidden:NO animated:NO];
            break;
            
        default:
            break;
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    self.alarmData.label = textField.text;
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"add Event エラー");
        abort();
    }
    
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField.tag == 0) {
        [self showPicker];
        [self saveTimeLabel];        
        return NO;
    }
    else {
        if (![datePicker isHidden]) {
            [self hidePicker];
        }
        return YES;
    }
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self saveTimeLabel];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)closeButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];

    if (![field resignFirstResponder]) {
        [self saveTimeLabel];
    }
}
- (void) saveTimeLabel {
    [field resignFirstResponder];

    self.alarmData.label = field.text;
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"add Event エラー");
        abort();
    }
}

- (IBAction)setAlarm {
    
    
    if ([datePicker.date compare:[NSDate date]] == NSOrderedAscending ) {
        self.alarmData.time = [[NSDate alloc]initWithTimeInterval:24 * 60 * 60 sinceDate:datePicker.date];
        NSLog(@"%@" ,self.alarmData.time);
    } else {
        self.alarmData.time = datePicker.date;
        NSLog(@"%@" ,self.alarmData.time);
    }
    
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"add Event エラー");
        abort();
    }
    
}

- (IBAction)pushDeleteBtn:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"アラームを削除します" message:@"よろしいですか？" delegate:self cancelButtonTitle:@"いいえ" otherButtonTitles:@"はい",nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self deleteAlarm];
    }
}

- (void)deleteAlarm {
    [self.managedObjectContext deleteObject:self.alarmData];
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"add Event エラー");
        abort();
    }
    [self.navigationController popViewControllerAnimated:YES];

}

@end
