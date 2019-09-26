//
//  HQSegmentLineView.m
//  HuiJuHuaQi
//
//  Created by XieLB on 16/7/28.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQSegmentLineView.h"

@interface HQSegmentLineView ()
{
    NSArray *_titleArr;
}

@property (nonatomic, strong) UIView *moveLineView;

@end

@implementation HQSegmentLineView

- (instancetype)initWithFrame:(CGRect)frame
                     titleArr:(NSArray *)titleArr
                     delegate:(id <HQSegmentLineViewDelegate>)delegate
{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.bottomLine.hidden = YES;
        self.topLine.hidden = YES;
        _selectedSegmentIndex = 0;
        
        _titleArr = [[NSArray alloc] initWithArray:titleArr];
        _delegate = delegate;
        
//        float btnWidth = SCREEN_WIDTH/titleArr.count;
        
        float btnWidth = frame.size.width/titleArr.count;
        for (int i=0; i<titleArr.count; i++) {
            
            CGRect segmentBtnFrame;
            if (i==0) {
                segmentBtnFrame = CGRectMake(0, 0.5, btnWidth, self.height-0.5);
            }else {
                segmentBtnFrame = CGRectMake(i*btnWidth, 0.5, btnWidth, self.height-0.5);
            }
            
            
            UIButton *segmentBtn = [HQHelper buttonOfMainButtonWithFrame:segmentBtnFrame
                                                                   title:titleArr[i]
                                                             normalColor:WhiteColor
                                                               highColor:WhiteColor
                                                           disabledColor:WhiteColor
                                                              titleColor:BlackTextColor
                                                           disTitleColor:nil
                                                                    font:FONT(17)
                                                                  target:self
                                                                  action:@selector(didSegmentAction:)];
            [segmentBtn setTitleColor:GreenColor forState:UIControlStateSelected];
            [segmentBtn setTitleColor:GreenColor forState:UIControlStateDisabled];
            if (i==0) {
                segmentBtn.enabled = NO;
            }
            segmentBtn.tag = 100 + i;
            [self addSubview:segmentBtn];
            
            
            
            
            float textWidth = [HQHelper sizeWithFont:FONT(17)
                                             maxSize:CGSizeMake(1000, 17)
                                            titleStr:titleArr[i]].width;
            CGRect redPointFrame = CGRectMake(segmentBtn.centerX+textWidth/2-5, 8, 15, 15);
            
            
            UILabel *redNumLabel = [HQHelper labelWithFrame:redPointFrame
                                                       text:@""
                                                  textColor:[UIColor whiteColor]
                                              textAlignment:NSTextAlignmentCenter
                                                       font:FONT(14)];
            redNumLabel.layer.cornerRadius  = redNumLabel.height/2;
            redNumLabel.layer.masksToBounds = YES;
            redNumLabel.backgroundColor = RedColor;
            redNumLabel.tag = 200 + i;
            redNumLabel.hidden = YES;
            [self addSubview:redNumLabel];
            
            if (i == 0) {
                
                CGRect moveLineFrame = CGRectMake(segmentBtn.centerX - textWidth/2 - 10, self.height - 2, textWidth+20, 2);
                _moveLineView = [[UIView alloc] initWithFrame:moveLineFrame];
                _moveLineView.backgroundColor = HexAColor(0x23c89f, 1);
            }
        }
        
        UIView *lineBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-0.5, SCREEN_WIDTH, 0.5)];
        lineBottomView.backgroundColor = CellSeparatorColor;
        [self addSubview:lineBottomView];
        
        [self insertSubview:_moveLineView aboveSubview:lineBottomView];
    }
    
    return self;
}




/**
 *  刷新所有红点状态
 *
 *  @param stateArr    所有红点状态数组，数组成员为红点数字
 */
- (void)refreshRedPointStateWithStateArr:(NSArray *)stateArr
{
    
    for (int i=0; i<stateArr.count; i++) {
        
        int redNumber = [stateArr[i] intValue];
        
        UILabel *redNumLabel = [self viewWithTag:200 + i];
        
        if (redNumber == 0) {
            
            redNumLabel.hidden = YES;
        }else {
        
            redNumLabel.hidden = NO;
            if (redNumber > 99) {
                redNumLabel.text = [NSString stringWithFormat:@"99+"];
            }else {
                redNumLabel.text = [NSString stringWithFormat:@"%d", redNumber];
            }
            CGFloat titleWidth = [HQHelper sizeWithFont:FONT(14)
                                                maxSize:CGSizeMake(1000, 20)
                                               titleStr:redNumLabel.text].width + 4;
            if (titleWidth<15) {
                titleWidth = 15;
            }
            redNumLabel.width = titleWidth;
        }
    }
}




- (void)didSegmentAction:(UIButton *)button
{
    
    if (!button.enabled) {
        return;
    }
    
    
    _selectedSegmentIndex = button.tag - 100;
    
    
    for (int i=0; i<_titleArr.count; i++) {
        
        UIButton *segmentBtn = (UIButton *)[self viewWithTag:i+100];
        if (segmentBtn == button) {
            segmentBtn.enabled = NO;
        }else {
            segmentBtn.enabled = YES;
        }
    }
    
    
    CGFloat nowTitleWidth = [HQHelper sizeWithFont:FONT(17)
                                           maxSize:CGSizeMake(1000, 17)
                                          titleStr:_titleArr[button.tag - 100]].width;
    [UIView animateWithDuration:0.35 animations:^{
        
        _moveLineView.frame = CGRectMake(button.centerX - nowTitleWidth/2 - 10, self.height - 2, nowTitleWidth+20, 2);
    }];
    
    
    if ([self.delegate respondsToSelector:@selector(didSegmentLineViewButtonNumber:)]) {
        
        [self.delegate didSegmentLineViewButtonNumber:(int)button.tag-100];
    }
    
}


- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex
{
    _selectedSegmentIndex = selectedSegmentIndex;
    
    
    for (int i=0; i<_titleArr.count; i++) {
        
        UIButton *segmentBtn = (UIButton *)[self viewWithTag:i+100];
        if (_selectedSegmentIndex == segmentBtn.tag-100) {
            segmentBtn.enabled = NO;
            
            CGFloat nowTitleWidth = [HQHelper sizeWithFont:FONT(17)
                                                   maxSize:CGSizeMake(1000, 17)
                                                  titleStr:_titleArr[segmentBtn.tag - 100]].width;
            [UIView animateWithDuration:0.35 animations:^{
                
                _moveLineView.frame = CGRectMake(segmentBtn.centerX - nowTitleWidth/2 - 10, self.height - 2, nowTitleWidth+20, 2);
            }];
            
        }else {
            segmentBtn.enabled = YES;
        }
    }
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
}

@end
