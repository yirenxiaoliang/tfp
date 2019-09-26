//
//  TFRuleLateCell.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/6/18.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFRuleLateCell.h"
#import "TFPCSettingDetailMocel.h"
#import "TFAtdWatDataListModel.h"

@interface TFRuleLateCell ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSArray *rows;

@end

@implementation TFRuleLateCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupTableView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupTableView];
}


-(void)refreshRuleLateCellWithRows:(NSArray *)rows{
    self.rows = rows;
    [self.tableView reloadData];
}

+(CGFloat)refreshRuleLateCellHeightWithRows:(NSArray *)rows{
    CGFloat height = 0;
    
    height += rows.count == 0 ? 0 : (rows.count + 1) * 25 + 10;
    
    return height;
}

+(instancetype)ruleLateCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFRuleLateCell";
    TFRuleLateCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[TFRuleLateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.layer.masksToBounds = YES;
    }
    return cell;
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = HexColor(0xF8FBFE);
    tableView.showsVerticalScrollIndicator = NO;
    [self addSubview:tableView];
    self.tableView = tableView;
    
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 25);
    UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){15,0,130,25}];
    label.textColor = LightBlackTextColor;
    label.font = FONT(14);
    label.text = @"";
    self.titleLabel = label;
    [view addSubview:label];
    tableView.tableHeaderView = view;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.rows.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.layer.masksToBounds = YES;
        cell.backgroundColor = HexColor(0xF8FBFE);
        cell.contentView.backgroundColor = HexColor(0xF8FBFE);
    }
    cell.textLabel.textColor = GrayTextColor;
    cell.textLabel.font = FONT(14);
    if (self.type == 0) {
        TFLateNigthWalk *model = self.rows[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"第一天下班晚走%@小时，第二天可以晚到%@小时",TEXT(model.nigthwalkmin),TEXT(model.lateMin)];
        cell.imageView.image = nil;
    }else if (self.type == 1){
        TFAtdWatDataListModel *model = self.rows[indexPath.row];
        cell.textLabel.text = model.name;
        cell.imageView.image = IMG(@"打卡定位");
    }else{
        TFAtdWatDataListModel *model = self.rows[indexPath.row];
        cell.textLabel.text = model.name;
        cell.imageView.image = IMG(@"Wifi");
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 25;
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


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
