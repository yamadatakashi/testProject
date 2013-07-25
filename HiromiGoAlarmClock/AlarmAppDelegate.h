//
//  AlarmAppDelegate.h
//  HiromiGoAlarmClock
//
//  Created by 山田 卓史 on 2013/04/08.
//  Copyright (c) 2013年 SWEET ROOM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AlarmViewController;
@class WakeUpView;
@class AlarmData;

@interface AlarmAppDelegate : UIResponder <UIApplicationDelegate> {
    NSMutableArray *arrayData;  //CoreData配列
    UITabBarController *tabBarController;
    //    BOOL hiddenTabBar;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) AlarmViewController *viewController;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) UINavigationController *navigationController;
@property (strong, nonatomic) WakeUpView *wakeUpViewController;
@property (strong,nonatomic) UITabBarController *tabBarController;
@property (nonatomic, strong) NSMutableArray *songDataFromCoreData;


- (void) hideTabBar:(Boolean)hiddenTabBar;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
@end
