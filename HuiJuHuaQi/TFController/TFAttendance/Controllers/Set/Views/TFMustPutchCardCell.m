//
//  TFMustPutchCardCell.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/3/7.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFMustPutchCardCell.h"

@interface TFMustPutchCardCell ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, weak) UILabel *headerLabel;
@property (nonatomic, weak) UILabel *footerLabel;

@end

@implementation TFMustPutchCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.backgroundColor = HexColor(0xF8FBFE);
    self.tableView.backgroundColor = HexColor(0xF8FBFE);
    self.contentView.backgroundColor = HexColor(0xF8FBFE);
}
-(void)refreshCellWithModel:(TFAtdClassModel *)model{
    if (!IsStrEmpty(model.time)) {
        self.tableView.tableHeaderView = [self headerView];
        self.headerLabel.text = [HQHelper nsdateToTime:[model.time longLongValue] formatStr:@"yyyy-MM-dd"];
    }else{
        self.tableView.tableHeaderView = nil;
    }
    if (model.id) {
        self.tableView.tableFooterView = [self footerView];
        self.footerLabel.text = [NSString stringWithFormat:@"%@:%@",model.name,model.classDesc];
    }else{
        self.tableView.tableFooterView = nil;
    }
    [self.tableView reloadData];
}

+(CGFloat)refreshCellHeightModel:(TFAtdClassModel *)model{
    CGFloat height = 0;
    
    if (!IsStrEmpty(model.time)) {
        height += 40;
    }
    if (model.id) {
        height += 40;
    }
    return height;
}

+(instancetype)mustPutchCardCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFMustPutchCardCell" owner:self options:nil] lastObject];
}
+(instancetype)mustPutchCardCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFMustPutchCardCell";
    TFMustPutchCardCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [TFMustPutchCardCell mustPutchCardCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.layer.masksToBounds = YES;
    }
    return cell;
}

-(UIView *)headerView{
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,40}];
    UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){15,0,SCREEN_WIDTH-100,40}];
    [view addSubview:label];
    label.textColor = ExtraLightBlackTextColor;
    label.font = FONT(14);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"删除" forState:UIControlStateNormal];
    [btn setTitleColor:GreenColor forState:UIControlStateNormal];
    btn.titleLabel.font = FONT(14);
    btn.frame = CGRectMake(SCREEN_WIDTH-60, 0, 60, 40);
    [view addSubview:btn];
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if ([self.delegate respondsToSelector:@selector(mustPutchCardCellDidDelete:)]) {
            [self.delegate mustPutchCardCellDidDelete:self];
        }
    }];
    self.headerLabel = label;
    return view;
}

-(UIView *)footerView{
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,40}];
    UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){15,0,SCREEN_WIDTH-30,40}];
    [view addSubview:label];
    label.textColor = ExtraLightBlackTextColor;
    label.font = FONT(14);
    self.footerLabel = label;
    UIView *line = [[UIView alloc] initWithFrame:(CGRect){15,0,SCREEN_WIDTH-15,0.5}];
    line.backgroundColor = BackGroudColor;
    [view addSubview:line];
    return view;
}
#pragma mark - tableView 数据源及代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.layer.masksToBounds = YES;
    }
    cell.textLabel.text = @"";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
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


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
