//
//  MediaViewController.m
//  AoniTitle
//
//  Created by aoni on 2017/5/22.
//  Copyright © 2017年 aoni. All rights reserved.
//

#import "MediaViewController.h"

#define kScreenHeight  [[UIScreen mainScreen] bounds].size.height
#define kScreenWidth   [[UIScreen mainScreen] bounds].size.width

@interface MediaViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *imageTableView;
@property (nonatomic, strong) UITableView *videoTableView;
@property (nonatomic, strong) UITableView *emergencyTableView;

@end

@implementation MediaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"media";

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"select" style:UIBarButtonItemStylePlain target:self action:@selector(select)];
    [self addTableView];
}

- (void)select{
    
}

- (void)addTableView{

    self.imageTableView = [self addTableViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.videoTableView = [self addTableViewWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight)];
    self.emergencyTableView = [self addTableViewWithFrame:CGRectMake(kScreenWidth*2, 0, kScreenWidth, kScreenHeight)];
    [self.mainScrollView addSubview:self.imageTableView];
    [self.mainScrollView addSubview:self.videoTableView];
    [self.mainScrollView addSubview:self.emergencyTableView];
}

- (UITableView *)addTableViewWithFrame:(CGRect)frame{
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 60;
    tableView.separatorStyle = UITableViewCellSelectionStyleBlue;
    return tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    if (tableView == self.imageTableView) {
        cell.textLabel.text = [NSString stringWithFormat:@"image:%ld",indexPath.row];
    } else if (tableView == self.videoTableView) {
        cell.textLabel.text = [NSString stringWithFormat:@"video:%ld",indexPath.row];
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"emergency:%ld",indexPath.row];
    }
    
    return cell;
}


@end
