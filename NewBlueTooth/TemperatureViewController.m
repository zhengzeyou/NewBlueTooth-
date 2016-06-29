//
//  TemperatureViewController.m
//  NewBlueTooth
//
//  Created by  on 16/1/15.
//  Copyright © 2016年 starlinktech. All rights reserved.
//

#import "TemperatureViewController.h"
#import "TemperatureView.h"

#import "NSString+Data.h"
#import "SVProgressHUD.h"


#define channelOnCharacteristicView @"CharacteristicView"


@interface TemperatureViewController ()
{
    int _temper;
    int _index;
    TemperatureView * _te;
    
    
}

@property (nonatomic ,strong)CBCharacteristic *characteristic;
@property (nonatomic ,strong)CBPeripheral *cbperipheral;
@property (nonatomic ,strong)NSString *currenttemper;
@property (nonatomic ,strong)NSTimer *timer;

@end

@implementation TemperatureViewController

-(void)viewWillAppear:(BOOL)animated
{

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updatetemper:) name:@"leftgettemper" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updatetemper1:) name:@"rightgettemper" object:nil];
    
    self.CTemperature.text = [NSString stringWithFormat:@"%0.1f°C", [self.currenttemperstart doubleValue]];
    self.FTemperature.text = [NSString stringWithFormat:@"%0.1f°F", [self.currenttemperstart doubleValue] *1.8 +32];
    
    NSUserDefaults *deflts= [NSUserDefaults standardUserDefaults];
    
     NSInteger s=[deflts integerForKey:@"remain"];
    
    [_te reloaddata:(int)s/100];
    
  }

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}



/**
 *  跟新当前温度
 *
 *  @param noti
 */
-(void)updatetemper:(NSNotification *)noti
{
    NSDictionary *par=noti.object;
    NSString *temper=[par objectForKey:@"leftgettemper"];
    self.CTemperature.text= [NSString stringWithFormat:@"%@°C",temper];
    self.FTemperature.text=[NSString stringWithFormat:@"%0.1f°F", [temper doubleValue] *1.8 +32];
    NSLog(@"%@",temper);
}

-(void)updatetemper1:(NSNotification *)noti
{
    NSDictionary *par=noti.object;
    NSString *temper=[par objectForKey:@"rightgettemper"];
    self.CTemperature.text= [NSString stringWithFormat:@"%@°C",temper];
    self.FTemperature.text=[NSString stringWithFormat:@"%0.1f°F", [temper doubleValue] *1.8 +32];
    NSLog(@"%@",temper);
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    
     __weak typeof(self) weakself=self;
    
    NSLog(@"%@",self.currPeripheralarr);

    
    
   _temper=[_currenttemper intValue];
    
   _te=[[TemperatureView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.currentlb.frame)+10, [UIScreen mainScreen].bounds.size.width-40, 80)];
   _te.Clickindex=^(int tag){
        NSLog(@"///////%ld",(long)tag);
        /**
         *  写数据
         */
       
       NSUserDefaults *defltse= [NSUserDefaults standardUserDefaults];
       NSInteger se=[defltse integerForKey:@"remain"];

       NSUserDefaults *deflts= [NSUserDefaults standardUserDefaults];
       [deflts setInteger:(NSInteger)tag forKey:@"remain"];
      
       Byte byte[] ={0X14,0X19,0X1E,0X23,0X28,0X2D,0X32,0X37,0X3C,0X41};

       NSLog(@"-------%hhu",byte[tag/100]);
       NSData *data=[NSData dataWithBytes:&byte[tag/100] length:sizeof(byte[tag/100])];
       
       if (se != tag) {
      
        for (CBPeripheral *per in weakself.currPeripheralarr) {
            if ([per isEqual:weakself.leftperipheral]) {
            [per writeValue:data forCharacteristic:weakself.leftSetTempercha type:CBCharacteristicWriteWithResponse];
            }else if ([per isEqual:weakself.rightperipheral])
            {
                
                [per writeValue:data forCharacteristic:weakself.rightSetTempercha type:CBCharacteristicWriteWithResponse];
            }

        }
            }
    };
    
    [self.view addSubview:_te];
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
