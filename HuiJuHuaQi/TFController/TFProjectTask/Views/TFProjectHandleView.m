//
//  TFProjectHandleView.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/4/19.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjectHandleView.h"

@interface TFProjectHandleView ()


@property (nonatomic, strong) NSMutableArray *btns;

@end

@implementation TFProjectHandleView
-(NSMutableArray *)btns{
    if (!_btns) {
        _btns = [NSMutableArray array];
    }
    return _btns;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupChild];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupChild];
    }
    return self;
}

-(void)setupChild{
    self.backgroundColor = WhiteColor;
    CGFloat width = SCREEN_WIDTH/4;
    NSArray *arr = @[@"删除",@"编辑",@"新增分类",@"新增任务",@"新增同级任务",@"新增下级任务"];
    NSArray *images = @[@"deletePro",@"editPro",@"categoryPro",@"taskPro",@"taskPro",@"taskPro"];
    for (NSInteger i = 0; i < arr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
        [btn setTitleColor:LightBlackTextColor forState:UIControlStateNormal];
        [btn setTitleColor:LightBlackTextColor forState:UIControlStateHighlighted];
        btn.titleLabel.font = FONT(14);
        btn.frame = CGRectMake(width * i, 0, width, 44);
        [btn setTitle:[NSString stringWithFormat:@" %@",arr[i]] forState:UIControlStateNormal];
        btn.tag = 0x123 + i;
        [btn setImage:IMG(images[i]) forState:UIControlStateNormal];
        [self.btns addObject:btn];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)btnClicked:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(projectHandleViewDidClickedIndex:btn:)]) {
        [self.delegate projectHandleViewDidClickedIndex:btn.tag-0x123 btn:btn];
    }
}

-(void)setType:(NSInteger)type{
    
    if (type == 0) {
        CGFloat total = 0;
        for (NSInteger i = 0 ; i < self.btns.count; i ++) {
            CGFloat width = 0;
            UIButton *btn = self.btns[i];
            if (i < 2) {
                width = 2*SCREEN_WIDTH/11;
            }else if(i < 4){
                width = (7*SCREEN_WIDTH/11)/2;
            }else {
                width = 0;
            }
            btn.frame = CGRectMake(total, 0, width, 44);
            total += width;
        }
        
    }else{
        CGFloat total = 0;
        for (NSInteger i = 0 ; i < self.btns.count; i ++) {
            CGFloat width = 0;
            UIButton *btn = self.btns[i];
            if (i < 2) {
                width = 2*SCREEN_WIDTH/11;
            }else if(i < 4){
                width = 0;
            }else {
                width = (7*SCREEN_WIDTH/11)/2;
            }
            btn.frame = CGRectMake(total, 0, width, 44);
            total += width;
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
