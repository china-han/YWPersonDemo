//
//  FirstViewController.m
//  PersonalCenter
//
//  Created by Arch on 2017/6/16.
//  Copyright © 2017年 mint_bin. All rights reserved.
//

#import "FirstViewController.h"


@interface FirstViewController () < UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL isHeader;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    NSLog(@"tableView  %f",self.tableView.frame.size.height);
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - NAVHEIGHT - SegmentHeaderViewHeight)];
//        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.rowHeight = 50;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const FirstViewControllerTableViewCellIdentifier = @"FirstViewControllerTableViewCell";
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:FirstViewControllerTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FirstViewControllerTableViewCellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"快点我%ld -> 进入我的消息",indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
}

@end
