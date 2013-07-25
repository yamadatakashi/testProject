//
//  CollectionCell.m
//  HermesCatalog
//
//  Created by 山田 卓史 on 12/12/10.
//  Copyright (c) 2012年 SWEET ROOM. All rights reserved.
//

#import "CollectionCell.h"
#import "AlarmAppDelegate.h"

@implementation CollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setImage:(UIImage *)image
{
    [self.goImageView setImage:image];
}


- (void)hiddenlockImage {
    [self.lockImageView setHidden:YES];
}

@end

