//
//  WeekDayViewController.m
//  HiromiGoAlarmClock
//
//  Created by 山田 卓史 on 2013/06/05.
//  Copyright (c) 2013年 SWEET ROOM. All rights reserved.
//

#import "WeekDayViewController.h"
#import "SettingViewController.h"
#import "DaysOfWeek.h"

@interface WeekDayViewController ()

@end

@implementation WeekDayViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize alarmData = _alarmData;
@synthesize navigationBar;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *backButton = [UIButton buttonWithType:101];
    backButton.showsTouchWhenHighlighted = NO;
    [backButton addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@"戻る" forState:UIControlStateNormal];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.navigationItem.title = @"リピート";
    self.navigationItem.leftBarButtonItem = backBarButton;
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];

    _tableData = [[NSMutableArray alloc] initWithCapacity:0];
    
    [_tableData addObject:@"月曜日(Monday)"];
    [_tableData addObject:@"火曜日(Tuesday)"];
    [_tableData addObject:@"水曜日(Wednesday)"];
    [_tableData addObject:@"木曜日(Thursday)"];
    [_tableData addObject:@"金曜日(Friday)"];
    [_tableData addObject:@"土曜日(Saturday)"];
    [_tableData addObject:@"日曜日(Sunday)"];
    
    _selectedData = [[NSMutableArray alloc] init];
    mDays = [self.alarmData.repeat intValue];
    NSLog(@"%d", mDays);
    
    _selectedData = [[NSMutableArray alloc] initWithArray:[DaysOfWeek getBooleanArray:mDays]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"setting_back_image.png"]];
    tableView.backgroundView = imageView;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [_tableData count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier];
    }
    
    if ([_selectedData containsObject:[NSNumber numberWithInteger:indexPath.row]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    cell.textLabel.text = [_tableData objectAtIndex:indexPath.row];
    return cell;

}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedCell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (selectedCell.accessoryType == UITableViewCellAccessoryNone) {
        selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        [_selectedData addObject:[NSNumber numberWithInteger:indexPath.row]];
        mDays = [DaysOfWeek set:indexPath.row checkBool:YES repeatData:mDays];
    } else {
        if ([_selectedData count] <= 1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"すべてのチェックを外すことは出来ません" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
        [_selectedData removeObject:[NSNumber numberWithInteger:indexPath.row]];
        selectedCell.accessoryType = UITableViewCellAccessoryNone;
        mDays = [DaysOfWeek set:indexPath.row checkBool:NO repeatData:mDays];
    }
    
    self.alarmData.repeat = [NSNumber numberWithInt:mDays];
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"add Event エラー");
        abort();
    }

}

- (void)closeButtonClicked
{
    SettingViewController *settingCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingView"];
    settingCtl.managedObjectContext = self.managedObjectContext;
    settingCtl.alarmData = self.alarmData;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
