//
//  TemperatureViewController.h
//  NewBlueTooth
//
//  Created by  on 16/1/15.
//  Copyright © 2016年 starlinktech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BabyBluetooth.h"

@interface TemperatureViewController : UIViewController

{
    @public
    BabyBluetooth *baby;

}

@property (nonatomic,copy)NSString *currenttemperstart;
@property (weak, nonatomic) IBOutlet UILabel *CTemperature;
@property (weak, nonatomic) IBOutlet UILabel *FTemperature;
@property (weak, nonatomic) IBOutlet UILabel *currentlb;

@property (nonatomic,strong)NSMutableArray *currenttemperarr;


/**
 *  设置温度
 */
@property (nonatomic,strong)CBCharacteristic *leftSetTempercha;
@property (nonatomic,strong)CBCharacteristic *rightSetTempercha;

@property (nonatomic,strong)CBCharacteristic *leftGetTempercha;
@property (nonatomic,strong)CBCharacteristic *rightGetTempercha;

@property (nonatomic,strong)CBPeripheral *leftperipheral;

@property (nonatomic,strong)CBPeripheral *rightperipheral;

@property (nonatomic,strong)NSMutableArray *currPeripheralarr;




@end
