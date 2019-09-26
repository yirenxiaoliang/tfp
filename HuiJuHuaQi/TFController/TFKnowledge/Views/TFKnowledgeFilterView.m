//
//  TFKnowledgeFilterView.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/1/24.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFKnowledgeFilterView.h"
#import "TFKnowledgeBL.h"
#import "TFKnowledgeFilterItemCell.h"
#define MarginWidth 55
#define Color RGBColor(0x3d, 0xb8, 0xc1)




@interface TFKnowledgeFilterView ()<UITableViewDelegate,UITableViewDataSource,TFKnowledgeFilterItemCellDelegate,HQBLDelegate>

@property (nonatomic, weak)  UITableView *tableView;

@property (nonatomic, strong) TFKnowledgeBL *knowledgeBL;

@property (nonatomic, strong) NSMutableArray *catagorys;

@property (nonatomic, strong) TFCategoryModel *requestModel;

@property (nonatomic, strong) NSMutableArray *subjects;

@end

@implementation TFKnowledgeFilterView
-(NSMutableArray *)subjects{
    if (!_subjects) {
        _subjects = [NSMutableArray array];
        NSArray *arr = @[@"全部知识",@"我创建的",@"我部门的",@"我收藏的",@"邀我回答"];
        for (NSInteger i = 0; i < 5; i++) {
            TFCategoryModel *model = [[TFCategoryModel alloc] init];
            model.name = arr[i];
            
            [_subjects addObject:model];
        }
    }
    return _subjects;
}

-(NSMutableArray *)catagorys{
    if (!_catagorys) {
        _catagorys = [NSMutableArray array];
    }
    return _catagorys;
}

-(TFKnowledgeBL *)knowledgeBL{
    if (!_knowledgeBL) {
        _knowledgeBL = [TFKnowledgeBL build];
        _knowledgeBL.delegate = self;
    }
    return _knowledgeBL;
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
    
    UIView *headView = [[UIView alloc] initWithFrame:(CGRect){MarginWidth,0,SCREEN_WIDTH-MarginWidth,NaviHeight}];
    headView.backgroundColor = WhiteColor;
    [self addSubview:headView];
    
    UILabel *titleView = [[UILabel alloc] init];
    titleView.text = @"筛选";
    titleView.font = BFONT(18);
    [titleView sizeToFit];
    [headView addSubview:titleView];
    titleView.textColor = BlackTextColor;
    titleView.center = CGPointMake(headView.width/2, (NaviHeight-TopM)/2 + TopM);
    titleView.bottom = headView.height-12;
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [headView addSubview:sureBtn];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitle:@"确定" forState:UIControlStateHighlighted];
    [sureBtn setTitleColor:GreenColor forState:UIControlStateNormal];
    [sureBtn setTitleColor:GreenColor forState:UIControlStateHighlighted];
    sureBtn.frame = CGRectMake( headView.width-60, TopM, 60, NaviHeight-StatusBarHeight-TopM);
    [sureBtn addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.bottom = headView.height;
    
//    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [headView addSubview:startBtn];
//    [startBtn setTitle:@"重置" forState:UIControlStateNormal];
//    [startBtn setTitle:@"重置" forState:UIControlStateHighlighted];
//    [startBtn setTitleColor:GreenColor forState:UIControlStateNormal];
//    [startBtn setTitleColor:GreenColor forState:UIControlStateHighlighted];
//    startBtn.frame = CGRectMake(0, 0, headView.width/2, 49);
//    [startBtn addTarget:self action:@selector(startClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line = [[UIView alloc] initWithFrame:(CGRect){0,headView.height-0.5,headView.width,0.5}];
    line.backgroundColor = CellSeparatorColor;
    [headView addSubview:line];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBgView)];
//    [bgview addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [bgview addGestureRecognizer:pan];
    
    [self setupTableView];
    
    self.backgroundColor = RGBAColor(0, 0, 0, 0);
    self.layer.masksToBounds = NO;
    
    [self.knowledgeBL requestGetKnowledgeCategory];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_getKnowledgeCategory) {
        
        [self.catagorys removeAllObjects];
        [self.catagorys addObjectsFromArray:resp.body];
        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_knowledgeLabel) {
        [MBProgressHUD hideHUDForView:self.tableView animated:YES];
        self.requestModel.labels = resp.body;
        self.requestModel.show = @1;
        for (TFCategoryModel *ll in self.requestModel.labels) {
            ll.select = self.requestModel.select;
        }
        [self.tableView reloadData];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    [MBProgressHUD hideHUDForView:self animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}

-(void)sure{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSInteger i = 0; i < self.subjects.count;i++) {
        TFCategoryModel *model = self.subjects[i];
        if ([model.select isEqualToNumber:@1]) {
            [dict setObject:@(i) forKey:@"range"];
            break;
        }
    }
    NSString *categoryId = @"";
    NSString *labelId = @"";
    for (TFCategoryModel *model in self.catagorys) {
        if ([model.select isEqualToNumber:@1]) {
            categoryId = [categoryId stringByAppendingString:[NSString stringWithFormat:@"%@,",[model.id description]]];
        }
        for (TFCategoryModel *label in model.labels) {
            if ([label.select isEqualToNumber:@1]) {
                labelId = [labelId stringByAppendingString:[NSString stringWithFormat:@"%@,",[label.id description]]];
            }
        }
    }
    if (categoryId.length) {
        categoryId = [categoryId substringToIndex:categoryId.length-1];
    }
    if (labelId.length) {
        labelId = [labelId substringToIndex:labelId.length-1];
    }
    [dict setObject:categoryId forKey:@"categoryId"];
    [dict setObject:labelId forKey:@"labelId"];
    
    if ([self.delegate respondsToSelector:@selector(filterViewDidSureBtnWithDict:)]) {
        [self.delegate filterViewDidSureBtnWithDict:dict];
    }
}

- (void)tapBgView{
    
    if ([self.delegate respondsToSelector:@selector(filterViewDidClicked:)]) {
        [self.delegate filterViewDidClicked:NO];
    }
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
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(MarginWidth, NaviHeight, SCREEN_WIDTH-MarginWidth, SCREEN_HEIGHT-NaviHeight) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(10, 0, BottomHeight+8, 0);
    tableView.backgroundColor = BackGroudColor;
    [self addSubview:tableView];
    self.tableView = tableView;
    
}
#pragma mark - tableView 数据源及代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.catagorys.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.subjects.count;
    }else{
        TFCategoryModel *model = self.catagorys[section-1];
        if ([model.show isEqualToNumber:@1]) {
            return model.labels.count + 1;
        }else{
            return 1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        TFKnowledgeFilterItemCell *cell = [TFKnowledgeFilterItemCell knowledgeFilterItemCellWithTableView:tableView];
        TFCategoryModel *model = self.subjects[indexPath.row];
        [cell refreshKnowledgeFilterItemCellWithName:model];
        cell.tag = indexPath.section * 0x9999 + indexPath.row;
        cell.delegate = self;
        return cell;
        
    }else{
        
        TFCategoryModel *model = self.catagorys[indexPath.section-1];
        TFKnowledgeFilterItemCell *cell = [TFKnowledgeFilterItemCell knowledgeFilterItemCellWithTableView:tableView];
        cell.delegate = self;
        cell.tag = indexPath.section * 0x9999 + indexPath.row;
        if (indexPath.row == 0) {
            [cell refreshKnowledgeFilterItemCellWithCategory:model];
        }else{
            TFCategoryModel *label = model.labels[indexPath.row-1];
            [cell refreshKnowledgeFilterItemCellWithLabel:label];
        }
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section != 0) {
        
        if (indexPath.row == 0) {
            TFCategoryModel *model = self.catagorys[indexPath.section-1];
            if (model.labels) {
                model.show = [model.show isEqualToNumber:@1] ? @0 : @1;
                [tableView reloadData];
            }else{
                self.requestModel = model;
                [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
                [self.knowledgeBL requestGetKnowledgeLabelWithCategoryId:model.id];
            }
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
    
}
#pragma mark - TFKnowledgeFilterItemCell
-(void)filterItemCellDidSelectBtn:(TFKnowledgeFilterItemCell *)cell{
    
    NSInteger section = cell.tag / 0x9999;
    NSInteger row = cell.tag % 0x9999;
    if (section == 0) {
        
        for (TFCategoryModel *model in self.subjects) {
            model.select = @0;
        }
        TFCategoryModel *model = self.subjects[row];
        model.select = @1;
        [self.tableView reloadData];
        
    }else{
        
        TFCategoryModel *model = self.catagorys[section-1];
        if (row == 0) {
            model.select = [model.select isEqualToNumber:@1] ? @0 : @1;
            if (model.labels) {
                for (TFCategoryModel *ll in model.labels) {
                    ll.select = model.select;
                }
                [self.tableView reloadData];
            }else{
                self.requestModel = model;
                [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
                [self.knowledgeBL requestGetKnowledgeLabelWithCategoryId:model.id];
            }
            
        }else{
            TFCategoryModel *label = model.labels[row-1];
            label.select = [label.select isEqualToNumber:@1] ? @0 : @1;
            BOOL total = YES;
            for (TFCategoryModel *llc in model.labels) {
                if (![llc.select isEqualToNumber:@1]) {
                    total = NO;
                }
            }
            model.select = total ? @1 : @0;
            [self.tableView reloadData];
        }
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
