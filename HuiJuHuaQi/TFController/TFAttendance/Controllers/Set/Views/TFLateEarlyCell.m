//
//  TFLateEarlyCell.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/3/6.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFLateEarlyCell.h"
#import "TFLateEarlyItemCell.h"

@interface TFLateEarlyCell()<UITableViewDelegate,UITableViewDataSource,TFLateEarlyItemCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UILabel *headLabel;
@property (nonatomic, strong) UILabel *footLabel;

@property (nonatomic, strong) TFLateNigthWalk *model;
@end

@implementation TFLateEarlyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self headerView];
    self.backgroundColor = HexColor(0xF8FBFE);
    self.bottomLine.hidden = YES;
    self.tableView.scrollEnabled = NO;
}

-(void)headerView{
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,40}];
    UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){16,0,SCREEN_WIDTH-100,40}];
    [view addSubview:label];
    self.headLabel = label;
    label.textColor = LightBlackTextColor;
    label.font = FONT(14);
    label.text = @"";
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"删除" forState:UIControlStateNormal];
    [btn setTitleColor:GreenColor forState:UIControlStateNormal];
    btn.frame = CGRectMake(SCREEN_WIDTH-70, 0, 70, 40);
    [view addSubview:btn];
    btn.titleLabel.font = FONT(12);
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if ([self.delegate respondsToSelector:@selector(lateEarlyCellDidDeleteBtn:)]) {
            [self.delegate lateEarlyCellDidDeleteBtn:self];
        }
    }];
    self.tableView.tableHeaderView = view;
    view.backgroundColor = HexColor(0xF8FBFE);
    UIView *line = [[UIView alloc] initWithFrame:(CGRect){0,40,SCREEN_WIDTH,0.5}];
    line.backgroundColor = CellSeparatorColor;
    [view addSubview:line];
}

-(UIView *)footerView{
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,40}];
    UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){15,0,SCREEN_WIDTH-30,40}];
    [view addSubview:label];
    label.text = @"";
    label.font = FONT(14);
    label.textColor = LightBlackTextColor;
    self.footLabel = label;
    view.backgroundColor = HexColor(0xF8FBFE);
    view.layer.borderColor = CellSeparatorColor.CGColor;
    view.layer.borderWidth = 0.5;
    return view;
}

-(void)refreshLateEarlyCellWithModel:(TFLateNigthWalk *)model{
    self.model = model;
    self.headLabel.text = [NSString stringWithFormat:@"栏目%ld",self.tag+1];
    if ((!IsStrEmpty(model.nigthwalkmin)) && (!IsStrEmpty(model.lateMin))) {
        self.tableView.tableFooterView = [self footerView];
        self.footLabel.text = [NSString stringWithFormat:@"第一天下班晚走%@小时，第二天上班可晚到%@小时",model.nigthwalkmin,model.lateMin];
    }else{
        self.tableView.tableFooterView = nil;
    }
    [self.tableView reloadData];
}

+(CGFloat)refreshLateEarlyCellHeightWithModel:(TFLateNigthWalk *)model{
    CGFloat height = 0;
    
    if (!IsStrEmpty(model.nigthwalkmin) && !IsStrEmpty(model.lateMin)) {
        height  = 88 + 80;
    }else{
        height = 88 + 40;
    }
    
    return height;
}

#pragma mark - tableView 数据源及代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TFLateEarlyItemCell *cell = [TFLateEarlyItemCell lateEarlyItemCellWithTableView:tableView];
    [cell refreshLateEarlyItemCellWithModel:self.model];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 88;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
    
}

#pragma TFLateEarlyItemCellDelegate
-(void)lateEarlyItemCellDidClickedSetting:(TFLateNigthWalk *)model{
    if ([self.delegate respondsToSelector:@selector(lateEarlyCellDidSetting:)]) {
        [self.delegate lateEarlyCellDidSetting:model];
    }
}

+(instancetype)lateEarlyCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFLateEarlyCell" owner:self options:nil] lastObject];
}

+ (instancetype)lateEarlyCellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"TFLateEarlyCell";
    TFLateEarlyCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self lateEarlyCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
