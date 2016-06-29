//
//  CountStepsTableView.h
//  NewBlueTooth
//
//  Created by starlink on 16/1/15.
//  Copyright © 2016年 starlinktech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountStepsTableView : UITableView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)NSArray *allDataArray;

@end
