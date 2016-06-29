//
//  PeripheralChoose.m
//  NewBlueTooth
//
//  Created by  on 16/2/15.
//  Copyright © 2016年 starlinktech. All rights reserved.
//

#import "PeripheralChoose.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface PeripheralChoose()
{
    NSMutableArray *_datas;
    
}

@end

@implementation PeripheralChoose

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        self.table.layer.cornerRadius = 5;
        self.table.layer.masksToBounds = YES;
        _datas=[NSMutableArray array];
        self.backgroundColor=[UIColor blackColor];
        self.alpha=0.8;
        
        self.table = [[UITableView alloc]initWithFrame:CGRectMake(self.frame.size.width/5, self.frame.size.height/2- 80, self.frame.size.width*3/5, 0)];
        self.table.backgroundColor = [UIColor whiteColor];
        self.table.tableFooterView = [[UIView alloc]init];
        [self addSubview:self.table];
        
    }
    return self;
}

-(void)setDatasource:(NSMutableArray *)datasource
{  NSMutableArray *data = [self removeSmall:datasource];
    _datas = data;
    self.table.frame = CGRectMake(self.frame.size.width/5, self.frame.size.height/2 - data.count*20, self.frame.size.width*3/5, data.count * 40);
}

- (NSMutableArray*)removeSmall:(NSMutableArray *)data{
    NSMutableArray *data1 = [[NSMutableArray alloc]init];
    
    for (id per1 in data) {
        if (![data1 containsObject:per1]) {
            [data1 addObject:per1];
        }
    }
    
    return data1;
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    self.table.delegate = self;
    self.table.dataSource = self;

    
}

#pragma tableviewdelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _datas.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"peripheral";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text=[(CBPeripheral *)_datas[indexPath.row] name];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_click) {
        _click(tableView,indexPath);
    }
    
    [self.table deselectRowAtIndexPath:indexPath animated:YES];
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
    
}


@end
