
//
//  TFCustomSelectOptionCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/8/20.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCustomSelectOptionCell.h"
#import "TFCustomOptionItemCell.h"

@interface TFCustomSelectOptionCell ()<UITableViewDelegate,UITableViewDataSource,TFCustomOptionItemCellDelegate>

/** 标题 */
@property (nonatomic, weak) UILabel *titleLabel;
/** 必填符号 */
@property (nonatomic, weak) UILabel *requireLabel;
/** 提示文字 */
@property (nonatomic, weak) UILabel *placehoder;
/** 选项列表 */
@property (nonatomic, weak) UITableView *tableView;

/** optionArrs */
@property (nonatomic, strong) NSMutableArray *optionArrs;

/** 边框View */
@property (nonatomic, weak) UIView *borderView;

@end

@implementation TFCustomSelectOptionCell

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
    lable.textColor = ExtraLightBlackTextColor;
    lable.font = FONT(14);
    self.titleLabel = lable;
    lable.numberOfLines = 0;
//    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(self.contentView).with.offset(15);
//        make.top.equalTo(self.contentView).with.offset(8);
//        make.right.equalTo(self.contentView).with.offset(-15);
//
//    }];
    
    UILabel *requi = [[UILabel alloc] init];
    requi.text = @"*";
    self.requireLabel = requi;
    requi.textColor = RedColor;
    requi.font = BFONT(14);
    requi.backgroundColor = ClearColor;
    [self.contentView addSubview:requi];
    requi.textAlignment = NSTextAlignmentLeft;
//    [requi mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(self.contentView).with.offset(6);
//        make.top.equalTo(self.contentView).with.offset(8);
//    }];

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

//    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(self.contentView).with.offset(0);
//        make.top.equalTo(lable.mas_bottom).with.offset(5);
//        make.bottom.equalTo(self.contentView).with.offset(-5);
//        make.right.equalTo(self.contentView).with.offset(0);
//    }];
    
    UIView *borderView = [[UIView alloc] init];
    [tableView.backgroundView addSubview:borderView];
    self.borderView = borderView;
//    borderView.layer.cornerRadius = 4;
//    borderView.layer.borderWidth = 1;
//    borderView.layer.borderColor = WhiteColor.CGColor;
    [borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.tableView.backgroundView).with.offset(15);
        make.top.equalTo(self.tableView.backgroundView).with.offset(5);
        make.bottom.equalTo(self.tableView.backgroundView).with.offset(-10);
        make.right.equalTo(self.tableView.backgroundView).with.offset(-15);
        
    }];
    
    self.layer.masksToBounds = YES;
    self.bottomLine.hidden = NO;
    
    UILabel *placehoder = [[UILabel alloc] init];
    placehoder.text = @"";
    self.placehoder = placehoder;
    placehoder.textColor = GrayTextColor;
    placehoder.font = FONT(14);
    placehoder.backgroundColor = ClearColor;
    [self.contentView addSubview:placehoder];
    placehoder.textAlignment = NSTextAlignmentLeft;
    placehoder.hidden = YES;
}

/** 创建cell */
+(instancetype)customSelectOptionCellWithTableView:(UITableView *)tableView{
    
    static NSString *indentifier = @"TFCustomSelectOptionCell";
    TFCustomSelectOptionCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[TFCustomSelectOptionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
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
        if (self.model.selects.count == 0) {
            self.placehoder.hidden = NO;
            self.placehoder.text = @"请选择";
        }else{
            self.placehoder.hidden = YES;
            self.placehoder.text = @"";
        }
    }else{// 阴影

        self.borderView.hidden = YES;
        if (self.model.selects.count == 0){
            self.placehoder.text = @"未选择";
            self.placehoder.hidden = NO;
        }else{
            self.placehoder.hidden = YES;
            self.placehoder.text = @"";
        }
        self.titleLabel.textColor = ExtraLightBlackTextColor;
    }
    [self.tableView reloadData];
}

-(void)setModel:(TFCustomerRowsModel *)model{
    _model = model;
    
    CGFloat head = 15;
    CGFloat title = 80;
    self.headMargin = head;
    if ([model.field.structure isEqualToString:@"1"]) {
        
        // 标题
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView.mas_left).with.offset(head);
            make.top.equalTo(self.contentView.mas_top).with.offset(head);
            //            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-head);
            make.width.equalTo(@(title));
        }];
        // 必填
        [self.requireLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.titleLabel.mas_top);
            make.right.equalTo(self.titleLabel.mas_left);
            //            make.bottom.equalTo(self.titleLabel.mas_bottom);
            make.width.equalTo(@(8));
        }];
        // tableView
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.titleLabel.mas_right).with.offset(0);
            make.right.equalTo(self.contentView.mas_right).with.offset(0);
            make.top.equalTo(self.contentView.mas_top).with.offset(3);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-6);
        }];
        
        // placehoder
        [self.placehoder mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.titleLabel.mas_right).with.offset(20);
            make.right.equalTo(self.contentView.mas_right).with.offset(0);
            make.top.equalTo(self.contentView.mas_top).with.offset(15);
            make.height.equalTo(@18);
        }];
    }else{
        // 标题
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView).with.offset(head);
            make.top.equalTo(self.contentView).with.offset(12);
            make.right.equalTo(self.contentView).with.offset(-head);
        }];
        // 必填
        [self.requireLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.titleLabel.mas_top);
            make.right.equalTo(self.titleLabel.mas_left);
            //            make.bottom.equalTo(self.titleLabel.mas_bottom);
            make.width.equalTo(@(8));
        }];
        // tableView
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(-6);
            make.top.equalTo(self.titleLabel.mas_bottom).with.offset(6);
            make.bottom.equalTo(self.contentView).with.offset(-12);
            make.right.equalTo(self.contentView).with.offset(0);
        }];
        // placehoder
        [self.placehoder mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.titleLabel.mas_left).with.offset(0);
            make.right.equalTo(self.titleLabel.mas_right).with.offset(0);
            make.top.equalTo(self.titleLabel.mas_bottom).with.offset(15);
            make.height.equalTo(@18);
        }];
    }
    
    [self.optionArrs removeAllObjects];
    
    if (self.showEdit) {
        
        if ([model.type isEqualToString:@"picklist"]) {// 下拉
            if ([model.field.chooseType isEqualToString:@"0"]) {// 单选
                [self.optionArrs addObject:[NSMutableArray arrayWithArray:model.selects]];
            }else{// 多选
                [self.optionArrs addObject:[NSMutableArray arrayWithArray:model.selects]];
            }
        }else{// 多级下拉
            
            [self.optionArrs addObject:[NSMutableArray arrayWithArray:model.selects]];
//            if (model.selects.count) {
//                for (TFCustomerOptionModel *op in model.selects) {
//                    NSMutableArray *arr = [NSMutableArray array];
//                    [arr addObject:op];
//                    [self.optionArrs addObject:arr];
//                }
//                NSInteger totol = self.optionArrs.count;
//                if ([model.field.selectType isEqualToString:@"1"]) {
//                    for (NSInteger i = 0; i < 3-totol; i ++) {
//                        NSMutableArray *arr = [NSMutableArray array];
//                        [self.optionArrs addObject:arr];
//                    }
//                }else{
//                    for (NSInteger i = 0; i < 2-totol; i ++) {
//                        NSMutableArray *arr = [NSMutableArray array];
//                        [self.optionArrs addObject:arr];
//                    }
//                }
//            }
//            else{
//                if ([model.field.selectType isEqualToString:@"1"]) {
//                    NSMutableArray *arr = [NSMutableArray array];
//                    [self.optionArrs addObject:arr];
//                    NSMutableArray *arr1 = [NSMutableArray array];
//                    [self.optionArrs addObject:arr1];
//                    NSMutableArray *arr2 = [NSMutableArray array];
//                    [self.optionArrs addObject:arr2];
//                }else{
//                    NSMutableArray *arr = [NSMutableArray array];
//                    [self.optionArrs addObject:arr];
//                    NSMutableArray *arr1 = [NSMutableArray array];
//                    [self.optionArrs addObject:arr1];
//                }
//            }
        }
        
    }else{
        
        [self.optionArrs addObject:[NSMutableArray arrayWithArray:model.selects]];
        
    }
    if (model.selects.count != 0) {
        self.placehoder.text = @"";
        self.placehoder.hidden = YES;
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
    if ([fieldControl isEqualToString:@"1"]) {
        self.titleLabel.textColor = HexColor(0xb1b5bb);
    }else{
        self.titleLabel.textColor = ExtraLightBlackTextColor;
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
    
//    if (self.showEdit) {
//
//        if ([self.model.type isEqualToString:@"picklist"]) {// 下拉
//            return 1;
//        }else{
//            if ([self.model.field.selectType isEqualToString:@"1"]) {
//                return 3;
//            }else{
//                return 2;
//            }
//        }
//    }else{
//        return 1;
//    }
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFCustomOptionItemCell *cell = [TFCustomOptionItemCell customOptionItemCellWithTableView:tableView];
    cell.delegate = self;
    cell.edit = self.edit;
//    NSArray *options = self.optionArrs[indexPath.row];
    [cell refreshCustomOptionItemCellWithModel:self.model edit:NO];
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
            
            [self.delegate customOptionItemCellDidClickedOptions:self.model.entrys isSingle:YES model:self.model level:indexPath.row];
            
            
//            if ([self.model.field.selectType isEqualToString:@"1"]) {// 三级
//                if (indexPath.row == 0) {
//
//                    [self.delegate customOptionItemCellDidClickedOptions:self.model.entrys isSingle:YES model:self.model level:indexPath.row];
//
//                }
//                else if (indexPath.row == 1){
//
//                    NSArray *selOptions = self.optionArrs[indexPath.row-1];
//                    if (selOptions.count == 0) {
//                        [MBProgressHUD showError:@"请选择上一级" toView:KeyWindow];
//                        return;
//                    }
//                    for (TFCustomerOptionModel *op in selOptions) {
//                        if ([op.open isEqualToNumber:@1]) {
//                            [self.delegate customOptionItemCellDidClickedOptions:op.subList isSingle:YES model:self.model level:indexPath.row];
//                            break;
//                        }
//                    }
//                }
//                else{
//
//                    NSArray *selOptions = self.optionArrs[indexPath.row-1];
//                    if (selOptions.count == 0) {
//                        [MBProgressHUD showError:@"请选择上一级" toView:KeyWindow];
//                        return;
//                    }
//                    for (TFCustomerOptionModel *op in selOptions) {
//                        if ([op.open isEqualToNumber:@1]) {
//                            [self.delegate customOptionItemCellDidClickedOptions:op.subList isSingle:YES model:self.model level:indexPath.row];
//                            break;
//                        }
//                    }
//                }
//
//            }else{// 二级
//                if (indexPath.row == 0) {
//
//                    [self.delegate customOptionItemCellDidClickedOptions:self.model.entrys isSingle:YES model:self.model level:indexPath.row];
//                }else{
//
//                    NSArray *selOptions = self.optionArrs[indexPath.row-1];
//                    if (selOptions.count == 0) {
//                        [MBProgressHUD showError:@"请选择上一级" toView:KeyWindow];
//                        return;
//                    }
//                    for (TFCustomerOptionModel *op in selOptions) {
//                        if ([op.open isEqualToNumber:@1]) {
//                            [self.delegate customOptionItemCellDidClickedOptions:op.subList isSingle:YES model:self.model level:indexPath.row];
//                            break;
//                        }
//                    }
//                }
//            }
            
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [TFCustomOptionItemCell refreshCustomOptionItemCellHeightWithModel:self.model edit:NO];
 
//    if (self.optionArrs.count > indexPath.row) {
//
//        NSArray *options = self.optionArrs[indexPath.row];
//        return [TFCustomOptionItemCell refreshCustomOptionItemCellHeightWithOptions:options];
//    }else{
//        return 0;
//    }
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

#pragma mark - TFCustomOptionItemCellDelegate
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
    
    if ([model.field.structure isEqualToString:@"1"]) {// 左右
        
        CGFloat titleHeight =[HQHelper sizeWithFont:BFONT(14) maxSize:(CGSize){80,MAXFLOAT} titleStr:model.label].height;// 标题高度
        CGFloat optHeight = 0;
        
        optHeight += [TFCustomOptionItemCell refreshCustomOptionItemCellHeightWithModel:model edit:showEdit];
       
        height += optHeight;
        height += 8;// 边距
        
        if (height < (titleHeight + 30)) {
            height = titleHeight + 30;
        }
        
    }else{// 上下
        height += 8;// 顶部与标题的间距
        height += [HQHelper sizeWithFont:BFONT(14) maxSize:(CGSize){SCREEN_WIDTH-30,MAXFLOAT} titleStr:model.label].height;// 标题高度
        height += 8;// tableView与标题的间距
        height += 8;// tableView与底部的间距
        
        
        height += [TFCustomOptionItemCell refreshCustomOptionItemCellHeightWithModel:model edit:showEdit];
        
        if (height < 70) {
            height = 70;
        }
        
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
