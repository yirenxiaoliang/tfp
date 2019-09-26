//
//  TFNoteTwoBtnBottomView.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/3/26.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFNoteTwoBtnBottomView.h"

@interface TFNoteTwoBtnBottomView ()

@property (weak, nonatomic) IBOutlet UIButton *moreBtn;

@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (weak, nonatomic) IBOutlet UILabel *countLab;

@end

@implementation TFNoteTwoBtnBottomView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    UILabel *line = [UILabel initCustom:CGRectMake(0, 0, SCREEN_WIDTH, 0.5) title:@"" titleColor:kUIColorFromRGB(0xFFFFFF) titleFont:10 bgColor:kUIColorFromRGB(0x909090)];
    [self addSubview:line];
    
    [self.moreBtn addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.addBtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)refreshNoteTwoBtnBottomViewWithType:(NSInteger)count {
    
    self.countLab.text = [NSString stringWithFormat:@"%ld项备忘",count];
}

- (void)moreAction {

    if ([self.delegate respondsToSelector:@selector(bottomViewForLeftMenu)]) {
        
        [self.delegate bottomViewForLeftMenu];
    }
}

- (void)addAction {

    if ([self.delegate respondsToSelector:@selector(newNote)]) {
        
        [self.delegate newNote];
    }
}

+ (instancetype)noteTwoBtnBottomView {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"TFNoteTwoBtnBottomView" owner:self options:nil] lastObject];
}

@end
