//
//  CollectionCell.h
//  HermesCatalog
//
//  Created by 山田 卓史 on 12/12/10.
//  Copyright (c) 2012年 SWEET ROOM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlarmAppDelegate.h"

@interface CollectionCell : UICollectionViewCell
{
}
- (void)setImage:(UIImage *)image;
- (void)hiddenlockImage;
@property (weak, nonatomic) IBOutlet UIImageView *goImageView;
@property (weak, nonatomic) IBOutlet UIImageView *lockImageView;

@end
