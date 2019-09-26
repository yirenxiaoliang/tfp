//
//  TFNoteListBottomView.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/3/26.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFNoteListBottomView.h"

@interface TFNoteListBottomView ()

@property (weak, nonatomic) IBOutlet UIButton *oneBtn;
@property (weak, nonatomic) IBOutlet UIButton *twoBtn;

@property (weak, nonatomic) IBOutlet UILabel *threeBtn;

@end

@implementation TFNoteListBottomView

- (void)awakeFromNib {

    [super awakeFromNib];
    
    UILabel *line = [UILabel initCustom:CGRectMake(0, 0, SCREEN_WIDTH, 0.5) title:@"" titleColor:kUIColorFromRGB(0xFFFFFF) titleFont:10 bgColor:kUIColorFromRGB(0x909090)];
    [self addSubview:line];
    
    [self.oneBtn addTarget:self action:@selector(oneBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.twoBtn addTarget:self action:@selector(twoBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)refreshNoteListBottomViewWithType:(NSInteger)type count:(NSInteger)count {

    if (type == 1) {
        
        [self.oneBtn setTitle:@"删除" forState:UIControlStateNormal];
        [self.oneBtn setTitleColor:kUIColorFromRGB(0xF91313) forState:UIControlStateNormal];
        
        self.twoBtn.hidden = YES;
        
    }
    else if (type == 2) {
    
        [self.oneBtn setTitle:@"退出共享" forState:UIControlStateNormal];
        [self.oneBtn setTitleColor:kUIColorFromRGB(0x909090) forState:UIControlStateNormal];
        
        self.twoBtn.hidden = YES;
        
    }
    else if (type == 3) {
        
        [self.oneBtn setTitle:@"彻底删除" forState:UIControlStateNormal];
        [self.oneBtn setTitleColor:kUIColorFromRGB(0xF91313) forState:UIControlStateNormal];
        
        self.twoBtn.hidden = NO;
        [self.twoBtn setTitle:@"恢复备忘" forState:UIControlStateNormal];
        [self.twoBtn setTitleColor:kUIColorFromRGB(0x3689E9) forState:UIControlStateNormal];
        
        
    }
    
    self.threeBtn.text = [NSString stringWithFormat:@"已选%ld项",count];
    self.threeBtn.textColor = kUIColorFromRGB(0x909090);
}

- (void)oneBtnAction {

    if ([self.delegate respondsToSelector:@selector(oneButtonClicked)]) {
        
        [self.delegate oneButtonClicked];
    }
}

- (void)twoBtnAction {

    if ([self.delegate respondsToSelector:@selector(twoButtonClicked)]) {
        
        [self.delegate twoButtonClicked];
    }
}

+ (instancetype)noteListBottomView {

    return [[[NSBundle mainBundle] loadNibNamed:@"TFNoteListBottomView" owner:self options:nil] lastObject];
}

@end
