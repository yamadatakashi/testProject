//
//  FinishVoiceEditViewController.m
//  HiromiGoAlarmClock
//
//  Created by 山田 卓史 on 2013/06/11.
//  Copyright (c) 2013年 SWEET ROOM. All rights reserved.
//

#import "FinishVoiceEditViewController.h"
#import "SettingViewController.h"
#import "DaysOfWeek.h"
#import "VoiceList.h"

#define MAX_VOICEDATA_NUM 7

@interface FinishVoiceEditViewController ()

@end

@implementation FinishVoiceEditViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize alarmData = _alarmData;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _tableData = [[NSMutableArray alloc] initWithCapacity:0];
    [_tableData addObjectsFromArray:[VoiceList finishVoiceSet]];
    

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    selectedSoundRow = [self.alarmData.finishvoice intValue] - 1;
    
    UIButton *backButton = [UIButton buttonWithType:101];
    backButton.showsTouchWhenHighlighted = NO;
    [backButton addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@"戻る" forState:UIControlStateNormal];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.navigationItem.title = @"クリアボイス選択";
    self.navigationItem.leftBarButtonItem = backBarButton;
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    
        
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    
    NSString *soundName;
    for (int i = 0; i < MAX_VOICEDATA_NUM; i++) {
        if (i < 7) {
            soundName = [NSString stringWithFormat:@"clear0%d" ,i + 1];
        }
//        else {
//            soundName = [NSString stringWithFormat:@"clear%d" ,i + 1];
//        }
        
        NSLog(@"soundName => %@", soundName);
        
        alarmPath = [[NSBundle mainBundle]pathForResource:soundName ofType:@"caf"];
        alarmURL = [NSURL fileURLWithPath:alarmPath];
        _soundPlayer[i] = [[AVAudioPlayer alloc] initWithContentsOfURL:alarmURL error:nil];
        _soundPlayer[i].numberOfLoops = 0;
        [_soundPlayer[i] prepareToPlay];
        _soundPlayer[i].delegate = self;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)closeButtonClicked
{
    SettingViewController *settingCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingView"];
    settingCtl.managedObjectContext = self.managedObjectContext;
    settingCtl.alarmData = self.alarmData;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"setting_back_image.png"]];
    tableView.backgroundView = imageView;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [_tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    if (selectedSoundRow == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
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
    if (selectedSoundRow != 7) {
        if (_soundPlayer[selectedSoundRow].play) {
            [_soundPlayer[selectedSoundRow] stop];
            _soundPlayer[selectedSoundRow].currentTime = 0;
            [_soundPlayer[selectedSoundRow] prepareToPlay];
        }
    }
    
    self.alarmData.finishvoice = [NSNumber numberWithInt:indexPath.row + 1];
    NSLog(@"finishvoice => %d index => %d", [self.alarmData.finishvoice intValue], indexPath.row + 1);
    
    for (NSInteger index = 0; index < [_tableData count]; index++) {
        UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        
        selectedCell.accessoryType = UITableViewCellAccessoryNone;
        
        if (indexPath.row == index) {
            selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
            selectedSoundRow = indexPath.row;
            
            if (index != 7) {
                [_soundPlayer[indexPath.row] play];
            }
        }
    }
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"add Event エラー");
        abort();
    }
}

@end
