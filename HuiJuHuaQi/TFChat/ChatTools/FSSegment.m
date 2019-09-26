//
//  FSSegment.m
//  BaseProject
//
//  Created by luyuan on 16/4/26.
//  Copyright © 2016年 soonking. All rights reserved.
//

#import "FSSegment.h"

@implementation FSSegment{
    
    UIControl *lastItem;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
        
        [self commoninit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame Titles:(NSArray *)titles {
    
    _titles = titles;
    self = [self initWithFrame:frame];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame Titles:(NSArray *)titles NormalTitleColor:(UIColor *)normalTitleColor SelectedTitleColor:(UIColor *)selectedTitleColor {
    
    _titles = titles;
    _normalTitleColor = normalTitleColor;
    _selectedTitleColor = selectedTitleColor;
    self = [self initWithFrame:frame];
    return self;
}

- (void)commoninit {

    _selectedIndex = 0;
    CGFloat width = self.frame.size.width/_titles.count;
    for (int i = 0; i < _titles.count-0; i++) {
        
        UIControl *control = [[UIControl alloc]initWithFrame:CGRectMake(i*width, 0, width+1, self.frame.size.height)];
        control.tag = i+10;
        [control addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:control];
        
        // 标题
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, control.frame.size.width, control.frame.size.height-10)];
        title.text = _titles[i];
        title.font = [UIFont systemFontOfSize:14];
        title.tag = 2;
        title.textAlignment = NSTextAlignmentCenter;
        title.textColor = _normalTitleColor;
        [control addSubview:title];
        
        
        // 指示图片父视图
        UIView *bottomImg = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(control.frame)-7, control.frame.size.width, 10)];
        [control addSubview:bottomImg];
        bottomImg.hidden = YES;
        bottomImg.tag = 1;
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, control.frame.size.width, 2)];
        line.layer.cornerRadius = 2;
        line.clipsToBounds = YES;
        line.backgroundColor = [UIColor orangeColor];
        [bottomImg addSubview:line];
        
        UIImageView *arrowImg = [[UIImageView alloc]initWithFrame:CGRectMake((bottomImg.frame.size.width-15)/2.0, CGRectGetMaxY(line.frame), 15, 8)];
        arrowImg.image = [UIImage imageNamed:@"traingle"];
        [bottomImg addSubview:arrowImg];
        
        if (i == 0) {
            
            lastItem = control;
            title.textColor = _selectedTitleColor;
            bottomImg.hidden = NO;
        }
    }
}



// 改变索引
- (void)segmentValueChanged:(UIControl *)control {
 
    if (_selectedIndex == control.tag - 10) {
        
        return;
    }
    [self showOrHiddenBottomViewFromSuperView:lastItem IsHidden:YES];
    [self showOrHiddenBottomViewFromSuperView:control IsHidden:NO];
    lastItem = control;
    _selectedIndex = control.tag-10;
    if (_block)
    {
       _block(_selectedIndex);
    }

}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    
   
    _selectedIndex = selectedIndex;
    UIControl *control = [self viewWithTag:10+_selectedIndex];
    [self showOrHiddenBottomViewFromSuperView:lastItem IsHidden:YES];
    [self showOrHiddenBottomViewFromSuperView:control IsHidden:NO];
    lastItem = control;
    if (_block)
    {
        _block(_selectedIndex);
    }

}

// 索引改变时视图变化
- (void)showOrHiddenBottomViewFromSuperView:(UIControl *)superView IsHidden:(BOOL) isHidden{
    
    UIView *bottomView = [superView viewWithTag:1];
    bottomView.hidden = isHidden;
    UILabel *title = [superView viewWithTag:2];
    if (isHidden) {
        
        title.textColor = _normalTitleColor;
    }
    else {
        title.textColor = _selectedTitleColor;
    }
}

- (void)setTitles:(NSArray *)titles
{
    _titles = titles;
    for (int i=0; i<titles.count; i++)
    {
        UIControl *control = (UIControl *)[self viewWithTag:i+10];
        UILabel *titleLable = (UILabel *)[control viewWithTag:2];
        titleLable.text = titles[i];
    }
}

@end
