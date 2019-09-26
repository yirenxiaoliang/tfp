//
//  TFCustomMultiSelectCell.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/8/21.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCustomMultiSelectCell.h"
#import "TFCustomSelectCell.h"

@interface TFCustomMultiSelectCell ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
/** 标题 */
@property (nonatomic, strong) UILabel *titleLabel;
/** 必填符号 */
@property (nonatomic, strong) UILabel *requireLabel;
/** 点击索引 */
@property (nonatomic, strong) NSNumber *index;

@end

@implementation TFCustomMultiSelectCell

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupChildView];
    }
    return self;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupChildView];
    }
    return self;
}

- (void)setupChildView {
    
    UILabel *lable = [[UILabel alloc] init];
    [self.contentView addSubview:lable];
    lable.textColor = BlackTextColor;
    lable.font = FONT(14);
    self.titleLabel = lable;
    lable.numberOfLines = 0;
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).with.offset(15);
        make.top.equalTo(self.contentView).with.offset(8);
        make.right.equalTo(self.contentView).with.offset(-15);
        
    }];
    
    
    UILabel *requi = [[UILabel alloc] init];
    requi.text = @"*";
    self.requireLabel = requi;
    requi.textColor = RedColor;
    requi.font = BFONT(14);
    requi.backgroundColor = ClearColor;
    [self.contentView addSubview:requi];
    requi.textAlignment = NSTextAlignmentLeft;
    [requi mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).with.offset(6);
        make.top.equalTo(self.contentView).with.offset(8);
    }];
    
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = WhiteColor;
    [self.contentView addSubview:tableView];
    tableView.scrollEnabled = NO;
    self.tableView = tableView;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).with.offset(0);
        make.top.equalTo(lable.mas_bottom).with.offset(5);
        make.bottom.equalTo(self.contentView).with.offset(-5);
        make.right.equalTo(self.contentView).with.offset(0);
    }];
    
    
}

#pragma mark - 初始化tableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.entrys.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFCustomerOptionModel *model = self.model.entrys[indexPath.row];
    TFCustomSelectCell *cell = [TFCustomSelectCell CustomSelectCellWithTableView:tableView];
    cell.bottomLine.hidden = YES;
    cell.topLine.hidden = YES;
    [cell refreshCustomMultiCellWithModel:model];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (!self.edit) {
        return;
    }
    if ([self.fieldControl isEqualToString:@"1"]) {
        [MBProgressHUD showError:@"只读属性不可更改" toView:KeyWindow];
        return;
    }
    if ([self.model.field.chooseType isEqualToString:@"0"]) {
        
        self.index = @(indexPath.row);
        
        for (TFCustomerOptionModel *model in self.model.entrys) {
            model.open = @0;
        }
        
        TFCustomerOptionModel *model = self.model.entrys[indexPath.row];
        model.open = @1;
        
    }
    else {
        
        TFCustomerOptionModel *model = self.model.entrys[indexPath.row];
        if ([model.open isEqualToNumber:@1]) {
            model.open = @0;
        }else {
            model.open = @1;
        }
    }
    
    NSMutableArray *arr = [NSMutableArray array];
    for (TFCustomerOptionModel *model in self.model.entrys) {
        if ([model.open isEqualToNumber:@1]) {
            [arr addObject:model];
        }
    }
    self.model.selects = arr;
    
    if ([self.delegate respondsToSelector:@selector(customMultiSelectCellDidOptionWithModel:)]) {
        [self.delegate customMultiSelectCellDidOptionWithModel:self.model];
    }
    
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFCustomerOptionModel *model = self.model.entrys[indexPath.row];
    return [TFCustomSelectCell refreshCustomMultiCellHeightWithModel:model];
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

/** 刷新cell内容 */
-(void)setModel:(TFCustomerRowsModel *)model{
    
    _model = model;
    
    self.titleLabel.text = model.label;
    
    [self.tableView reloadData];
}

/** 必填控制 */
-(void)setFieldControl:(NSString *)fieldControl{
    _fieldControl = fieldControl;
    if ([fieldControl isEqualToString:@"2"]) {
        self.requireLabel.hidden = NO;
    }else{
        self.requireLabel.hidden = YES;
    }
    if ([fieldControl isEqualToString:@"1"]) {
        self.titleLabel.textColor = HexColor(0xb1b5bb);
    }else{
        self.titleLabel.textColor = ExtraLightBlackTextColor;
    }
}
/** 刷新cell高度 */
+ (CGFloat)refreshCustomMultiSelectCellHeightWithModel:(TFCustomerRowsModel *)model{

    CGFloat height = 8;// title 与 上边距
    CGSize size = [HQHelper sizeWithFont:BFONT(12) maxSize:(CGSize){SCREEN_WIDTH-30,MAXFLOAT} titleStr:model.label];
    height += size.height;// 标题的高度
    height += 8; // 标题 与 tableView的高度
    
    // tableView 的高度 == cell高度之和
    for (int i=0; i<model.entrys.count; i++) {
        TFCustomerOptionModel *op = model.entrys[i];
        height += [TFCustomSelectCell refreshCustomMultiCellHeightWithModel:op];
    }
    
    height += 8;// tableView 与 下边距
    
    return height;
}

+ (TFCustomMultiSelectCell *)CustomMultiSelectCellWithTableView:(UITableView *)tableView {
    
    static NSString *indentifier = @"TFCustomMultiSelectCell";
    TFCustomMultiSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[TFCustomMultiSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.masksToBounds = YES;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
