//
//  TFNoteTextView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/3/20.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFNoteTextView.h"

#define FirstMargin 15
#define SecondMargin 45

@interface TFNoteTextView ()

/** checkBtn */
@property (nonatomic, weak) UIButton *checkBtn;
/** numBtn */
@property (nonatomic, weak) UIButton *numBtn;

@end


@implementation TFNoteTextView

@synthesize delegate;


-(instancetype)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
        
        UIButton *finish = [HQHelper buttonWithFrame:(CGRect){2,0,30,30} normalImageStr:@"finish" seletedImageStr:@"selectFinish" highImageStr:@"" target:self action:@selector(selectBtnClicked:)];
        [self addSubview:finish];
        finish.hidden = YES;
        self.checkBtn = finish;
        
        UIButton *num = [HQHelper buttonWithFrame:(CGRect){30,0,30,30} target:nil action:nil];
        [self addSubview:num];
        num.userInteractionEnabled = NO;
        num.hidden = YES;
        self.numBtn = num;
        [num setTitleColor:LightBlackTextColor forState:UIControlStateNormal];
        
        
//        self.scrollEnabled = NO;
        self.layer.masksToBounds = YES;
        self.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5);
        
        [finish mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(@0);
            make.left.mas_equalTo(@(FirstMargin));
            make.width.mas_equalTo(@30);
            make.height.mas_equalTo(@30);
        }];
        
        [num mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(@0);
            make.left.mas_equalTo(@(SecondMargin + FirstMargin));
            make.width.mas_equalTo(@30);
            make.height.mas_equalTo(@30);
        }];
        
        
        
    }
    return self;
}

- (void)selectBtnClicked:(UIButton *)button{
    
    button.selected = !button.selected;
    
    if ([self.noteDelegate respondsToSelector:@selector(noteTextView:didCheckBtnWithCheck:)]) {
        [self.noteDelegate noteTextView:self didCheckBtnWithCheck:button.selected?2:1];
    }
}


-(void)setType:(NSInteger)type{
    _type = type;
    
}

-(void)setNum:(NSInteger)num{
    _num = num;
    if (num == 0) {
        self.numBtn.hidden = YES;
        
        if (_check == 0) {
            self.checkBtn.hidden = YES;
            self.textContainerInset = UIEdgeInsetsMake(5, FirstMargin, 5, FirstMargin);
            
            [self.numBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(@0);
                make.left.mas_equalTo(@(FirstMargin));
            }];
            
        }else if (_check == 1){
            self.checkBtn.hidden = NO;
            self.checkBtn.selected = NO;
            self.textContainerInset = UIEdgeInsetsMake(5, SecondMargin, 5, FirstMargin);
            
            [self.numBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(@0);
                make.left.mas_equalTo(@(SecondMargin));
            }];
        }else{
            self.checkBtn.hidden = NO;
            self.checkBtn.selected = YES;
            self.textContainerInset = UIEdgeInsetsMake(5, SecondMargin, 5, FirstMargin);
            
            [self.numBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(@0);
                make.left.mas_equalTo(@(SecondMargin));
            }];
        }
        
    }else{
        self.numBtn.hidden = NO;
        [self.numBtn setTitle:[NSString stringWithFormat:@"%ld.",num] forState:UIControlStateNormal];
        if (_check == 0) {
            self.checkBtn.hidden = YES;
            self.textContainerInset = UIEdgeInsetsMake(5, SecondMargin, 5, FirstMargin);
            
            [self.numBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(@0);
                make.left.mas_equalTo(@(FirstMargin+5));
            }];
        }else if (_check == 1){
            self.checkBtn.hidden = NO;
            self.checkBtn.selected = NO;
            self.textContainerInset = UIEdgeInsetsMake(5, SecondMargin + 23, 5,FirstMargin);
            [self.numBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(@0);
                make.left.mas_equalTo(@(SecondMargin));
            }];
        }else{
            self.checkBtn.hidden = NO;
            self.checkBtn.selected = YES;
            self.textContainerInset = UIEdgeInsetsMake(5, SecondMargin + 23, 5, FirstMargin);
            [self.numBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(@0);
                make.left.mas_equalTo(@(SecondMargin));
            }];
        }
    }
}

-(void)setCheck:(NSInteger)check{
    
    _check = check;
    
    
    if (check == 2) {// 需要变成灰色文字和删除线
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.text attributes:@{
                                                                                                                  NSForegroundColorAttributeName:HexColor(0x909090),
                                                                                                                  NSStrikethroughStyleAttributeName:@(NSUnderlinePatternSolid|NSUnderlineStyleSingle),
                                                                                                                  NSFontAttributeName:FONT(17)
                                                                                                                  }];
        self.attributedText = str;
        
        [self.numBtn setTitleColor:HexColor(0x909090) forState:UIControlStateNormal];
        
    }else{
        
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.text attributes:@{
                                                                                                                  NSForegroundColorAttributeName:LightBlackTextColor,
                                                                                                                  NSFontAttributeName:FONT(17)
                                                                                                                  }];
        self.attributedText = str;
        
        [self.numBtn setTitleColor:LightBlackTextColor forState:UIControlStateNormal];
        
    }
    
    
    if (_check == 0) {
        self.checkBtn.hidden = YES;
        
        if (_num == 0) {
            self.numBtn.hidden = YES;
            self.textContainerInset = UIEdgeInsetsMake(5, FirstMargin, 5, FirstMargin);
        }else{
            self.numBtn.hidden = NO;
            self.textContainerInset = UIEdgeInsetsMake(5, 40, 5, FirstMargin);
            [self.numBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(@0);
                make.left.mas_equalTo(@(FirstMargin+5));
            }];
        }
        
    }else if (_check == 1){
        self.checkBtn.hidden = NO;
        self.checkBtn.selected = NO;
        if (_num == 0) {
            self.numBtn.hidden = YES;
            self.textContainerInset = UIEdgeInsetsMake(5, SecondMargin, 5, FirstMargin);
        }else{
            self.numBtn.hidden = NO;
            self.textContainerInset = UIEdgeInsetsMake(5, SecondMargin + 23, 5, FirstMargin);
            [self.numBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(@0);
                make.left.mas_equalTo(@(SecondMargin));
            }];
        }
        
    }else{
        self.checkBtn.hidden = NO;
        self.checkBtn.selected = YES;
        if (_num == 0) {
            self.numBtn.hidden = YES;
            self.textContainerInset = UIEdgeInsetsMake(5, SecondMargin, 5, FirstMargin);
        }else{
            self.numBtn.hidden = NO;
            self.textContainerInset = UIEdgeInsetsMake(5, SecondMargin + 23, 5, FirstMargin);
            [self.numBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(@0);
                make.left.mas_equalTo(@(SecondMargin));
            }];
        }
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
