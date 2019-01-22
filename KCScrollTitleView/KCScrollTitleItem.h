//
//  KCScrollTitleItem.h
//  KCScrollTitleViewExample
//
//  Created by knowchatMac01 on 2019/1/12.
//  Copyright © 2019年 Hangzhou knowchat Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KCScrollTitleItem: UIButton
    
/**
 item选中状态下的大小
 */
@property (nonatomic, assign) CGSize itemSize;

/**
 item未选中状态下透明度
 */
@property (nonatomic, assign) CGFloat itemNormalAlpha;

/**
 item缩放比例
 */
@property (nonatomic, assign) CGFloat itemScaleRatio;

/**
 item最大宽度
 */
@property (nonatomic, assign) CGFloat itemMaxWidth;

/**
 当前缩放比例
 */
@property (nonatomic, assign) CGFloat currentPercentRatio;

/**
 改变标题回调
 */
@property (nonatomic, copy) dispatch_block_t changeTitleBlock;

/**
 标题
 */
@property (nonatomic, strong, readonly) NSAttributedString *attTitle;
    
/**
 显示标题的label
 */
@property (nonatomic, strong, readonly) UILabel *lblTitle;

/**
 计算富文本大小 ceilf()
 
 @param str 富文本
 @return 大小
 */
+ (CGSize)calculateSizeWithStr:(NSAttributedString *)str;
    
/**
 获取使用的加粗字体
 
 @param value 字号
 @return 字体
 */
+ (UIFont *)titleBoldFontWithValue:(CGFloat)value;
    
/**
 初始化方法
 
 @param title 富文本标题
 @return KCScrollTitleItem
 */
- (instancetype)initWithTitle:(NSAttributedString *)title;
    
/**
 修改标题
 
 @param title 新标题
 */
- (void)changeTitle:(NSAttributedString *)title;
@end
