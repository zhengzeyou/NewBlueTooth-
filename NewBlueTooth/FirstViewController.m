//
//  FirstViewController.m
//  BlueTooth
//
//  Created by  on 16/1/14.
//  Copyright © 2016年 starlinktech. All rights reserved.
//

#import "FirstViewController.h"
#import "NSUserDefaults+Klanguage.h"
#import "AppDelegate.h"

#import "CheckPeripheral.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    
    
    NSLocale *locale = [NSLocale currentLocale];
    NSString * localName1 = [locale localeIdentifier];

    if ([localName1 isEqualToString:@"zh-Hant_CN"]||[localName1 isEqualToString:@"zh_CN"]) {
        imageView.image = [UIImage imageNamed:@"home"];
    }else {
        imageView.image = [UIImage imageNamed:@"home-en"];
    }
    
    UIImageView *buttonView = [[UIImageView alloc]initWithFrame:CGRectZero];
    buttonView.userInteractionEnabled = YES;
    buttonView.frame = CGRectMake(0, 0, 110, 110);
    buttonView.layer.cornerRadius = 55;
    buttonView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/7*5);
    buttonView.contentMode = UIViewContentModeScaleAspectFit;
    buttonView.image = [UIImage imageNamed:@"homeButton"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [buttonView addGestureRecognizer:tap];
    [self.view addSubview:imageView];
    [self.view addSubview:buttonView];
    // Do any additional setup after loading the view.
}

- (void)tapAction {
    
//    if (_click) {
//        _click();
//    }
    
        CheckPeripheral *blue=[[CheckPeripheral alloc]init];
    
    [self.navigationController pushViewController:blue animated:YES];
    
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
