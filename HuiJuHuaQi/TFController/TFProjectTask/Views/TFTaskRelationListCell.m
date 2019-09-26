//
//  TFTaskRelationListCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/8.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFTaskRelationListCell.h"
#import "TFTaskRelationCell.h"
#import "TFProjectSectionModel.h"

@interface TFTaskRelationListCell ()<UITableViewDelegate,UITableViewDataSource,TFTaskRelationCellDelegate>

/** tableView */
@property (nonatomic, weak) UITableView *tableView ;

/** relations */
@property (nonatomic, strong) NSMutableArray *relations;

/** footerView */
@property (nonatomic, strong) UIView *footerView;

/** type */
@property (nonatomic, assign) NSInteger type;

/** auth */
@property (nonatomic, assign) BOOL auth;

@end


@implementation TFTaskRelationListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupTableView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.layer.masksToBounds = YES;
    }
    return self;
}

+ (TFTaskRelationListCell *)taskRelationListCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFTaskRelationListCell";
    TFTaskRelationListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[TFTaskRelationListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.topLine.hidden = NO;
    cell.bottomLine.hidden = YES;
    cell.layer.masksToBounds = YES;
    return cell;
}


-(void)refreshTaskRelationListCellWithModels:(id)model type:(NSInteger)type auth:(BOOL)auth{
    
    self.relations = model;
    self.type = type;
    self.auth = auth;
    CGFloat heiht = 0;
    for (TFProjectSectionModel *model in self.relations) {
        
        if (![model.select isEqualToNumber:@1]) {
            heiht += [TFTaskRelationCell refreshTaskRelationCellHeightWithModel:model];
        }else{
            heiht += 40;
        }
    }
    if (type == 0) {
        self.tableView.height = heiht + 41;
        self.tableView.tableFooterView = self.footerView;
    }else{
        self.tableView.height = heiht;
        self.tableView.tableFooterView = nil;
    }
    
    [self.tableView reloadData];
    
}
+(CGFloat)refreshTaskRelationListCellHeightWithModels:(id)model type:(NSInteger)type{
    
    NSArray *arr = model;
    CGFloat heiht = 0;
    for (TFProjectSectionModel *model in arr) {
        
        if (![model.select isEqualToNumber:@1]) {
            heiht += [TFTaskRelationCell refreshTaskRelationCellHeightWithModel:model];
        }else{
            heiht += 44;
        }
    }
    if (type == 0) {
        heiht += 41;
    }
    
    return heiht;
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1, SCREEN_WIDTH, 0) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = WhiteColor;
    [self.contentView addSubview:tableView];
    self.tableView = tableView;
    tableView.scrollEnabled = NO;
    
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH-40,40}];
    UILabel *addLabel = [HQHelper labelWithFrame:(CGRect){25,0,SCREEN_WIDTH-40,40} text:@"添加关联" textColor:LightGrayTextColor textAlignment:NSTextAlignmentLeft font:FONT(14)];
    addLabel.font = FONT(14);
    [view addSubview:addLabel];
    self.footerView = view;
    tableView.tableFooterView = view;
    addLabel.userInteractionEnabled = YES;
    

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(footerClicked)];
    [addLabel addGestureRecognizer:tap];
    
}

- (void)footerClicked{
    
    if ([self.delegate respondsToSelector:@selector(addTaskRelation)]) {
        [self.delegate addTaskRelation];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.relations.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFTaskRelationCell *cell = [TFTaskRelationCell taskRelationCellWithTableView:tableView];
    [cell refreshTaskRelationCellWithModel:self.relations[indexPath.row] auth:self.auth];
    cell.delegate = self;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [TFTaskRelationCell refreshTaskRelationCellHeightWithModel:self.relations[indexPath.row]];
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

#pragma mark - TFTaskRelationCellDelegate
-(void)taskRelationCellLongPressItem:(TFProjectSectionModel *)model taskIndex:(NSInteger)taskIndex{
    
    if (self.type == 0) {
        
        if ([self.delegate respondsToSelector:@selector(taskRelationListLongPressWithModel:taskIndex:)]) {
            
            [self.delegate taskRelationListLongPressWithModel:model taskIndex:taskIndex];
        }
        
    }
}

-(void)taskRelationCellDidShow:(TFProjectSectionModel *)model{
    
    if ([self.delegate respondsToSelector:@selector(taskRelationListCellDidShow)]) {
        [self.delegate taskRelationListCellDidShow];
    }
    [self.tableView reloadData];
    
}

-(void)taskRelationCellDidClickedItem:(TFProjectRowModel *)model{
    if ([self.delegate respondsToSelector:@selector(taskRelationListDidClickedModel:)]) {
        [self.delegate taskRelationListDidClickedModel:model];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
