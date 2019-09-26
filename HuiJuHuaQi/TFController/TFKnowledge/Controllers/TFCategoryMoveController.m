//
//  TFCategoryMoveController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/12/11.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCategoryMoveController.h"
#import "TFCustomSelectOptionCell.h"
#import "TFKnowledgeBL.h"
#import "TFCategoryModel.h"
#import "TFCustomAlertView.h"


@interface TFCategoryMoveController ()<UITableViewDelegate,UITableViewDataSource,TFCustomSelectOptionCellDelegate,HQBLDelegate,TFCustomAlertViewDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** categoryRow */
@property (nonatomic, strong) TFCustomerRowsModel *categoryRow;
/** labelRow */
@property (nonatomic, strong) TFCustomerRowsModel *labelRow;

/** 知识 */
@property (nonatomic, strong) TFKnowledgeBL *knowledgeBL;
/** 添加附件及图片时对应的Model ,也用于记录子表单下拉对应的Model */
@property (nonatomic, strong) TFCustomerRowsModel *attachmentModel;
/** 选项弹窗 */
@property (nonatomic, strong) TFCustomAlertView *optionAlertView;

@end

@implementation TFCategoryMoveController

-(TFCustomAlertView *)optionAlertView{
    if (!_optionAlertView) {
        _optionAlertView = [[TFCustomAlertView alloc] init];
        _optionAlertView.delegate = self;
    }
    return _optionAlertView;
}
-(TFCustomerRowsModel *)categoryRow{
    if (!_categoryRow) {
        _categoryRow = [[TFCustomerRowsModel alloc] init];
        _categoryRow.name = @"category";
        _categoryRow.field = [[TFCustomerFieldModel alloc] init];
        _categoryRow.field.chooseType = @"0";
        _categoryRow.type = @"picklist";
    }
    return _categoryRow;
}

-(TFCustomerRowsModel *)labelRow{
    if (!_labelRow) {
        _labelRow = [[TFCustomerRowsModel alloc] init];
        _labelRow.field = [[TFCustomerFieldModel alloc] init];
        _labelRow.field.chooseType = @"1";
        _labelRow.name = @"label";
        _labelRow.type = @"picklist";
    }
    return _labelRow;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"移动到";
    self.knowledgeBL = [TFKnowledgeBL build];
    self.knowledgeBL.delegate = self;
    //    [self.knowledgeBL requestGetKnowledgeCategoryAndLabel];
    [self.knowledgeBL requestGetKnowledgeCategory];
    //    [self.knowledgeBL requestGetKnowledgeLabelWithCategoryId:@1];
    
    [self setupTableView];
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
}
-(void)sure{
    
    if (self.categoryRow.selects.count == 0) {
        [MBProgressHUD showError:@"请选择分类" toView:self.view];
        return;
    }
    NSString *categoryIds = @"";
    for (TFCustomerOptionModel *model in self.categoryRow.selects) {
        categoryIds = [categoryIds stringByAppendingString:[NSString stringWithFormat:@"%@,",model.value]];
    }
    if (categoryIds.length > 0) {
        categoryIds = [categoryIds substringToIndex:categoryIds.length-1];
    }
    
    NSString *labelIds = @"";
    for (TFCustomerOptionModel *model in self.labelRow.selects) {
        labelIds = [labelIds stringByAppendingString:[NSString stringWithFormat:@"%@,",model.value]];
    }
    if (labelIds.length > 0) {
        labelIds = [labelIds substringToIndex:labelIds.length-1];
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.knowledgeBL requestMoveKnowledgeWithDataId:self.dataId categoryId:categoryIds labelIds:labelIds];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_getKnowledgeCategory) {
        
        NSArray *arr =  resp.body;
        NSMutableArray<Optional,TFCustomerOptionModel> *ops = [NSMutableArray<Optional,TFCustomerOptionModel> array];
        for (TFCategoryModel *model in arr) {
            TFCustomerOptionModel *option = [[TFCustomerOptionModel alloc] init];
            option.value = [model.id description];
            option.label = model.name;
            [ops addObject:option];
        }
        self.categoryRow.entrys =ops ;
    }
    if (resp.cmdId == HQCMD_knowledgeLabel) {
        
        NSArray *arr =  resp.body;
        NSMutableArray<Optional,TFCustomerOptionModel> *ops = [NSMutableArray<Optional,TFCustomerOptionModel> array];
        for (TFCategoryModel *model in arr) {
            TFCustomerOptionModel *option = [[TFCustomerOptionModel alloc] init];
            option.value = [model.id description];
            option.label = model.name;
            [ops addObject:option];
        }
        self.labelRow.entrys = ops;
        
        TFCustomerOptionModel *option = self.categoryRow.selects.firstObject;
        for (TFCustomerOptionModel *kk in self.categoryRow.entrys) {// 将标签放入该分类的下级
            if ([option.value isEqualToString:kk.value]) {
                kk.subList = ops;
            }
        }
        
        if (ops.count) {
            if (self.labelRow.selects.count) {// 标签的选中值在不在该分类下，不在就清空，要重选
                TFCustomerOptionModel *option1 = self.labelRow.selects.firstObject;
                if (![[option1.parentId description] isEqualToString:option.value]) {
                    self.labelRow.selects = nil;
                    for (TFCustomerOptionModel *oi in self.labelRow.entrys) {// 选中态取消
                        oi.open = nil;
                    }
                    [self.tableView reloadData];
                }
            }
        }else{
            self.labelRow.selects = nil;
            for (TFCustomerOptionModel *oi in self.labelRow.entrys) {// 选中态取消
                oi.open = nil;
            }
            [self.tableView reloadData];
        }
        
    }
    
    if (resp.cmdId == HQCMD_knowledgeMove) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showImageSuccess:@"移动成功" toView:self.view];
        if (self.refresh) {
            self.refresh();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        
        TFCustomSelectOptionCell *cell = [TFCustomSelectOptionCell customSelectOptionCellWithTableView:tableView];
        cell.delegate = self;
        cell.title = @"分类";
        cell.fieldControl = @"2";
        cell.edit = YES;
        cell.showEdit = YES;
        cell.model = self.categoryRow;
        return cell;
    }else {
        
        TFCustomSelectOptionCell *cell = [TFCustomSelectOptionCell customSelectOptionCellWithTableView:tableView];
        cell.delegate = self;
        cell.title = @"标签";
        cell.fieldControl = @"0";
        cell.edit = YES;
        cell.showEdit = YES;
        cell.model = self.labelRow;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 75;
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


#pragma mark - TFCustomSelectOptionCellDelegate
-(void)customOptionItemCellDidClickedOptions:(NSArray *)options isSingle:(BOOL)isSingle model:(TFCustomerRowsModel *)model level:(NSInteger)level{
    
    if ([model.name isEqualToString:@"label"]) {
        if (self.categoryRow.selects.count == 0) {
            [MBProgressHUD showError:@"请先选分类" toView:self.view];
            return;
        }
    }
    
    self.attachmentModel = model;
    self.optionAlertView.isSingle = isSingle;
    [self.optionAlertView refreshCustomAlertViewWithData:options];
    [self.optionAlertView showAnimation];
    
}

#pragma mark - TFCustomAlertViewDelegate
-(void)sureClickedWithOptions:(NSMutableArray *)options{
    
    self.attachmentModel.selects = options;
    //    if ([self.attachmentModel.name isEqualToString:@"category"]) {// 它决定了标签的选项
    //        TFCustomerOptionModel *option = options.firstObject;
    //        self.knowledge.labels.entrys = option.subList;
    //        if (self.knowledge.labels.selects.count) {// 标签的选中值在不在该分类下，不在就清空，要重选
    //            TFCustomerOptionModel *option1 = self.knowledge.labels.selects.firstObject;
    //            if (![[option1.parentId description] isEqualToString:option.value]) {
    //                self.knowledge.labels.selects = nil;
    //            }
    //        }
    //    }
    
    if ([self.attachmentModel.name isEqualToString:@"category"]) {// 它决定了标签的选项
        TFCustomerOptionModel *oo = options.firstObject;
        if (oo.subList == nil) {
            [self.knowledgeBL requestGetKnowledgeLabelWithCategoryId:@([oo.value longLongValue])];
        }else{
            TFCustomerOptionModel *option = options.firstObject;
            self.labelRow.entrys = option.subList;
            if (self.labelRow.selects.count) {// 标签的选中值在不在该分类下，不在就清空，要重选
                TFCustomerOptionModel *option1 = self.labelRow.selects.firstObject;
                if (![[option1.parentId description] isEqualToString:option.value]) {
                    self.labelRow.selects = nil;
                    for (TFCustomerOptionModel *oi in self.labelRow.entrys) {// 选中态取消
                        oi.open = nil;
                    }
                }
            }
        }
    }
    [self.tableView reloadData];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
