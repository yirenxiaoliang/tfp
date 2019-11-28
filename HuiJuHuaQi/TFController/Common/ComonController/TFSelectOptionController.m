//
//  TFSelectOptionController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/9/8.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFSelectOptionController.h"
#import "HQSelectTimeCell.h"
#import "HQTFNoContentView.h"
#import "TFProjectTaskBL.h"
#import "TFProjectLabelModel.h"
#import "TFCustomSelectCell.h"
#import "HQTFSearchHeader.h"
#import "HQTFSearchHeader.h"

@interface TFSelectOptionController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate,HQTFSearchHeaderDelegate,UITextFieldDelegate>
/** UITableView *tableView */
@property (nonatomic, weak) UITableView *tableView;

/** projectTaskBL */
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;

/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;


@property (nonatomic, weak) HQTFSearchHeader *headerSearch;

@property (nonatomic, copy) NSString *word;

@end

@implementation TFSelectOptionController

-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"无选项"];
    }
    return _noContentView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)didBack:(UIButton *)sender{
    for (TFCustomerOptionModel *model in self.entrys) {
        model.hidden = @0;
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    // 用于项目任务
    if (self.isTaskTag && self.projectId) {
        self.entrys = nil;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.projectTaskBL requsetGetProjectLabelWithProjectId:self.projectId keyword:@"" type:0];
    }else if (self.isTaskTag && !self.projectId){
        self.entrys = nil;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.projectTaskBL requsetGetPersonnelLabelWithType:2];
    }
    [self setupTableView];
    [self setupNavi];
}
#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_getProjectLabel) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSArray *arr = resp.body;
        
        NSMutableArray <TFCustomerOptionModel>*options = [NSMutableArray<TFCustomerOptionModel> array];
        for (TFProjectLabelModel *mo in arr) {
            for (TFProjectLabelModel *model in mo.childList) {
                TFCustomerOptionModel *op = [[TFCustomerOptionModel alloc] init];
                op.color = model.colour;
                op.value = [model.id description];
                op.label = model.name;
                [options addObject:op];
            }
        }
        
        self.entrys = options;
        
        for (TFCustomerOptionModel *mo in self.entrys) {
            for (TFCustomerOptionModel *model in self.selectEntrys) {
                if ([[model.value description] isEqualToString:[mo.value description]]) {
                    mo.open = @1;
                    break;
                }
            }
        }
        
        
        if (self.entrys.count) {
            self.tableView.backgroundView = [UIView new];
        }else{
            self.tableView.backgroundView = self.noContentView;
        }
        
        [self setupNavi];
        
        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_getPersonnelLabel) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSArray *arr = resp.body;
        
        NSMutableArray <TFCustomerOptionModel>*options = [NSMutableArray<TFCustomerOptionModel> array];
        for (TFProjectLabelModel *model in arr) {
            TFCustomerOptionModel *op = [[TFCustomerOptionModel alloc] init];
            op.color = model.colour;
            op.value = [model.id description];
            op.label = model.name;
            [options addObject:op];
            
        }
        
        self.entrys = options;
        
        if (self.entrys.count) {
            self.tableView.backgroundView = [UIView new];
        }else{
            self.tableView.backgroundView = self.noContentView;
        }
        
        [self setupNavi];
        
        [self.tableView reloadData];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}



#pragma mark - navi
- (void)setupNavi{
    
    self.navigationItem.title = @"请选择";
    if (self.entrys.count) {
        
        TFCustomerOptionModel *option = self.entrys[0];
        
        if (!option.subList || option.subList.count == 0) {
            
            self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
        }else{
            self.isMutil = YES;
        }
    }

    if (self.isSingleSelect && !self.isMutil) {
        
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)sure{
    
    NSMutableArray *selects = [NSMutableArray array];
    for (TFCustomerOptionModel *option in self.entrys) {
        if ([option.open isEqualToNumber:@1]) {
            [selects addObject:option];
        }
    }
    
    if (self.isMutil) {
        
        if (!selects.count) {
            [MBProgressHUD showError:@"请选择" toView:self.view];
            return;
        }
        
    }
    
    
    if (self.selectAction) {
        self.selectAction(selects);
        
        for (UIViewController *vc in self.navigationController.childViewControllers) {
            
            if (vc == self.backVc) {
                
                [self.navigationController popToViewController:vc animated:YES];
                
            }
        }
    }
    
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
//    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    if (!self.isTaskTag) {
        if (self.entrys.count) {
            tableView.backgroundView = [UIView new];
        }else{
            tableView.backgroundView = self.noContentView;
        }
    }
    
    HQTFSearchHeader *headerSearch = [[HQTFSearchHeader alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,64}];
    //        headerSearch.textField.returnKeyType = UIReturnKeySearch;
    headerSearch.textField.delegate = self;
    headerSearch.delegate = self;
    self.headerSearch = headerSearch;
    self.headerSearch.type = SearchHeaderTypeSearch;
    self.headerSearch.textField.backgroundColor = BackGroudColor;
    self.headerSearch.image.backgroundColor = BackGroudColor;
    self.headerSearch.backgroundColor = WhiteColor;
    tableView.tableHeaderView = headerSearch;
}

-(void)searchHeaderTextChange:(UITextField *)textField{
    
    UITextRange *range = [textField markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textField positionFromPosition:range.start offset:0];
    
    
    if (!position) {
        
        for (TFCustomerOptionModel *model in self.entrys) {
            model.hidden = @1;
        }
        for (TFCustomerOptionModel *model in self.entrys) {
            if ([model.label containsString:textField.text]) {
                model.hidden = @0;
            }
        }
        
        [self.tableView reloadData];
        self.word = textField.text;
    }
    if (textField.text.length == 0) {
        
        for (TFCustomerOptionModel *model in self.entrys) {
            model.hidden = @0;
        }
        [self.tableView reloadData];
        self.word = textField.text;
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textField.text = self.word;
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.text = self.word;
}




-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.entrys.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    TFCustomerOptionModel *model = self.entrys[indexPath.row];
//    HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
//    cell.timeTitle.text = model.label;
//    cell.titltW.constant = SCREEN_WIDTH - 30 - 30;
//    cell.backgroundColor = WhiteColor;
//    cell.time.textColor = WhiteColor;
//    cell.time.text = @"";
//    cell.timeTitle.textColor = ExtraLightBlackTextColor;
//    cell.topLine.hidden = YES;
//    if (self.entrys.count -1 == indexPath.row) {
//        cell.bottomLine.hidden = YES;
//    }else{
//        cell.bottomLine.hidden = NO;
//    }
//    
//    if (model.open && [model.open isEqualToNumber:@1]) {
//        [cell.arrow setImage:[UIImage imageNamed:@"选中"]];
//    }else{
//        [cell.arrow setImage:[UIImage imageNamed:@"没选中"]];
//    }
//    return cell;
    
    TFCustomerOptionModel *model = self.entrys[indexPath.row];
    TFCustomSelectCell *cell = [TFCustomSelectCell CustomSelectCellWithTableView:tableView];
    [cell refreshCustomSelectVcWithModel:model];
    if (indexPath.row == 0) {
        cell.topLine.hidden = YES;
    }else{
        cell.topLine.hidden = NO;
    }
    cell.layer.masksToBounds = YES;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (self.isMutil) {// 多级
        
        for (TFCustomerOptionModel *model1 in self.entrys) {
            model1.open = @0;
        }
        
        TFCustomerOptionModel *model = self.entrys[indexPath.row];
        model.open = @1;
        [self.tableView reloadData];
        
        if (!model.subList.count) {// 没有下级就不往下跳了
            return;
        }
        
        TFSelectOptionController *select = [[TFSelectOptionController alloc] init];
        select.entrys = model.subList;
        select.isSingleSelect = self.isSingleSelect;
        select.backVc = self.backVc;
        select.isMutil = self.isMutil;
        select.selectAction = ^(NSMutableArray * parameter) {
            
            NSMutableArray *arr = [NSMutableArray arrayWithObject:model];
            [arr addObjectsFromArray:parameter];
            if (self.selectAction) {
                self.selectAction(arr);
            }
        };
        [self.navigationController pushViewController:select animated:YES];
        
        
        
    }else{
        
        if (self.isSingleSelect) {// 单选
            
            TFCustomerOptionModel *model = self.entrys[indexPath.row];
            
            if ([model.open isEqualToNumber:@1]) {
                model.open = @0;
            }else{

                for (TFCustomerOptionModel *model in self.entrys) {
                    model.open = @0;
                }
                model.open = @1;
            }

            [self.tableView reloadData];
            
            model.open = @1;
            [self.tableView reloadData];
            NSMutableArray *arr = [NSMutableArray arrayWithObject:model];
            if (self.selectAction) {
                self.selectAction(arr);
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }else{// 多选
            
            TFCustomerOptionModel *model = self.entrys[indexPath.row];
            
            model.open = (!model.open || [model.open isEqualToNumber:@0])?@1:@0;
            
            [self.tableView reloadData];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TFCustomerOptionModel *model = self.entrys[indexPath.row];
    if ([model.hidden isEqualToNumber:@1]) {
        return 0;
    }else{
        return [TFCustomSelectCell refreshCustomSelectVcHeightWithModel:model];
    }
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
