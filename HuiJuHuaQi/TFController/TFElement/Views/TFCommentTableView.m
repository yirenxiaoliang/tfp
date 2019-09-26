//
//  TFCommentTableView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/7/26.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCommentTableView.h"
#import "HQTFTaskDynamicCell.h"
#import "HQTFNoContentView.h"
#import "TFTaskHybirdDynamicModel.h"
#import "TFTaskDetailCommCell.h"
#import "TFTaskSeeCell.h"
#import "TFTaskDetailCommCell.h"

@interface TFCommentTableView ()<UITableViewDelegate,UITableViewDataSource,HQTFTaskDynamicCellDelegate>

/** tableView */
@property (nonatomic, weak) UITableView *tableView ;

/** 动态数组 */
@property (nonatomic, strong) NSMutableArray *dynamics;

/** isShow */
@property (nonatomic, assign) BOOL isShow;

/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;

/** type */
@property (nonatomic, assign) NSInteger type;

@end

@implementation TFCommentTableView

-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(SCREEN_WIDTH-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"暂无数据"];
    }
    return _noContentView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self setupTableView];
        
        self.tableView.scrollEnabled = NO;
    }
    return self;
}

-(void)setIsHeader:(BOOL)isHeader{
    _isHeader = isHeader;
    if (isHeader) {
        UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,self.width,44}];
        view.backgroundColor = WhiteColor;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = FONT(15);
        [view addSubview:button];
        button.frame = CGRectMake(15, 0, 70, 44);
        [button setTitleColor:BlackTextColor forState:UIControlStateNormal];
        [button setImage:IMG(@"评论CD") forState:UIControlStateNormal];
        [button setTitle:@" 评论" forState:UIControlStateNormal];
        self.tableView.tableHeaderView = view;
    }
}

/** 刷新数据 */
-(void)refreshHybirdTableViewWithDatas:(NSArray *)datas{
    self.type = 1;
    self.dynamics = [NSMutableArray arrayWithArray:datas];
    
    if (self.dynamics.count < 6) {
        self.isShow = YES;
    }
    
    if (self.dynamics.count == 0) {
        self.tableView.backgroundView = self.noContentView;
    }else{
        self.tableView.backgroundView = [UIView new];
    }
    
    for (NSInteger i = self.dynamics.count-1; i >= 0; i--) {
        TFTaskHybirdDynamicModel *model = self.dynamics[i];
        if (self.isShow) {
            model.show = @1;
        }else{
            if (i >= self.dynamics.count-5) {
                model.show = @1;
            }else{
                model.show = @0;
            }
        }
    }
    
    
    if ([self.delegate respondsToSelector:@selector(commentTableView:didChangeHeight:)]) {
        
        CGFloat height = 0;
        for (TFTaskHybirdDynamicModel *model in self.dynamics) {
            if ([model.show isEqualToNumber:@1]) {
                if ([model.dynamic_type integerValue] == 1) {
                    height += [HQTFTaskDynamicCell refreshCommentCellHeightWithHybirdModel:model];
                }else if ([model.dynamic_type integerValue] == 2){
                    height += 40;
                }else if ([model.dynamic_type integerValue] == 3){
                    height += [TFTaskDetailCommCell refreshTaskDetailCommCellHeightWithModel:model];
                }
            }
        }
        if (self.dynamics.count == 0) {
            if (self.isHeader) {
                [self.delegate commentTableView:self didChangeHeight:SCREEN_WIDTH+44];
            }else{
                [self.delegate commentTableView:self didChangeHeight:SCREEN_WIDTH];
            }
        }else{
            CGFloat minHei = self.isShow ? height : height + 40;
            
            if (self.isHeader) {
                
                [self.delegate commentTableView:self didChangeHeight:minHei+44 < SCREEN_WIDTH+44 ? SCREEN_WIDTH+44 : minHei+44];
            }else{
                [self.delegate commentTableView:self didChangeHeight:minHei < SCREEN_WIDTH ? SCREEN_WIDTH : minHei];
            }
        }
    }
    [self.tableView reloadData];
}

/** 刷新数据 */
-(void)refreshCommentTableViewWithDatas:(NSArray *)datas{

    self.dynamics = [NSMutableArray arrayWithArray:datas];
    
    if (self.dynamics.count < 6) {
        self.isShow = YES;
    }
    
    if (self.dynamics.count == 0) {
        self.tableView.backgroundView = self.noContentView;
    }else{
        self.tableView.backgroundView = [UIView new];
    }
    
    for (NSInteger i = self.dynamics.count-1; i >= 0; i--) {
        TFCustomerCommentModel *model = self.dynamics[i];
        if (self.isShow) {
            model.show = @1;
        }else{
            if (i >= self.dynamics.count-5) {
                model.show = @1;
            }else{
                model.show = @0;
            }
        }
    }
    
    
    [self.tableView reloadData];
    
    if ([self.delegate respondsToSelector:@selector(commentTableView:didChangeHeight:)]) {
        
        CGFloat height = 0;
        for (TFCustomerCommentModel *model in self.dynamics) {
            if ([model.show isEqualToNumber:@1]) {
                height += [HQTFTaskDynamicCell refreshCommentCellHeightWithCustomModel:model];
            }
        }
        if (self.dynamics.count == 0) {
            if (self.isHeader) {
                [self.delegate commentTableView:self didChangeHeight:SCREEN_WIDTH+44];
            }else{
                [self.delegate commentTableView:self didChangeHeight:SCREEN_WIDTH];
            }
        }else{
            CGFloat minHei = self.isShow ? height : height + 40;
            
            if (self.isHeader) {
                
                [self.delegate commentTableView:self didChangeHeight:minHei+44 < SCREEN_WIDTH+44 ? SCREEN_WIDTH+44 : minHei+44];
            }else{
                [self.delegate commentTableView:self didChangeHeight:minHei < SCREEN_WIDTH ? SCREEN_WIDTH : minHei];
            }
        }
    }
}


#pragma mark - 初始化tableView
- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    [self addSubview:tableView];
    self.tableView = tableView;
    self.tableView.backgroundView = self.noContentView;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dynamics.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.type == 0) {
        
        HQTFTaskDynamicCell *cell = [HQTFTaskDynamicCell taskDynamicCellWithTableView:tableView];
        cell.delegate = self;
        [cell refreshCommentCellWithCustomModel:self.dynamics[indexPath.row]];
        
        if (self.dynamics.count == indexPath.row + 1) {
            cell.bottomLine.hidden = YES;
        }else{
            cell.bottomLine.hidden = NO;
        }
        cell.contentView.backgroundColor = BackGroudColor;
        return cell;
    }else{
        TFTaskHybirdDynamicModel *model = self.dynamics[indexPath.row];
        
        if ([model.dynamic_type integerValue] == 1) {
            
            HQTFTaskDynamicCell *cell = [HQTFTaskDynamicCell taskDynamicCellWithTableView:tableView];
            cell.delegate = self;
            [cell refreshCommentCellWithHybirdModel:model];
            
            cell.bottomLine.hidden = YES;
            cell.contentView.backgroundColor = BackGroudColor;
            return cell;
        }else if ([model.dynamic_type integerValue] == 2){
            TFTaskSeeCell *cell = [TFTaskSeeCell taskSeeCellWithTableView:tableView];
            [cell refreshtaskSeeCellWithModel:model];
            cell.contentView.backgroundColor = BackGroudColor;
            return cell;
        }else{
            TFTaskDetailCommCell *cell = [TFTaskDetailCommCell taskDetailCommCellWithTableView:tableView];
            [cell refreshTaskDetailCommCellWithModel:model];
            return cell;
        }

    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.type == 0) {
        
        TFCustomerCommentModel *model = self.dynamics[indexPath.row];
        if ([model.show isEqualToNumber:@1]) {
            return [HQTFTaskDynamicCell refreshCommentCellHeightWithCustomModel:self.dynamics[indexPath.row]];
        }else{
            return 0;
        }
    }else{
        
        TFTaskHybirdDynamicModel *model = self.dynamics[indexPath.row];
        if ([model.show isEqualToNumber:@1]) {
            if ([model.dynamic_type integerValue] == 1) {
                return [HQTFTaskDynamicCell refreshCommentCellHeightWithHybirdModel:model];
            }else if ([model.dynamic_type integerValue] == 2){
                return 40;
            }else{
                return [TFTaskDetailCommCell refreshTaskDetailCommCellHeightWithModel:model];
            }
        }else{
            return 0;
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (self.isShow) {
        return 0;
    }else{
        return 40;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
  
    if (self.isShow) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }else{
        UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,40}];
        if (self.type == 0) {
            view.backgroundColor = WhiteColor;
        }else{
            view.backgroundColor = BackGroudColor;
        }
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"显示更多 ↑" forState:UIControlStateNormal];
        [button setTitle:@"显示更多 ↑" forState:UIControlStateHighlighted];
        [button setTitleColor:GreenColor forState:UIControlStateNormal];
        [button setTitleColor:GreenColor forState:UIControlStateHighlighted];
        button.frame = view.bounds;
        button.titleLabel.font = FONT(12);
        [view addSubview:button];
        [button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
        return view;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)buttonClicked{
    
    self.isShow = YES;
    
    for (NSInteger i = self.dynamics.count-1; i >= 0; i--) {
        TFCustomerCommentModel *model = self.dynamics[i];
        model.show = @1;
    }
    
    
    [self.tableView reloadData];
    
    if ([self.delegate respondsToSelector:@selector(commentTableView:didChangeHeight:)]) {
        
        CGFloat height = 0;
        if (self.type == 0) {
            
            for (TFCustomerCommentModel *model in self.dynamics) {
                if ([model.show isEqualToNumber:@1]) {
                    height += [HQTFTaskDynamicCell refreshCommentCellHeightWithCustomModel:model];
                }
            }
        }else{
            
            for (TFTaskHybirdDynamicModel *model in self.dynamics) {
                if ([model.show isEqualToNumber:@1]) {
                    if ([model.dynamic_type integerValue] == 1) {
                        height += [HQTFTaskDynamicCell refreshCommentCellHeightWithHybirdModel:model];
                    }else if ([model.dynamic_type integerValue] == 2){
                        height += 40;
                    }else if ([model.dynamic_type integerValue] == 3){
                        height += [TFTaskDetailCommCell refreshTaskDetailCommCellHeightWithModel:model];
                    }
                }
            }
        }
        if (self.isHeader) {
            [self.delegate commentTableView:self didChangeHeight:height + 44];
        }else{
            [self.delegate commentTableView:self didChangeHeight:height];
        }
    }
    
}


#pragma mark - HQTFTaskDynamicCellDelegate
-(void)taskDynamicCell:(HQTFTaskDynamicCell *)taskDynamicCell didClickVoice:(TFFileModel *)model{
    
    if ([self.delegate respondsToSelector:@selector(commentTableViewDidClickVioce:)]) {
        [self.delegate commentTableViewDidClickVioce:model];
    }
}


-(void)taskDynamicCell:(HQTFTaskDynamicCell *)taskDynamicCell didClickImage:(UIImageView *)imageView{
    
    if ([self.delegate respondsToSelector:@selector(commentTableViewDidClickImage:)]) {
        [self.delegate commentTableViewDidClickImage:imageView];
    }
}


-(void)taskDynamicCell:(HQTFTaskDynamicCell *)taskDynamicCell didClickFile:(TFFileModel *)file{
    
    if ([self.delegate respondsToSelector:@selector(commentTableViewDidClickFile:)]) {
        [self.delegate commentTableViewDidClickFile:file];
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
