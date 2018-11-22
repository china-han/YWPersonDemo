//
//  ViewController.m
//  个人主页demo
//
//  Created by hyw on 2018/11/14.
//  Copyright © 2018年 bksx. All rights reserved.
//

#import "ViewController.h"
#import "PersonalCenterViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *enlargeSwitch;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)intoCenterAction:(id)sender {
    PersonalCenterViewController *personalCenterVC = [[PersonalCenterViewController alloc]init];
    personalCenterVC.isEnlarge = self.enlargeSwitch.on;
    personalCenterVC.selectedIndex = 0;
    [self.navigationController pushViewController:personalCenterVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
