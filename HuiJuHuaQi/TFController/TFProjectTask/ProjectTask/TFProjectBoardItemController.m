//
//  TFProjectBoardItemController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/5/2.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjectBoardItemController.h"
#import "TFBoardView.h"
#import "TFTaskColumnAddController.h"
#import "TFProjectTaskBL.h"
#import "TFCreateTaskRowController.h"
#import "TFModelEnterController.h"
#import "TFProjectTaskDetailController.h"
#import "TFAddTaskController.h"
#import "TFCreateNoteController.h"
//#import "TFCustomDetailController.h"
#import "TFNewCustomDetailController.h"
#import "TFApprovalDetailController.h"
#import "TFProjectDetailTabBarController.h"
#import "YPTabBar.h"
#import "TFProjectRowTableView.h"
#import "TFLabelImageButton.h"
#import "TFCancelRelationshipController.h"

@interface TFProjectBoardItemController ()<TFBoardViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate,HQBLDelegate,YPTabBarDelegate,TFProjectRowTableViewDelegate>

/** TFBoardView */
@property (nonatomic, strong) TFBoardView *boardView;

/** editSection */
@property (nonatomic, strong) TFProjectSectionModel *editSection;

/** TFProjectTaskBL */
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;

/** page */
@property (nonatomic, assign) NSInteger page;

/** handleTask */
@property (nonatomic, strong) TFProjectRowModel *handleTask;

/** 记录传递的权限数组 */
@property (nonatomic, strong) NSArray *menus;

/** tabBar */
@property (nonatomic, strong) YPTabBar *tabBar;
/** button */
@property (nonatomic, strong) UIButton *button;

/** TFProjectRowTableView  */
@property (nonatomic, strong) TFProjectRowTableView *projectRowTableView;

/** button */
@property (nonatomic, strong) TFLabelImageButton *rowButton;

/** level */
@property (nonatomic, copy) NSString *level;

/** UIView *lineView */
@property (nonatomic, strong) UIView *lineView;

/** 激活是否需要填写激活原因 */
@property (nonatomic, copy) NSString <Optional>*project_complete_status;
/** 修改截止时间是否需要填写修改原因 */
@property (nonatomic, copy) NSString <Optional>*project_time_status;
/** 权限 */
@property (nonatomic, copy) NSString *auth;

@end

@implementation TFProjectBoardItemController

-(TFLabelImageButton *)rowButton{
    if (!_rowButton) {
        
        TFLabelImageButton *button = [TFLabelImageButton buttonWithType:UIButtonTypeCustom];
        button.frame = (CGRect){0,0,SCREEN_WIDTH,44};
        [button addTarget:self action:@selector(rowButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = WhiteColor;
        [button setTitleColor: HexColor(0x909090) forState:UIControlStateNormal];
        [button setTitleColor: HexColor(0x909090) forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:@"展开"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"下拉"] forState:UIControlStateSelected];
        _rowButton = button;
        button.titleLabel.font = FONT(14);
        
    }
    return _rowButton;
}

- (void)rowButtonClick:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected) {
        [self.projectRowTableView showAnimation];
    }else{
        [self.projectRowTableView hiddenAnimation];
    }
}

-(UIButton *)button{
    if (!_button) {
        
        UIButton *button = [HQHelper buttonWithFrame:(CGRect){SCREEN_WIDTH-40,0,40,43} target:self action:@selector(buttonClick)];
        button.backgroundColor = WhiteColor;
        [self.view insertSubview:button aboveSubview:_tabBar];
        [button setImage:[UIImage imageNamed:@"taskMenu"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"taskMenu"] forState:UIControlStateHighlighted];
        button.layer.shadowOffset = CGSizeMake(-20, -5);
        button.layer.shadowColor = CellSeparatorColor.CGColor;
        button.layer.shadowRadius = 10;
        button.layer.shadowOpacity = 0.5;
        _button = button;
        
    }
    return _button;
}

-(TFProjectRowTableView *)projectRowTableView{
    if (!_projectRowTableView) {
        _projectRowTableView = [[TFProjectRowTableView alloc] initWithFrame:(CGRect){0,NaviHeight+88,SCREEN_WIDTH,SCREEN_HEIGHT-NaviHeight-88}];
        _projectRowTableView.delegate = self;
        if (self.projectColumnModel.subnodeArr.count) {
            TFProjectSectionModel *sec = self.projectColumnModel.subnodeArr[0];
            sec.select = @1;
        }
        [_projectRowTableView refreshProjectRowTableViewWithRows:self.projectColumnModel.subnodeArr];
    }
    return _projectRowTableView;
}

#pragma mark - TFProjectRowTableViewDelegate
-(void)projectRowTableViewDidRowIndex:(NSInteger)rowIndex{
    
    self.rowButton.selected = NO;
    self.tabBar.selectedItemIndex = rowIndex;
    
    TFProjectSectionModel *row = self.projectColumnModel.subnodeArr[rowIndex];
    [self.rowButton setTitle:row.name forState:UIControlStateNormal];
    [self.rowButton setTitle:row.name forState:UIControlStateSelected];
}
-(void)projectRowTableViewDidEmpty{

    self.rowButton.selected = NO;
}


- (void)buttonClick{
    
    if (![self.projectModel.project_status isEqualToString:@"0"]) {
        if ([self.projectModel.project_status isEqualToString:@"1"]) {// 归档
            
            [MBProgressHUD showError:@"项目已归档" toView:self.view];
        }
        if ([self.projectModel.project_status isEqualToString:@"2"]) {// 暂停
            
            [MBProgressHUD showError:@"项目已暂停" toView:self.view];
        }
        return;
    }
//    [self.auths removeAllObjects];
//    if ([HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"16"]) {
//        [self.auths addObject:@"新增分组"];
//    }
//    if ([HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"17"] ||
//        [HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"18"] ||
//        [HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"19"]) {
//        [self.auths addObject:@"管理分组"];
//    }
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"新增任务列",@"管理任务列",nil];
    sheet.tag = 0x333;
//    for (NSString *str in self.auths) {
//        [sheet addButtonWithTitle:str];
//    }
    
    [sheet showInView:self.view];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ProjectRowTableViewHideNotification object:nil];
}


-(YPTabBar *)tabBar{
    
    if (!_tabBar) {
        _tabBar = [[YPTabBar alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,44}];
        _tabBar.delegate = self;
        _tabBar.itemTitleColor = HexColor(0x909090);
        _tabBar.itemTitleSelectedColor = HexAColor(0x3689e9, 1);
        _tabBar.itemTitleFont = [UIFont systemFontOfSize:14];
        _tabBar.itemTitleSelectedFont = FONT(14);
        _tabBar.selectedItemIndex = 0 ;
        _tabBar.leftAndRightSpacing = 10;
        _tabBar.rightSpacing = 40;
        _tabBar.backgroundColor = WhiteColor;
        [_tabBar setScrollEnabledAndItemFitTextWidthWithSpacing:20];
        [_tabBar setItemSelectedBgInsets:UIEdgeInsetsMake(42, 10, 0,10) tapSwitchAnimated:NO];
        self.tabBar.itemSelectedBgColor = HexAColor(0x3689e9, 1);
        
        UIView *lineView = [[UIView alloc] initWithFrame:(CGRect){0,44,SCREEN_WIDTH,0.5}];
        [self.view addSubview:lineView];
        lineView.backgroundColor = CellSeparatorColor;
        self.lineView = lineView;
        
        // 刷新tabbar
        NSMutableArray<YPTabItem *> *items = [NSMutableArray<YPTabItem *> array];
        for (NSInteger i = 0; i < self.projectColumnModel.subnodeArr.count; i++) {
            YPTabItem *item = [[YPTabItem alloc] init];
            TFProjectSectionModel *model = self.projectColumnModel.subnodeArr[i];
            item.title = model.name;
            [items addObject:item];
        }
        _tabBar.items = items;
        _tabBar.selectedItemIndex = 0;
        
    }
    return _tabBar;
}


#pragma mark - YPTabBarDelegate
-(void)yp_tabBar:(YPTabBar *)tabBar didSelectedItemAtIndex:(NSUInteger)index{
    
    if (self.projectColumnModel.subnodeArr.count) {
        TFProjectSectionModel *model = self.projectColumnModel.subnodeArr[index];
        
        [self.boardView refreshMoveViewWithModels:model.subnodeArr withType:IsStrEmpty(self.projectColumnModel.flow_id)?0:1];
        [self.boardView loadAllData];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ProjectRowTableViewHideNotification object:nil];
}

-(TFBoardView *)boardView{
    
    if (!_boardView) {
        _boardView = [[TFBoardView alloc] initWithFrame:CGRectMake(0, 17, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-44-17-BottomHeight)];
        _boardView.delegate = self;
        _boardView.projectId = self.projectId;
        _boardView.temp_id = self.projectModel.temp_id;
        [self.view insertSubview:_boardView atIndex:0];
    }
    return _boardView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    // 获取项目设置详情
    [self.projectTaskBL requestGetProjectDetailWithProjectId:self.projectId];
    self.view.backgroundColor = WhiteColor;
    
    if (self.projectColumnModel.subnodeArr.count) {
        TFProjectSectionModel *model = self.projectColumnModel.subnodeArr[0];
        if ([model.children_data_type isEqualToString:@"1"]) {
            self.projectColumnModel.level = @"3";
        }else{
            self.projectColumnModel.level = @"2";
        }
    }
#warning 后面处理层级判断
    self.level = self.projectColumnModel.level;
    
    if ([self.level isEqualToString:@"2"]) {
        
        [self.boardView refreshMoveViewWithModels:self.projectColumnModel.subnodeArr withType:IsStrEmpty(self.projectColumnModel.flow_id)?0:1];
        self.lineView.hidden = YES;
        
    }else{
        // 加载tabBar
        [self.view addSubview:self.tabBar];
        [self.view insertSubview:self.button aboveSubview:_tabBar];
        self.boardView.frame = CGRectMake(0, 17+44, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-44-17-BottomHeight-44);
        self.boardView.viewHeight = SCREEN_HEIGHT-NaviHeight-44-17-BottomHeight-44;
        self.lineView.hidden = NO;
        
        // 新增
        [self.view insertSubview:self.rowButton aboveSubview:self.button];
        if (self.projectColumnModel.subnodeArr.count) {
            TFProjectSectionModel *row = self.projectColumnModel.subnodeArr[0];
            [self.rowButton setTitle:row.name forState:UIControlStateNormal];
            [self.rowButton setTitle:row.name forState:UIControlStateSelected];
        }
    }

}


/** 用于刷新该控制器boardView数据 */
-(void)refreshBoardViewData{
    if ([self.level isEqualToString:@"2"]) {
        [self.boardView loadAllData];
    }
}


#pragma mark - TFBoardViewDelegate
-(void)boardView:(TFBoardView *)boardView didClickedFinishItem:(TFProjectRowModel *)model{
    
    if (![self.projectModel.project_status isEqualToString:@"0"]) {
        if ([self.projectModel.project_status isEqualToString:@"1"]) {// 归档
            
            [MBProgressHUD showError:@"项目已归档" toView:self.view];
        }
        if ([self.projectModel.project_status isEqualToString:@"2"]) {// 暂停
            
            [MBProgressHUD showError:@"项目已暂停" toView:self.view];
        }
        return;
    }
    self.handleTask = model;
    if (IsStrEmpty(self.auth)) {
        
        if (model.task_id) {// 子任务
            
//            [self.projectTaskBL requsetGetProjectTaskFinishAuthAndActiveCauseWithProjectId:model.projectId taskId:model.taskInfoId taskType:@2];
            [self.projectTaskBL requsetGetProjectTaskFinishAuthAndActiveCauseWithProjectId:model.projectId taskId:model.bean_id taskType:@2];
            
        }else{// 主任务
            
//            [self.projectTaskBL requsetGetProjectTaskFinishAuthAndActiveCauseWithProjectId:model.projectId taskId:model.taskInfoId taskType:@1];
            
            [self.projectTaskBL requsetGetProjectTaskFinishAuthAndActiveCauseWithProjectId:model.projectId taskId:model.bean_id taskType:@1];
        }
    }else{
        
        if ([self.auth isEqualToString:@"1"]) {
            
            if ([self.handleTask.complete_status isEqualToNumber:@1]) {
                
                if ([self.project_complete_status isEqualToString:@"1"]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"激活原因" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    alert.delegate = self;
                    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                    alert.tag = 0x222;
                    [alert show];
                }else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确定激活此任务？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    alert.delegate = self;
                    alert.tag = 0x222;
                    [alert show];
                }
                
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确定完成此任务？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.delegate = self;
                alert.tag = 0x111;
                [alert show];
            }
            
            
        }else{
            [MBProgressHUD showError:@"无权限修改" toView:self.view];
        }
    }
}

-(void)boardView:(TFBoardView *)boardView didClickedItem:(TFProjectRowModel *)model{
    
    // 1备忘录 2任务 3自定义模块数据 4审批数据
    if ([model.dataType isEqualToNumber:@1]) {
        
        TFCreateNoteController *note = [[TFCreateNoteController alloc] init];
        note.type = 1;
//        note.noteId = model.id;
        note.noteId = model.bean_id;
        [self.navigationController pushViewController:note animated:YES];
        
    }else if ([model.dataType isEqualToNumber:@2]){
        
        TFProjectTaskDetailController *detail = [[TFProjectTaskDetailController alloc] init];
        detail.projectId = self.projectId;
        detail.sectionId = self.projectColumnModel.id;
        TFProjectSectionModel *row = self.projectColumnModel.subnodeArr[self.page];
        detail.rowId = row.id;
//        detail.dataId = model.taskInfoId;
        detail.dataId = model.bean_id;
        detail.action = ^(NSDictionary *parameter) {
            
            if ([parameter valueForKey:@"complete_status"]) {// 完成
                
                model.complete_status = [parameter valueForKey:@"complete_status"];
                model.finishType = [parameter valueForKey:@"complete_status"];
                if ([[model.complete_status description] isEqualToString:@"0"]) {
                    model.activeNum = @([model.activeNum integerValue] + 1);
                }
                
            }
            
            if ([parameter valueForKey:@"passed_status"]) {// 检验
                
                model.passed_status = [parameter valueForKey:@"passed_status"];
            }
            
            [self.boardView refreshData];
        };
        detail.deleteAction = ^{
          
            [self.boardView loadDataWithSectionModel:row index:self.page];
        };
        [self.navigationController pushViewController:detail animated:YES];
        
    }else if ([model.dataType isEqualToNumber:@3]){
        
//        TFCustomDetailController *detail = [[TFCustomDetailController alloc] init];
        TFNewCustomDetailController *detail = [[TFNewCustomDetailController alloc] init];
        detail.bean = model.bean_name;
        detail.dataId = model.bean_id;
        [self.navigationController pushViewController:detail animated:YES];
        
    }else{
        TFApprovalListItemModel *approval = [[TFApprovalListItemModel alloc] init];
        approval.id = model.id;
        approval.task_id = [model.task_id description];
        approval.task_key = model.task_key;
        approval.task_name = model.task_name;
//        approval.approval_data_id = model.approval_data_id;
        approval.approval_data_id = [model.bean_id description];
        approval.module_bean = model.module_bean;
        approval.begin_user_name = model.begin_user_name;
        approval.begin_user_id = model.begin_user_id;
        approval.process_definition_id = model.process_definition_id;
        approval.process_key = model.process_key;
        approval.process_name = model.process_name;
        approval.process_status = model.process_status;
        approval.status = model.status;
        approval.process_field_v = model.process_field_v;
        
        TFApprovalDetailController *detail = [[TFApprovalDetailController alloc] init];
        detail.approvalItem = approval;
        detail.listType = 1;
        [self.navigationController pushViewController:detail animated:YES];
        
    }
    
}

-(void)boardView:(TFBoardView *)boardView changePage:(NSInteger)page{
    self.page = page;
}

-(void)boardView:(TFBoardView *)boardView didMenuWithModel:(TFProjectSectionModel *)model menus:(NSArray *)menus{
    
    if (![self.projectModel.project_status isEqualToString:@"0"]) {
        if ([self.projectModel.project_status isEqualToString:@"1"]) {// 归档
            
            [MBProgressHUD showError:@"项目已归档" toView:self.view];
        }
        if ([self.projectModel.project_status isEqualToString:@"2"]) {// 暂停
            
            [MBProgressHUD showError:@"项目已暂停" toView:self.view];
        }
        return;
    }
    self.editSection = model;
    self.menus = menus;
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
    sheet.tag = 0x333;
    
    for (NSString *str in menus) {
        [sheet addButtonWithTitle:str];
    }
    
    [sheet showInView:self.view];
    
}

-(void)boardView:(TFBoardView *)boardView addTaskWithModel:(TFProjectSectionModel *)model{
    
    if (![self.projectModel.project_status isEqualToString:@"0"]) {
        if ([self.projectModel.project_status isEqualToString:@"1"]) {// 归档
            
            [MBProgressHUD showError:@"项目已归档" toView:self.view];
        }
        if ([self.projectModel.project_status isEqualToString:@"2"]) {// 暂停
            
            [MBProgressHUD showError:@"项目已暂停" toView:self.view];
        }
        return;
    }
    self.editSection = model;
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"新建",@"引用", nil];
    sheet.tag = 0x444;
    [sheet showInView:self.view];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag == 0x333) {
        
        if (buttonIndex == 0) {
            return;
        }
        
        NSString *str = self.menus[buttonIndex-1];
        if ([str isEqualToString:@"编辑任务列名称"]) {
            TFProjectRowModel *model = [[TFProjectRowModel alloc] init];
            model.id = self.editSection.id;
            model.name = self.editSection.name;
            model.projectId = self.projectId;
            model.sectionId = self.projectColumnModel.id;
            TFTaskColumnAddController *add = [[TFTaskColumnAddController alloc] init];
            add.projectRow = model;
            add.index = 1;
            add.type = 1;
            add.refresh = ^(TFProjectSectionModel *parameter) {
                
                self.editSection.name = parameter.name;
                
                if ([self.level isEqualToString:@"2"]) {// 两层
                    [self.boardView refreshMoveViewWithModels:self.projectColumnModel.subnodeArr withType:-1];
                }else{// 三层
                    TFProjectSectionModel *model = self.projectColumnModel.subnodeArr[self.tabBar.selectedItemIndex];
                    [self.boardView refreshMoveViewWithModels:model.subnodeArr withType:-1];
                }
                
            };
            [self.navigationController pushViewController:add animated:YES];
        }else if ([str isEqualToString:@"删除"]){
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除列表" message:[NSString stringWithFormat:@"确定要删除列表【%@】吗？删除后该列表下的所有信息同时被删除。\n\n请输入要删除的列表名称",self.editSection.name] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            alert.delegate = self;
            [alert show];
        }else if ([str isEqualToString:@"取消关联"]){
            
            NSMutableArray *frs = [NSMutableArray array];
            for (TFProjectRowModel *row in self.editSection.tasks) {
                if ([row.quote_status isEqualToNumber:@1]) {
                    
                    TFProjectRowFrameModel *model = [[TFProjectRowFrameModel alloc] initBorder];
                    model.projectRow = row;
                    [frs addObject:model];
                }
            }
            
            if (frs.count == 0) {
                [MBProgressHUD showError:@"无关联数据" toView:self.view];
                return;
            }
            TFCancelRelationshipController *ce = [[TFCancelRelationshipController alloc] init];
            ce.frames = frs;
            ce.refreshAction = ^{
                
                    [self.boardView loadDataWithSectionModel:self.editSection index:self.page];
            };
            [self.navigationController pushViewController:ce animated:YES];
        }
    }
    
    if (actionSheet.tag == 0x444) {
        if (buttonIndex == 0) {// 新建
            
//            TFAddCustomController *add = [[TFAddCustomController alloc] init];
//            add.bean = [NSString stringWithFormat:@"project_custom_%@_%@",[self.projectId description],[UM.userLoginInfo.company.id description]];
//            add.type = 8;
//            add.tableViewHeight = SCREEN_HEIGHT-64;
//            [self.navigationController pushViewController:add animated:YES];
            
            TFModelEnterController *enter = [[TFModelEnterController alloc] init];
            enter.type = 5;
            enter.projectId = self.projectId;
            enter.rowId = self.editSection.id;
            enter.parameterAction = ^(NSMutableDictionary *parameter) {// 新建任务刷新该列
              
                [self.projectTaskBL requestCreateTaskWithDict:parameter];
//                [self.boardView loadDataWithSectionModel:self.editSection index:self.page];
                
            };
            enter.memoAction = ^(id parameter) {// 新建备忘录、审批、自定义
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:self.projectId forKey:@"projectId"];
                [dict setObject:self.editSection.id forKey:@"subnodeId"];
                NSString *bean = [parameter valueForKey:@"bean"];
                [dict setObject:bean forKey:@"bean"];
                NSString *ids = [parameter valueForKey:@"data"];
                
                [dict setObject:ids forKey:@"quoteTaskId"];
                
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [self.projectTaskBL requestAddQuoteWithDict:dict];
                
            };
            
            [self.navigationController pushViewController:enter animated:YES];
        }else if (buttonIndex == 1){// 引用
            TFModelEnterController *enter = [[TFModelEnterController alloc] init];
            enter.type = 3;
            enter.projectId = self.projectId;
            enter.rowId = self.editSection.id;
            enter.parameterAction = ^(NSDictionary *parameter) {
              
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:self.projectId forKey:@"projectId"];
                [dict setObject:self.editSection.id forKey:@"subnodeId"];
                NSString *bean = [parameter valueForKey:@"bean"];
                if (bean) {
                    [dict setObject:bean forKey:@"bean"];
                }
                NSString *ids = [parameter valueForKey:@"data"];
                if (ids) {
                    [dict setObject:ids forKey:@"quoteTaskId"];
                }
                NSNumber *beanType = [parameter valueForKey:@"beanType"];
                if (beanType) {
                    [dict setObject:beanType forKey:@"bean_type"];
                }
                if ([parameter valueForKey:@"moduleName"]) {
                    [dict setObject:[parameter valueForKey:@"moduleName"] forKey:@"moduleName"];
                }
                if ([parameter valueForKey:@"moduleId"]) {
                    [dict setObject:[parameter valueForKey:@"moduleId"] forKey:@"moduleId"];
                }
                
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [self.projectTaskBL requestAddQuoteWithDict:dict];
            };
            [self.navigationController pushViewController:enter animated:YES];
        }
    }
    
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        if (alertView.tag == 0x111) {// 完成任务
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
//            [self.projectTaskBL requestTaskFinishOrActiveWithTaskId:self.handleTask.taskInfoId completeStatus:@1 remark:nil];
            [self.projectTaskBL requestTaskFinishOrActiveWithTaskId:self.handleTask.bean_id completeStatus:@1 remark:nil];
            
        }else if (alertView.tag == 0x222) {// 激活任务
            
            if ([self.project_complete_status isEqualToString:@"1"]) {
                
                if ([alertView textFieldAtIndex:0].text.length) {
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    
//                    [self.projectTaskBL requestTaskFinishOrActiveWithTaskId:self.handleTask.taskInfoId completeStatus:@0 remark:[alertView textFieldAtIndex:0].text];
                    [self.projectTaskBL requestTaskFinishOrActiveWithTaskId:self.handleTask.bean_id completeStatus:@0 remark:[alertView textFieldAtIndex:0].text];
                }else{
                    [MBProgressHUD showError:@"请填写激活原因" toView:self.view];
                }
            }else{
                
//                [self.projectTaskBL requestTaskFinishOrActiveWithTaskId:self.handleTask.taskInfoId completeStatus:@0 remark:nil];
                [self.projectTaskBL requestTaskFinishOrActiveWithTaskId:self.handleTask.bean_id completeStatus:@0 remark:nil];
            }
            
        }else{
            
            UITextField *textField = [alertView textFieldAtIndex:0];
            NSString *str = textField.text;
            
            if ([str isEqualToString:self.editSection.name]) {
                
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                [self.projectTaskBL requestDeleteProjectSectionWithSectionId:self.editSection.id columnId:self.projectColumnModel.id projectId:self.projectId];
            }else{
                
                [MBProgressHUD showError:@"删除不成功" toView:self.view];
                
            }
        }
        
    }
}

/** 拖拽列 */
-(void)boardView:(TFBoardView *)boardView dataChanged:(NSArray *)models destinationIndex:(NSInteger)destinationIndex{
    
    NSMutableArray *arr = [NSMutableArray array];
    for (TFProjectSectionModel *row in models) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:row.id forKey:@"id"];
        [dict setObject:row.name forKey:@"name"];
        [dict setObject:row.sort forKey:@"sort"];
        [dict setObject:row.main_id forKey:@"main_id"];
        [arr addObject:dict];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.projectTaskBL requestSortProjectSectionWithList:arr columnId:self.projectColumnModel.id projectId:self.projectId activeNodeId:self.projectColumnModel.id originalNodeId:self.projectColumnModel.id];
    
}
/** 拖拽任务 */
-(void)boardView:(TFBoardView *)boardView dataChanged:(NSArray *)models destinationIndex:(NSInteger)destinationIndex originalIndex:(NSInteger)originalIndex moveTask:(TFProjectRowModel *)moveTask{
    
    TFProjectSectionModel *original = models[originalIndex];
    TFProjectSectionModel *destination = models[destinationIndex];
    
    NSMutableArray *arr = [NSMutableArray array];
    for (TFProjectRowModel *row in destination.tasks) {
        [arr addObject:[row toDictionary]];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [self.projectTaskBL requestDragTaskToSortWithOriginalNodeId:original.id toSubnodeId:destination.id dataList:arr moveId:moveTask.taskInfoId];
    [self.projectTaskBL requestDragTaskToSortWithOriginalNodeId:original.id toSubnodeId:destination.id dataList:arr moveId:moveTask.bean_id];
}

-(void)boardViewDidTaskRow{

    if (![self.projectModel.project_status isEqualToString:@"0"]) {
        if ([self.projectModel.project_status isEqualToString:@"1"]) {// 归档
            
            [MBProgressHUD showError:@"项目已归档" toView:self.view];
        }
        if ([self.projectModel.project_status isEqualToString:@"2"]) {// 暂停
            
            [MBProgressHUD showError:@"项目已暂停" toView:self.view];
        }
        return;
    }
    TFTaskColumnAddController *add = [[TFTaskColumnAddController alloc] init];
    add.index = 1;
    add.type = 0;
    add.projectColumnModel = self.projectColumnModel;
    add.projectId = self.projectId;
    add.refresh = ^(id parameter) {

        if (self.refreshAction) {
            self.refreshAction();
        }
    };
    [self.navigationController pushViewController:add animated:YES];
    
    
}


#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_deleteProjectSection) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"删除成功" toView:self.view];
        
        for (TFProjectSectionModel *model in self.projectColumnModel.subnodeArr) {
            
            if ([model.id isEqualToNumber:self.editSection.id]) {
                [self.projectColumnModel.subnodeArr removeObject:model];
                break;
            }
        }
        
        [self.boardView refreshMoveViewWithModels:self.projectColumnModel.subnodeArr withType:IsStrEmpty(self.projectColumnModel.flow_id)?0:1];
    }
    if (resp.cmdId == HQCMD_getProjecDetail) {
        
        TFProjectModel *model = resp.body;
        self.project_time_status = model.project_time_status;
        self.project_complete_status = model.project_complete_status;
        
    }
    if (resp.cmdId == HQCMD_sortProjectSection) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }
    if (resp.cmdId == HQCMD_dragTaskSort) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }
    
    if (resp.cmdId == HQCMD_addTaskQuote) {
        
        [self.boardView loadDataWithSectionModel:self.editSection index:self.page];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        for (UIViewController *vc in self.navigationController.childViewControllers) {
            if ([vc isKindOfClass:[TFProjectDetailTabBarController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    }
    
    
    if (resp.cmdId == HQCMD_finishOrActiveTask || resp.cmdId == HQCMD_finishOrActiveChildTask) {
        
        self.handleTask.complete_status = [self.handleTask.complete_status isEqualToNumber:@1]?@0:@1;
        self.handleTask.finishType = self.handleTask.complete_status;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.boardView refreshData];
        
    }
    
    if (resp.cmdId == HQCMD_createTask) {
        
        [self.boardView loadDataWithSectionModel:self.editSection index:self.page];
    }
    
    if (resp.cmdId == HQCMD_getProjectFinishAndActiveAuth) {
        
        NSDictionary *dict = resp.body;
        NSString *auth = [[dict valueForKey:@"finish_task_role"] description];
        self.auth = auth;
        
        if ([self.auth isEqualToString:@"1"]) {
            
            
            if ([self.handleTask.complete_status isEqualToNumber:@1]) {
                
                if ([self.project_complete_status isEqualToString:@"1"]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"激活原因" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    alert.delegate = self;
                    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                    alert.tag = 0x222;
                    [alert show];
                }else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确定激活此任务？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    alert.delegate = self;
                    alert.tag = 0x222;
                    [alert show];
                }
                
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确定完成此任务？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.delegate = self;
                alert.tag = 0x111;
                [alert show];
            }
            
            
        }else{
            [MBProgressHUD showError:@"无权限修改" toView:self.view];
        }
        
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
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
