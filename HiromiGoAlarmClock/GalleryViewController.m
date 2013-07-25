//
//  GalleryViewController.m
//  HiromiGoAlarmClock
//
//  Created by 山田 卓史 on 2013/07/12.
//  Copyright (c) 2013年 SWEET ROOM. All rights reserved.
//

#import "GalleryViewController.h"
#import "CollectionCell.h"

@interface GalleryViewController ()

@end

@implementation GalleryViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*セクションの数*/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

/*セクションに応じたセルの数*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 20;
}

#pragma mark -
#pragma mark UICollectionViewDataSource

/*セルの内容を返す*/
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionCell *cell = (CollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    int imageNum = indexPath.row + 1;
    
    NSString *zeroStr;
    if(imageNum <= 9) {
        zeroStr = @"000";
    }
    else if (imageNum >= 10 && imageNum <= 99) {
        zeroStr = @"00";
    }
    else {
        zeroStr = @"0";
    }
    
    NSString *imageName = [NSString stringWithFormat:@"go_thum_%@%d.png",zeroStr, imageNum];
    [cell setImage:[UIImage imageNamed:imageName]];
//    [cell hiddenlockImage];
    return cell;
}

@end
