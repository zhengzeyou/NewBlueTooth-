//
//  TemperatureView.m
//  NewBlueTooth
//
//  Created by  on 16/1/15.
//  Copyright © 2016年 starlinktech. All rights reserved.
//

#import "TemperatureView.h"


@interface TemperatureView()
{
    NSMutableArray *_buttonArr;
    UIView *baseview;
}

@end

@implementation TemperatureView


-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        
        
        baseview=[[UIView alloc]initWithFrame:CGRectMake(0, 20, self.frame.size.width, self.frame.size.height-40)];
        baseview.layer.masksToBounds=YES;
        baseview.layer.cornerRadius=17;
        baseview.layer.borderWidth=3;
        baseview.layer.borderColor=[UIColor whiteColor].CGColor;
        [self addSubview:baseview];
        
        /**
         *  坐标
         */
        for (int i=0; i<10; i++) {
            UIView *view=nil;
            if (i%2==0) {
                view=[[UIView alloc]initWithFrame:CGRectMake(25+(self.frame.size.width-50)*i/9, 0, 4, 6)];
                
            }else
            {
                view=[[UIView alloc]initWithFrame:CGRectMake(25+(self.frame.size.width-50)*i/9, baseview.frame.size.height-6, 4, 6)];
            }
            view.backgroundColor=[UIColor whiteColor];
           [baseview addSubview:view];
        }
        
        /**
         *  按钮
         */
        for (int i=0; i<10; i++) {
            
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            
            btn.frame=CGRectMake(17+(self.frame.size.width-50)*i/9, (baseview.frame.size.height-20)/2, 20, 20);
            //[btn setCenter:CGPointMake(27+(self.frame.size.width-50)*i/9, (self.frame.size.height-15)/2)];
            
            [btn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"TemperSelected"] forState:UIControlStateSelected];
            btn.tag=i*100;
            [btn addTarget:self action:@selector(didclick:) forControlEvents:UIControlEventTouchUpInside];
            [baseview addSubview:btn];

            
        }
        
        /**
         *  数字
         */
        
        for (int i=0; i<10; i++) {
            UILabel *lb=nil;
            
            if (i%2==0) {
              lb=[[UILabel alloc]initWithFrame:CGRectMake(10+(self.frame.size.width-50)*i/9, 0, 30, 15)];
            }else
            {
              lb=[[UILabel alloc]initWithFrame:CGRectMake(10+(self.frame.size.width-50)*i/9, self.frame.size.height-17, 30, 15)];

            }

            lb.font=[UIFont systemFontOfSize:15];
            lb.textAlignment=NSTextAlignmentCenter;
            lb.text=[NSString stringWithFormat:@"%d",20+i*5];
            lb.textColor=[UIColor whiteColor];
            [self addSubview:lb];
        }
        
        
        
    }
    return self;
}


-(void)didclick:(UIButton *)sender
{
    
    for (UIView *v in baseview.subviews) {
        if ([v isKindOfClass:[UIButton class]]) {
            UIButton *btn=(UIButton *)v;
            btn.selected=NO;
        }
    }
         sender.selected=YES;
    
      if (_Clickindex) {
          _Clickindex((int)sender.tag);
        }
    
}

-(void)reloaddata:(int)tag
{
   
    
    int tags=tag*100;
    UIButton *btn=nil;
    for (UIView *v in baseview.subviews) {
        if ([v isKindOfClass:[UIButton class]] && (v.tag ==tags) ) {
            btn=(UIButton *)v;
            break;
        }
    }
    [self didclick:btn];
    
}



@end
