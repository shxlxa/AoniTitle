//
//  MainViewController.m
//  NetWork
//
//  Created by aoni on 16/9/6.
//  Copyright © 2016年 aoni. All rights reserved.
//

#import "MainViewController.h"


#define kScreenHeight  [[UIScreen mainScreen] bounds].size.height
#define kScreenWidth   [[UIScreen mainScreen] bounds].size.width
#define HYColor(a,b,c) [UIColor colorWithRed:a green:b blue:c alpha:1]

//#define buttonW kScreenWidth*2/9.0-20
#define buttonW 200.0/3.0

@interface MainViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *topScrollView;
@property (nonatomic, strong) NSMutableArray  *allButtons;

@property (nonatomic, strong) UIView  *slideView;


@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
    
    [self addTopScrollView];
    [self addMainScrollView];
}




#pragma mark - 标题scrollView
- (void)addTopScrollView{
    
    _topScrollView = [[UIScrollView alloc] init];
    _topScrollView.showsVerticalScrollIndicator = NO;
    _topScrollView.showsHorizontalScrollIndicator = NO;
    _topScrollView.frame = CGRectMake((kScreenWidth-200)/2.0, 0, 200, 44);
    
    _topScrollView.contentSize = CGSizeMake(kScreenWidth, 44);
    [_topScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    self.navigationItem.titleView = _topScrollView;
    [self addButton];
    
    self.slideView = [[UIView alloc] init];
    self.slideView.frame = CGRectMake( 0, self.topScrollView.bounds.size.height-3, buttonW, 2);
    [self.topScrollView addSubview:self.slideView];
    self.slideView.backgroundColor = [UIColor whiteColor];
}

#pragma mark - content scrollView
- (void)addMainScrollView{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] init];
        _mainScrollView.backgroundColor = [UIColor colorWithRed:0.642 green:1.000 blue:0.722 alpha:1.000];
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        _mainScrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        _mainScrollView.contentSize = CGSizeMake(kScreenWidth * 3, kScreenHeight);
        [_mainScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        _mainScrollView.delegate = self;
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.bounces = NO;
        [self.view addSubview:_mainScrollView];
    }
    //设置标题初始状态
    UIButton* firstBtn = self.allButtons[0];
    [self titleButtonClicked:firstBtn];
    [firstBtn setTitleColor:HYColor(1, 0, 0) forState:UIControlStateNormal];
    firstBtn.transform = CGAffineTransformMakeScale(1.2, 1.2);
}


/** 添加标题栏 */
- (void)addButton
{
    for (int i = 0; i < 3; i++) {
        CGFloat labelW = 200/3.0;
        CGFloat labelH = 44;
        CGFloat labelY = 0;
        CGFloat labelX = i * labelW;
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:self.topList[i] forState:UIControlStateNormal];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        button.backgroundColor = [UIColor redColor];
        button.frame = CGRectMake(labelX, labelY, labelW, labelH);
        [_topScrollView addSubview:button];
        [self.allButtons addObject:button];
        button.tag = i;
        button.userInteractionEnabled = YES;
        [button addTarget:self action:@selector(titleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}


/*---------------------------  逻辑处理      --------------------------------------*/
- (void)titleButtonClicked:(UIButton *)btn{
    //title滚动区，选中的标题自动会根据情况移动居中
    [self titleScrollViewChangeWithBtnTag:btn.tag];
    //content滚动区，会根据选中的标题切换到对应的页面内容
    [self contentScrollViewChangeWithBtnTag:btn.tag];
}

#pragma mark - currentIndex
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _mainScrollView) {
        NSInteger i = scrollView.contentOffset.x / kScreenWidth;
        //结束一次页面滚动，就需要重新设置title滚动区的按钮的位置
        [self titleScrollViewChangeWithBtnTag:i];
    }
}

#pragma mark content滚动区
-(void)contentScrollViewChangeWithBtnTag:(NSInteger)tag{
    // 计算当前内容区域的偏移量
    CGFloat offset = kScreenWidth * tag;
    [self.mainScrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
}

#pragma mark title滚动区 根据角标变化，滚动到中间
-(void)titleScrollViewChangeWithBtnTag:(NSInteger)tag{
    UIButton* btn = self.allButtons[tag];
    // 计算得出当前应该设置的偏移量
    CGFloat offset = btn.center.x - kScreenWidth * 0.5;
    //保证标题的第一个不滚出左边界
    if (offset < 0) {
        offset = 0;
    }
    //80*7 - 375 = 185
    CGFloat maxOffset = self.topScrollView.contentSize.width - kScreenWidth;
    //保证标题的最后一个在最右端
    if (offset > maxOffset) {
        offset = maxOffset;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.slideView.frame = CGRectMake( tag * buttonW, self.topScrollView.bounds.size.height-3, buttonW, 2);
    }];
    //动态性的设置标题滚动区的偏移量
    [self.topScrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
}

#pragma mark 只要在滚动就会不停的调用该方法,mainScrollView
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == _mainScrollView) {
        //先拿到相邻的角标
        NSInteger leftIndex = scrollView.contentOffset.x / kScreenWidth;
        leftIndex = (leftIndex >= self.allButtons.count - 2)?(self.allButtons.count - 2):leftIndex;
        NSInteger rightIndex = leftIndex + 1;
        //根据角标拿到对应的title
        UIButton* leftBtn = self.allButtons[leftIndex];
        UIButton* rightBtn = self.allButtons[rightIndex];
        
        //然后拿到相邻区域的leftWidth和rightWidth
        CGFloat x = scrollView.contentOffset.x;
        //leftWidth,rightWidth：可以看做滚动前屏幕右侧有一个点，leftWidth为这个点到左侧的距离
        //rightWidth为这个点到右侧的距离，随着向右滚动，leftWidth越来越小，rightWidth越来越大
        CGFloat leftWdth = rightIndex * kScreenWidth - scrollView.contentOffset.x;
        CGFloat rightWidth = kScreenWidth - leftWdth;
        
        //然后获取leftScale和rightScale
        CGFloat leftScale = leftWdth / kScreenWidth;
        CGFloat rightScale = rightWidth / kScreenWidth;
        
        NSLog(@"%.2f--%.2f--%.2f",leftWdth,rightWidth,x);
        // 1、先处理title字体的随着滚动内容区域的形变
        leftBtn.transform = CGAffineTransformMakeScale(leftScale*0.2+1, leftScale*0.2+1);
        rightBtn.transform = CGAffineTransformMakeScale(rightScale*0.2+1, rightScale*0.2+1);
        
        // 2、再处理title字体的颜色值
        [leftBtn setTitleColor:HYColor(leftScale, 0, 0) forState:UIControlStateNormal];
        [rightBtn setTitleColor:HYColor(rightScale, 0, 0) forState:UIControlStateNormal];
    }
    
}

/*--------------------------  懒加载  --------------------------------*/
- (NSMutableArray *)topList{
    if (!_topList) {
        _topList = [NSMutableArray arrayWithObjects:@"图片",@"视频",@"紧急", nil];
    }
    return _topList;
}

#pragma mark - 懒加载可变数组
-(NSMutableArray *)allButtons{
    if (_allButtons == nil) {
        _allButtons = [NSMutableArray array];
    }
    return _allButtons;
}


@end
