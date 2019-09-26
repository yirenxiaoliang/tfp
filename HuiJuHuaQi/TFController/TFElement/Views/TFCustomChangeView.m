//
//  TFCustomChangeView.m
//  HuiJuHuaQi
//
//  Created by HQ-30 on 2017/12/13.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCustomChangeView.h"
#import "TFCustomChangeCell.h"

@interface TFCustomChangeView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UIButton *cancelBtn;

@property (nonatomic, weak) UIButton *sureBtn;


@property (nonatomic, strong) NSMutableArray *items;

/**
 * 左按钮被点击函数
 */
@property (nonatomic, copy) ActionHandler onLeftTouched;

/**
 * 右按钮被点击函数
 */
@property (nonatomic, copy) ActionParameter onRightTouched;

/**
 * 关闭函数
 */
@property (nonatomic, copy) ActionHandler onDismiss;


@end

@implementation TFCustomChangeView

-(NSMutableArray *)items{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = BlackTextColor;
        label.textAlignment = NSTextAlignmentLeft;
        label.font = BFONT(16);
        [self addSubview:label];
        self.titleLabel = label;
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(self).with.offset(15);
            make.left.equalTo(self).with.offset(15);
            make.right.equalTo(self).with.offset(15);
            make.height.equalTo(@20);
        }];
        
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        tableView.backgroundColor = WhiteColor;
        [self addSubview:tableView];
        self.tableView = tableView;
        
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.equalTo(self).with.offset(-44);
            make.left.equalTo(self).with.offset(0);
            make.right.equalTo(self).with.offset(0);
            make.top.equalTo(@45);
        }];
        
        
        UIView *horLine = [[UIView alloc] init];
        [self addSubview:horLine];
        horLine.backgroundColor = HexColor(0xe2e2e2);
        
        [horLine mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.equalTo(self).with.offset(-44);
            make.left.equalTo(self).with.offset(0);
            make.right.equalTo(self).with.offset(0);
            make.height.equalTo(@0.5);
        }];
        
        UIView *verLine = [[UIView alloc] init];
        [self addSubview:verLine];
        verLine.backgroundColor = HexColor(0xe2e2e2);
        
        [verLine mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.equalTo(self).with.offset(0);
            make.top.equalTo(horLine.mas_bottom).with.offset(0);
            make.width.equalTo(@0.5);
            make.centerX.equalTo(self.mas_centerX);
        }];
        
        UIButton *cancelBtn = [[UIButton alloc] init];
        [self addSubview:cancelBtn];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitle:@"取消" forState:UIControlStateHighlighted];
        [cancelBtn setTitleColor:HexColor(0x0075ff) forState:UIControlStateNormal];
        [cancelBtn setTitleColor:HexColor(0x0075ff) forState:UIControlStateHighlighted];
        self.cancelBtn = cancelBtn;
        [cancelBtn addTarget:self action:@selector(leftButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setBackgroundImage:[HQHelper createImageWithColor:CellSeparatorColor] forState:UIControlStateHighlighted];
        
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(horLine.mas_bottom).with.offset(0);
            make.left.equalTo(self).with.offset(0);
            make.right.equalTo(verLine.mas_left).with.offset(0);
            make.bottom.equalTo(self).with.offset(0);
        }];
        
        UIButton *sureBtn = [[UIButton alloc] init];
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn setTitle:@"确定" forState:UIControlStateHighlighted];
        [sureBtn setTitleColor:HexColor(0x0075ff) forState:UIControlStateNormal];
        [sureBtn setTitleColor:HexColor(0x0075ff) forState:UIControlStateHighlighted];
        [sureBtn setBackgroundImage:[HQHelper createImageWithColor:CellSeparatorColor] forState:UIControlStateHighlighted];
        [self addSubview:sureBtn];
        self.sureBtn = sureBtn;
        [sureBtn addTarget:self action:@selector(rightButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        
        [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(horLine.mas_bottom).with.offset(0);
            make.right.equalTo(self).with.offset(0);
            make.left.equalTo(verLine.mas_right).with.offset(0);
            make.bottom.equalTo(self).with.offset(0);
        }];
        
        self.layer.cornerRadius = 12;
        self.layer.masksToBounds = YES;
        self.backgroundColor = WhiteColor;
        
    }
    return self;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TFCustomChangeModel *model = self.items[indexPath.row];
    TFCustomChangeCell *cell = [TFCustomChangeCell customChangeCellWithTableView:tableView];
    
    if ([model.select isEqualToNumber:@1]) {
        [cell.box setImage:[UIImage imageNamed:@"选中"]];
    }else{
        [cell.box setImage:[UIImage imageNamed:@"未选中22"]];
    }
    cell.name.text = model.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    TFCustomChangeModel *model = self.items[indexPath.row];
    
    if ([model.select isEqualToNumber:@1]) {
        model.select = @0;
    }else{
        model.select = @1;
    }
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 35;
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
 * 左按钮处理
 */
- (void)leftButtonTouched:(id)sender {
    if (self.onLeftTouched) self.onLeftTouched();
    [self dismiss];
}

/**
 * 右按钮处理
 */
- (void)rightButtonTouched:(id)sender {
    
    NSMutableArray *arr = [NSMutableArray array];
    for (TFCustomChangeModel *model in self.items) {
        if ([model.select isEqualToNumber:@1]) {
            [arr addObject:model];
        }
    }
    
    if (self.onRightTouched) self.onRightTouched(arr);
    [self dismiss];
}

- (void) dismiss {
    if (self.onDismiss) self.onDismiss();
}

/**
 * 提示框
 * @param title 标题
 * @param onRightTouched 右按钮被点击
 */
+ (void) showCustomChangeView:(NSString *)title
                        items:(NSArray <TFCustomChangeModel> *)items
               onRightTouched:(ActionParameter)onRightTouched {
    
    // 当前窗体
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    [[window viewWithTag:0x12345] removeFromSuperview];
    
    // 背景mask窗体
    UIButton *bgView = [[UIButton alloc] init];
    bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
    bgView.tag = 0x12345;
    [bgView addTarget:self action:@selector(tapBgView:) forControlEvents:UIControlEventTouchDown];
    bgView.alpha = 0;
    
    // 告警窗体
    TFCustomChangeView *view = [[TFCustomChangeView alloc] initWithFrame:(CGRect){20,0,SCREEN_WIDTH-100,100 + items.count * 35}];
    view.centerX = SCREEN_WIDTH/2.0;
    view.centerY = SCREEN_HEIGHT/2.0;
    [view.items addObjectsFromArray:items];
    [view.tableView reloadData];
    view.onRightTouched = onRightTouched;
    view.onDismiss = ^(void) {
        
        [UIView animateWithDuration:0.25 animations:^{
            bgView.alpha = 0;
        } completion:^(BOOL finished) {
            [bgView removeFromSuperview];
        }];
    };
    view.titleLabel.text = title;
    view.tag = 0x445;
    [bgView addSubview:view];
    
    [UIView animateWithDuration:0.25 animations:^{
        bgView.alpha = 1;
    }];
    
    [window addSubview:bgView];
    
    // 显示窗体
    [window makeKeyAndVisible];
}

+ (void)tapBgView:(UIButton *)tap{
    
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    
    [UIView animateWithDuration:0.25 animations:^{
        [window viewWithTag:0x12345].alpha = 0;
    } completion:^(BOOL finished) {
        [[window viewWithTag:0x12345] removeFromSuperview];
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
