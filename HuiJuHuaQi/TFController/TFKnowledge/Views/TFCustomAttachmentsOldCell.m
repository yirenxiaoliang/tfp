//
//  TFCustomAttachmentsOldCell.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/3/4.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCustomAttachmentsOldCell.h"
#import "TFSingleAttachmentCell.h"

@interface TFCustomAttachmentsOldCell ()<UITableViewDataSource,UITableViewDelegate,TFSingleAttachmentCellDelegate>

/** tableView */
@property (nonatomic, weak) UITableView *tableView;
/** 标题 */
@property (nonatomic, strong) UILabel *titleLabel;
/** 必填符号 */
@property (nonatomic, strong) UILabel *requireLabel;
/** borderView */
@property (nonatomic, strong) UIView *borderView;
/** Footer */
@property (nonatomic, strong) UIView *btnView;
/** addAttachBtn */
@property (nonatomic, strong) UIButton *addAttachBtn;
/** tap */
@property (nonatomic, strong) UITapGestureRecognizer *tap;

@end

@implementation TFCustomAttachmentsOldCell

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
    
    UIView *borderView = [[UIView alloc] init];
    [self.contentView addSubview:borderView];
    self.borderView = borderView;
    borderView.layer.cornerRadius = 4;
    borderView.layer.borderWidth = 1;
    borderView.layer.borderColor = HexColor(0xd5d5d5).CGColor;
    [borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).with.offset(15);
        make.top.equalTo(lable.mas_bottom).with.offset(8);
        make.bottom.equalTo(self.contentView).with.offset(-8);
        make.right.equalTo(self.contentView).with.offset(-15);
        
    }];
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = WhiteColor;
    [borderView addSubview:tableView];
    tableView.scrollEnabled = NO;
    self.tableView = tableView;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(borderView).with.offset(0);
        make.top.equalTo(borderView).with.offset(4);
        make.bottom.equalTo(borderView).with.offset(-4);
        make.right.equalTo(borderView).with.offset(0);
    }];
    
    self.btnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-30, 32)];
    UIButton *addAttachBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addAttachBtn.userInteractionEnabled = NO;
    [self.btnView addSubview:addAttachBtn];
    self.addAttachBtn = addAttachBtn;
    [addAttachBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btnView).with.offset(8);
        make.centerY.equalTo(self.btnView.mas_centerY);
    }];
    [addAttachBtn setImage:IMG(@"custom附件") forState:UIControlStateNormal];
    [addAttachBtn setTitle:@"添加附件" forState:UIControlStateNormal];
    [addAttachBtn setTitleColor:kUIColorFromRGB(0xACB8C5) forState:UIControlStateNormal];
    addAttachBtn.titleLabel.font = FONT(14);
    self.tableView.tableFooterView = self.btnView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addAttachmentsAction)];
    [self.btnView addGestureRecognizer:tap];
    self.tap = tap;
}

#pragma mark - 初始化tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.selects.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFFileModel *fileModel = self.model.selects[indexPath.row];
    TFSingleAttachmentCell *cell = [TFSingleAttachmentCell SingleAttachmentCellWithTableView:tableView];
    cell.type = (NSInteger)self.type;
    cell.delegate = self;
    [cell refreshSingleAttachmentCellWithModel:fileModel];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if ([self.delegate respondsToSelector:@selector(customAttachmentsCell:didClickedFile:index:)]) {
        TFFileModel *fileModel = self.model.selects[indexPath.row];
        [self.delegate customAttachmentsCell:self didClickedFile:fileModel index:indexPath.row];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 48;
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

/** 展示详情 */
-(void)setShowEdit:(BOOL)showEdit{
    
    _showEdit = showEdit;
    
    if (showEdit) {// 框
        
        self.borderView.layer.cornerRadius = 4;
        self.borderView.layer.borderWidth = 1;
        self.borderView.layer.borderColor = HexColor(0xd5d5d5).CGColor;
        self.borderView.layer.shadowColor = ClearColor.CGColor;
        self.borderView.layer.shadowOffset = CGSizeMake(0, 0);
        self.borderView.layer.shadowRadius = 0;
        self.borderView.layer.shadowOpacity = 0.5;
        self.borderView.backgroundColor = ClearColor;
        
    }else{// 阴影
        
        self.borderView.layer.cornerRadius = 4;
        self.borderView.layer.borderWidth = 0;
        self.borderView.layer.borderColor = HexColor(0xd5d5d5).CGColor;
        self.borderView.layer.shadowColor = HexColor(0xd5d5d5).CGColor;
        self.borderView.layer.shadowOffset = CGSizeMake(0, 0);
        self.borderView.layer.shadowRadius = 4;
        self.borderView.layer.shadowOpacity = 0.5;
        self.borderView.backgroundColor = WhiteColor;
    }
    
}

/** 刷新cell内容 */
-(void)setModel:(TFCustomerRowsModel *)model{
    
    _model = model;
    
    [self.tableView reloadData];
}
/** 类型 */
-(void)setType:(AttachmentsCellType)type{
    _type = type;
    if (type == AttachmentsCellEdit) {
        self.addAttachBtn.hidden = NO;
        self.tap.enabled = YES;
    }else{
        self.addAttachBtn.hidden = YES;
        self.tap.enabled = NO;
    }
}

/** 标题 */
-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
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
/** 刷新cell高度 */
+ (CGFloat)refreshCustomAttachmentsCellHeightWithModel:(TFCustomerRowsModel *)model type:(AttachmentsCellType)type{
    
    CGFloat height = 8;// title 与 上边距
    height += [HQHelper sizeWithFont:BFONT(12) maxSize:(CGSize){SCREEN_WIDTH-30,MAXFLOAT} titleStr:model.label].height;// title 高度
    height += 8;// borderView 与 title的间距
    if (model.selects.count) {
        height += (model.selects.count*48) + 10;// borderView 高度 == tableView的高度+上下间距
    }
    if (type == AttachmentsCellEdit) {
        height += 38;
    }else{
        if (model.selects == 0) {
            height += 38;
        }
    }
    height += 8;// borderView 与 下边距
    return height<75?75:height;
}
/** 刷新cell高度 */
+ (CGFloat)refreshCustomAttachmentsCellHeightWithFiles:(NSArray *)files{
    
    CGFloat height = 8;// title 与 上边距
    height += [HQHelper sizeWithFont:BFONT(12) maxSize:(CGSize){SCREEN_WIDTH-30,MAXFLOAT} titleStr:@"附件"].height;// title 高度
    height += 8;// borderView 与 title的间距
    if (files.count) {
        height += (files.count*48) + 10;// borderView 高度 == tableView的高度+上下间距
    }
    if (files == 0) {
        height += 38;
    }
    
    height += 8;// borderView 与 下边距
    return height<75?75:height;
}

#pragma mark TFSingleAttachmentCellDelegate
- (void)deleteAttachmentAction:(NSInteger)index {
    
    [self.model.selects removeObjectAtIndex:index];
    
    if ([self.delegate respondsToSelector:@selector(deleteAttachmentsWithIndex:)]) {
        
        [self.delegate deleteAttachmentsWithIndex:index];
    }
}

- (void)addAttachmentsAction {
    
    if ([self.delegate respondsToSelector:@selector(addAttachmentsClickedWithCell:)]) {
        
        [self.delegate addAttachmentsClickedWithCell:self];
    }
}

+ (TFCustomAttachmentsOldCell *)CustomAttachmentsCellWithTableView:(UITableView *)tableView {
    
    static NSString *indentifier = @"TFCustomAttachmentsOldCell";
    TFCustomAttachmentsOldCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[TFCustomAttachmentsOldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
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

