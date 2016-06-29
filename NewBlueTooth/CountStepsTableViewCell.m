//
//  CountStepsTableViewCell.m
//  NewBlueTooth
//
//  Created by starlink on 16/1/15.
//  Copyright © 2016年 starlinktech. All rights reserved.
//

#import "CountStepsTableViewCell.h"
#import "StepData.h"

#define kColor [UIColor colorWithRed:241/255.0 green:145/255.0 blue:66/255.0 alpha:1]


@implementation CountStepsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    if (_stepsLabel.text.length >= 5) {
        _stepsLabel.textColor = kColor;
    }else {
        _stepsLabel.textColor = [UIColor colorWithRed:100/255.0 green:176/255.0 blue:68/255.0 alpha:1];
    }
//    [self _time];
}


- (void)_time {
    NSDate *  senddate = [NSDate date];
    NSDateFormatter  *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYYMMdd"];
    NSString *  locationString = [dateformatter stringFromDate:senddate];
    NSLog(@"%@",locationString);
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
