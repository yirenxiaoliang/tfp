//
//  TFApprovalBarView.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/10/19.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFApprovalBarView.h"
#import "TFApprovalItemView.h"

@interface TFApprovalBarView ()<TFApprovalItemViewDelegate>

@property (nonatomic, weak) UIView *greenView;


@property (nonatomic, strong) NSMutableArray *views;

@end

@implementation TFApprovalBarView

-(NSMutableArray *)views{
    if (!_views) {
        _views = [NSMutableArray array];
    }
    return _views;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupChildView];

    }
    return self;
}

/** 初始化子控件 */
-(void)setupChildView{
    
    NSArray *names = @[@"我发起的",@"待我审批",@"我已审批",@"抄送到我"];
    NSArray *images = @[@"我发起的-o",@"待我审批-o",@"我已审批-o",@"抄送到我-o"];
    NSArray *selectedImages = @[@"我发起的",@"待我审批",@"我已审批",@"抄送到我"];
    for (NSInteger i = 0; i < 4; i ++) {
        TFApprovalItemView *view = [TFApprovalItemView approvalItemView];
        [self addSubview:view];
        view.tag = 0x123 + i;
        view.frame = CGRectMake(SCREEN_WIDTH/4 * i, 0, SCREEN_WIDTH/4, self.height);
        view.name = names[i];
        view.image = [UIImage imageNamed:images[i]];
        view.selectedImage = [UIImage imageNamed:selectedImages[i]];
        view.state = NO;
        view.number = 0;
        view.delegate = self;
        [self.views addObject:view];
        if (i == 0) {
            view.state = YES;
        }
    }
    
    UIView *greenView = [[UIView alloc] initWithFrame:(CGRect){0,self.height-2.5,18,2}];
    [self addSubview:greenView];
    greenView.backgroundColor = GreenColor;
    self.greenView = greenView;
    greenView.centerX = SCREEN_WIDTH/8;
    
    UIView *speView = [[UIView alloc] initWithFrame:(CGRect){0,self.height-0.5,self.width,0.5}];
    [self addSubview:speView];
    speView.backgroundColor = CellSeparatorColor;
    
}

-(void)approvalItemViewClicked:(TFApprovalItemView *)approvalItemView{
    NSInteger tag = approvalItemView.tag-0x123;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.greenView.centerX = SCREEN_WIDTH/8 + tag * SCREEN_WIDTH/4;
    }];
    
    for (TFApprovalItemView *view in self.views) {
        view.state = NO;
    }
    
    TFApprovalItemView *view = self.views[tag];
    view.state = YES;
    
    if ([self.delegate respondsToSelector:@selector(approvalBarViewDidClickWithIndex:)]) {
        [self.delegate approvalBarViewDidClickWithIndex:tag];
    }
}

-(void)setSelectedIndex:(NSInteger)selectedIndex{
    
    if (selectedIndex >= 0 && selectedIndex < self.views.count) {
        _selectedIndex = selectedIndex;
        
        for (TFApprovalItemView *view in self.views) {
            view.state = NO;
        }
        
        TFApprovalItemView *view = self.views[selectedIndex];
        view.state = YES;
        
        [UIView animateWithDuration:0.25 animations:^{
            self.greenView.centerX = SCREEN_WIDTH/8 + selectedIndex * SCREEN_WIDTH/4;
        }];
    }
}

-(void)refreshWaitApprovalNumber:(NSInteger)number{
    
    TFApprovalItemView *view = self.views[1];
    view.number = number;
}
-(void)refreshCopyApprovalNumber:(NSInteger)number{
    
    TFApprovalItemView *view = self.views[3];
    view.number = number;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
