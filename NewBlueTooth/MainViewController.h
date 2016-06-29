//
//  MainViewController.h
//  Hawak
//
//  Created by  on 16/1/14.
//  Copyright © 2016年 StarLink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BabyBluetooth.h"

@interface MainViewController : UIViewController{

@public
BabyBluetooth *baby;

}
/**
 *  设备的温度
 */
@property (nonatomic ,strong)NSString *currenttemperarr;

/**
 *  设备的电量
 */
@property (nonatomic ,strong)NSString *battryarr;

/**
 *  设备的步数
 */
@property (nonatomic ,strong)NSString *bushuarr;


//@property (nonatomic,strong)CBCharacteristic *gettempercha;
//
//@property (nonatomic ,strong)CBCharacteristic *stepcha;

@property (nonatomic,strong)CBPeripheral *leftperipheral;

@property (nonatomic,strong)CBPeripheral *rightperipheral;


@property (nonatomic,strong)NSMutableArray *currPeripheralarr;

//@property (nonatomic,strong)CBCharacteristic *SetTempercha;



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



@end
