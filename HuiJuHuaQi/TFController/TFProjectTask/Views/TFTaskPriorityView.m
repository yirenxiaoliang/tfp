//
//  TFTaskPriorityView.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/4/18.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFTaskPriorityView.h"
#import "TFPriorityStatusCell.h"

@interface TFTaskPriorityView ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) ActionHandler cancelHandler;
@property (nonatomic, copy) ActionParameter sureHandler;
@property (weak, nonatomic) IBOutlet UIView *headVeiw;
/** 优先级选项 */
@property (nonatomic, strong) NSArray *prioritys;

@end

@implementation TFTaskPriorityView


-(void)awakeFromNib{
    [super awakeFromNib];
    self.tableView.scrollEnabled = NO;
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateHighlighted];
    self.cancelBtn.titleLabel.font = FONT(16);
    [self.cancelBtn setTitleColor:ExtraLightBlackTextColor forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:ExtraLightBlackTextColor forState:UIControlStateHighlighted];
    self.title.textColor = BlackTextColor;
    self.title.font = FONT(16);
    self.title.textAlignment = NSTextAlignmentCenter;
    self.title.text = @"优先级";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.headVeiw.backgroundColor = HexColor(0xF7F8FA);
    self.backgroundColor = WhiteColor;
}
- (IBAction)cancelClicked:(id)sender {
    
    if (self.cancelHandler) {
        self.cancelHandler();
    }
}

+(instancetype)taskPriorityView{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFTaskPriorityView" owner:self options:nil] lastObject];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.prioritys) {
        return self.prioritys.count;
    }else{
        if (self.type == 0) {
            return 4;
        }
        return 3;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TFPriorityStatusCell *cell = [TFPriorityStatusCell priorityStatusCellWithTableView:tableView];
    if (self.prioritys) {
        TFCustomerOptionModel *model = self.prioritys[indexPath.row];
        if (self.type == 0) {
            
            [cell refreshStatusCellWithModel:model];
        }else{
            [cell refreshPriorityStatusCellWithModel:model];
        }
        if ([model.open isEqualToNumber:@1]) {
            cell.selectBtn.selected = YES;
        }else{
            cell.selectBtn.selected = NO;
        }
    }else{
        [cell refreshPriorityStatusCellWithType:self.type status:indexPath.row];
        if (self.status == indexPath.row) {
            cell.selectBtn.selected = YES;
        }else{
            cell.selectBtn.selected = NO;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    if (self.prioritys) {
        for (TFCustomerOptionModel *model in self.prioritys) {
            model.open = @0;
        }
        TFCustomerOptionModel *model = self.prioritys[indexPath.row];
        model.open = [model.open isEqualToNumber:@1] ? @0 : @1;
        [self.tableView reloadData];
        if (self.sureHandler) {
            self.sureHandler(@[model]);
        }
    }else{
        self.status = indexPath.row;
        [self.tableView reloadData];
        if (self.sureHandler) {
            self.sureHandler(@(self.status));
        }
    }
    if (self.cancelHandler) {
        self.cancelHandler();
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

/**
 *  prioritys 为选项
 */
+(void)taskPriorityViewWithPrioritys:(NSArray *)prioritys type:(NSInteger)type sure:(ActionParameter)sure{
    
    // 当前窗体
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    [[window viewWithTag:0x98765] removeFromSuperview];
    
    // 背景mask窗体
    UIButton *bgView = [[UIButton alloc] init];
    bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
    bgView.tag = 0x98765;
    [bgView addTarget:self action:@selector(tapBgView:) forControlEvents:UIControlEventTouchDown];
    bgView.alpha = 0;
    
    TFTaskPriorityView *view = [TFTaskPriorityView taskPriorityView];
    view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 40 + 44 * prioritys.count);
    view.type = type;
    if (type == 0) {
        view.title.text = @"选择状态";
    }else{
        view.title.text = @"优先级";
    }
    view.prioritys = prioritys;
    view.sureHandler = sure;
    [view.tableView reloadData];
    __weak UIView *weakView = view;
    view.cancelHandler = ^{
        [UIView animateWithDuration:0.35 animations:^{
            weakView.y = SCREEN_HEIGHT;
            bgView.alpha = 0;
            
        } completion:^(BOOL finished) {
            [bgView removeFromSuperview];
        }];
        
    };
    view.tag = 0x11111;
    [bgView addSubview:view];
    [window addSubview:bgView];
    // 动画显示
    [UIView animateWithDuration:0.35 animations:^{
        view.y = SCREEN_HEIGHT -(40+44 * prioritys.count);
        bgView.alpha = 1;
        
    }];
    // 显示窗体
    [window makeKeyAndVisible];
    
}

+(void)taskPriorityViewWithType:(NSInteger)type status:(NSInteger)status sure:(ActionParameter)sure{
    
    // 当前窗体
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    [[window viewWithTag:0x98765] removeFromSuperview];
    
    // 背景mask窗体
    UIButton *bgView = [[UIButton alloc] init];
    bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
    bgView.tag = 0x98765;
    [bgView addTarget:self action:@selector(tapBgView:) forControlEvents:UIControlEventTouchDown];
    bgView.alpha = 0;
    
    TFTaskPriorityView *view = [TFTaskPriorityView taskPriorityView];
    view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 40 + 44 * 4);
    view.type = type;
    view.title.text = type == 0 ? @"选择状态" : @"优先级";
    view.status = status;
    view.sureHandler = sure;
    [view.tableView reloadData];
    __weak UIView *weakView = view;
    view.cancelHandler = ^{
        [UIView animateWithDuration:0.35 animations:^{
            weakView.y = SCREEN_HEIGHT;
            bgView.alpha = 0;
            
        } completion:^(BOOL finished) {
            [bgView removeFromSuperview];
        }];
        
    };
    view.tag = 0x11111;
    [bgView addSubview:view];
    [window addSubview:bgView];
    // 动画显示
    [UIView animateWithDuration:0.35 animations:^{
        view.y = SCREEN_HEIGHT -(40+44 * 4);
        bgView.alpha = 1;
        
    }];
    // 显示窗体
    [window makeKeyAndVisible];
    
}

+ (void)tapBgView:(UIButton *)tap{
    
    
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    
    [UIView animateWithDuration:0.35 animations:^{
        [window viewWithTag: 0x11111].y = SCREEN_HEIGHT;
        [window viewWithTag:0x98765].alpha = 0;
        
    } completion:^(BOOL finished) {
        [[window viewWithTag:0x98765] removeFromSuperview];
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
