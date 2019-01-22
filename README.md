# KCScrollTitleView



- KCScrollTitleView

> *KCScrollTitleItem*

> *KCScrollTitleView*



#### Demo示例（和UIScrollView结合使用）

<p align="center">
  <img src="Screen_Shot1.png" title="Screen_Shot1" float=left>
</p>



#### 实现UIScrollViewDelegate

```objective-c
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //给KCScrollTitleView设置滑动比例
    CGFloat percent = scrollView.contentOffset.x / (scrollView.contentSize.width - scrollView.frame.size.width);
    
    self.vwScrollTitle.percent = percent;
}
```



#### 修改标题

```objective-c
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
```



#### 增加标题

```objective-c
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
```



#### 删除标题

```objective-c
- (void)deleteEvent:(UIButton *)btn {
    if (self.vwScrollTitle.aryItems.count > 0) {
        
        //修改aryItems和scwShow.contentSize

        [self.vwScrollTitle.aryItems removeLastObject];

        self.scwShow.contentSize = CGSizeMake(self.vwScrollTitle.aryItems.count * CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));

        [self.vwScrollTitle show];
    }
}
```

