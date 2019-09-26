//
//  TFSubformCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/9/6.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFSubformCell.h"
#import "TFCustomBaseModel.h"
#import "TFFileElementCell.h"
#import "HQTFInputCell.h"
#import "HQSelectTimeCell.h"
#import "TFManyLableCell.h"
#import "HQSelectTimeView.h"
#import "TFSingleTextCell.h"
#import "HQTFMorePeopleCell.h"
#import "HQTFPeopleCell.h"
#import "TFSubformSectionView.h"
#import "TFCustomLocationCell.h"

@interface TFSubformCell ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,HQTFInputCellDelegate,TFFileElementCellDelegate,TFSubformSectionViewDelegate,TFCustomLocationCellDelegate,TFSingleTextCellDelegate>

/** UITableView *tableView */
@property (nonatomic, weak) UITableView *tableView;

/** 子表单 */
@property (nonatomic, strong) NSMutableArray *subforms;

/** tableHeaderView */
@property (nonatomic, strong) UILabel *tableHeaderView;

/** tableFooterView */
@property (nonatomic, strong) UIView *tableFooterView;

/** TFCustomerRowsModel */
@property (nonatomic, strong) TFCustomerRowsModel *rowModel;

@property (nonatomic, assign) NSInteger repeat;
@property (nonatomic, assign) NSInteger refresh;

@end


@implementation TFSubformCell


-(NSMutableArray *)subforms{
    
    if (!_subforms) {
        _subforms = [NSMutableArray array];
    }
    return _subforms;
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupTableView];
    }
    return self;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupTableView];
    }
    return self;
}
+ (TFSubformCell *)subformCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"TFSubformCell";
    TFSubformCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[TFSubformCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    cell.topLine.hidden = YES;
    cell.bottomLine.hidden = YES;
    cell.layer.masksToBounds = YES;
    return cell;
}

/** 刷新 */
-(void)refreshSubformCell{
    
    [self.tableView reloadData];
}
/** 新增刷新方法 */
-(void)refreshSubformCellWithModel:(TFCustomerRowsModel *)model{
    
    self.rowModel = model;
    
    if (self.repeat < 1) {
        self.repeat += 1;
        self.tableHeaderView.text = [NSString stringWithFormat:@"    %@",model.label];
        [self.subforms addObject:[self.rowModel copy]];
        self.rowModel.selects = self.subforms;
        [self.tableView reloadData];
    }
}

/** 详情、编辑等刷新方法 */
-(void)refreshSubformCellWithModel:(TFCustomerRowsModel *)model withSelects:(NSArray *)selects{
    
    self.rowModel = model;
    
    if (self.repeat < 1) {
        self.repeat += 1;
        self.tableHeaderView.text = [NSString stringWithFormat:@"    %@",model.label];
        [self.subforms addObject:[self.rowModel copy]];
        self.rowModel.selects = self.subforms;
        [self.tableView reloadData];
    }
}

-(void)setIsEdit:(BOOL)isEdit{
    _isEdit = isEdit;
    if (self.refresh < 1) {
        self.refresh += 1;
        if (isEdit) {
            self.tableView.tableFooterView = self.tableFooterView;
        }else{
            self.tableView.tableFooterView = nil;
        }
        
    }
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55+40) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    tableView.scrollEnabled = NO;
    
    [self.contentView addSubview:tableView];
    self.tableView = tableView;
    
    UILabel *requi = [[UILabel alloc] init];
    requi.text = @"*";
    self.requireLabel = requi;
    requi.textColor = RedColor;
    requi.font = FONT(14);
    requi.backgroundColor = ClearColor;
    [self.contentView addSubview:requi];
    requi.textAlignment = NSTextAlignmentLeft;
    [requi mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).with.offset(6);
        make.top.equalTo(self.contentView).with.offset(17);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(15);
        
    }];
    
    UILabel *tableHeaderView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,55} text:@"    子表单" textColor:ExtraLightBlackTextColor textAlignment:NSTextAlignmentLeft font:FONT(14)];
    tableHeaderView.backgroundColor = WhiteColor;
    self.tableHeaderView = tableHeaderView;
    
    UIButton *tableFooterView = [HQHelper buttonWithFrame:(CGRect){0,0,SCREEN_WIDTH,40} target:self action:@selector(footerClick)];
    tableFooterView.backgroundColor = BackGroudColor;
    [tableFooterView setTitle:@"+  增加栏目" forState:UIControlStateNormal];
    [tableFooterView setTitle:@"+  增加栏目" forState:UIControlStateHighlighted];
    [tableFooterView setTitleColor:GreenColor forState:UIControlStateNormal];
    [tableFooterView setTitleColor:GreenColor forState:UIControlStateHighlighted];
    tableFooterView.titleLabel.font = FONT(12);
    self.tableFooterView = tableFooterView;

    tableView.tableHeaderView = tableHeaderView;
    tableView.tableFooterView = tableFooterView;
    
    [tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    
    HQLog(@"%@",change[NSKeyValueChangeNewKey]);
    
    CGSize size = [change[NSKeyValueChangeNewKey] CGSizeValue];
    
    self.tableView.height = size.height + 8;
    
    if ([self.delegate respondsToSelector:@selector(subformCell:withHeight:)]) {
        [self.delegate subformCell:self withHeight:size.height+8];
    }
}



-(void)dealloc{
    [self.tableView removeObserver:self forKeyPath:@"contentSize"];
}




- (void)footerClick{
    
    self.repeat += 1;
    [self.subforms addObject:self.rowModel.mutableCopy];
    
    [self.tableView reloadData];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.subforms.count;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    TFCustomerRowsModel *model = self.subforms[section];
    return model.componentList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFCustomerRowsModel *layout = self.subforms[indexPath.section];
    TFCustomerRowsModel *model = layout.componentList[indexPath.row];
    TFCustomerFieldModel *field = model.field;
    
    if ([model.type isEqualToString:@"text"]) {// 单行文本
        
        TFSingleTextCell *cell = [TFSingleTextCell singleTextCellWithTableView:tableView];
        cell.titleLabel.text = model.label;
        cell.enterBtn.hidden = YES;
        cell.textView.placeholder = @"请输入";
        cell.textView.delegate = self;
        cell.textView.tag = 0x777 *indexPath.section + indexPath.row;
        cell.textView.text = TEXT(model.fieldValue);
        if ([field.fieldControl isEqualToString:@"2"]) {
            cell.requireLabel.hidden = NO;
        }else{
            cell.requireLabel.hidden = YES;
        }
        cell.textView.userInteractionEnabled = self.isEdit;
        cell.enterBtn.hidden = !self.isEdit;
        
        return cell;
        
    }else if ([model.type isEqualToString:@"reference"]){// 关联关系
        
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        cell.timeTitle.text = model.label;
        if (model.fieldValue) {
            cell.time.text = model.fieldValue;
            cell.time.textColor = [HQHelper colorWithHexString:model.field.defaultValueColor]?:BlackTextColor;
        }else{
            
            cell.time.text = @"关联关系";
            cell.time.textColor = PlacehoderColor;
        }
        if ([field.fieldControl isEqualToString:@"2"]) {
            cell.requireLabel.hidden = NO;
        }else{
            cell.requireLabel.hidden = YES;
        }
        cell.arrowShowState = !self.isEdit;
        
        return cell;
        
    }else if ([model.type isEqualToString:@"area"]){// area
        
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        cell.timeTitle.text = model.label;
        if (model.otherDict) {
            cell.time.text = model.otherDict[@"address"];
            cell.time.textColor = BlackTextColor;
        }else{
            cell.time.text = @"请选择";
            cell.time.textColor = PlacehoderColor;
        }
        if ([field.fieldControl isEqualToString:@"2"]) {
            cell.requireLabel.hidden = NO;
        }else{
            cell.requireLabel.hidden = YES;
        }
        cell.arrowShowState = !self.isEdit;
        return cell;
        
    }else if ([model.type isEqualToString:@"location"]) {// 定位
        
        TFSingleTextCell *cell = [TFSingleTextCell singleTextCellWithTableView:tableView];
        cell.titleLabel.text = model.label;
        cell.textView.placeholder = @"请输入";
        cell.textView.delegate = self;
        cell.textView.tag = 0x777 *indexPath.section + indexPath.row;
        cell.textView.text = TEXT(model.fieldValue);
        cell.enterBtn.hidden = NO;
        [cell.enterBtn setImage:[UIImage imageNamed:@"定位"] forState:UIControlStateNormal];
        [cell.enterBtn setImage:[UIImage imageNamed:@"定位"] forState:UIControlStateHighlighted];
        cell.enterBtn.tag = 0x777 *indexPath.section + indexPath.row;
        if ([field.fieldControl isEqualToString:@"2"]) {
            cell.requireLabel.hidden = NO;
        }else{
            cell.requireLabel.hidden = YES;
        }
        cell.delegate = self;
        
        cell.enterBtn.hidden = !self.isEdit;
        cell.textView.userInteractionEnabled = self.isEdit;
        return cell;
        
        //        TFCustomLocationCell *cell = [TFCustomLocationCell customLocationCellWithTableView:tableView];
        //        cell.delegate = self;
        //        cell.tag = 0x777 *indexPath.section + indexPath.row;
        //        [cell customLocationCellWithModel:model];
        //        if ([field.fieldControl isEqualToString:@"2"]) {
        //            cell.requireLabel.hidden = NO;
        //        }else{
        //            cell.requireLabel.hidden = YES;
        //        }
        //
        //        if (self.type == 1) {
        //            cell.isEdit = NO;
        //        }else{
        //            cell.isEdit = YES;
        //        }
        //        return cell;
        
    }else if ([model.type isEqualToString:@"textarea"]){// 多行文本
        
        TFManyLableCell *cell = [TFManyLableCell creatManyLableCellWithTableView:tableView];
        cell.titleLab.text = model.label;
        cell.textVeiw.delegate = self;
        cell.textVeiw.placeholder = @"请输入（200字以内）";
        cell.textVeiw.tag = 0x777 *indexPath.section + indexPath.row;
        cell.textVeiw.text = model.fieldValue;
        if ([field.fieldControl isEqualToString:@"2"]) {
            cell.requireLabel.hidden = NO;
        }else{
            cell.requireLabel.hidden = YES;
        }
        cell.textVeiw.userInteractionEnabled = self.isEdit;
        
        return cell;
        
    }else if ([model.type isEqualToString:@"number"]){// 电话
        
        HQTFInputCell *cell = [HQTFInputCell inputCellWithTableView:tableView];
        cell.titleLabel.text = model.label;
        cell.textField.placeholder = @"请输入";
        cell.delegate = self;
        cell.textField.tag = 0x123 * indexPath.section + indexPath.row;
        cell.textField.text = TEXT(model.fieldValue);
        [cell refreshInputCellWithType:0];
        
        if ([field.fieldControl isEqualToString:@"2"]) {
            cell.requireLabel.hidden = NO;
        }else{
            cell.requireLabel.hidden = YES;
        }
        cell.enterBtn.hidden = !self.isEdit;
        cell.textField.userInteractionEnabled = self.isEdit;
        
        return cell;
        
    }else if ([model.type isEqualToString:@"number"]){// 邮箱
        
        HQTFInputCell *cell = [HQTFInputCell inputCellWithTableView:tableView];
        cell.titleLabel.text = model.label;
        cell.textField.placeholder = @"请输入";
        cell.delegate = self;
        cell.textField.tag = 0x123 * indexPath.section + indexPath.row;
        cell.textField.text = TEXT(model.fieldValue);
        [cell refreshInputCellWithType:0];
        if ([field.fieldControl isEqualToString:@"2"]) {
            cell.requireLabel.hidden = NO;
        }else{
            cell.requireLabel.hidden = YES;
        }
        cell.enterBtn.hidden = !self.isEdit;
        cell.textField.userInteractionEnabled = self.isEdit;
        
        return cell;
        
    }else if ([model.type isEqualToString:@"attachment"]){// 附件
        
        TFFileElementCell *cell = [TFFileElementCell fileElementCellWithTableView:tableView];
        cell.delegate = self;
        cell.tag = 0x345 * indexPath.section + indexPath.row;
        [cell refreshFileElementCellWithFiles:model.selects withType:0];
        if ([field.fieldControl isEqualToString:@"2"]) {
            cell.requireLabel.hidden = NO;
        }else{
            cell.requireLabel.hidden = YES;
        }
        cell.isEdit = self.isEdit;
        return cell;
        
    }else if ([model.type isEqualToString:@"picture"]){// 图片
        
        TFFileElementCell *cell = [TFFileElementCell fileElementCellWithTableView:tableView];
        cell.delegate = self;
        cell.tag = 0x345 * indexPath.section + indexPath.row;
        [cell refreshFileElementCellWithFiles:model.selects withType:1];
        if ([field.fieldControl isEqualToString:@"2"]) {
            cell.requireLabel.hidden = NO;
        }else{
            cell.requireLabel.hidden = YES;
        }
        cell.isEdit = self.isEdit;
        return cell;
        
    }else if ([model.type isEqualToString:@"datetime"]){// 时间/日期
        
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        cell.timeTitle.text = model.label;
        if (model.fieldValue) {
            cell.time.text = TEXT(model.fieldValue);
            cell.time.textColor = BlackTextColor;
        }else{
            
            cell.time.text = @"请选择时间";
            cell.time.textColor = PlacehoderColor;
        }
        if ([field.fieldControl isEqualToString:@"2"]) {
            cell.requireLabel.hidden = NO;
        }else{
            cell.requireLabel.hidden = YES;
        }
        cell.arrowShowState = !self.isEdit;
        return cell;
        
    }else if ([model.type isEqualToString:@"identifier"]){// 自动编号
        
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        cell.timeTitle.text = model.label;
        cell.time.text = TEXT(model.fieldValue);
        cell.time.textColor = BlackTextColor;
        cell.arrowShowState = !self.isEdit;
        return cell;
        
    }else if ([model.type isEqualToString:@"number"]){// 邮箱
        
        HQTFInputCell *cell = [HQTFInputCell inputCellWithTableView:tableView];
        cell.titleLabel.text = model.label;
        cell.textField.placeholder = @"请输入";
        cell.delegate = self;
        cell.textField.tag = 0x123 * indexPath.section + indexPath.row;
        cell.textField.text = TEXT(model.fieldValue);
        [cell refreshInputCellWithType:0];
        if ([field.fieldControl isEqualToString:@"2"]) {
            cell.requireLabel.hidden = NO;
        }else{
            cell.requireLabel.hidden = YES;
        }
        cell.enterBtn.hidden = !self.isEdit;
        cell.textField.userInteractionEnabled = self.isEdit;
        
        return cell;
        
    }else if ([model.type isEqualToString:@"picklist"]){// 下拉列表
        
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        cell.timeTitle.text = model.label;
        if (model.fieldValue) {
            cell.time.text = TEXT(model.fieldValue);
            cell.time.textColor = BlackTextColor;
        }else{
            
            cell.time.text = @"请选择";
            cell.time.textColor = PlacehoderColor;
        }
        if ([field.fieldControl isEqualToString:@"2"]) {
            cell.requireLabel.hidden = NO;
        }else{
            cell.requireLabel.hidden = YES;
        }
        cell.arrowShowState = !self.isEdit;
        return cell;
        
    }else if ([model.type isEqualToString:@"multi"]){// 复选框
        
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        cell.timeTitle.text = model.label;
        if (model.fieldValue) {
            cell.time.text = TEXT(model.fieldValue);
            cell.time.textColor = BlackTextColor;
        }else{
            
            cell.time.text = @"请选择";
            cell.time.textColor = PlacehoderColor;
        }
        if ([field.fieldControl isEqualToString:@"2"]) {
            cell.requireLabel.hidden = NO;
        }else{
            cell.requireLabel.hidden = YES;
        }
        cell.arrowShowState = !self.isEdit;
        return cell;
        
    }else if ([model.type isEqualToString:@"personnel"]){// 人员
        
        if ([model.field.chooseType isEqualToString:@"1"]) {// 多选
            HQTFMorePeopleCell *cell = [HQTFMorePeopleCell morePeopleCellWithTableView:tableView];
            cell.titleLabel.text = @"执行人";
            cell.contentLabel.text = @"请添加";
            cell.contentLabel.textColor = PlacehoderColor;
            [cell refreshMorePeopleCellWithPeoples:@[]];
            cell.bottomLine.hidden = YES;
            cell.imageHidden = !self.isEdit;
            return cell;
        }else{// 单选
            HQTFPeopleCell *cell = [HQTFPeopleCell peopleCellWithTableView:tableView];
            cell.titleLabel.text = @"执行人";
            cell.contentLabel.text = @"";
            cell.contentLabel.textColor = LightBlackTextColor;
            cell.bottomLine.hidden = YES;
            cell.peoples = @[];
            cell.enterImg.hidden = !self.isEdit;
            return cell;
        }
    }
    
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = @"";
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    if (!self.isEdit) {
        return;
    }
    
    TFCustomerRowsModel *layout = self.subforms[indexPath.section];
    TFCustomerRowsModel *model = layout.componentList[indexPath.row];
    
    if ([model.type isEqualToString:@"datetime"]) {
        
        if ([self.delegate respondsToSelector:@selector(subformCellSelectTime:withModel:)]) {
            [self.delegate subformCellSelectTime:self withModel:model];
        }
        
    }
    
    if ([model.type isEqualToString:@"picklist"]) {// 下拉
        
        if ([self.delegate respondsToSelector:@selector(subformCellSelectPicklist:withModel:)]) {
            [self.delegate subformCellSelectPicklist:self withModel:model];
        }
        
    }
    
    if ([model.type isEqualToString:@"multi"]) {// 复选
        
        if ([self.delegate respondsToSelector:@selector(subformCellSelectMutil:withModel:)]) {
            [self.delegate subformCellSelectMutil:self withModel:model];
        }
    
    }
    
    if ([model.type isEqualToString:@"personnel"]) {// 人员
        
        if ([self.delegate respondsToSelector:@selector(subformCellSelectPersonnel:withModel:)]) {
            [self.delegate subformCellSelectPersonnel:self withModel:model];
        }
    }
    
    if ([model.type isEqualToString:@"area"]) {// 地区
        
        if ([self.delegate respondsToSelector:@selector(subformCellSelectArea:withModel:)]) {
            [self.delegate subformCellSelectArea:self withModel:model];
        }
    
    }

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFCustomerRowsModel *layout = self.subforms[indexPath.section];
    TFCustomerRowsModel *model = layout.componentList[indexPath.row];
//    TFCustomerFieldModel *field = model.field;

    if ([model.type isEqualToString:@"textarea"]) {
        return [TFManyLableCell refreshManyLableCellHeightWithModel:model type:0];
    }
    
    if ([model.type isEqualToString:@"picture"]) {
        return [TFFileElementCell refreshFileElementCellHeightWithFiles:model.selects structure:@"1" isEdit:YES];
    }
    
    if ([model.type isEqualToString:@"attachment"]) {
        return [TFFileElementCell refreshFileElementCellHeightWithFiles:model.selects structure:@"1" isEdit:YES];
    }
    
    return 55;
}




- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
//    TFCustomerRowsModel *layout = self.subforms[section];
    
    TFSubformSectionView *view = [TFSubformSectionView subformSectionView];
    view.tag = 0x888 + section;
    view.titleLabel.text = [NSString stringWithFormat:@"栏目%ld",section + 1];
    view.delegate = self;
    view.isEdit = self.isEdit;
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark - TFSubformSectionViewDelegate
-(void)subformSectionView:(TFSubformSectionView *)subformSectionView didClickedDeleteBtn:(UIButton *)button{
    
    NSInteger section = subformSectionView.tag - 0x888;
    
    [self.subforms removeObjectAtIndex:section];
    
    [self.tableView reloadData];
}


#pragma mark - TFSingleTextCellDelegate
-(void)singleTextCell:(TFSingleTextCell *)singleTextCell didClilckedEnterBtn:(UIButton *)enterBtn{
    
    NSInteger section = enterBtn.tag / 0x777;
    NSInteger row = enterBtn.tag % 0x777;
    
    TFCustomerRowsModel *layout = self.subforms[section];
    TFCustomerRowsModel *model = layout.componentList[row];
    
    if ([model.type isEqualToString:@"location"]) {// 定位
       
        if ([self.delegate respondsToSelector:@selector(subformCell:singleTextCell:didClilckedEnterBtn:withModel:)]) {
            [self.delegate subformCell:self singleTextCell:singleTextCell didClilckedEnterBtn:enterBtn withModel:model];
        }
        
    }

}

#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    
    NSInteger section = textView.tag / 0x777;
    NSInteger row = textView.tag % 0x777;
    
    TFCustomerRowsModel *layout = self.subforms[section];
    TFCustomerRowsModel *model = layout.componentList[row];
    
    model.fieldValue = textView.text;
}

#pragma mark - HQTFInputCellDelegate
-(void)inputCellWithTextField:(UITextField *)textField{
    
    NSInteger section = textField.tag / 0x123;
    NSInteger row = textField.tag % 0x123;
    
    TFCustomerRowsModel *layout = self.subforms[section];
    TFCustomerRowsModel *model = layout.componentList[row];
    
    model.fieldValue = textField.text;
    
}

#pragma mark - TFFileElementCellDelegate
-(void)fileElementCellDidClickedSelectFile:(TFFileElementCell *)fileElementCell {
    
    
    NSInteger section = fileElementCell.tag / 0x345;
    NSInteger row = fileElementCell.tag % 0x345;
    
    TFCustomerRowsModel *layout = self.subforms[section];
    TFCustomerRowsModel *model = layout.componentList[row];
    
    if ([self.delegate respondsToSelector:@selector(subformCell:fileElementCellDidClickedSelectFile:withModel:)]) {
        [self.delegate subformCell:self fileElementCellDidClickedSelectFile:fileElementCell withModel:model];
    }
    
}

-(void)fileElementCell:(TFFileElementCell *)fileElementCell didClickedFile:(TFFileModel *)file index:(NSInteger)index{
    
    
    NSInteger section = fileElementCell.tag / 0x345;
    NSInteger row = fileElementCell.tag % 0x345;
    
    TFCustomerRowsModel *layout = self.subforms[section];
    TFCustomerRowsModel *fileCus = layout.componentList[row];
    
    if ([self.delegate respondsToSelector:@selector(subformCell:fileElementCell:didClickedFile:index:withModel:)]) {
        [self.delegate subformCell:self fileElementCell:fileElementCell didClickedFile:file index:index withModel:fileCus];
    }
}
-(void)fileElementCellDidDeleteFile:(TFFileElementCell *)fileElementCell withIndex:(NSInteger)index{
    
    NSInteger section = fileElementCell.tag / 0x345;
    NSInteger row = fileElementCell.tag % 0x345;
    
    TFCustomerLayoutModel *layout = self.subforms[section];
    TFCustomerRowsModel *fileCus = layout.rows[row];
    
    [fileCus.selects removeObjectAtIndex:index];
    
    [self.tableView reloadData];
    
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
