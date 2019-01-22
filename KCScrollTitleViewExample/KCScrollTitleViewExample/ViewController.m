//
//  ViewController.m
//  KCScrollTitleViewExample
//
//  Created by knowchatMac01 on 2019/1/12.
//  Copyright © 2019年 Hangzhou knowchat Information Technology Co., Ltd. All rights reserved.
//

#import "ViewController.h"
#import "KCScrollTitleView.h"
#import "Masonry.h"

@interface ViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scwShow;
@property (nonatomic, strong) KCScrollTitleView *vwScrollTitle;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    NSArray *aryTitle = @[@"推荐",@"活跃",@"新人",@"乌鲁木齐"];

    self.scwShow = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scwShow.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds) * aryTitle.count, CGRectGetHeight(self.view.bounds));
    self.scwShow.delegate = self;
    self.scwShow.pagingEnabled = YES;
    [self.view addSubview:self.scwShow];
    
    //先创建每一个item
    NSMutableArray *aryTitleItem = @[].mutableCopy;
    for (NSInteger i = 0; i < aryTitle.count; i++) {
        NSAttributedString *attTitle = [[NSAttributedString alloc] initWithString:aryTitle[i] attributes:@{NSFontAttributeName:[KCScrollTitleItem titleBoldFontWithValue:21.f]}];
        KCScrollTitleItem *item = [[KCScrollTitleItem alloc] initWithTitle:attTitle];
        item.itemMaxWidth = 79;
        item.itemSize = [KCScrollTitleItem calculateSizeWithStr:attTitle];
        item.backgroundColor = [UIColor whiteColor];
        [item addTarget:self action:@selector(scrollTitleItemEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        [aryTitleItem addObject:item];
    }
    
    //默认选中 index = 3
    [self.scwShow setContentOffset:CGPointMake(3 * CGRectGetWidth(self.view.frame), 0)];
    //创建item的父视图
    self.vwScrollTitle = [[KCScrollTitleView alloc] initWithItems:aryTitleItem defaultSelect:3];
    self.vwScrollTitle.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.vwScrollTitle];
    [self.vwScrollTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.topMargin.mas_equalTo(60);
        //无需设置大小，KCScrollTitleView大小会根据item自适应
    }];
    //务必要调用show方法，才能开始展示
    [self.vwScrollTitle show];
    
    
    
    //功能演示相关
    {
        UIButton *btnAdd = [[UIButton alloc] init];
        [btnAdd setTitle:@"增加" forState:UIControlStateNormal];
        [btnAdd setBackgroundColor:[UIColor blueColor]];
        [btnAdd addTarget:self action:@selector(addEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnAdd];
        [btnAdd mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.bottomMargin.equalTo(self.view).offset(-200);
            make.size.mas_equalTo(CGSizeMake(80, 44));
        }];
        
        UIButton *btnChange = [[UIButton alloc] init];
        [btnChange setTitle:@"改名" forState:UIControlStateNormal];
        [btnChange setBackgroundColor:[UIColor blueColor]];
        [btnChange addTarget:self action:@selector(changeEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnChange];
        [btnChange mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(btnAdd.mas_left).offset(-30);
            make.size.bottom.equalTo(btnAdd);
        }];
        
        UIButton *btnDelete = [[UIButton alloc] init];
        [btnDelete setTitle:@"删除" forState:UIControlStateNormal];
        [btnDelete setBackgroundColor:[UIColor blueColor]];
        [btnDelete addTarget:self action:@selector(deleteEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnDelete];
        [btnDelete mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(btnAdd.mas_right).offset(30);
            make.size.bottom.equalTo(btnAdd);
        }];
        
        //操作提示框
        UILabel *lblTips = [[UILabel alloc] init];
        lblTips.backgroundColor = [UIColor whiteColor];
        lblTips.textColor = [UIColor blackColor];
        lblTips.textAlignment = NSTextAlignmentCenter;
        lblTips.text = @"左右滑动或点标题切换栏目";
        lblTips.userInteractionEnabled = NO;
        [self.view addSubview:lblTips];
        [lblTips mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(btnAdd).offset(80);
            make.width.mas_equalTo(250);
        }];
    }
}

#pragma mark - KCScrollTitleItem Event
- (void)scrollTitleItemEvent:(KCScrollTitleItem *)item {
    CGFloat pageWidth = CGRectGetWidth(self.scwShow.frame);
    NSInteger currentPageIndex = floor((self.scwShow.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    NSInteger itemPageIndex = [self.vwScrollTitle.aryItems indexOfObject:item];
    if (currentPageIndex == itemPageIndex) {
        //和上次点击的是同一个item
    
    }else {
        //和上次点击的不是同一个item，scrollView需滑动到对应item的contentOffset
        [self.scwShow setContentOffset:CGPointMake(itemPageIndex * pageWidth, 0) animated:YES];
    }
}
    
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //给KCScrollTitleView设置滑动比例
    CGFloat percent = scrollView.contentOffset.x / (scrollView.contentSize.width - scrollView.frame.size.width);
    self.vwScrollTitle.percent = percent;
}

#pragma mark - btn event
- (void)changeEvent:(UIButton *)btn {
    if (self.vwScrollTitle.aryItems.count > 0) {
        KCScrollTitleItem *item = self.vwScrollTitle.aryItems.lastObject;
        NSString *strTitle = @"乌鲁木齐";
        if ([item.attTitle.string isEqualToString:@"乌鲁木齐"]) {
            strTitle = @"杭州";
        }
        NSAttributedString *attTitle = [[NSAttributedString alloc] initWithString:strTitle attributes:@{NSFontAttributeName:[KCScrollTitleItem titleBoldFontWithValue:21.f]}];
        [item changeTitle:attTitle];
    }
}

- (void)addEvent:(UIButton *)btn {
    //创建新Item
    NSAttributedString *attTitle = [[NSAttributedString alloc] initWithString:@"新增" attributes:@{NSFontAttributeName:[KCScrollTitleItem titleBoldFontWithValue:21.f]}];
    KCScrollTitleItem *item = [[KCScrollTitleItem alloc] initWithTitle:attTitle];
    item.itemMaxWidth = 79;
    item.itemSize = [KCScrollTitleItem calculateSizeWithStr:attTitle];
    item.backgroundColor = [UIColor whiteColor];
    [item addTarget:self action:@selector(scrollTitleItemEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    //修改aryItems和scwShow.contentSize
    [self.vwScrollTitle.aryItems addObject:item];
    self.scwShow.contentSize = CGSizeMake(self.vwScrollTitle.aryItems.count * CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
    [self.vwScrollTitle show];
    
    //选中新加的item
    [self scrollTitleItemEvent:item];
}

- (void)deleteEvent:(UIButton *)btn {
    if (self.vwScrollTitle.aryItems.count > 0) {
        //修改aryItems和scwShow.contentSize
        [self.vwScrollTitle.aryItems removeLastObject];
        self.scwShow.contentSize = CGSizeMake(self.vwScrollTitle.aryItems.count * CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
        [self.vwScrollTitle show];
    }
}
@end
