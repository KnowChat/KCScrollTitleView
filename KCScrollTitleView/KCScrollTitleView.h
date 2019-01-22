//
//  KCScrollTitleView.h
//  Knowchat04
//
//  Created by knowchatMac01 on 2018/8/28.
//  Copyright © 2018年 yyk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KCScrollTitleItem.h"

@interface KCScrollTitleView : UIView
    
/**
 动画比例，改变该值，实现不同进度的效果
 */
@property (nonatomic, assign) CGFloat percent;

/**
 线宽区间
 */
@property (nonatomic, assign) CGSize  lineWidthRangle;

/**
 线高
 */
@property (nonatomic, assign) CGFloat lineHegiht;

/**
 线颜色
 */
@property (nonatomic, strong) UIColor *lineColor;

/**
 item间距
 */
@property (nonatomic, assign) CGFloat itemSpace;

/**
 缩放比例
 */
@property (nonatomic, assign) CGFloat scaleRatio;

/**
 item未选中状态下透明度
 */
@property (nonatomic, assign) CGFloat itemNormalAlpha;

/**
 KCScrollTitleItem对象
 */
@property (nonatomic, strong) NSMutableArray<KCScrollTitleItem *> *aryItems;

/**
 初始化，无需给size，大小自适应

 @param items item控件
 @return tab标签
 */
- (instancetype)initWithItems:(NSMutableArray<KCScrollTitleItem *> *)items defaultSelect:(NSUInteger)selectedIndex;

/**
 展示视图或增删Items后，需要调用该方法刷新界面
 */
- (void)show;
@end
