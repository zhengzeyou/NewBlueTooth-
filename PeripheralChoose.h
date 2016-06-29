//
//  PeripheralChoose.h
//  NewBlueTooth
//
//  Created by  on 16/2/15.
//  Copyright © 2016年 starlinktech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PeripheralChoose : UIView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong)UITableView *table;

@property (nonatomic ,strong)NSMutableArray *datasource;

@property (nonatomic,strong) void(^click)(UITableView *,NSIndexPath *indexpath);

@end
