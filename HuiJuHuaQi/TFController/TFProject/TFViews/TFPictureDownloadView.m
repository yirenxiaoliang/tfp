//
//  TFPictureDownloadView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/6/5.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFPictureDownloadView.h"
#import "HQRootButton.h"

@implementation TFDownloadModel



@end

@interface TFPictureDownloadView ()

/** buttons */
@property (nonatomic, strong) NSMutableArray *buttons;

@end


@implementation TFPictureDownloadView

-(NSMutableArray *)buttons{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    
    for (NSInteger i = 0; i < 3; i++) {
        HQRootButton *btn = [HQRootButton rootButton];
        btn.tipLable.hidden = YES;
        btn.scale = 0.7;
        btn.backgroundColor = ClearColor;
        [self addSubview:btn];
        btn.tag = 0x123 + i;
        btn.frame = CGRectMake(SCREEN_WIDTH/3 * i, 0, SCREEN_WIDTH/3, 80);
        [self.buttons addObject:btn];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:WhiteColor forState:UIControlStateHighlighted];
        [btn setTitleColor:WhiteColor forState:UIControlStateNormal];
        
    }
}

- (void)btnClicked:(UIButton *)button{
    
    if ([self.delegate respondsToSelector:@selector(pictureDownloadView:withIndex:)]) {
        [self.delegate pictureDownloadView:self withIndex:button.tag - 0x123];
    }
    
}

-(void)pictureDownloadViewWithModels:(NSArray *)models{
    
    if (models.count <= 0) {
        return;
    }
    
    if (models.count == 1) {
        TFDownloadModel *model1 = models[0];
        
        UIButton *btn0 = self.buttons[0];
        UIButton *btn1 = self.buttons[1];
        UIButton *btn2 = self.buttons[2];
        btn0.hidden = YES;
        btn2.hidden = YES;
        
        [btn1 setTitle:model1.name forState:UIControlStateNormal];
        [btn1 setImage:[UIImage imageNamed:model1.image] forState:UIControlStateNormal];
        [btn1 setTitle:model1.name forState:UIControlStateHighlighted];
        [btn1 setImage:[UIImage imageNamed:model1.image] forState:UIControlStateHighlighted];
        
    }else if (models.count == 2){
        
        TFDownloadModel *model1 = models[0];
        TFDownloadModel *model2 = models[1];
        UIButton *btn0 = self.buttons[0];
        UIButton *btn1 = self.buttons[1];
        UIButton *btn2 = self.buttons[2];
        btn1.hidden = YES;
        
        [btn0 setTitle:model1.name forState:UIControlStateNormal];
        [btn0 setImage:[UIImage imageNamed:model1.image] forState:UIControlStateNormal];
        [btn0 setTitle:model1.name forState:UIControlStateHighlighted];
        [btn0 setImage:[UIImage imageNamed:model1.image] forState:UIControlStateHighlighted];
        
        [btn2 setTitle:model2.name forState:UIControlStateNormal];
        [btn2 setImage:[UIImage imageNamed:model2.image] forState:UIControlStateNormal];
        [btn2 setTitle:model2.name forState:UIControlStateHighlighted];
        [btn2 setImage:[UIImage imageNamed:model2.image] forState:UIControlStateHighlighted];
        
    }else{
        
        TFDownloadModel *model1 = models[0];
        TFDownloadModel *model2 = models[1];
        TFDownloadModel *model3 = models[2];
        UIButton *btn0 = self.buttons[0];
        UIButton *btn1 = self.buttons[1];
        UIButton *btn2 = self.buttons[2];
        
        [btn0 setTitle:model1.name forState:UIControlStateNormal];
        [btn0 setImage:[UIImage imageNamed:model1.image] forState:UIControlStateNormal];
        [btn0 setTitle:model1.name forState:UIControlStateHighlighted];
        [btn0 setImage:[UIImage imageNamed:model1.image] forState:UIControlStateHighlighted];
        
        [btn1 setTitle:model2.name forState:UIControlStateNormal];
        [btn1 setImage:[UIImage imageNamed:model2.image] forState:UIControlStateNormal];
        [btn1 setTitle:model2.name forState:UIControlStateHighlighted];
        [btn1 setImage:[UIImage imageNamed:model2.image] forState:UIControlStateHighlighted];
        
        [btn2 setTitle:model3.name forState:UIControlStateNormal];
        [btn2 setImage:[UIImage imageNamed:model3.image] forState:UIControlStateNormal];
        [btn2 setTitle:model3.name forState:UIControlStateHighlighted];
        [btn2 setImage:[UIImage imageNamed:model3.image] forState:UIControlStateHighlighted];
        
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
