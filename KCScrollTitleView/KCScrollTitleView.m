//
//  KCScrollTitleView.m
//  Knowchat04
//
//  Created by knowchatMac01 on 2018/8/28.
//  Copyright © 2018年 yyk. All rights reserved.
//

#import "KCScrollTitleView.h"
#import "Masonry.h"

@interface KCScrollTitleView()
@property (nonatomic, strong) UIView *vwLine;
@property (nonatomic, assign) NSUInteger selectedIndex;
@end

@implementation KCScrollTitleView

@synthesize selectedIndex = _selectedIndex;

- (instancetype)initWithItems:(NSMutableArray<KCScrollTitleItem *> *)items defaultSelect:(NSUInteger)selectedIndex {
    if (self = [super init]) {
        self.aryItems = items;
        self.selectedIndex = selectedIndex;
        [self loadDefault];
    }
    return self;
}

- (void)loadDefault {
    self.lineWidthRangle = CGSizeMake(14, 35);
    self.lineHegiht = 4;
    self.scaleRatio = 2 / 3.0;
    self.itemNormalAlpha = 0.5;
    self.lineColor = [UIColor blackColor];
    self.itemSpace = 18;
}

- (CGFloat)calculateLineMidXAtIndex:(NSInteger)index {
    KCScrollTitleItem *item0 = self.aryItems[0];
    if (index == 0) {
        return item0.itemSize.width / 2.0;
    }
    
    CGFloat midX = 0;
    for (NSInteger i = 0; i < index; i++) {
        KCScrollTitleItem *item = self.aryItems[i];
        midX += (item.itemSize.width * self.scaleRatio + self.itemSpace);
    }
    midX += (self.aryItems[index].itemSize.width / 2.0);
    return midX;
}

- (CGSize)intrinsicContentSize {
    if (self.aryItems.count == 0) {
        return CGSizeZero;
    }
    
    //一个选中的宽度+其他未选中宽度
    CGFloat width = 0;
    CGFloat maxWidth = self.aryItems[0].itemSize.width;
    for (NSInteger i = 0; i < self.aryItems.count; i++) {
        width += self.aryItems[i].itemSize.width * self.scaleRatio + self.itemSpace;
        if (maxWidth < self.aryItems[i].itemSize.width) {
            maxWidth = self.aryItems[i].itemSize.width;
        }
    }
    width = width - self.itemSpace - maxWidth * self.scaleRatio + maxWidth;
    
    NSAttributedString *strTitle = self.aryItems[0].attTitle;
    CGFloat hegiht = [KCScrollTitleItem calculateSizeWithStr:strTitle].height;
    
    return CGSizeMake(width, hegiht + 5);
}

- (void)show {
    //移除原有界面
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.transform = CGAffineTransformIdentity;
        [obj removeFromSuperview];
    }];
    [self invalidateIntrinsicContentSize];
    
    if (self.aryItems.count == 0) {
        return;
    }
    
    __weak __typeof(&*self)weakSelf = self;
    for (NSInteger i = 0; i < _aryItems.count; i++) {
        KCScrollTitleItem *item = self.aryItems[i];
        item.itemScaleRatio = self.scaleRatio;
        item.itemNormalAlpha = self.itemNormalAlpha;
        item.changeTitleBlock = ^{
            CGFloat adjectPercent = weakSelf.aryItems.count <= 1?0:(weakSelf.selectedIndex * 1.0 / (weakSelf.aryItems.count - 1));
            [weakSelf setPercent:adjectPercent];
            [weakSelf invalidateIntrinsicContentSize];
        };
        [self addSubview:item];
        
        CGSize itemSize = item.itemSize;
        
        [item mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).offset(-5 / 2.0);
            make.size.mas_equalTo(itemSize);
            
            if (i > 0) {
                KCScrollTitleItem *lastItem = self.aryItems[i - 1];
                make.left.equalTo(lastItem.mas_right).offset(self.itemSpace);
            }else {
                make.left.mas_equalTo(0);
            }
        }];
        
        [self addSubview:item.lblTitle];
        [item.lblTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(item);
            make.width.mas_lessThanOrEqualTo(item.itemMaxWidth);
        }];
        
        if (i == self.selectedIndex) {
            item.currentPercentRatio = 1;
        }else {
            item.currentPercentRatio = 0;
        }
    }
    
    CGFloat item0MidX = [self calculateLineMidXAtIndex:0];
    self.vwLine = [[UIView alloc] init];
    self.vwLine.layer.cornerRadius = self.lineHegiht / 2.0;
    self.vwLine.layer.masksToBounds = YES;
    self.vwLine.backgroundColor = self.lineColor;
    [self addSubview:self.vwLine];
    [self.vwLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.height.mas_equalTo(self.lineHegiht);
        make.width.mas_equalTo(self.lineWidthRangle.width);
        make.centerX.equalTo(self.mas_left).offset(item0MidX);
    }];
    
    [self layoutIfNeeded];
    self.vwLine.transform = CGAffineTransformMakeTranslation([self calculateLineMidXAtIndex:self.selectedIndex] - [self calculateLineMidXAtIndex:0], 0);
}

#pragma mark - Set
- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    if (selectedIndex >= self.aryItems.count) {
        _selectedIndex = 0;
    }else {
        _selectedIndex = selectedIndex;
    }
}

- (void)setPercent:(CGFloat)percent {
    if (percent < 0) {
        _percent = 0;
    }else if (percent > 1) {
        _percent = 1;
    }else {
        if (isnan(percent)) {
            _percent = 1;
        }else {
            _percent = percent;
        }
    }
    
    if (self.aryItems.count > 1) {
        NSInteger leftIndex = floor(percent * (self.aryItems.count - 1));
        NSInteger rightIndex = ceilf(percent * (self.aryItems.count - 1));
        if (leftIndex < self.aryItems.count && rightIndex < self.aryItems.count) {
            if (leftIndex == rightIndex) {
                //修正所有item.transform
                for (NSInteger i = 0; i < self.aryItems.count; i++) {
                    if (i == leftIndex) {
                        KCScrollTitleItem *item = self.aryItems[i];
                        item.currentPercentRatio = 1;
                    }else {
                        KCScrollTitleItem *item = self.aryItems[i];
                        item.currentPercentRatio = 0;
                    }
                }
            
                //处理线条
                if (leftIndex == 0) {
                    self.vwLine.transform = CGAffineTransformIdentity;
                }else {
                    self.vwLine.transform = CGAffineTransformMakeTranslation([self calculateLineMidXAtIndex:leftIndex] - [self calculateLineMidXAtIndex:0], 0);
                }
                
                self.selectedIndex = leftIndex;
                
            }else {
                KCScrollTitleItem *leftItem = self.aryItems[leftIndex];
                KCScrollTitleItem *rightItem = self.aryItems[rightIndex];
                
                //平分比例 eg: 1.0 / 4 = 0.25
                CGFloat unitRatio = 1.0 / (self.aryItems.count - 1);
                //当前比例占多少个平分比例 eg: NSInteger(0.6 / 0.25) = 2
                NSInteger unitNum = percent / unitRatio;
                //求余 eg: (0.6 - 0.25 * 2)
                CGFloat lessRatio = (percent - unitRatio * unitNum) * 1.0;
                //余数占平分比例的比例
                CGFloat currentPercentRatio = lessRatio / unitRatio;
                
//                NSLog(@"%f",currentPercentRatio);

                leftItem.currentPercentRatio = (1 - currentPercentRatio);
                rightItem.currentPercentRatio = currentPercentRatio;
                
                //线段移动
                CGFloat leftMidX = [self calculateLineMidXAtIndex:leftIndex];
                CGFloat rightMidX = [self calculateLineMidXAtIndex:rightIndex];
                CGFloat currentMoveMax = rightMidX- leftMidX;
                CGFloat currentMove = currentPercentRatio * currentMoveMax;
                CGFloat currentMidX = leftMidX + currentMove;
                
//                NSLog(@"%f-%f-%f",currentMoveRangle,currentMove,allMove);

                //线段放大（抛物线方式）
                CGFloat lineScaleMax = self.lineWidthRangle.height / self.lineWidthRangle.width;
                CGFloat lineScale = -4 * (lineScaleMax - 1) * pow(currentPercentRatio, 2.0) + 4 * (lineScaleMax - 1) * currentPercentRatio + 1;
                
                self.vwLine.transform = CGAffineTransformMakeTranslation(currentMidX - [self calculateLineMidXAtIndex:0], 0);
                self.vwLine.transform = CGAffineTransformScale(self.vwLine.transform, lineScale, 1);
            }
        }
    }else if (self.aryItems.count == 1){
        KCScrollTitleItem *item = self.aryItems[0];
        item.currentPercentRatio = 1;
        self.vwLine.transform = CGAffineTransformIdentity;
        self.selectedIndex = 0;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
