//
//  CountStepsTableViewCell.h
//  NewBlueTooth
//
//  Created by starlink on 16/1/15.
//  Copyright © 2016年 starlinktech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountStepsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stepsLabel;

@end
