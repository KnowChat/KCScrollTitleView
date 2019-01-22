//
//  KCScrollTitleItem.m
//  KCScrollTitleViewExample
//
//  Created by knowchatMac01 on 2019/1/12.
//  Copyright © 2019年 Hangzhou knowchat Information Technology Co., Ltd. All rights reserved.
//

#import "KCScrollTitleItem.h"
#import "Masonry.h"

@interface KCScrollTitleItem()

@end

@implementation KCScrollTitleItem
- (instancetype)initWithTitle:(NSAttributedString *)title {
    if (self = [super init]) {
        _itemMaxWidth = MAXFLOAT;
        _attTitle = title;
        _lblTitle = [[UILabel alloc] init];
    }
    return self;
}
    
+ (CGSize)calculateSizeWithStr:(NSAttributedString *)str {
    CGSize size = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, CGRectGetHeight(UIScreen.mainScreen.bounds)) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    return CGSizeMake(ceilf(size.width), ceilf(size.height));
}
    
+ (UIFont *)titleBoldFontWithValue:(CGFloat)value {
    if (@available(iOS 8.2, *)) {
        return [UIFont systemFontOfSize:value weight:UIFontWeightBlack];
    }else {
        return [UIFont boldSystemFontOfSize:value];
    }
}
    
#pragma mark - set
- (void)setAttTitle:(NSAttributedString *)attTitle {
    _attTitle = attTitle;
    self.lblTitle.attributedText = attTitle;
}
    
- (void)changeTitle:(NSAttributedString *)title {
    if (title.length > 0) {
        self.attTitle = title;
        self.itemSize = [KCScrollTitleItem calculateSizeWithStr:title];
        
        if (self.changeTitleBlock) {
            self.changeTitleBlock();
        }
    }
}
    
- (void)setItemSize:(CGSize)itemSize {
    if (itemSize.width > _itemMaxWidth) {
        itemSize.width = _itemMaxWidth;
    }
    _itemSize = itemSize;
}
    
- (void)setCurrentPercentRatio:(CGFloat)currentPercentRatio {
    _currentPercentRatio = currentPercentRatio;
    CGFloat scale = self.itemScaleRatio + (1 - self.itemScaleRatio) * currentPercentRatio;
    CGFloat alpha = self.itemNormalAlpha + (1 - self.itemNormalAlpha) * currentPercentRatio;
    
    self.lblTitle.transform = CGAffineTransformMakeScale(scale, scale);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithAttributedString:self.attTitle];
    NSRange range = NSMakeRange(0, attStr.length);
    NSMutableDictionary *dicAttStr = [[NSMutableDictionary alloc] initWithDictionary:[attStr attributesAtIndex:0 effectiveRange:&range]];
    UIFont *currentFont = dicAttStr[NSFontAttributeName];
    UIFont *adjustFont = nil;
    if (currentPercentRatio > 0.5) {
        if (@available(iOS 8.2, *)) {
            adjustFont = [UIFont systemFontOfSize:currentFont.pointSize weight:UIFontWeightBlack];
        }else {
            adjustFont = [UIFont boldSystemFontOfSize:currentFont.pointSize];
        }
    }else {
        adjustFont = [UIFont systemFontOfSize:currentFont.pointSize];
    }
    [dicAttStr setObject:adjustFont forKey:NSFontAttributeName];
    [attStr addAttributes:dicAttStr range:NSMakeRange(0, attStr.length)];
    self.attTitle = attStr;
    
    self.lblTitle.alpha = alpha;
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.itemSize.width * scale, self.itemSize.height * scale));
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
