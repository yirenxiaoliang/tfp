//
//  TFCustomSelectOptionOldCell.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/3/4.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCustomSelectOptionOldCell.h"
#import "TFCustomOptionItemOldCell.h"

@interface TFCustomSelectOptionOldCell ()<UITableViewDelegate,UITableViewDataSource,TFCustomOptionItemOldCellDelegate>

/** 标题 */
@property (nonatomic, weak) UILabel *titleLabel;
/** 必填符号 */
@property (nonatomic, weak) UILabel *requireLabel;
/** 选项列表 */
@property (nonatomic, weak) UITableView *tableView;

/** optionArrs */
@property (nonatomic, strong) NSMutableArray *optionArrs;

/** 边框View */
@property (nonatomic, weak) UIView *borderView;

@end

@implementation TFCustomSelectOptionOldCell

-(NSMutableArray *)optionArrs{
    if (!_optionArrs) {
        _optionArrs = [NSMutableArray array];
    }
    return _optionArrs;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupChildView];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupChildView];
    }
    return self;
}

/** 初始化子控件 */
- (void)setupChildView{
    
    UILabel *lable = [[UILabel alloc] init];
    [self.contentView addSubview:lable];
    lable.textColor = BlackTextColor;
    lable.font = BFONT(12);
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
    tableView.layer.masksToBounds = NO;
    self.tableView = tableView;
    tableView.backgroundView = [UIView new];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).with.offset(0);
        make.top.equalTo(lable.mas_bottom).with.offset(5);
        make.bottom.equalTo(self.contentView).with.offset(-5);
        make.right.equalTo(self.contentView).with.offset(0);
    }];
    
    UIView *borderView = [[UIView alloc] init];
    [tableView.backgroundView addSubview:borderView];
    self.borderView = borderView;
    borderView.layer.cornerRadius = 4;
    borderView.layer.borderWidth = 1;
    borderView.layer.borderColor = WhiteColor.CGColor;
    [borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.tableView.backgroundView).with.offset(15);
        make.top.equalTo(self.tableView.backgroundView).with.offset(5);
        make.bottom.equalTo(self.tableView.backgroundView).with.offset(-10);
        make.right.equalTo(self.tableView.backgroundView).with.offset(-15);
        
    }];
    
    self.layer.masksToBounds = YES;
    
}

/** 创建cell */
+(instancetype)customSelectOptionCellWithTableView:(UITableView *)tableView{
    
    static NSString *indentifier = @"TFCustomSelectOptionOldCell";
    TFCustomSelectOptionOldCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[TFCustomSelectOptionOldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.masksToBounds = YES;
    return cell;
}

/** 展示详情 */
-(void)setShowEdit:(BOOL)showEdit{
    
    _showEdit = showEdit;
    
    if (showEdit) {// 框
        
        self.borderView.hidden = YES;
        
    }else{// 阴影
        
        self.borderView.hidden = YES;
        
        //        self.borderView.hidden = NO;
        //        self.borderView.layer.cornerRadius = 4;
        //        self.borderView.layer.borderWidth = 0;
        //        self.borderView.layer.borderColor = HexColor(0xd5d5d5).CGColor;
        //        self.borderView.layer.shadowColor = HexColor(0xd5d5d5).CGColor;
        //        self.borderView.layer.shadowOffset = CGSizeMake(0, 0);
        //        self.borderView.layer.shadowRadius = 4;
        //        self.borderView.layer.shadowOpacity = 0.5;
        //        self.borderView.backgroundColor = WhiteColor;
    }
    [self.tableView reloadData];
}

-(void)setModel:(TFCustomerRowsModel *)model{
    _model = model;
    
    [self.optionArrs removeAllObjects];
    
    if (self.showEdit) {
        
        if ([model.type isEqualToString:@"picklist"]) {// 下拉
            if ([model.field.chooseType isEqualToString:@"0"]) {// 单选
                [self.optionArrs addObject:[NSMutableArray arrayWithArray:model.selects]];
            }else{// 多选
                [self.optionArrs addObject:[NSMutableArray arrayWithArray:model.selects]];
            }
        }else{// 多级下拉
            if (model.selects.count) {
                for (TFCustomerOptionModel *op in model.selects) {
                    NSMutableArray *arr = [NSMutableArray array];
                    [arr addObject:op];
                    [self.optionArrs addObject:arr];
                }
                NSInteger totol = self.optionArrs.count;
                if ([model.field.selectType isEqualToString:@"1"]) {
                    for (NSInteger i = 0; i < 3-totol; i ++) {
                        NSMutableArray *arr = [NSMutableArray array];
                        [self.optionArrs addObject:arr];
                    }
                }else{
                    for (NSInteger i = 0; i < 2-totol; i ++) {
                        NSMutableArray *arr = [NSMutableArray array];
                        [self.optionArrs addObject:arr];
                    }
                }
            }else{
                if ([model.field.selectType isEqualToString:@"1"]) {
                    NSMutableArray *arr = [NSMutableArray array];
                    [self.optionArrs addObject:arr];
                    NSMutableArray *arr1 = [NSMutableArray array];
                    [self.optionArrs addObject:arr1];
                    NSMutableArray *arr2 = [NSMutableArray array];
                    [self.optionArrs addObject:arr2];
                }else{
                    NSMutableArray *arr = [NSMutableArray array];
                    [self.optionArrs addObject:arr];
                    NSMutableArray *arr1 = [NSMutableArray array];
                    [self.optionArrs addObject:arr1];
                }
            }
        }
        
    }else{
        
        [self.optionArrs addObject:[NSMutableArray arrayWithArray:model.selects]];
        
    }
    
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
}

/** 标题 */
-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}

#pragma mark - 初始化tableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.showEdit) {
        
        if ([self.model.type isEqualToString:@"picklist"]) {// 下拉
            return 1;
        }else{
            if ([self.model.field.selectType isEqualToString:@"1"]) {
                return 3;
            }else{
                return 2;
            }
        }
    }else{
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFCustomOptionItemOldCell *cell = [TFCustomOptionItemOldCell customOptionItemCellWithTableView:tableView];
    cell.delegate = self;
    cell.edit = self.edit;
    NSArray *options = self.optionArrs[indexPath.row];
    [cell refreshCustomOptionItemCellWithOptions:options];
    cell.rightBtn.tag = 0x123 + indexPath.row;
    cell.showEdit = self.showEdit;
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
    
    if ([self.delegate respondsToSelector:@selector(customOptionItemCellDidClickedOptions:isSingle:model:level:)]) {
        
        if ([self.model.type isEqualToString:@"picklist"]) {
            if ([self.model.field.chooseType isEqualToString:@"0"]) {// 单选
                [self.delegate customOptionItemCellDidClickedOptions:self.model.controlEntrys.count > 0 ? self.model.controlEntrys : self.model.entrys isSingle:YES model:self.model level:indexPath.row];
            }else{// 多选
                [self.delegate customOptionItemCellDidClickedOptions:self.model.entrys isSingle:NO model:self.model level:indexPath.row];
            }
        }else{
            
            if ([self.model.field.selectType isEqualToString:@"1"]) {// 三级
                if (indexPath.row == 0) {
                    
                    [self.delegate customOptionItemCellDidClickedOptions:self.model.entrys isSingle:YES model:self.model level:indexPath.row];
                    
                }else if (indexPath.row == 1){
                    
                    NSArray *selOptions = self.optionArrs[indexPath.row-1];
                    if (selOptions.count == 0) {
                        [MBProgressHUD showError:@"请选择上一级" toView:KeyWindow];
                        return;
                    }
                    for (TFCustomerOptionModel *op in selOptions) {
                        if ([op.open isEqualToNumber:@1]) {
                            [self.delegate customOptionItemCellDidClickedOptions:op.subList isSingle:YES model:self.model level:indexPath.row];
                            break;
                        }
                    }
                }else{
                    
                    NSArray *selOptions = self.optionArrs[indexPath.row-1];
                    if (selOptions.count == 0) {
                        [MBProgressHUD showError:@"请选择上一级" toView:KeyWindow];
                        return;
                    }
                    for (TFCustomerOptionModel *op in selOptions) {
                        if ([op.open isEqualToNumber:@1]) {
                            [self.delegate customOptionItemCellDidClickedOptions:op.subList isSingle:YES model:self.model level:indexPath.row];
                            break;
                        }
                    }
                }
                
            }else{// 二级
                if (indexPath.row == 0) {
                    
                    [self.delegate customOptionItemCellDidClickedOptions:self.model.entrys isSingle:YES model:self.model level:indexPath.row];
                }else{
                    
                    NSArray *selOptions = self.optionArrs[indexPath.row-1];
                    if (selOptions.count == 0) {
                        [MBProgressHUD showError:@"请选择上一级" toView:KeyWindow];
                        return;
                    }
                    for (TFCustomerOptionModel *op in selOptions) {
                        if ([op.open isEqualToNumber:@1]) {
                            [self.delegate customOptionItemCellDidClickedOptions:op.subList isSingle:YES model:self.model level:indexPath.row];
                            break;
                        }
                    }
                }
            }
            
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.optionArrs.count > indexPath.row) {
        
        NSArray *options = self.optionArrs[indexPath.row];
        return [TFCustomOptionItemOldCell refreshCustomOptionItemCellHeightWithOptions:options];
    }else{
        return 0;
    }
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

#pragma mark - TFCustomOptionItemOldCellDelegate
-(void)customOptionItemCellDidClickedRightBtn:(UIButton *)rightBtn{
    
    if (!self.edit) {
        return;
    }
    if ([self.fieldControl isEqualToString:@"1"]) {
        [MBProgressHUD showError:@"只读属性不可更改" toView:KeyWindow];
        return;
    }
    
    NSInteger tag = rightBtn.tag - 0x123;
    for (NSInteger i = tag; i < self.optionArrs.count; i ++) {
        [self.optionArrs replaceObjectAtIndex:i withObject:[NSMutableArray array]];
        if (i < self.model.selects.count) {
            TFCustomerOptionModel *model = self.model.selects[i];
            model.open = @0;
        }
    }
    if (tag < self.model.selects.count) {
        self.model.selects = [NSMutableArray arrayWithArray:[self.model.selects subarrayWithRange:(NSRange){0,tag}]];
        [self.tableView reloadData];
    }
    
    [self handleOpenWithSelects:self.model.selects totals:self.model.entrys];
    
}

/** 将选中的之外的全部置为不选中 */
-(void)handleOpenWithSelects:(NSArray *)selects totals:(NSArray *)totals{
    
    for (TFCustomerOptionModel *op in totals) {
        BOOL have = NO;
        for (TFCustomerOptionModel *model in selects) {
            if ([model.label isEqualToString:op.label]) {
                have = YES;
                break;
            }
        }
        if (have == NO) {
            op.open = @0;
        }
        if (op.subList) {
            [self handleOpenWithSelects:selects totals:op.subList];
        }
    }
}

/** 高度 */
+(CGFloat)refreshCustomSelectOptionCellHeightWithModel:(TFCustomerRowsModel *)model showEdit:(BOOL)showEdit{
    
    CGFloat height = 0;
    
    height += 8;// 顶部与标题的间距
    height += [HQHelper sizeWithFont:BFONT(12) maxSize:(CGSize){SCREEN_WIDTH-30,MAXFLOAT} titleStr:model.label].height;// 标题高度
    height += 8;// tableView与标题的间距
    height += 8;// tableView与底部的间距
    
    NSMutableArray *options = [NSMutableArray array];
    
    if (showEdit) {
        if ([model.type isEqualToString:@"picklist"]) {// 下拉
            if ([model.field.chooseType isEqualToString:@"0"]) {// 单选
                [options addObject:[NSMutableArray arrayWithArray:model.selects]];
            }else{// 多选
                [options addObject:[NSMutableArray arrayWithArray:model.selects]];
            }
        }else{// 多级下拉
            if (model.selects.count) {
                for (TFCustomerOptionModel *op in model.selects) {
                    NSMutableArray *arr = [NSMutableArray array];
                    [arr addObject:op];
                    [options addObject:arr];
                }
                NSInteger totol = options.count;
                if ([model.field.selectType isEqualToString:@"1"]) {// 三级
                    for (NSInteger i = 0; i < 3-totol; i ++) {
                        NSMutableArray *arr = [NSMutableArray array];
                        [options addObject:arr];
                    }
                }else{// 两级
                    for (NSInteger i = 0; i < 2-totol; i ++) {
                        NSMutableArray *arr = [NSMutableArray array];
                        [options addObject:arr];
                    }
                }
            }else{
                if ([model.field.selectType isEqualToString:@"1"]) {
                    NSMutableArray *arr = [NSMutableArray array];
                    [options addObject:arr];
                    NSMutableArray *arr1 = [NSMutableArray array];
                    [options addObject:arr1];
                    NSMutableArray *arr2 = [NSMutableArray array];
                    [options addObject:arr2];
                }else{
                    NSMutableArray *arr = [NSMutableArray array];
                    [options addObject:arr];
                    NSMutableArray *arr1 = [NSMutableArray array];
                    [options addObject:arr1];
                }
            }
        }
    }else{
        
        [options addObject:[NSMutableArray arrayWithArray:model.selects]];
    }
    
    
    for (NSArray *arr in options) {// tableView的高度
        height += [TFCustomOptionItemOldCell refreshCustomOptionItemCellHeightWithOptions:arr];
    }
    
    return height;
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
