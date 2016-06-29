//
//  MainViewController.m
//  BlueTooth
//
//  Created by  on 16/1/14.
//  Copyright © 2016年 starlinktech. All rights reserved.
//

#import "CheckPeripheral.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "MainViewController.h"
#import "FirstViewController.h"
#import "NSString+Data.h"
#import "SVProgressHUD.h"
#import "PeripheralChoose.h"


#define channelOnPeropheralView @"peripheralView"

@interface CheckPeripheral ()<CBCentralManagerDelegate,CBPeripheralDelegate>
{
       
    NSInteger totolfoot;
    
    BOOL isshan;
    
    NSString * str1;
    
    NSString *str2;
    
    NSString *str3;
    
    CGRect _MainScreenRect;
    
    NSInteger lefttem;
    NSInteger righttem;
    BOOL isLeft;
    BOOL isRight;
    MainViewController *main;

    

    
   
}

@property (nonatomic,strong)CBCentralManager *manager;

/**
 *  左脚
 */
@property (nonatomic,strong)CBPeripheral *leftperipheral;

@property (nonatomic,strong)CBPeripheral *rightperipheral;


/**
 *  发现到的外部设备
 */
@property (nonatomic,strong)NSMutableArray *FoundPeripherals;
/**
 *  已经连接上的外部设备
 */
@property (nonatomic,strong)NSMutableArray *connectedperipherals;

;



/**
 *  温度
 */
@property (nonatomic,strong)CBCharacteristic *leftGetTempercha;

@property (nonatomic,strong)CBCharacteristic *rightGetTempercha;

/**
 *  电量
 */
@property (nonatomic,strong)CBCharacteristic *leftbatterycha;
@property (nonatomic,strong)CBCharacteristic *rightbatterycha;

/**
 *  步数
 */
@property (nonatomic,strong)CBCharacteristic *leftstepcha;
@property (nonatomic,strong)CBCharacteristic *rightstepcha;

/**
 *  设置温度
 */
@property (nonatomic,strong)CBCharacteristic *leftSetTempercha;
@property (nonatomic,strong)CBCharacteristic *rightSetTempercha;

/**
 *  设置计步器
 */

@property (nonatomic,strong)CBCharacteristic *leftOpStepCount;
@property (nonatomic,strong)CBCharacteristic *rightOpStepCount;



@property (nonatomic,strong)NSTimer *timer;


@end


@implementation CheckPeripheral


-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
    [self.timer setFireDate:[NSDate distantPast]];
    isshan=NO;
    lefttem = -1;
    righttem = -1;
    isLeft = YES;
    isRight = YES;
    



}

-(void)viewDidAppear:(BOOL)animated
{
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.timer setFireDate:[NSDate distantFuture]];
}

-(UInt16) swap:(UInt16)s {
    UInt16 temp = s << 8;
    temp |= (s >> 8);
    return temp;
}


-(void)show{
    
    if (self.FoundPeripherals.count == 0) {
        [SVProgressHUD showInfoWithStatus:@"没有发现设备"];
        return;
    }
    
    PeripheralChoose *perichoose = [[PeripheralChoose alloc]initWithFrame:CGRectMake(0, 0,_MainScreenRect.size.width , _MainScreenRect.size.height)];
    perichoose.datasource =self.FoundPeripherals;
    __weak typeof(self) weakself=self;
    perichoose.click = ^(UITableView *table,NSIndexPath *indexpath){
        [weakself.manager connectPeripheral:weakself.FoundPeripherals[indexpath.row] options:nil];
    };
   
    [self.view addSubview:perichoose];

}

- (IBAction)clickleftfoot:(id)sender {
    
    [self show];
    
    
}


- (IBAction)clickrightfoot:(id)sender {
    [self show];
}


-(void)didshan
{
    @autoreleasepool {
        if (isshan==NO) {
        [self.LeftFoot setImage:[UIImage imageNamed:@"lefthighfoot"]];
        [self.RightFoot setImage:[UIImage imageNamed:@"righthighfoot"]];
        isshan=YES;
    }
    else if (isshan==YES) {
       
       if (self.connectedperipherals.count==1) {
           [self.LeftFoot setImage:[UIImage imageNamed:@"lefthighfoot"]];
           [self.RightFoot setImage:[UIImage imageNamed:@"rightfoot"]];
       }else if(self.connectedperipherals.count==2)
       {
           [self.LeftFoot setImage:[UIImage imageNamed:@"lefthighfoot"]];
           [self.RightFoot setImage:[UIImage imageNamed:@"righthighfoot"]];

       }else
       {
           [self.RightFoot setImage:[UIImage imageNamed:@"rightfoot"]];
           [self.LeftFoot setImage:[UIImage imageNamed:@"leftfoot"]];
        }
       
       isshan=NO;
       }
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _MainScreenRect = [UIScreen mainScreen].bounds;
    
    
    self.timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(didshan) userInfo:nil repeats:YES];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
    
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"left"] style:UIBarButtonItemStylePlain target:self action:@selector(bbleft)];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"right"] style:UIBarButtonItemStylePlain target:self action:@selector(bb)];
    
    [SVProgressHUD showInfoWithStatus:@"准备打开设备"];
    
    self.connectedperipherals=[NSMutableArray array];
    self.FoundPeripherals=[NSMutableArray array];
    
    self.manager=[[CBCentralManager alloc]initWithDelegate:self queue:nil options:nil];
    
}

#pragma CBCentralDelegate
/**
 *  系统蓝牙连接状态更新代理
 *
 *  @param central CBCentralManager
 */
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
        {
            [SVProgressHUD showInfoWithStatus:@"设备打开成功，开始扫描设备"];
            [_manager scanForPeripheralsWithServices:nil  options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
        }
            break;
        case CBCentralManagerStatePoweredOff:
            [SVProgressHUD showInfoWithStatus:@"蓝牙未打开，请先打开蓝牙"];
            break;
        default:
            break;
    }

}


/**
 *  扫描到蓝牙并且连接
 *
 *  @param central           CBCentralManager
 *  @param peripheral        CBPeripheral
 *  @param advertisementData
 *  @param RSSI
 */
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
       NSLog(@"%@",peripheral.name);
    /**
     *  连接到两只脚后，停止搜寻
     */
    if (self.connectedperipherals.count==2) {
        [self.manager stopScan];
    }
    
    if (self.FoundPeripherals.count == 0) {
        if ([peripheral.name containsString:@"ECOS"]) {
            
                [self.FoundPeripherals addObject:peripheral];
        }

    }else {
        if ([peripheral.name containsString:@"ECOS"]) {
            for (int i = 0;i<self.FoundPeripherals.count;i++) {
                CBPeripheral *per1 = self.FoundPeripherals[i];
                if ([per1.name isEqualToString: peripheral.name]) {
                    return;
                }
                
                [self.FoundPeripherals addObject:peripheral];

            }
        }

        
    }
}
/**
 *  设备连接成功后的代理
 *
 *  @param central
 *  @param peripheral
 */
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    
    if (self.connectedperipherals.count==2) {
       
        [self.manager stopScan];
        
    }
    
    if (self.connectedperipherals.count==1) {
        
        self.leftperipheral=peripheral;
        [self.connectedperipherals addObject:self.leftperipheral];
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@左边连接成功",peripheral.name]];

        
    }else
    {
        self.rightperipheral=peripheral;
        [self.connectedperipherals addObject:self.rightperipheral];
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@右边连接成功",peripheral.name]];

    }
    
    peripheral.delegate=self;
    [peripheral discoverServices:nil];
}

/**
 *  设备未能连接上的代理
 *
 *  @param central
 *  @param peripheral
 *  @param error
 */
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@连接失败",peripheral.name]];
    if (self.connectedperipherals.count<2) {
        [self.manager scanForPeripheralsWithServices:nil options:nil];
    }
}

/*
 *  设备连接上断开的代理
 *
 *  @param central
 *  @param peripheral
 *  @param error
 */
-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
        [self.connectedperipherals removeObject:peripheral];
        [self.manager scanForPeripheralsWithServices:nil options:nil];
}

#pragma CBPeripheral Delegate
/**
 *  发现到了设备的服务
 *
 *  @param peripheral
 *  @param error
 */
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    /**
     *  遍历service，搜索service的特征
     */
    for (CBService *s in peripheral.services) {
        [peripheral discoverCharacteristics:nil forService:s];
    }
}

/**
 *  发现到设备service的特征
 *
 *  @param peripheral
 *  @param service
 *  @param error
 */
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(nonnull CBService *)service error:(nullable NSError *)error
{
    for (CBCharacteristic *c in service.characteristics) {
        UInt16 GetTemper=[self swap:0xFFA2];
        UInt16 Getstep = [self swap:0xFFA6];
        UInt16 SetTemper=[self swap:0xFFA1];
        UInt16 Getbatter = [self swap:0x2A19];
        UInt16 OpStep = [self swap:0xFFA5];
        
        NSData *gettemperdata=[[NSData alloc]initWithBytes:(char *)&GetTemper length:2];
        NSData *settemperdata=[[NSData alloc]initWithBytes:(char *)&SetTemper length:2];
        NSData *getstepdata =[[NSData alloc]initWithBytes:(char *)&Getstep length:2];
        NSData *getbatterdata = [[NSData alloc]initWithBytes:(char *)&Getbatter length:sizeof(Getbatter)];
        NSData *opStepCount = [[NSData alloc]initWithBytes:(char *)&OpStep length:sizeof(OpStep)];
        
        CBUUID *gettemperid=[CBUUID UUIDWithData:gettemperdata];
        CBUUID *settemperid= [CBUUID UUIDWithData:settemperdata];
        CBUUID *getstepid= [CBUUID UUIDWithData:getstepdata];
        CBUUID *getbatterpid=[CBUUID UUIDWithData:getbatterdata];
        CBUUID *opStepCountID = [CBUUID UUIDWithData:opStepCount];
        
        if ([c.UUID isEqual:gettemperid]) {
            
            NSLog(@"------%@",c);
            if (peripheral==self.leftperipheral)
            {
                self.leftGetTempercha=c;
            }
            else if (peripheral==self.rightperipheral)
            {
                self.rightGetTempercha=c;
            }
            [peripheral setNotifyValue:YES forCharacteristic:c];
            
        }else if ([c.UUID isEqual:settemperid])
        {
            if (peripheral==self.leftperipheral) {
                
                self.leftSetTempercha=c;
                
            }
            else if (peripheral==self.rightperipheral)
            {
                self.rightSetTempercha=c;
            }
            
        }else if ([c.UUID isEqual:getstepid])
        {
            if (peripheral==self.leftperipheral)
            {
                self.leftstepcha=c;
            }
            else if (peripheral==self.rightperipheral)
            {
                self.rightstepcha=c;
            }

            [peripheral setNotifyValue:YES forCharacteristic:c];
        }else if ([c.UUID isEqual:getbatterpid])
        {
            
            if (peripheral==self.leftperipheral) {
              
                self.leftstepcha=c;
                
            }else if (peripheral==self.rightperipheral)
            {
                self.rightstepcha=c;
            }
            
            [peripheral setNotifyValue:YES forCharacteristic:c];
        }
        else if ([c.UUID isEqual:opStepCountID])
        {
            if (peripheral == self.leftperipheral)
            {
                self.leftOpStepCount = c;
            } else if (peripheral == self.rightperipheral)
            {
                self.rightOpStepCount = c;
            }
        }
    }
}


/**
 *  获得设备发来的数据
 */

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    UInt16 GetTemper = [self swap:0xFFA2];
    UInt16 Getstep   = [self swap:0xFFA6];
    UInt16 SetTemper = [self swap:0xFFA1];
    UInt16 Getbatter = [self swap:0x2A19];
    NSLog(@"蓝牙设备已然在运行");
    
    NSData *gettemperdata=[[NSData alloc]initWithBytes:(char *)&GetTemper length:2];
    NSData *settemperdata=[[NSData alloc]initWithBytes:(char *)&SetTemper length:2];
    NSData *getstepdata =[[NSData alloc]initWithBytes:(char *)&Getstep length:2];
    NSData *getbatterlevel = [[NSData alloc]initWithBytes:(char *)&Getbatter length:sizeof(Getbatter)];
    
    CBUUID *gettemperid=[CBUUID UUIDWithData:gettemperdata];
    CBUUID *settemperid=[CBUUID UUIDWithData:settemperdata];
    CBUUID *getstepid=[CBUUID UUIDWithData:getstepdata];
    CBUUID *getbatterpid = [CBUUID UUIDWithData:getbatterlevel];
    
   
    if ([characteristic.UUID isEqual:gettemperid]) {
       
        id value=characteristic.value;
         NSLog(@"转化前当前这次温度：%@",value);
       NSString * str=[NSString hexadecimalString:value];
        str1 = [NSString to10:str];
        NSLog(@"转化后当前这次温度：%@",str1);
        if (peripheral == self.leftperipheral&&isLeft == YES) {
            lefttem = [str1 integerValue ];
             NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:@"left" forKey:@"left"];
            [dic setObject:str1 forKey:@"leftgettemper"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"leftgettemper" object:dic];
            
        } else if(peripheral == self.rightperipheral&&isRight == YES){
            righttem =[str1 integerValue];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:@"right" forKey:@"right"];
            [dic setObject:str1 forKey:@"rightgettemper"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"rightgettemper" object:dic];
        }
        if (lefttem != -1&&righttem != -1&&isRight == YES&&isLeft == YES ) {
            if (lefttem < righttem) {
                isLeft = YES;
                isRight = NO;
            }else {
                isLeft = NO;
                isRight = YES;
            }
        }
        
            
    }else if ([characteristic.UUID isEqual:settemperid])
    {
        
                
    }else if ([characteristic.UUID isEqual:getstepid])
    {
        id value=characteristic.value;
        NSLog(@"转化前当前这次记步的步数：%@",value);
        NSString *str=[NSString hexadecimalString:value];
        str3 = [NSString to10:str];
        NSLog(@"转化后当前这次记步的步数：%@",str3);
        if (peripheral==self.leftperipheral) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"getstep" object:[NSDictionary dictionaryWithObject:str3 forKey:@"getstep"]];
            
        }else if (peripheral==self.rightperipheral)
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"getRightStep" object:[NSDictionary dictionaryWithObject:str3 forKey:@"getRightStep"]];
        }


    }else if([characteristic.UUID isEqual:getbatterpid]){
        
        NSLog(@"%@,%@",characteristic.UUID,getbatterpid);
        id value=characteristic.value;
        NSString *st=[NSString hexadecimalString:value];
        str2 = [NSString to10:st];
        NSLog(@"电量：%@",str2);
        
//        if (peripheral==self.leftperipheral) {
        
             [[NSNotificationCenter defaultCenter]postNotificationName:@"getbatterlevel" object:[NSDictionary dictionaryWithObject:str2 forKey:@"getbatterlevel"]];
            
//        }else if (peripheral==self.rightperipheral)
//        {
//             [[NSNotificationCenter defaultCenter]postNotificationName:@"rightgetbatterlevel" object:[NSDictionary dictionaryWithObject:str2 forKey:@"getbatterlevel"]];
//        }
        
    }
    
}


/**
 *  实时跟新数据
 */
-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (characteristic.isNotifying) {
        [peripheral readValueForCharacteristic:characteristic];
    }
}




-(void)bbleft
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)bb
{
    
    if (self.connectedperipherals.count<1) {
        [SVProgressHUD showInfoWithStatus:@"请连接设备"];
        return;
    }
    if(main == nil) {
         main=[[MainViewController alloc]init];
    }
   
    main.currPeripheralarr=self.connectedperipherals;
    main.leftstepcha=self.leftstepcha;
    main.rightstepcha=self.rightstepcha;
    main.leftGetTempercha=self.leftGetTempercha;
    main.rightGetTempercha=self.rightGetTempercha;
    main.leftSetTempercha=self.leftSetTempercha;
    main.rightSetTempercha=self.rightSetTempercha;
    main.leftperipheral=self.leftperipheral;
    main.rightperipheral=self.rightperipheral;
    main.currenttemperarr = str1;
    main.battryarr = str2;
    main.leftOpStepCount = self.leftOpStepCount;
    main.rightOpStepCount = self.rightOpStepCount;
    [self.navigationController pushViewController:main animated:YES];
}


#pragma CBCentralManager Delegate
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}


@end
