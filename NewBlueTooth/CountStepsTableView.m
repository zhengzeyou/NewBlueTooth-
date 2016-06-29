//
//  CountStepsTableView.m
//  NewBlueTooth
//
//  Created by starlink on 16/1/15.
//  Copyright © 2016年 starlinktech. All rights reserved.
//

#import "CountStepsTableView.h"
#import "CountStepsTableViewCell.h"
#import "StepData.h"

@implementation CountStepsTableView
{
    NSString *_identify;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        UINib *cell = [UINib nibWithNibName:@"CountStepsTableViewCell" bundle:nil];
        _identify = @"TableViewCell";
        [self registerNib:cell forCellReuseIdentifier:_identify];
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.allDataArray.count<7) {
        return self.allDataArray.count;
    }
    return 7;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CountStepsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_identify];
//    cell.data = self.allDataArray[indexPath.row];
    if (self.allDataArray.count > 0) {
        StepData *data = self.allDataArray[indexPath.row];
        cell.timeLabel.text = data.starTime;
        cell.endTimeLabel.text = data.endTime;
        if (data.steps > 9999) {
            
            cell.stepsLabel.textColor = [UIColor colorWithRed:241/255.0 green:145/255.0 blue:66/255.0 alpha:1];
        }else {
            
            cell.stepsLabel.textColor = [UIColor colorWithRed:100/255.0 green:176/255.0 blue:68/255.0 alpha:1];
        }
        cell.stepsLabel.text = [NSString stringWithFormat:@"%d",data.steps];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
