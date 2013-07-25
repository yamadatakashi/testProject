//
//  AlarmAppDelegate.m
//  HiromiGoAlarmClock
//
//  Created by 山田 卓史 on 2013/04/08.
//  Copyright (c) 2013年 SWEET ROOM. All rights reserved.
//

#import "AlarmAppDelegate.h"
#import "AlarmViewController.h"
#import "DaysOfWeek.h"
#import "AlarmData.h"
#import "WakeUpViewController.h"
#import "OptionViewController.h"
#import "GlobalSettinViewController.h"
#import "GalleryViewController.h"

@implementation AlarmAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize navigationController;
@synthesize tabBarController = _tabBarController;
@synthesize songDataFromCoreData = _songDataFromCoreData;

- (void) hideTabBar:(Boolean)hiddenTabBar {
[UIView beginAnimations:nil context:NULL];
[UIView setAnimationDuration:1.0];
//for(UIView *view in self.tabBarController.view.subviews)
//{
//        CGRect _rect = view.frame;
//        if([view isKindOfClass:[UITabBar class]])
//        {
//            if (hiddenTabBar) {
//                _rect.origin.y = 431;
//                [view setFrame:_rect];
//            } else {
//                _rect.origin.y = 584;
//                [view setFrame:_rect];
//            }
//        } else {
//            if (hiddenTabBar) {
//                _rect.size.height = 431;
//                [view setFrame:_rect];
//            } else {
//                _rect.size.height = 584;
//                [view setFrame:_rect];
//            }
//        }
//    [UIView commitAnimations];
//    }
//    hiddenTabBar = !hiddenTabBar;
    if (hiddenTabBar) {
//		self.tabBarController.tabBar.hidden = YES;
		for(UIView *view in self.tabBarController.view.subviews)
		{
			CGRect _frame = view.frame;
			if(![view isKindOfClass:[UITabBar class]])
			{
                CGRect r = [[UIScreen mainScreen] bounds];
				_frame.size.height = r.size.height;
				[view setFrame:_frame];
			}
            else {
                CGRect r = [[UIScreen mainScreen] bounds];
                _frame.origin.y = r.size.height + 15;
                [view setFrame:_frame];

            }
		}
	}
	else {
//		self.tabBarController.tabBar.hidden = NO;
		for(UIView *view in self.tabBarController.view.subviews)
		{
			CGRect _frame = view.frame;
			if(![view isKindOfClass:[UITabBar class]])
			{
                CGRect r = [[UIScreen mainScreen] bounds];
				_frame.size.height = r.size.height;
				[view setFrame:_frame];
			}
            else {
                CGRect r = [[UIScreen mainScreen] bounds];
                _frame.origin.y = r.size.height - 50;
                [view setFrame:_frame];
                
            }
		}
	}
    [UIView commitAnimations];
}

- (void)setMainView:(UIApplication *)application checkNotif:(UILocalNotification *)notification{
    UIStoryboard *storyboard;
    NSString * storyBoardName;
    
    CGRect r = [[UIScreen mainScreen] bounds];
    
    if(r.size.height == 480){
        storyBoardName = @"MainStoryboard_Old";
    }else{
        storyBoardName =@"MainStoryboard";
    }
    
    storyboard = [UIStoryboard storyboardWithName:storyBoardName bundle:nil];
    
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    
    //それぞれのViewControllerを初期化
    AlarmViewController *alarmViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainAlarmView"];
    GalleryViewController *galleryViewController = [storyboard instantiateViewControllerWithIdentifier:@"GalleryView"];
    GlobalSettinViewController *globalSettinViewController = [storyboard instantiateViewControllerWithIdentifier:@"GlobalSettingView"];
    OptionViewController *optionViewController = [storyboard instantiateViewControllerWithIdentifier:@"OptionView"];
    
    
    //それぞれNavigationControllerにセット
    //一個ずつ配列に追加していきます。
    UINavigationController *firstNavi = [[UINavigationController alloc] initWithRootViewController:alarmViewController];
    [firstNavi setNavigationBarHidden:YES]; //今回は最初のタブだけナビゲーションバーを非表示に設定。
    [viewControllers addObject:firstNavi];
    
    UINavigationController *secondNavi = [[UINavigationController alloc] initWithRootViewController:galleryViewController];
    [secondNavi setNavigationBarHidden:YES];
    [viewControllers addObject:secondNavi];
    
    UINavigationController *thirdNavi = [[UINavigationController alloc] initWithRootViewController:globalSettinViewController];
    [thirdNavi setNavigationBarHidden:YES];
    [viewControllers addObject:thirdNavi];
    
    UINavigationController *fourthNavi = [[UINavigationController alloc] initWithRootViewController:optionViewController];
    [fourthNavi setNavigationBarHidden:YES];
    [viewControllers addObject:fourthNavi];
    
    //最後にTabBarをセットして完了です。
    self.tabBarController = [[UITabBarController alloc] init];
    [self.tabBarController setViewControllers:viewControllers];
    
    for(UIView *view in self.tabBarController.view.subviews)
    {
        CGRect _frame = view.frame;
        if(![view isKindOfClass:[UITabBar class]])
        {
            CGRect r = [[UIScreen mainScreen] bounds];
            _frame.size.height = r.size.height;
            [view setFrame:_frame];
        }
        else {
            CGRect r = [[UIScreen mainScreen] bounds];
            _frame.origin.y = r.size.height - 50;
            [view setFrame:_frame];
            
        }
    }

    //タブバー情報を取得
    UITabBar *tabBar = self.tabBarController.tabBar;
    
    UIImage *selectedImage01 = [UIImage imageNamed:@"btn_alarmset_on.png"];
    UIImage *unselectedImage01 = [UIImage imageNamed:@"btn_alarmset_off.png"];
    UITabBarItem *item01 = [tabBar.items objectAtIndex:0]; //1番左のタブが0、順に増やして下さい
    [item01 setFinishedSelectedImage:selectedImage01 withFinishedUnselectedImage:unselectedImage01];
    
    UIImage *selectedImage02 = [UIImage imageNamed:@"btn_gallery_on.png"];
    UIImage *unselectedImage02 = [UIImage imageNamed:@"btn_gallery_off.png"];
    UITabBarItem *item02 = [tabBar.items objectAtIndex:1]; //1番左のタブが0、順に増やして下さい
    [item02 setFinishedSelectedImage:selectedImage02 withFinishedUnselectedImage:unselectedImage02];
    
    UIImage *selectedImage03 = [UIImage imageNamed:@"btn_setting_on.png"];
    UIImage *unselectedImage03 = [UIImage imageNamed:@"btn_setting_off.png"];
    UITabBarItem *item03 = [tabBar.items objectAtIndex:2]; //1番左のタブが0、順に増やして下さい
    [item03 setFinishedSelectedImage:selectedImage03 withFinishedUnselectedImage:unselectedImage03];
    
    UIImage *selectedImage04 = [UIImage imageNamed:@"btn_option_on.png"];
    UIImage *unselectedImage04 = [UIImage imageNamed:@"btn_option_off.png"];
    UITabBarItem *item04 = [tabBar.items objectAtIndex:3]; //1番左のタブが0、順に増やして下さい
    [item04 setFinishedSelectedImage:selectedImage04 withFinishedUnselectedImage:unselectedImage04];
    //    self.tabBarController.tabBar.hidden = YES;
    
    //    if (notification != nil) {
    
    self.window.rootViewController = self.tabBarController;
    
    //    }
    
    tabBarController.selectedIndex = 0;
    
    [self.window makeKeyAndVisible];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults boolForKey:@"PUSH_ONOFF_FIRSTSET"]) {
        [defaults setBool:YES forKey:@"PUSH_ONOFF_FIRSTSET"];
        [defaults setInteger:1 forKey:@"PUSH_ONOFF"];
    }
    
    
    if (notification != nil) {
        NSArray *array = [notification.userInfo objectForKey:@"key_id"];
        int alarmVoiceID = [[array objectAtIndex:0] intValue];
        int finishVoiceID = [[array objectAtIndex:1] intValue];
        
        application.applicationIconBadgeNumber = 0;
        [[UIApplication sharedApplication] cancelLocalNotification:notification];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        WakeUpViewController *wakeupCtl = [storyboard instantiateViewControllerWithIdentifier:@"WakeUpView"];
        [wakeupCtl setFromNotifFlag:1];
        [wakeupCtl setAlarmVoiceID:alarmVoiceID];
        [wakeupCtl setFinishVoiceID:finishVoiceID];
        [firstNavi pushViewController:wakeupCtl animated:YES];
        [self hideTabBar:YES];
        [self.navigationController setNavigationBarHidden:YES];
    }
    
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
//    UIStoryboard *storyboard;
//    NSString * storyBoardName;
//    
//    CGRect r = [[UIScreen mainScreen] bounds];
//    
//    if(r.size.height == 480){
//        storyBoardName = @"MainStoryboard_Old";
//    }else{
//        storyBoardName =@"MainStoryboard";
//    }
//    
//    storyboard = [UIStoryboard storyboardWithName:storyBoardName bundle:nil];
//    
//    
//    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
//    //    navigationController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
//    //    [self.window addSubview:navigationController.view];
//    //
//    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
//    
//    //それぞれのViewControllerを初期化
//    AlarmViewController *alarmViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainAlarmView"];
//    GalleryViewController *galleryViewController = [storyboard instantiateViewControllerWithIdentifier:@"GalleryView"];
//    GlobalSettinViewController *globalSettinViewController = [storyboard instantiateViewControllerWithIdentifier:@"GlobalSettingView"];
//    OptionViewController *optionViewController = [storyboard instantiateViewControllerWithIdentifier:@"OptionView"];
//    
//    
//    //それぞれNavigationControllerにセット
//    //一個ずつ配列に追加していきます。
//    UINavigationController *firstNavi = [[UINavigationController alloc] initWithRootViewController:alarmViewController];
//    [firstNavi setNavigationBarHidden:YES]; //今回は最初のタブだけナビゲーションバーを非表示に設定。
//    [viewControllers addObject:firstNavi];
//    
//    UINavigationController *secondNavi = [[UINavigationController alloc] initWithRootViewController:galleryViewController];
//    [viewControllers addObject:secondNavi];
//    
//    UINavigationController *thirdNavi = [[UINavigationController alloc] initWithRootViewController:globalSettinViewController];
//    [viewControllers addObject:thirdNavi];
//    
//    UINavigationController *fourthNavi = [[UINavigationController alloc] initWithRootViewController:optionViewController];
//    [viewControllers addObject:fourthNavi];
//    
//    //最後にTabBarをセットして完了です。
//    self.tabBarController = [[UITabBarController alloc] init];
//    [self.tabBarController setViewControllers:viewControllers];
//    
//    //タブバー情報を取得
//    UITabBar *tabBar = self.tabBarController.tabBar;
//    
//    UIImage *selectedImage01 = [UIImage imageNamed:@"btn_alarmset_on.png"];
//    UIImage *unselectedImage01 = [UIImage imageNamed:@"btn_alarmset_off.png"];
//    UITabBarItem *item01 = [tabBar.items objectAtIndex:0]; //1番左のタブが0、順に増やして下さい
//    [item01 setFinishedSelectedImage:selectedImage01 withFinishedUnselectedImage:unselectedImage01];
//    
//    UIImage *selectedImage02 = [UIImage imageNamed:@"btn_gallery_on.png"];
//    UIImage *unselectedImage02 = [UIImage imageNamed:@"btn_gallery_off.png"];
//    UITabBarItem *item02 = [tabBar.items objectAtIndex:1]; //1番左のタブが0、順に増やして下さい
//    [item02 setFinishedSelectedImage:selectedImage02 withFinishedUnselectedImage:unselectedImage02];
//    
//    UIImage *selectedImage03 = [UIImage imageNamed:@"btn_setting_on.png"];
//    UIImage *unselectedImage03 = [UIImage imageNamed:@"btn_setting_off.png"];
//    UITabBarItem *item03 = [tabBar.items objectAtIndex:2]; //1番左のタブが0、順に増やして下さい
//    [item03 setFinishedSelectedImage:selectedImage03 withFinishedUnselectedImage:unselectedImage03];
//    
//    UIImage *selectedImage04 = [UIImage imageNamed:@"btn_option_on.png"];
//    UIImage *unselectedImage04 = [UIImage imageNamed:@"btn_option_off.png"];
//    UITabBarItem *item04 = [tabBar.items objectAtIndex:3]; //1番左のタブが0、順に増やして下さい
//    [item04 setFinishedSelectedImage:selectedImage04 withFinishedUnselectedImage:unselectedImage04];
//    
//    //    if (notification != nil) {
//    
//    self.window.rootViewController = self.tabBarController;
//    
//    //    }
//    
//    tabBarController.selectedIndex = 0;
//    
//    [self.window makeKeyAndVisible];
//    
//    NSArray *array = [notification.userInfo objectForKey:@"key_id"];
//    int alarmVoiceID = [[array objectAtIndex:0] intValue];
//    int finishVoiceID = [[array objectAtIndex:1] intValue];
//    
//    application.applicationIconBadgeNumber = 0;
//    [[UIApplication sharedApplication] cancelLocalNotification:notification];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    
//    WakeUpViewController *wakeupCtl = [storyboard instantiateViewControllerWithIdentifier:@"WakeUpView"];
//    [wakeupCtl setFromNotifFlag:1];
//    [wakeupCtl setAlarmVoiceID:alarmVoiceID];
//    [wakeupCtl setFinishVoiceID:finishVoiceID];
//    [firstNavi pushViewController:wakeupCtl animated:YES];
//    [self.navigationController setNavigationBarHidden:YES];
    [self setMainView:application checkNotif:notification];



}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 画面の生成
//    _viewController = [storyboard instantiateViewControllerWithIdentifier:@"MainAlarmView"];
    
    UILocalNotification *notification;
    notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    

    
//    UIStoryboard *storyboard;
//    NSString * storyBoardName;
//    
//    CGRect r = [[UIScreen mainScreen] bounds];
//    
//    if(r.size.height == 480){
//        storyBoardName = @"MainStoryboard_Old";
//    }else{
//        storyBoardName =@"MainStoryboard";
//    }
//    
//    storyboard = [UIStoryboard storyboardWithName:storyBoardName bundle:nil];
//    
//
//    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
////    navigationController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
////    [self.window addSubview:navigationController.view];
////    
//    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
//    
//    //それぞれのViewControllerを初期化
//    AlarmViewController *alarmViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainAlarmView"];
//    GalleryViewController *galleryViewController = [storyboard instantiateViewControllerWithIdentifier:@"GalleryView"];
//    GlobalSettinViewController *globalSettinViewController = [storyboard instantiateViewControllerWithIdentifier:@"GlobalSettingView"];
//    OptionViewController *optionViewController = [storyboard instantiateViewControllerWithIdentifier:@"OptionView"];
//
//    
//    //それぞれNavigationControllerにセット
//    //一個ずつ配列に追加していきます。
//    UINavigationController *firstNavi = [[UINavigationController alloc] initWithRootViewController:alarmViewController];
//    [firstNavi setNavigationBarHidden:YES]; //今回は最初のタブだけナビゲーションバーを非表示に設定。
//    [viewControllers addObject:firstNavi];
//    
//    UINavigationController *secondNavi = [[UINavigationController alloc] initWithRootViewController:galleryViewController];
//    [viewControllers addObject:secondNavi];
//    
//    UINavigationController *thirdNavi = [[UINavigationController alloc] initWithRootViewController:globalSettinViewController];
//    [viewControllers addObject:thirdNavi];
//    
//    UINavigationController *fourthNavi = [[UINavigationController alloc] initWithRootViewController:optionViewController];
//    [viewControllers addObject:fourthNavi];
//    
//    //最後にTabBarをセットして完了です。
//    self.tabBarController = [[UITabBarController alloc] init];
//    [self.tabBarController setViewControllers:viewControllers];
//    
//    //タブバー情報を取得
//    UITabBar *tabBar = self.tabBarController.tabBar;
//    
//    UIImage *selectedImage01 = [UIImage imageNamed:@"btn_alarmset_on.png"];
//    UIImage *unselectedImage01 = [UIImage imageNamed:@"btn_alarmset_off.png"];
//    UITabBarItem *item01 = [tabBar.items objectAtIndex:0]; //1番左のタブが0、順に増やして下さい
//    [item01 setFinishedSelectedImage:selectedImage01 withFinishedUnselectedImage:unselectedImage01];
//    
//    UIImage *selectedImage02 = [UIImage imageNamed:@"btn_gallery_on.png"];
//    UIImage *unselectedImage02 = [UIImage imageNamed:@"btn_gallery_off.png"];
//    UITabBarItem *item02 = [tabBar.items objectAtIndex:1]; //1番左のタブが0、順に増やして下さい
//    [item02 setFinishedSelectedImage:selectedImage02 withFinishedUnselectedImage:unselectedImage02];
//    
//    UIImage *selectedImage03 = [UIImage imageNamed:@"btn_setting_on.png"];
//    UIImage *unselectedImage03 = [UIImage imageNamed:@"btn_setting_off.png"];
//    UITabBarItem *item03 = [tabBar.items objectAtIndex:2]; //1番左のタブが0、順に増やして下さい
//    [item03 setFinishedSelectedImage:selectedImage03 withFinishedUnselectedImage:unselectedImage03];
//    
//    UIImage *selectedImage04 = [UIImage imageNamed:@"btn_option_on.png"];
//    UIImage *unselectedImage04 = [UIImage imageNamed:@"btn_option_off.png"];
//    UITabBarItem *item04 = [tabBar.items objectAtIndex:3]; //1番左のタブが0、順に増やして下さい
//    [item04 setFinishedSelectedImage:selectedImage04 withFinishedUnselectedImage:unselectedImage04];
////    self.tabBarController.tabBar.hidden = YES;
//    
////    if (notification != nil) {
//
//    self.window.rootViewController = self.tabBarController;
//    
////    }
//
//    tabBarController.selectedIndex = 0;
//    
//    [self.window makeKeyAndVisible];
//    
//
//    if (notification != nil) {
//        NSArray *array = [notification.userInfo objectForKey:@"key_id"];
//        int alarmVoiceID = [[array objectAtIndex:0] intValue];
//        int finishVoiceID = [[array objectAtIndex:1] intValue];
//        
//        application.applicationIconBadgeNumber = 0;
//        [[UIApplication sharedApplication] cancelLocalNotification:notification];
//        [[NSNotificationCenter defaultCenter] removeObserver:self];
//        
//        WakeUpViewController *wakeupCtl = [storyboard instantiateViewControllerWithIdentifier:@"WakeUpView"];
//        [wakeupCtl setFromNotifFlag:1];
//        [wakeupCtl setAlarmVoiceID:alarmVoiceID];
//        [wakeupCtl setFinishVoiceID:finishVoiceID];
//        [firstNavi pushViewController:wakeupCtl animated:YES];
//        
//        [self.navigationController setNavigationBarHidden:YES];
//    }
    
    [self setMainView:application checkNotif:notification];
    NSMutableArray *songDataArray = [self getCsvData:@"songdata"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL isFirstStartBool = [defaults boolForKey:@"FIRST_START_KEY_BOOL"];
    
    if (!isFirstStartBool) {
        [defaults setBool:YES forKey:@"FIRST_START_KEY_BOOL"];
        [defaults synchronize];

        if (![defaults boolForKey:@"PUSH_ONOFF_FIRSTSET"]) {
            [defaults setBool:YES forKey:@"PUSH_ONOFF_FIRSTSET"];
            [defaults setInteger:1 forKey:@"PUSH_ONOFF"];
        }
        
        for (int i = 0; i < songDataArray.count; i++) {
            NSManagedObject *songDataObject = [NSEntityDescription insertNewObjectForEntityForName:@"SongData" inManagedObjectContext:self.managedObjectContext];
            
            
            NSArray *songLoadData = [songDataArray objectAtIndex:i];
            
            int songID = [[songLoadData objectAtIndex:0] intValue];
            NSLog(@"ID:%d NAME:%@", songID , [songLoadData objectAtIndex:1]);
            
            [songDataObject setValue:[NSNumber numberWithInt:songID] forKey:@"songID"];
            [songDataObject setValue:[songLoadData objectAtIndex:1] forKey:@"songName"];
            [songDataObject setValue:[NSNumber numberWithInt:0] forKey:@"times"];
        }
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"add Event エラー");
            abort();
        }
        else {
        self.songDataFromCoreData = [[NSMutableArray alloc] init];
        self.songDataFromCoreData = [self getCoreData:@"SongData"];
        NSLog(@"songDataFromCoreData:%@", self.songDataFromCoreData);
        }

    }
    
    return YES;
}

- (NSMutableArray *)getCoreData:(NSString *)name {
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    //        NSEntityDescription *entityWatchList = [NSEntityDescription entityForName:@"Watch" inManagedObjectContext:self.managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:name inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    [request setFetchBatchSize:20];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"songID" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    NSError *error = nil;
    dataArray = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    return dataArray;
}

- (NSMutableArray *)getCsvData:(NSString *)name {
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSString *csvFile = [[NSBundle mainBundle] pathForResource:name ofType:@"csv"];
    NSData *csvData = [NSData dataWithContentsOfFile:csvFile];
    NSString *csv = [[NSString alloc] initWithData:csvData encoding:NSUTF8StringEncoding];
    NSScanner *scanner = [NSScanner scannerWithString:csv];
    NSCharacterSet *charaSet = [NSCharacterSet newlineCharacterSet];
    NSString *lineData;
    
    while (![scanner isAtEnd]) {
        [scanner scanUpToCharactersFromSet:charaSet intoString:&lineData];
        NSArray *array = [lineData componentsSeparatedByString:@","];
        [dataArray addObject:array];
        [scanner scanCharactersFromSet:charaSet intoString:NULL];
    }
    
    return dataArray;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
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
        arrayData = [[NSMutableArray alloc] init];
    }
    else {
        arrayData = mutableFetchResult;
    }
    
    NSInteger repeartCount = 7;
    NSDate *today = [NSDate date];
    NSDate *date;
    NSString *dateString;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents;
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd HH:mm";
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"yyyy-MM-dd";
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
//    [timeFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"US"]];
//    [timeFormat setLocale:[NSLocale systemLocale]];
//    [timeFormat setTimeZone:[NSTimeZone systemTimeZone]];
    timeFormat.dateFormat = @"HH:mm";
    
    UILocalNotification *notify = [[UILocalNotification alloc] init];
    NSLog(@"arrayData:%@", arrayData);
    
    if ([arrayData count] != 0) {
        
        for (int i = 0; i <= [arrayData count] -1; i++) {
            AlarmData *alarmData = [arrayData objectAtIndex:i];
            NSArray *selectedWeek = [DaysOfWeek getNotifDaysArray:[alarmData.repeat intValue]];
            
            if ([alarmData.on intValue] == 1) {
                
                for (NSInteger i = 0; i < repeartCount; i++) {
                    date = [today dateByAddingTimeInterval:i * 24 * 60 * 60];
                    dateComponents = [calendar components:NSWeekdayCalendarUnit fromDate:date];
                    
                    if ([selectedWeek containsObject:[NSNumber numberWithInteger:dateComponents.weekday - 1]]) {
                        dateString = [NSString stringWithFormat:@"%@ %@",
                                      [dateFormat stringFromDate:date],
                                      [timeFormat stringFromDate:alarmData.time]];
                        
                        if ([today compare:[format dateFromString:dateString]] == NSOrderedAscending) {
                            notify.fireDate = [format dateFromString:dateString];
                            notify.timeZone = [NSTimeZone defaultTimeZone];
                            notify.hasAction = YES;
//                            notify.repeatInterval = NSMinuteCalendarUnit;
                            
                            NSString *soundName;
                            int alarmVoiceID = [alarmData.alarmvoice intValue];
                            
                            
                            
                            if (alarmVoiceID == 4) {
                                //                                srand((unsigned int)time(NULL));
                                alarmVoiceID = arc4random() % 2 + 1;
                                NSLog(@"%@, alarmVoiceID => %d", @"random", alarmVoiceID);
                                
                            }
                            
                            soundName = [NSString stringWithFormat:@"alarm0%d.caf" ,alarmVoiceID];
                            notify.soundName = soundName;
                            notify.alertBody = @"時間になりました！";
                            notify.alertAction = @"アラーム停止";
                            
                            NSArray *value = [NSArray arrayWithObjects:alarmData.alarmvoice, alarmData.finishvoice, nil];
                            notify.userInfo = [NSDictionary dictionaryWithObject:value forKey:@"key_id"];
                            UIApplication *app = [UIApplication sharedApplication];
                            app.applicationIconBadgeNumber = 0;
                            [app scheduleLocalNotification:notify];
                            
                            NSLog(@"NotifID => %d, time => %@", i, [format dateFromString:dateString]);

                        }
                    }
                }
            }
        }
    }
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"AlarmData" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"AlarmData.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return __persistentStoreCoordinator;
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
