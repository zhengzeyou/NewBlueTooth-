//
//  PeripheralModel.h
//  NewBlueTooth
//
//  Created by  on 16/2/15.
//  Copyright © 2016年 starlinktech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface PeripheralModel : NSObject

@property (nonatomic,strong)CBPeripheral *peripheral;

@property (nonatomic,strong)CBCharacteristic *stepcha;

@property (nonatomic,strong)CBCharacteristic *GetTempercha;

@property (nonatomic,strong)CBCharacteristic *batterycha;

@property (nonatomic,strong)CBCharacteristic *SetTempercha;

@property (nonatomic,strong)CBCharacteristic *OpStepCount;



+(id)PeripheralModel:(NSDictionary *)dic;

-(id)initWithDictionary:(NSDictionary *)dic;



@end
