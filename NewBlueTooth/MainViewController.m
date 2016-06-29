
//
//  MainViewController.m
//  Hawak
//
//  Created by  on 16/1/14.
//  Copyright © 2016年 StarLink. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"
#import "NSUserDefaults+Klanguage.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "TemperatureViewController.h"
#import "CountAllViewController.h"
#import "StepData.h"
#import "StepDataDB.h"

#define UIScreenHeight [UIScreen mainScreen].bounds.size.height
#define UIScreenWidth [UIScreen mainScreen].bounds.size.width

@interface MainViewController (){
    
    UIImageView *imageView;
    NSInteger width1;
    NSInteger superWidth;
    NSInteger  Height;
    NSInteger changeInt;
    NSInteger changeInts;
    NSInteger topheight;
    NSInteger doubleWidth;
    UIImageView *lightImgView1;
    UIImageView *lightImgView2;
    UILabel *temlashow1;
    UILabel *temlashow2;
    UILabel *hualashow1;
    UILabel *hualashow2;
    
    
    UIButton *stopOrstarBt;
     NSInteger allSteps;//保存所有步数,可实时更新
    TemperatureViewController *temperature;
    

    
    
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    if (UIScreenWidth == 320) {
        
        width1 = 15;
        superWidth = 25;
        Height = 504;
        topheight = 180;
        doubleWidth = 100;
        if (UIScreenHeight == 480) {
            topheight = 150;
            Height = 416;
            doubleWidth =85;
        }
        
    }else {
        
        width1 = 25;
        superWidth = 40;
        Height = UIScreenHeight - 64;
        topheight = 200;
        doubleWidth = 120;
    }
    changeInt = 1;
    changeInts = 1;
    
    [self createbackground];
    
    //导航栏的修改
    [self rendNaviBar];
    
    //日期
    [self getTimeorUI];
    
    //三大模块
    [self createThreePart];
    
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updatesteps:) name:@"getstep" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(leftupdatetemper:) name:@"leftgettemper" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(rightupdatetemper:) name:@"rightgettemper" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getbatterlevel:) name:@"getbatterlevel" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updatesteps:) name:@"getstep" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updatesteps:) name:@"getRightStep" object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    

}


//得到步数
- (void)updatesteps:(NSNotification *)notification {
    id steps = notification.object;
    NSInteger left = [[steps objectForKey:@"getstep"] integerValue];
    NSInteger right = [[steps objectForKey:@"getRightStep"] integerValue];
    
    if (left>right) {
        allSteps = left;
    }else {
        allSteps = right;
    }
    NSLog(@"实时步数为%d",(int)allSteps);
}

//得到电量
- (void)getbatterlevel:(NSNotification *)notification{
    id batter = notification.object;
    self.battryarr =[batter objectForKey:@"getbatterlevel"];
    NSLog(@"这块板子的电量为:%@",self.battryarr);
    if ([self.battryarr doubleValue] > 25.0){
        
        lightImgView1.image = [UIImage imageNamed:@"leftgreenfoot"];
        
    }else {
        lightImgView1.image = [UIImage imageNamed:@"leftredfoot1"];
        
        [NSTimer scheduledTimerWithTimeInterval:0.45 target:self selector:@selector(changeAction2) userInfo:nil repeats:YES];
        
    }
    if ([self.battryarr  doubleValue] > 25.0) {
        
        lightImgView2.image = [UIImage imageNamed:@"rightgreenfoot"];
        
        
    }else {
        
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(changeAction1) userInfo:nil repeats:YES];
        [lightImgView2 setImage:[UIImage imageNamed:@"rightredfoot1"]];
        
    }
    
   }


//得到温度
-(void)leftupdatetemper:(NSNotification *)noti
{
    NSDictionary *par=noti.object;
    self.currenttemperarr = [par objectForKey:@"leftgettemper"];
    
    temlashow1.text = [NSString stringWithFormat:@"%0.1f", [self.currenttemperarr doubleValue]];
    temlashow2.text = [NSString stringWithFormat:@"%0.1f", [self.currenttemperarr doubleValue] *1.8 +32];
    hualashow1.text = [NSString stringWithFormat:@"%0.1f", [self.currenttemperarr doubleValue]];
    hualashow2.text = [NSString stringWithFormat:@"%0.1f", [self.currenttemperarr doubleValue] *1.8 +32];
   }


-(void)rightupdatetemper:(NSNotification *)noti
{
    NSDictionary *par=noti.object;
    self.currenttemperarr = [par objectForKey:@"rightgettemper"];

    temlashow1.text = [NSString stringWithFormat:@"%0.1f", [self.currenttemperarr doubleValue]];
    temlashow2.text = [NSString stringWithFormat:@"%0.1f", [self.currenttemperarr doubleValue] *1.8 +32];
    hualashow1.text = [NSString stringWithFormat:@"%0.1f", [self.currenttemperarr doubleValue]];
    hualashow2.text = [NSString stringWithFormat:@"%0.1f", [self.currenttemperarr doubleValue] *1.8 +32];
}



- (void)createbackground
{
    
    //背景图片
    UIScrollView *scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)];
    scrollview.contentSize = CGSizeMake(UIScreenWidth, Height);
    [self.view addSubview:scrollview];
    scrollview.showsVerticalScrollIndicator = NO;
    scrollview.bounces = NO;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth, Height)];
    imageView.image =  [UIImage imageNamed:@"leadbackgroundImg"];
    imageView.userInteractionEnabled = YES;
    [scrollview addSubview:imageView];
    
}

- (void)rendNaviBar{
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    UIImageView *ImgHead = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    ImgHead.image = [UIImage imageNamed:@"titlehead"];
    self.navigationItem.titleView = ImgHead;
    
}

- (void)getTimeorUI{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYYMMdd"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    NSString *  yearStr = [locationString substringToIndex:4];
    NSRange range1 = NSMakeRange(4, 2);
    NSString *  monthStr = [locationString substringWithRange:range1];
    NSString *  dayStr = [locationString substringFromIndex:6];
    
    
    //创建时间的UI
    UILabel *daylabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 60, 60)];
    daylabel.font = [UIFont systemFontOfSize:45];
    daylabel.text = dayStr;
    [imageView addSubview:daylabel];
    
    //得到当前系统下为星期几
    UILabel *weekday = [[UILabel alloc]initWithFrame:CGRectMake(70, 35, 80, 25)];
    weekday.textColor = [UIColor whiteColor];
    [imageView addSubview:weekday];
    weekday.font = [UIFont systemFontOfSize: 15];
    NSString *weekdayStr =[MainViewController weekdayStringFromDate:senddate];
    weekday.text = weekdayStr;
    
    UILabel *yearMonlabel  = [[UILabel alloc]initWithFrame:CGRectMake(70, 60, 60, 25)];
    yearMonlabel.textColor = [UIColor whiteColor];
    [imageView addSubview:yearMonlabel];
    yearMonlabel.font = [UIFont systemFontOfSize: 15];
    NSString *yearMonStr = [NSString stringWithFormat:@"%@/%@",monthStr,yearStr];
    yearMonlabel.text = yearMonStr;
    
    //语言设置
    NSLocale *locale = [NSLocale currentLocale];
    NSString * localName1 = [locale localeIdentifier];
    NSLog(@"%@",localName1);
    
    if ([localName1 isEqualToString:@"zh-Hant_CN"]||[localName1 isEqualToString:@"zh_CN"]) {//中文
        //下方的文字
        UILabel *passlabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 100, 120, 25)];
        passlabel.textColor = [UIColor whiteColor];
        [imageView addSubview:passlabel];
        UILabel *passlabel1 = [[UILabel alloc]initWithFrame:CGRectMake(105, 125, 100, 25)];
        passlabel1.textColor = [UIColor whiteColor];
        [imageView addSubview:passlabel1];
        passlabel.text = @"为了你的脚得到更";
        passlabel1.text = @"舒服的环境。";
        passlabel.font = [UIFont systemFontOfSize: 15];
        passlabel1.font = [UIFont systemFontOfSize:15];
    }else {//英文
        //下方的文字
        UILabel *passlabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 90, 180, 25)];
        passlabel.textColor = [UIColor whiteColor];
        [imageView addSubview:passlabel];
        UILabel *passlabel1 = [[UILabel alloc]initWithFrame:CGRectMake(60, 110, 200, 25)];
        passlabel1.textColor = [UIColor whiteColor];
        [imageView addSubview:passlabel1];
        passlabel.text = @"To comfort your foot,";
        passlabel1.text = @"as health care your body";
        passlabel.font = [UIFont systemFontOfSize: 15];
        passlabel1.font = [UIFont systemFontOfSize:15];
        
        
    }
    
}

//创建下方的三大模块
- (void)createThreePart{
    
    //第一个温度模块
    UIImageView *imageview1 = [[UIImageView alloc]initWithFrame:CGRectMake(superWidth ,topheight , UIScreenWidth- 2*superWidth, 80)];
    imageview1.contentMode = UIViewContentModeScaleAspectFit;
    imageview1.image = [UIImage imageNamed:@"partbackground"];
    imageview1.userInteractionEnabled = YES;
    [imageView addSubview:imageview1];
    
    UIImageView *temImgView1 = [[UIImageView alloc]initWithFrame:CGRectMake(width1, 5, 70, 70)];
    temImgView1.image = [UIImage imageNamed:@"temperatureCircle"];
    temImgView1.userInteractionEnabled = YES;
    [imageview1 addSubview: temImgView1];
    
    temlashow1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 45, 25)];
    temlashow1.textColor = [UIColor whiteColor];
    temlashow1.font = [UIFont systemFontOfSize:19];
    [temImgView1 addSubview:temlashow1];
    
    
    temlashow2 = [[UILabel alloc]initWithFrame:CGRectMake(30, 35, 45, 25)];
    temlashow2.textColor = [UIColor whiteColor];
    temlashow2.font = [UIFont systemFontOfSize:19];
    [temImgView1 addSubview:temlashow2];
    
    UIImageView *temImgView2 = [[UIImageView alloc]initWithFrame:CGRectMake(imageview1.frame.size.width - 70 - width1, 5, 70, 70)];
    temImgView2.image = [UIImage imageNamed:@"temperatureCircle"];
    temImgView2.userInteractionEnabled = YES;
    UITapGestureRecognizer *temperatureTap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(temperatureAction1)];
    UITapGestureRecognizer *temperatureTap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(temperatureAction2)];
    [temImgView1 addGestureRecognizer:temperatureTap1];
    [temImgView2 addGestureRecognizer:temperatureTap2];
    
    
    [imageview1 addSubview: temImgView2];
    hualashow1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 45, 25)];
    hualashow1.textColor = [UIColor whiteColor];
    hualashow1.font = [UIFont systemFontOfSize:19];
    [temImgView2 addSubview:hualashow1];
    
    hualashow2 = [[UILabel alloc]initWithFrame:CGRectMake(30, 35, 45, 25)];
    hualashow2.textColor = [UIColor whiteColor];
    hualashow2.font = [UIFont systemFontOfSize:19];
    [temImgView2 addSubview:hualashow2];
    
    temlashow1.text = [NSString stringWithFormat:@"%0.1f", [self.currenttemperarr doubleValue]];
    hualashow1.text = [NSString stringWithFormat:@"%0.1f", [self.currenttemperarr doubleValue]];
    hualashow2.text = [NSString stringWithFormat:@"%0.1f", [self.currenttemperarr doubleValue] *1.8 +32];
    temlashow2.text = [NSString stringWithFormat:@"%0.1f", [self.currenttemperarr doubleValue] *1.8 +32];
    
    if (UIScreenWidth == 320) {
        temlashow1.font = [UIFont systemFontOfSize:13];
        hualashow1.font = [UIFont systemFontOfSize:13];
        temlashow2.font = [UIFont systemFontOfSize:13];
        hualashow2.font = [UIFont systemFontOfSize:13];
    }
    
    
    UIImageView *temImgView3 = [[UIImageView alloc]initWithFrame:CGRectMake(imageview1.frame.size.width/2 - 25, 15, 50, 50)];
    temImgView3.image = [UIImage imageNamed:@"xieline"];
    [imageview1 addSubview: temImgView3];
    
    UILabel *temlabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20,20)];
    temlabel1.textColor = [UIColor whiteColor];
    temlabel1.text = @"°C";
    [temImgView3 addSubview:temlabel1];
    
    UILabel *temlabel2 = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, 20, 20)];
    temlabel2.textColor = [UIColor whiteColor];
    temlabel2.text = @"°F";
    [temImgView3 addSubview:temlabel2];
    
    //第二个电量模块
    UIImageView *imageview2 = [[UIImageView alloc]initWithFrame:CGRectMake(superWidth ,topheight + doubleWidth , UIScreenWidth- 2* superWidth, 80)];
    imageview2.contentMode = UIViewContentModeScaleAspectFit;
    [imageView addSubview:imageview2];
    imageview2.image = [UIImage imageNamed:@"partbackground"];
    
    lightImgView1 = [[UIImageView alloc]initWithFrame:CGRectMake(width1, 5, 70, 70)];
    [imageview2 addSubview: lightImgView1];
    lightImgView2 = [[UIImageView alloc]initWithFrame:CGRectMake(imageview1.frame.size.width - width1 - 70, 5, 70, 70)];
    [imageview2 addSubview: lightImgView2];
    NSLog(@"%@",self.battryarr);
    
    if ([self.battryarr doubleValue] < 25.0) {
        lightImgView1.image = [UIImage imageNamed:@"leftredfoot1"];
        
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeAction2) userInfo:nil repeats:YES];

        
    }else {
        lightImgView1.image = [UIImage imageNamed:@"leftgreenfoot"];
        
    }
    
    if ([self.battryarr  doubleValue] > 25.0) {
        
        lightImgView2.image = [UIImage imageNamed:@"rightgreenfoot"];
        
        
    }else {
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeAction1) userInfo:nil repeats:YES];
        [lightImgView2 setImage:[UIImage imageNamed:@"rightredfoot1"]];
        
        
    }

    
    
    UIImageView *lightImgView3 = [[UIImageView alloc]initWithFrame:CGRectMake(imageview1.frame.size.width/2 - 40, 25, 80, 30)];
    lightImgView1.contentMode = UIViewContentModeScaleAspectFit;
    lightImgView3.image = [UIImage imageNamed:@"lightnesses"];
    [imageview2 addSubview: lightImgView3];
    
    
    
    //第三个连接蓝牙模块
    UIImageView *imageview3 = [[UIImageView alloc]initWithFrame:CGRectMake(superWidth ,topheight + 2*doubleWidth , UIScreenWidth- 2*superWidth, 80)];
    imageview3.contentMode = UIViewContentModeScaleAspectFit;
    [imageView addSubview:imageview3];
    imageview3.image = [UIImage imageNamed:@"partbackground"];
    
    UIImageView *blueImgView1 = [[UIImageView alloc]initWithFrame:CGRectMake(width1, 5, 70, 70)];
    blueImgView1.image = [UIImage imageNamed:@"leftredfoot"];
    [imageview3 addSubview: blueImgView1];
    blueImgView1.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap1Action)];
    [blueImgView1  addGestureRecognizer:tap1];
    
    
    UIImageView *blueImgView2 = [[UIImageView alloc]initWithFrame:CGRectMake(imageview1.frame.size.width - 70 - width1, 5, 70, 70)];
    blueImgView2.userInteractionEnabled = YES;
    blueImgView2.image = [UIImage imageNamed:@"rightredfoot"];
    [imageview3 addSubview: blueImgView2];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap1Action)];
    [blueImgView2 addGestureRecognizer:tap2];
    
    stopOrstarBt = [UIButton buttonWithType:UIButtonTypeCustom];
    stopOrstarBt.frame = CGRectMake(imageview3.frame.size.width/2 - 35, 25, 30, 30);
    [stopOrstarBt setBackgroundImage:[UIImage imageNamed:@"stopBt"] forState:UIControlStateNormal];
    [stopOrstarBt  setBackgroundImage:[UIImage imageNamed:@"starBt"] forState:UIControlStateSelected];
    [imageview3 addSubview:stopOrstarBt];
    imageview3.userInteractionEnabled = YES;
    [stopOrstarBt  addTarget:self action:@selector(stopOrStarAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *reverBt = [UIButton buttonWithType:UIButtonTypeCustom];
    reverBt.frame = CGRectMake(imageview3.frame.size.width/2 +5 , 25, 30, 30);
    [reverBt setBackgroundImage:[UIImage imageNamed:@"revertBt"] forState:UIControlStateNormal];
    [imageview3 addSubview:reverBt];
    [reverBt  addTarget:self action:@selector(reverAction) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)changeAction1{
    
    if (changeInt == 1){
        
        [lightImgView2 setImage:[UIImage imageNamed:@"rightredfoot1"]];
        changeInt = 0;
        
    }else{
        
        [lightImgView2 setImage:[UIImage imageNamed:@"rightredfoot"]];
        changeInt = 1;
    }
}

- (void)changeAction2{
    
    if (changeInts == 1){
        
        [lightImgView1 setImage:[UIImage imageNamed:@"leftredfoot"]];
        changeInts = 0;
        
    }else{
        
        [lightImgView1 setImage:[UIImage imageNamed:@"leftredfoot1"]];
        changeInts = 1;
    }
    
}


//获取系统当前的星期几的方法
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    
    NSArray *weekdays;
    NSLocale *locale = [NSLocale currentLocale];
    NSString * localName1 = [locale localeIdentifier];
    if ([localName1 isEqualToString:@"zh-Hant_CN"]||[localName1 isEqualToString:@"zh_CN"]) {
        
        weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    }else {
        
        weekdays = [NSArray arrayWithObjects: [NSNull null], @"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", nil];
        
    }
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}
//控制开始与否的按钮方法
- (void)stopOrStarAction:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    
    /**
     *  开始计步后 保存当前步数
     */
    
    if (sender.selected == YES) {
        
        [self startDeviceStep];//让设备开始计步
        
        NSUserDefaults *currentAllSteps = [NSUserDefaults standardUserDefaults];
        [currentAllSteps setInteger:allSteps forKey:@"starSteps"];
        
        NSString *startTime = [self getTime];
        
        NSString *s = [[NSUserDefaults standardUserDefaults] objectForKey:@"startTime"];
        
        if (s.length == 0) {
            NSUserDefaults *start = [NSUserDefaults standardUserDefaults];
            [start setObject:startTime forKey:@"startTime"];
        }
        
        //        [timer fire];
        
    }
    else {
        
        //        [timer invalidate];
        
        NSUserDefaults *starSteps = [NSUserDefaults standardUserDefaults];
        NSInteger starSteps2 = [starSteps integerForKey:@"starSteps"];//当停止时取出保存的步数
        NSInteger oneStopSteps = allSteps - starSteps2;//停止后的暂时步数
        
        NSUserDefaults *lastStopSteps = [NSUserDefaults standardUserDefaults];
        NSInteger lastSteps = [lastStopSteps integerForKey:@"temporarySteps"];
        
        NSInteger sum = oneStopSteps + lastSteps;
        
        NSUserDefaults *tempSteps = [NSUserDefaults standardUserDefaults];
        [tempSteps setInteger:sum forKey:@"temporarySteps"];//把停止后的步数存起来
        
    }
    
    
}

//重置
- (void)reverAction{
    NSLog(@"REVERT");
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否重置计步器" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
}

//记步手势响应的方法
- (void)tap1Action{
    CountAllViewController *vc = [[CountAllViewController alloc]init];
    //    vc.steps = self.battryarr;
    
    //    NSInteger starSteps = [[NSUserDefaults standardUserDefaults] integerForKey:@"starSteps"];
    
    //    vc.tempSteps = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"temporarySteps"];
    //
    //        if (stopOrstarBt.selected == YES) {
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"starSteps"] > 0) {
        
        if (stopOrstarBt.selected == YES) {
            NSUserDefaults *starSteps = [NSUserDefaults standardUserDefaults];
            NSInteger starSteps2 = [starSteps integerForKey:@"starSteps"];//当停止时取出保存的步数
            NSInteger returnSteps = allSteps - starSteps2;//停止后的暂时步数
            
            NSUserDefaults *lastStopSteps = [NSUserDefaults standardUserDefaults];
            NSInteger lastSteps = [lastStopSteps integerForKey:@"temporarySteps"];
            
            NSInteger sum = returnSteps + lastSteps;
            
            vc.tempSteps = (int)sum;
        }else if (stopOrstarBt.selected == NO) {
            vc.tempSteps = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"temporarySteps"];
        }
        
        
        
        //        NSUserDefaults *tempSteps = [NSUserDefaults standardUserDefaults];
        //        [tempSteps setInteger:sum forKey:@"temporarySteps"];//把停止后的步数存起来
    }else {
        vc.tempSteps = (int)allSteps;
    }
    
    //        }
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tap2Action{
    //    TemperatureViewController *temperature = [[TemperatureViewController alloc]init];
    //
    //    [self.navigationController pushViewController:temperature animated:YES];
}

//温度手势的方法
- (void)temperatureAction1{
    NSLog(@"温度");
    if (temperature == nil) {
        temperature = [[TemperatureViewController alloc]init];

    }
    temperature.currPeripheralarr=self.currPeripheralarr;
    temperature.leftGetTempercha=self.leftGetTempercha;
    temperature.rightGetTempercha=self.rightGetTempercha;
    temperature.leftSetTempercha=self.leftSetTempercha;
    temperature.rightSetTempercha=self.rightSetTempercha;
    temperature.leftperipheral=self.leftperipheral;
    temperature.rightperipheral=self.rightperipheral;
    temperature.currenttemperstart = self.currenttemperarr;
    [self.navigationController pushViewController:temperature animated:YES];
    
    
    
}
- (void)temperatureAction2{
    if (temperature == nil) {
        temperature = [[TemperatureViewController alloc]init];
    }
    temperature.currPeripheralarr=self.currPeripheralarr;
    temperature.leftGetTempercha=self.leftGetTempercha;
    temperature.rightGetTempercha=self.rightGetTempercha;
    temperature.leftSetTempercha=self.leftSetTempercha;
    temperature.rightSetTempercha=self.rightSetTempercha;
    temperature.leftperipheral=self.leftperipheral;
    temperature.rightperipheral=self.rightperipheral;
    [self.navigationController pushViewController:temperature animated:YES];
    
}

- (NSString*)getTime {
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"YYYY/MM/dd HH:mm"];
    NSString *time = [dateformatter stringFromDate:[NSDate date]];
    return time;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        //        [timer invalidate];
        NSString *startTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"startTime"];
        
        if (startTime.length >0) {
            
            if (stopOrstarBt.selected == YES) {
                stopOrstarBt.selected = NO;
                /**
                 如果开始后没有暂停 直接重置也要保存数据
                 */
                
                NSUserDefaults *starSteps = [NSUserDefaults standardUserDefaults];
                NSInteger starSteps2 = [starSteps integerForKey:@"starSteps"];//当停止时取出保存的步数
                NSInteger returnSteps = allSteps - starSteps2;//停止后的暂时步数
                
                NSUserDefaults *lastStopSteps = [NSUserDefaults standardUserDefaults];
                NSInteger lastSteps = [lastStopSteps integerForKey:@"temporarySteps"];
                
                NSInteger sum = returnSteps + lastSteps;
                
                StepData *data = [[StepData alloc]init];
                data.steps = (int)sum;
                data.starTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"startTime"];
                data.endTime = [self getTime];
                [StepDataDB addData:data];
                
                NSUserDefaults *revert = [NSUserDefaults standardUserDefaults];
                [revert setInteger:0 forKey:@"temporarySteps"];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"startTime"];
                [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"starSteps"];
                
                //     allSteps = 0;
                [self revertDevice];
                return;
            }
            
            
            StepData *data = [[StepData alloc]init];
            NSUserDefaults *storeSteps = [NSUserDefaults standardUserDefaults];
            data.steps = (int)[storeSteps integerForKey:@"temporarySteps"];
            data.starTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"startTime"];
            data.endTime = [self getTime];
            [StepDataDB addData:data];
            
            NSUserDefaults *revert = [NSUserDefaults standardUserDefaults];
            [revert setInteger:0 forKey:@"temporarySteps"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"startTime"];
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"starSteps"];
            
            [self revertDevice];
        }
        //        allSteps = 0;
    } else {   //重置设备
        [self revertDevice];
    }
}


/**
 *  设备开始计步
 */
- (void)startDeviceStep {
    Byte b= 0X02;
  
    NSData *data=[NSData dataWithBytes:&b length:sizeof(b)];
    
    for (CBPeripheral *per in self.currPeripheralarr) {
        NSArray *characarr = per.services;
        for (CBService *servce  in characarr) {
            NSArray *charactarr = servce.characteristics;
            for (CBCharacteristic *character in charactarr) {
                UInt16 getsteps=[self swap:0xFFA5];
                NSData *getstepsdata=[[NSData alloc]initWithBytes:(char *)&getsteps length:2];
                CBUUID *getstepspid = [CBUUID UUIDWithData:getstepsdata];
                if ([character.UUID isEqual:getstepspid]) {
                    [per writeValue:data forCharacteristic:self.leftOpStepCount type:CBCharacteristicWriteWithResponse];
                    
                    
                }
            }
            
        }
        
    }
    
}

-(UInt16) swap:(UInt16)s {
    UInt16 temp = s << 8;
    temp |= (s >> 8);
    return temp;
}


/**
 *  将设备计步重置
 */
- (void)revertDevice {
    allSteps = 0;

    Byte bs = 0x03;
    Byte b = 0x01;
    NSData *data1=[NSData dataWithBytes:&bs length:sizeof(bs)];
    NSData *data=[NSData dataWithBytes:&b length:sizeof(b)];
    for (CBPeripheral *per in self.currPeripheralarr) {
        NSArray *characarr = per.services;
        for (CBService *servce  in characarr) {
            NSArray *charactarr = servce.characteristics;
            for (CBCharacteristic *character in charactarr) {
                UInt16 getsteps=[self swap:0xFFA5];
                NSData *getstepsdata=[[NSData alloc]initWithBytes:(char *)&getsteps length:2];
                CBUUID *getstepspid = [CBUUID UUIDWithData:getstepsdata];
                if ([character.UUID isEqual:getstepspid]) {
 
                    [per writeValue:data1 forCharacteristic:self.leftOpStepCount type:CBCharacteristicWriteWithResponse];
                    [per writeValue:data forCharacteristic:self.leftOpStepCount type:CBCharacteristicWriteWithResponse];
                }
            }
            
        }
        
    }
    
}





@end
