//
//  TFFileElementCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/8/22.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFFileElementCell.h"
#import "HQTFThreeLabelCell.h"
#import "HQTFTwoLineCell.h"

@interface TFFileElementCell ()<UITableViewDataSource,UITableViewDelegate,HQTFTwoLineCellDelegate>

/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** files */
@property (nonatomic, strong) NSMutableArray *files;

/** index 0:附件 1：图片 */
@property (nonatomic, assign) NSInteger index;


@end

@implementation TFFileElementCell

-(NSMutableArray *)files{
    if (!_files) {
        _files = [NSMutableArray array];
    }
    return _files;
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

+ (TFFileElementCell *)fileElementCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"TFFileElementCell";
    TFFileElementCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[TFFileElementCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    cell.topLine.hidden = NO;
    cell.bottomLine.hidden = YES;
    cell.layer.masksToBounds = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)refreshFileElementCellWithFiles:(NSArray *)files withType:(NSInteger)index{
    
    self.index = index;
    
    [self.files removeAllObjects];
    [self.files addObjectsFromArray:files];
    
    [self.tableView reloadData];
}

+ (CGFloat)refreshFileElementCellHeightWithFiles:(NSArray *)files structure:(NSString *)structure isEdit:(BOOL)isEdit{
    
    if (isEdit) {
        
        if ([structure isEqualToString:@"0"]) {
            return (files.count) * 60 + 90;
        }else{
            return (files.count) * 60 + 64;
        }
    }else{
        
        if ([structure isEqualToString:@"0"]) {
            return files.count == 0 ? 80 : files.count * 60 + 35;
        }else{
            return files.count == 0 ? 64 : files.count * 60;
        }
    }
}

- (UIView *)footerView{
    
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,62}];
    view.backgroundColor = ClearColor;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:button];
    button.frame = CGRectMake(20, 16, 30, 30);
//    [button setTitle:@"+" forState:UIControlStateNormal];
//    [button setTitle:@"+" forState:UIControlStateHighlighted];
//    [button setBackgroundImage:[HQHelper createImageWithColor:BackGroudColor] forState:UIControlStateNormal];
//    [button setBackgroundImage:[HQHelper createImageWithColor:BackGroudColor] forState:UIControlStateHighlighted];
    
    [button setBackgroundImage:[UIImage imageNamed:@"加人"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"加人"] forState:UIControlStateHighlighted];
    button.titleLabel.font = FONT(22);
    [button setTitleColor:GrayTextColor forState:UIControlStateNormal];
    [button setTitleColor:GrayTextColor forState:UIControlStateHighlighted];
    
    button.layer.cornerRadius = 15;
    button.layer.masksToBounds = YES;
    [button addTarget:self action:@selector(addClicked:) forControlEvents:UIControlEventTouchUpInside];
    return view;
}

- (void)addClicked:(UIButton *)button{
    
    if ([self.delegate respondsToSelector:@selector(fileElementCellDidClickedSelectFile:)]) {
        [self.delegate fileElementCellDidClickedSelectFile:self];
    }
    
}


#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = WhiteColor;
    tableView.scrollEnabled = NO;
    tableView.tableFooterView = [self footerView];
    [self.contentView addSubview:tableView];
    self.tableView = tableView;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@0);
        make.top.equalTo(@30);
        make.right.equalTo(@0);
        make.bottom.equalTo(@(-1));
        
    }];
    
    
    UILabel *lable = [[UILabel alloc] init];
    lable.textColor = ExtraLightBlackTextColor;
    lable.font = FONT(14);
    lable.backgroundColor = ClearColor;
    [self addSubview:lable];
    lable.textAlignment = NSTextAlignmentLeft;
    self.titleLab = lable;
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).with.offset(15);
        make.top.equalTo(self.contentView).with.offset(22);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(101);
        
    }];
    
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
        make.centerY.equalTo(lable.mas_centerY);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(15);
        
    }];
    
    self.layer.masksToBounds = YES;
}

-(void)setIsEdit:(BOOL)isEdit{
    _isEdit = isEdit;
    if (!isEdit) {
        self.tableView.tableFooterView = nil;
    }
    
    [self.tableView reloadData];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.files.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
 
    HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
    cell.type = TwoLineCellTypeTwo;
    [cell.enterImage setImage:[UIImage imageNamed:@"邮件已删除"] forState:UIControlStateNormal];
    [cell.enterImage setImage:[UIImage imageNamed:@"邮件已删除"] forState:UIControlStateNormal];
    cell.delegate = self;
    cell.enterImage.tag = 0x333 + indexPath.row;
    [cell refreshCellWithFileModel:self.files[indexPath.row]];
    cell.enterImage.hidden = NO;
    cell.enterImgTrailW.constant = 0;
    cell.enterImage.userInteractionEnabled = YES;
    if (self.isEdit) {
        cell.enterImage.hidden = NO;
    }else{
        cell.enterImage.hidden = YES;
    }
    if (indexPath.row == self.files.count-1) {
        cell.bottomLine.hidden = YES;
    }else{
        cell.bottomLine.hidden = NO;
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if ([self.delegate respondsToSelector:@selector(fileElementCell:didClickedFile:index:)]) {
        [self.delegate fileElementCell:self didClickedFile:self.files[indexPath.row] index:indexPath.row];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
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

#pragma mark - HQTFTwoLineCellDelegate
- (void)twoLineCell:(HQTFTwoLineCell *)cell didEnterImage:(UIButton *)enterBtn{
    
    NSInteger index = enterBtn.tag - 0x333;
    
    if ([self.delegate respondsToSelector:@selector(fileElementCellDidDeleteFile:withIndex:)]) {
        [self.delegate fileElementCellDidDeleteFile:self withIndex:index];
    }
}


-(void)setStructure:(NSString *)structure{
    _structure = structure;
    
    if ([structure isEqualToString:@"0"]) {
        
        [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.contentView).with.offset(12);
            
            make.width.mas_equalTo(SCREEN_WIDTH-30);
        }];
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@0);
            make.top.equalTo(@30);
            
        }];
        
    }else{
        
        [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.contentView).with.offset(22);
            
            make.width.mas_equalTo(101);
        }];
        
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@85);
            make.top.equalTo(@1);
            
        }];
    }
    
}

-(void)setFieldControl:(NSString *)fieldControl{
    _fieldControl = fieldControl;
    
    if ([fieldControl isEqualToString:@"2"]) {
        self.requireLabel.hidden = NO;
    }else{
        self.requireLabel.hidden = YES;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
