//
//  SuggestionCell.m
//  Alarm
//
//  Created by 山田 卓史 on 12/02/06.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SuggestionCell.h"

@implementation SuggestionCell

@synthesize timeLabel = _timeLabel;
@synthesize detailLabel = _detailLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
//    [_timeLabel release];
//    [_detailLabel release];
//    [super dealloc];
}
@end
