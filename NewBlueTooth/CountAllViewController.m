//
//  CountAllViewController.m
//  NewBlueTooth
//
//  Created by  on 16/1/15.
//  Copyright © 2016年 starlinktech. All rights reserved.
//

#import "CountAllViewController.h"
#import "CountStepsTableView.h"
#import "StepData.h"
#import "StepDataDB.h"

#define kColor [UIColor colorWithRed:241/255.0 green:145/255.0 blue:66/255.0 alpha:1]

@interface CountAllViewController ()

@property (nonatomic, strong) CountStepsTableView *tableView;
@property (nonatomic, strong) NSMutableArray *allDataArray;//保存所有计步数据数组
@property (nonatomic, strong) StepData *tempStep;



@end

@implementation CountAllViewController
{
    UILabel *all;
    
    int allHistorySteps;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"计步器";
    
    self.allDataArray = [[NSMutableArray alloc]init];
    all.text = @"0";
    
    [self initView];

//    [self createData];
    
    [self readData];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateSteps:) name:@"getstep" object:nil];
    
    
    // Do any additional setup after loading the view.
}

#pragma mark - 数据库相关操作

- (void)clearData {
    [StepDataDB deleteData];
}


#pragma mark --- 更新总步数的通知处理方法
- (void)updateSteps:(NSNotification *)notice{
    NSDictionary *par=notice.object;
    NSString *steps = [par objectForKey:@"getstep"];
    NSInteger  currcentHistory = allHistorySteps + [steps integerValue];
    all.text = [NSString stringWithFormat:@"%ld",(long)currcentHistory];
    
}

- (void)createData {

}

//读取所有记录并计算总步数
- (void)readData {
    [StepDataDB findData:^(NSArray *result) {
        int allSteps = 0;
        for (int i = 0; i < result.count; i++) {
            StepData *data = [[StepData alloc]init];
            data = result[i];
            [self.allDataArray addObject:data];
            allSteps += data.steps;
        }
        
        if (self.tempSteps != 0) {
           StepData *temp = [[StepData alloc]init];
            temp.starTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"startTime"];
            temp.endTime = nil;
            temp.steps = self.tempSteps;
            [self.allDataArray addObject:temp];
        }
        
        NSArray *array = [[self.allDataArray reverseObjectEnumerator]allObjects];
        
        self.tableView.allDataArray = array;
        [self.tableView reloadData];

        
        /**
         *  此循环用于统计累积步数
         */
        allHistorySteps = 0;
        for (int i = 0; i<array.count; i++) {
            StepData *data = [[StepData alloc]init];
            data = array[i];
            allHistorySteps += data.steps;
        }
        all.text = [NSString stringWithFormat:@"%d",allHistorySteps];
        

    }];
}

- (NSString *)getWeek:(NSDate *)inputDate {

    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
}

- (NSString *)getDate:(NSDate *)inputDate {
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYYMMdd"];
    NSString *locationString=[dateformatter stringFromDate:inputDate];
    NSString *yearStr = [locationString substringToIndex:4];
    NSRange range1 = NSMakeRange(4, 2);
    NSString *monthStr = [locationString substringWithRange:range1];
    NSString *dayStr = [locationString substringFromIndex:6];
    NSString *dayYearMonStr = [NSString stringWithFormat:@"%@/%@/%@",yearStr,monthStr,dayStr];
    return dayYearMonStr;
}

- (void)initView {
    CGFloat height = self.navigationController.navigationBar.frame.size.height;
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, height, self.view.frame.size.width, self.view.frame.size.height/7*3)];
    bgView.backgroundColor = kColor;
    
    [self.view addSubview:bgView];
    
    UIImageView *whiteLineView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bgView.frame.size.height - 70, bgView.frame.size.height - 70)];
    whiteLineView.center = CGPointMake(bgView.center.x, bgView.center.y+10);                                                   
    whiteLineView.image = [UIImage imageNamed:@"1111"];
    whiteLineView.backgroundColor = kColor;
    whiteLineView.layer.cornerRadius = (bgView.frame.size.height - 70)/2.0;
    [self.view insertSubview:whiteLineView aboveSubview:bgView];
    
    all = [[UILabel alloc]initWithFrame:CGRectMake(0, whiteLineView.frame.size.height/4, whiteLineView.frame.size.width, 50)];
    all.textAlignment = NSTextAlignmentCenter;
    all.text = @"53596";
    all.font = [UIFont systemFontOfSize:35];
    all.textColor = [UIColor orangeColor];
    [whiteLineView addSubview:all];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(all.frame), whiteLineView.frame.size.width - 60, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [whiteLineView addSubview:line];
    
    UILabel *msg = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), whiteLineView.frame.size.width, 30)];
    msg.text = @"累积步数";
    msg.textAlignment = NSTextAlignmentCenter;
    msg.font = [UIFont systemFontOfSize:16];
    [whiteLineView addSubview:msg];
    
    UILabel *recent = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(bgView.frame), self.view.frame.size.width, 50)];
    recent.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    recent.text = @"  最近记录";
    recent.textColor = [UIColor grayColor];
    [self.view addSubview:recent];
    
    self.tableView = [[CountStepsTableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(recent.frame), self.view.frame.size.width, self.view.frame.size.height - bgView.frame.size.height - 80) style:UITableViewStylePlain];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
