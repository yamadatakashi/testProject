//
//  SuggestionCell.h
//  Alarm
//
//  Created by 山田 卓史 on 12/02/06.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuggestionCell : UITableViewCell {
    
    UILabel* _timeLabel;
    UILabel* _detailLabel;
}

@property (nonatomic, retain) IBOutlet UILabel* timeLabel;
@property (retain, nonatomic) IBOutlet UILabel *detailLabel;

@end
