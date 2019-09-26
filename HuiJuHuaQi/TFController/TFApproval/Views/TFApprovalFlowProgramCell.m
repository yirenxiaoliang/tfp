//
//  TFApprovalFlowProgramCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/1/3.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFApprovalFlowProgramCell.h"
#import "TFApprovalFlowCell.h"

@interface TFApprovalFlowProgramCell ()<UITableViewDelegate,UITableViewDataSource>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** models */
@property (nonatomic, strong) NSMutableArray *models;

@property (nonatomic, assign) BOOL haveSectionHeader;

@end

@implementation TFApprovalFlowProgramCell

-(NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
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
        self.haveSectionHeader = YES;
        [self setupTableView];
    }
    return self;
}

+ (TFApprovalFlowProgramCell *)approvalFlowProgramCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"TFApprovalFlowProgramCell";
    TFApprovalFlowProgramCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[TFApprovalFlowProgramCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    cell.topLine.hidden = YES;
    cell.bottomLine.hidden = YES;
    cell.layer.masksToBounds = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)refreshApprovalFlowProgramCellWithModels:(NSArray *)models {
    
    [self.models removeAllObjects];
    [self.models addObjectsFromArray:models];
    
    [self.tableView reloadData];
}
- (void)refreshApprovalFlowProgramCellWithModels:(NSArray *)models haveHead:(BOOL)haveHead{
    
    self.haveSectionHeader = haveHead;
    [self.models removeAllObjects];
    [self.models addObjectsFromArray:models];
    
    [self.tableView reloadData];
}

+ (CGFloat)refreshApprovalFlowProgramCellHeightWithModels:(NSArray *)models{
    
    CGFloat height = 0;
    if (models.count) {
        height += 35;
    }
    
    for (id model in models) {
        
        height += [TFApprovalFlowCell refreshApprovalCellHeightWithModel:model];
    }
    
    return height;
}
+ (CGFloat)refreshApprovalFlowProgramCellHeightWithModels:(NSArray *)models haveHead:(BOOL)haveHead{
    
    CGFloat height = 0;
    if (haveHead) {
        if (models.count) {
            height += 35;
        }
    }
    for (id model in models) {
        
        height += [TFApprovalFlowCell refreshApprovalCellHeightWithModel:model];
    }
    
    return height;
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    tableView.scrollEnabled = NO;
    [self.contentView addSubview:tableView];
    self.tableView = tableView;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@(0));
        
    }];
    
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFApprovalFlowCell *cell = [TFApprovalFlowCell approvalFlowCellWithTableView:tableView];
   
    [cell refreshApprovalCellWithModel:self.models[indexPath.row]];
    if (indexPath.row == 0) {
        cell.topLineImage.hidden = YES;
        cell.bottomLineImage.hidden = NO;
        
    }else if (indexPath.row == self.models.count-1){
        cell.topLineImage.hidden = NO;
        cell.bottomLineImage.hidden = YES;
        cell.line.hidden = YES;
    }else{
        cell.topLineImage.hidden = NO;
        cell.bottomLineImage.hidden = NO;
        cell.line.hidden = NO;
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [TFApprovalFlowCell refreshApprovalCellHeightWithModel:self.models[indexPath.row]];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.haveSectionHeader) {
        return 35;
    }else{
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    
    if (self.haveSectionHeader) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){15,0,SCREEN_WIDTH-30,35}];
        [view addSubview:label];
        label.text = @"审批流程";
        label.textColor = LightBlackTextColor;
        label.font = FONT(14);
    }
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
