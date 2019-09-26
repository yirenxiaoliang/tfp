//
//  TFReferenceSearchAllRowCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/9/6.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFReferenceSearchAllRowCell.h"
#import "HQSelectTimeCell.h"

@interface TFReferenceSearchAllRowCell()<UITableViewDelegate,UITableViewDataSource>

/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** rows */
@property (nonatomic, strong) NSArray *rows;


@end

@implementation TFReferenceSearchAllRowCell

- (void)refreshCellWithRows:(NSArray *)rows{
    
    NSMutableArray *arr = [NSMutableArray array];
    for (TFFieldNameModel *model in rows) {
        if ([model.hidden isEqualToString:@"1"]) {
            continue;
        }
        [arr addObject:model];
    }
    
    self.rows = arr;
    self.tableView.height = arr.count * 20 + 10;
    [self.tableView reloadData];
}

+(CGFloat)refreshCellHeightWithRows:(NSArray *)rows{

    NSMutableArray *arr = [NSMutableArray array];
    for (TFFieldNameModel *model in rows) {
        if ([model.hidden isEqualToString:@"1"]) {
            continue;
        }
        [arr addObject:model];
    }
    
    if (arr.count == 0) {
        return 0;
    }else{
        return arr.count * 20 + 30;
    }

}

+ (TFReferenceSearchAllRowCell *)referenceSearchAllRowCellWithTableView:(UITableView *)tableView {
    
    static NSString *indentifier = @"TFReferenceSearchAllRowCell";
    TFReferenceSearchAllRowCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[TFReferenceSearchAllRowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupChild];
        self.contentView.backgroundColor = WhiteColor;
    }
    return self;
}

- (void)setupChild{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 0) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = RedColor;
    tableView.scrollEnabled = NO;
    [self addSubview:tableView];
    self.tableView = tableView;
    tableView.userInteractionEnabled = NO;
    
    UIImageView *selectImage = [[UIImageView alloc] init];
    [self addSubview:selectImage];
    [selectImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.height.width.equalTo(@30);
        make.centerY.equalTo(self.mas_centerY);
    }];
    self.selectImage = selectImage;
    selectImage.contentMode = UIViewContentModeCenter;
    selectImage.hidden = YES;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.rows.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFFieldNameModel *model = self.rows[indexPath.row];
    HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
    cell.topLine.hidden = YES;
    cell.bottomLine.hidden = YES;
    cell.arrowShowState = NO;
    if (indexPath.row == 0) {
        cell.timeTitle.text = [HQHelper stringWithFieldNameModel:model];
        cell.time.text = @"";
        cell.titltW.constant = SCREEN_WIDTH - 30;
        cell.timeTitle.font = FONT(15);
        cell.timeTitle.textColor = BlackTextColor;
        cell.time.font = FONT(12);
        cell.time.textColor = ExtraLightBlackTextColor;
    }else{
        cell.timeTitle.text = model.label;
        cell.time.text = [HQHelper stringWithFieldNameModel:model];
        cell.titltW.constant = 100;
        cell.timeTitle.font = FONT(12);
        cell.timeTitle.textColor = ExtraLightBlackTextColor;
        cell.time.font = FONT(12);
        cell.time.textColor = ExtraLightBlackTextColor;
    }
    cell.userInteractionEnabled = NO;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return 30;
    }
    return 20;
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




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
