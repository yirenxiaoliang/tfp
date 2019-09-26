//
//  TFProjectListView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/7/18.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjectListView.h"
#import "HQSelectTimeCell.h"
#import "TFProjectModel.h"

#define MarginWidth 55

@interface TFProjectListView ()<UITableViewDelegate,UITableViewDataSource>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** selectModel */
@property (nonatomic, strong) TFProjectModel *selectModel;

/** isPersonnel */
@property (nonatomic, strong) NSNumber *isPersonnel;


@end

@implementation TFProjectListView

+ (instancetype)projectListView{
    
    TFProjectListView *view = [[TFProjectListView alloc] initWithFrame:(CGRect){SCREEN_WIDTH,0,SCREEN_WIDTH,SCREEN_HEIGHT}];
    
    return view;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupChild];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupChild];
    }
    return self;
}



- (void)setupChild{
    
    UIView *bgview = [[UIView alloc] initWithFrame:(CGRect){0,0,MarginWidth,SCREEN_HEIGHT}];
    [self addSubview:bgview];
    
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){MarginWidth,0,SCREEN_WIDTH-MarginWidth,NaviHeight}];
    view.backgroundColor = WhiteColor;
    view.layer.masksToBounds = YES;
    [self addSubview:view];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:button];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    button.frame = CGRectMake(SCREEN_WIDTH-12-44-MarginWidth, 20+TopM, 44, 43);
    [button setTitleColor:GreenColor forState:UIControlStateNormal];
    [button addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line = [[UIView alloc] initWithFrame:(CGRect){0,NaviHeight-0.5,SCREEN_WIDTH-MarginWidth,0.5}];
    [view addSubview:line];
    line.backgroundColor = HexAColor(0xc8c8c8, 1);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBgView)];
    [bgview addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [bgview addGestureRecognizer:pan];
    
    [self setupTableView];
    
    self.backgroundColor = RGBAColor(0, 0, 0, 0);
    self.layer.masksToBounds = NO;
}

- (void)sure{
    
    if (self.isPersonnel) {
        if ([self.delegate respondsToSelector:@selector(filterViewDidSureBtnWithDict:)]) {
            [self.delegate filterViewDidSureBtnWithDict:@{@"projectId":@0}];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(filterViewDidSureBtnWithDict:)]) {
            [self.delegate filterViewDidSureBtnWithDict:@{@"projectId":self.selectModel.id}];
        }
    }
}

-(void)setConditions:(NSMutableArray *)conditions{
    
    _conditions = conditions;
    
    for (TFProjectModel *model in conditions) {
        if ([model.selectState isEqualToNumber:@1]) {
            self.selectModel = model;
            break;
        }
    }
    
    [self.tableView reloadData];
}

- (void)tapBgView{
    
    //    if ([self.delegate respondsToSelector:@selector(filterViewDidClicked:)]) {
    //        [self.delegate filterViewDidClicked:NO];
    //    }
    [self hideAnimation];
}

- (void)showAnimation{
    
    [KeyWindow addSubview:self];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.backgroundColor = RGBAColor(0, 0, 0, .5);
        self.left = 0;
    }];
    
}

- (void)hideAnimation{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.left = SCREEN_WIDTH;
        self.backgroundColor = RGBAColor(0, 0, 0, 0);
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

- (void)pan:(UIPanGestureRecognizer *)pan{
    
    CGPoint point = [pan translationInView:pan.view];
    
    //    HQLog(@"=%@=",NSStringFromCGPoint(point));
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.left = point.x;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            self.left += point.x-self.left;
            
            if (self.left <= 0) {
                self.left = 0.0;
            }else if (self.left >= SCREEN_WIDTH){
                self.left = SCREEN_WIDTH;
            }
            
            CGFloat alpha = self.left/(SCREEN_WIDTH-MarginWidth);
            HQLog(@"=======%f=====",0.5-0.5*alpha);
            
            self.backgroundColor = RGBAColor(0, 0, 0, 0.5-0.5*alpha);
            
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            if (self.left > MarginWidth) {
                
                [UIView animateWithDuration:0.25 animations:^{
                    
                    self.backgroundColor = RGBAColor(0, 0, 0, 0);
                    self.left = SCREEN_WIDTH;
                }completion:^(BOOL finished) {
                    
                    [self tapBgView];
                }];
            }else{
                
                [UIView animateWithDuration:0.25 animations:^{
                    
                    self.backgroundColor = RGBAColor(0, 0, 0, 0.5);
                    self.left = 0;
                }];
            }
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(MarginWidth, NaviHeight, SCREEN_WIDTH-MarginWidth, SCREEN_HEIGHT-NaviHeight) style:UITableViewStyleGrouped];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    [self addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    }
        
    return self.conditions.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {
        
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        cell.timeTitle.text = @"个人任务";
        cell.titltW.constant = self.width - 60;
        cell.backgroundColor = WhiteColor;
        cell.time.textColor = BlackTextColor;
        cell.time.text = @"";
        cell.timeTitle.textColor = LightBlackTextColor;
        if ([self.isPersonnel isEqualToNumber:@1]) {
            [cell.arrow setImage:[UIImage imageNamed:@"完成"]];
        }else{
            [cell.arrow setImage:nil];
        }
        cell.topLine.hidden = YES;
        return cell;
        
        
    }else{
        
        TFProjectModel *model = self.conditions[indexPath.row];
        
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        cell.timeTitle.text = model.name;
        cell.titltW.constant = self.width - 60;
        cell.backgroundColor = WhiteColor;
        cell.time.textColor = BlackTextColor;
        cell.time.text = @"";
        cell.timeTitle.textColor = LightBlackTextColor;
        if ([model.selectState isEqualToNumber:@1]) {
            [cell.arrow setImage:[UIImage imageNamed:@"完成"]];
        }else{
            [cell.arrow setImage:nil];
        }
        cell.topLine.hidden = NO;
        return cell;
        
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    
    if (indexPath.section == 0) {
        
        self.isPersonnel = @1;
        self.selectModel.selectState = @0;
        
    }else{
        
        self.isPersonnel = nil;
        self.selectModel.selectState = @0;
        
        TFProjectModel *model = self.conditions[indexPath.row];
        model.selectState = @1;
        self.selectModel = model;
        
    }
    
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 1) {
        return 0;
    }
    return 8;
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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
