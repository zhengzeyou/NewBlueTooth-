//
//  TemperatureView.h
//  NewBlueTooth
//
//  Created by  on 16/1/15.
//  Copyright © 2016年 starlinktech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TemperatureView : UIView


@property (nonatomic ,strong) void(^Clickindex)(int);


-(void)reloaddata:(int)tag;

@end
