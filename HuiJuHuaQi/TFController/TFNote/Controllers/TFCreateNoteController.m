
//
//  TFCreateNoteController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/3/19.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCreateNoteController.h"
#import "TFNoteAccessoryView.h"
#import "IQKeyboardManager.h"
#import "TFPicturePositionModel.h"
#import "TFNoteView.h"
#import "TFSelectDateView.h"
#import "TFCreateNoteModel.h"
#import "TFMutilStyleSelectPeopleController.h"
#import "TFMapController.h"
#import "TFSelectPeopleCell.h"
#import "HQSelectTimeCell.h"
#import "TFNoteModel.h"
#import "TFNoteDetailHeadView.h"
#import "TFTwoBtnsView.h"
#import "TFNoteBL.h"
#import "TFChangeHelper.h"
#import "TFNoteRemindController.h"
#import "TFCustomerCommentController.h"
#import "TFNoteRelatedController.h"
#import "HQSelectTimeCell.h"
#import "TFChatBL.h"

//#import "TFCustomDetailController.h"
#import "TFNewCustomDetailController.h"
#import "TFApprovalCopyerController.h"
#import "TFNoteDetailCardCell.h"
#import "TFNoteRelatedModel.h"
#import "TFRelatedCustomModel.h"
#import "TFContactorInfoController.h"
#import "TFModelEnterController.h"
#import "TFApprovalListItemModel.h"
#import "TFQuoteTaskItemModel.h"
#import "TFProjectRowFrameModel.h"
#import "TFCustomListItemModel.h"
#import "TFKnowledgeBL.h"
#import "TFNewProjectTaskItemCell.h"
#import "TFProjectTaskDetailController.h"
#import "TFApprovalDetailController.h"

@interface TFCreateNoteController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,TFNoteAccessoryViewDelegate,TFNoteViewDelegate,TFTwoBtnsViewDelegate,HQBLDelegate,UIAlertViewDelegate,HQSelectTimeCellDelegate,TFNoteDetailCardCellDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;
/** accessoryView */
@property (nonatomic, strong) TFNoteAccessoryView *accessoryView;

/** noteView */
@property (nonatomic, strong) TFNoteView *noteView;

/** createNoteModel 保存新建时的数据 */
@property (nonatomic, strong) TFCreateNoteModel *createNoteModel;

/* 头部 */
@property (nonatomic, strong) TFNoteDetailHeadView *noteDetailHeadView;

/* notes */
@property (nonatomic, strong) NSMutableArray *notes;

/** noteBL */
@property (nonatomic, strong) TFNoteBL *noteBL;
/** knowledgeBL */
@property (nonatomic, strong) TFKnowledgeBL *knowledgeBL;

@property (nonatomic, strong) TFTwoBtnsView *bottomView;

@property (nonatomic, copy) NSString *resultStr;

@property (nonatomic, strong) TFChatBL *chatBL;

//点击section索引
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) NSMutableArray *relates;
@property (nonatomic, strong) NSMutableArray *submitArr;

@property (nonatomic, strong) NSDictionary *detailDict;

/** referDataId */
@property (nonatomic, strong) NSNumber *referDataId;
/** referBean */
@property (nonatomic, copy) NSString *referBean;
/** referModuleId */
@property (nonatomic, strong) NSNumber *referModuleId;
@property (nonatomic, strong) TFProjectRowModel *selectTask;

@end

@implementation TFCreateNoteController

-(TFKnowledgeBL *)knowledgeBL{
    if (!_knowledgeBL) {
        _knowledgeBL = [TFKnowledgeBL build];
        _knowledgeBL.delegate = self;
    }
    return _knowledgeBL;
}

- (NSMutableArray *)relates {
    
    if (!_relates) {
        _relates = [NSMutableArray array];
    }
    return _relates;
}
- (NSMutableArray *)submitArr {
    
    if (!_submitArr) {
        _submitArr = [NSMutableArray array];
    }
    return _submitArr;
}
-(NSMutableArray *)notes{
    if (!_notes) {
        _notes = [NSMutableArray array];
    }
    return _notes;
}


-(TFNoteDetailHeadView *)noteDetailHeadView{
    
    if (!_noteDetailHeadView) {
        _noteDetailHeadView = [TFNoteDetailHeadView noteDetailHeadView];
    }
    return _noteDetailHeadView;
}

-(TFCreateNoteModel *)createNoteModel{
    if (!_createNoteModel) {
        _createNoteModel = [[TFCreateNoteModel alloc] init];
        
        _createNoteModel.relations = [[NSMutableArray array] init];
    }
    return _createNoteModel;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
    
    if (self.type != 1) {
        self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(cancel) text:@"取消" textColor:LightBlackTextColor];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.noteBL = [TFNoteBL build];
    self.noteBL.delegate = self;
    self.chatBL = [TFChatBL build];
    self.chatBL.delegate = self;
    
    self.enablePanGesture = YES;// 禁止右滑返回
    
    self.navigationItem.title = @"备忘录";
    if (self.type != 1) {
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"保存" textColor:LightBlackTextColor];
    }
    [self setupChild];
    [self setupNoteView];
    if (self.type != 0) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.noteBL requestGetNoteWithNoteId:self.noteId];
        [self.noteBL requestFindRelationListWithNoteId:self.noteId];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)keyboardShow:(NSNotification *)noti{
    
    NSDictionary *userInfo = noti.userInfo;
//    NSValue *beginValue    = [userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
    NSValue *endValue      = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect beginFrame      = beginValue.CGRectValue;
    CGRect endFrame        = endValue.CGRectValue;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, endFrame.size.height + 10, 0);
    
}
- (void)keyboardHide:(NSNotification *)noti{
    
    [self.view endEditing:YES];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)cancel{
    

        
    [self.view endEditing:YES];
    
    
    if (self.type == 0) {
        
        if (self.createNoteModel.isEdit) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否放弃编辑？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 1001;
            [alert show];
        }
        else {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else{
       NSString *str =  [self.createNoteModel.dict description];
        
        if ([self.resultStr isEqualToString:str]) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否放弃编辑？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            
            alert.tag = 1001;
            
            [alert show];
        }
        
    }

    
    
}
#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 1001) { //是否放弃编辑
        
        if (buttonIndex == 1) {
            [self.view endEditing:YES];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
    if (alertView.tag == 1002) {
        
        if (buttonIndex == 1) {
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.noteBL requestDeleteNoteWithDict:[NSString stringWithFormat:@"%@",self.noteId] type:2];
        }
        
    }
    
}

- (void)sure{
    

    if (!self.createNoteModel.isEdit) {
        
        [MBProgressHUD showError:@"请输入内容！" toView:self.view];
        return;
    }

    
    [self.view endEditing:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (self.type == 2) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.createNoteModel.dict];
        
        [dict setObject:self.noteId forKey:@"id"];
        
        [self.noteBL requestUpdateNoteWithDict:dict];
    }else{
        
        [self.noteBL requestCreateNoteWithDict:self.createNoteModel.dict];
    }
}

#pragma mark 编辑视图

- (void)setupNoteView{
    
    TFNoteView *noteView = [[TFNoteView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,80}];
    [self.view addSubview:noteView];
    noteView.delegate = self;
    self.noteView = noteView;
    self.tableView.tableHeaderView = noteView;
    
}
#pragma mark - TFNoteViewDelegate
-(void)noteView:(TFNoteView *)noteView changedHeight:(CGFloat)height{
    
    noteView.height = height;
//    self.tableView.tableHeaderView = noteView;
    [self.tableView reloadData];
}

-(void)noteView:(TFNoteView *)noteView noteItems:(NSArray *)noteItems{
    
    self.createNoteModel.noteItems = noteItems;
}

-(void)noteView:(TFNoteView *)noteView check:(NSInteger)index model:(TFNoteModel *)model{
    
    if (self.type == 1) {
        
        // 创建人不为自己
        if (![self.createNoteModel.create_by isEqualToNumber:UM.userLoginInfo.employee.id]) {
            model.check = 1;
            [MBProgressHUD showError:@"不可编辑" toView:self.view];
            return;
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.createNoteModel.dict];
        
        [dict setObject:self.noteId forKey:@"id"];
        
        [self.noteBL requestUpdateNoteWithDict:dict];
    }
}


-(void)noteView:(TFNoteView *)noteView accessoryIndex:(NSInteger)index{
    
    [self noteAccessoryDidSelectedItem:nil AtIndex:index];
}

#pragma mark HQSelectTimeCellDelegate
- (void)arrowClicked:(NSInteger)index section:(NSInteger)section {

    if (section == 1) {
        
        [self.createNoteModel.relations removeObjectAtIndex:index];
    }
    if (section == 2) {
        
        self.createNoteModel.remindTime = nil;
    }
    
    
    [self.tableView reloadData];
    

}

#pragma mark - 子控件
- (void)setupChild{
    

    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-44-BottomM) style:UITableViewStyleGrouped];

    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    tableView.backgroundColor = BackGroudColor;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    
    if (self.type != 1) {
        
        
        TFNoteAccessoryView *accessoryView = [[TFNoteAccessoryView alloc] initWithFrame:(CGRect){0,SCREEN_HEIGHT-NaviHeight-44-BottomM,SCREEN_WIDTH,44} withImages:@[@"choice",@"mark",@"notePhoto",@"relation",@"remaind",@"noteShare",@"noteLocation",@"noteHide"]];
        self.accessoryView = accessoryView;
        accessoryView.delegate = self;
        [self.view addSubview:accessoryView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewClicked)];
        [self.tableView addGestureRecognizer:tap];
        
        tableView.height = SCREEN_HEIGHT-NaviHeight-44-BottomM;
        
    }else{
        
        [self.view addSubview:self.noteDetailHeadView];
        self.noteDetailHeadView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 74);
        self.tableView.y = 74;
        tableView.height = SCREEN_HEIGHT-NaviHeight-44-74-BottomM;
        
        //[self setupBottomViewWithMyself:YES];
        
        
    }

}

#pragma mark -NoteAccessoryDelegate
-(void)noteAccessoryDidSelectedItem:(UIButton *)button AtIndex:(NSUInteger)index{
    
    if (index == 0 || index == 1) {
        
        TFNoteModel *model = self.createNoteModel.noteItems.lastObject;
        
        if (model.type == 0) {
            [model.noteTextView becomeFirstResponder];
        }else{
            [model.noteImageView.textView becomeFirstResponder];
        }
        
    }
    
    if (index == 2) {
        
        [self.noteView didClickedPhoto];
    }
    
    if (index == 3) {
        
//        TFNoteRelatedController *relatedVC = [[TFNoteRelatedController alloc] init];
//
//        relatedVC.refresh = ^(NSDictionary *dict) {
//
//            NSMutableArray *arr0 = [NSMutableArray array];
//            NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
//            [dictionary setObject:[dict valueForKey:@"ids"] forKey:@"id"];
//            [dictionary setObject:[dict valueForKey:@"module_name"] forKey:@"title"];
//            [dictionary setObject:[dict valueForKey:@"title"] forKey:@"content"];
//            [dictionary setObject:[dict valueForKey:@"icon_url"] forKey:@"icon_url"];
//            [dictionary setObject:[dict valueForKey:@"icon_color"] forKey:@"icon_color"];
//            [dictionary setObject:[dict valueForKey:@"icon_type"] forKey:@"icon_type"];
//
//
//            NSArray *array = [dict valueForKey:@"row"];
//            NSDictionary *dic1 = array[0];
//            [dictionary setObject:[dic1 valueForKey:@"picture"] forKey:@"picture"];
//            [dictionary setObject:[dic1 valueForKey:@"name"] forKey:@"name"];
//            [arr0 addObject:dictionary];
//
//            NSMutableArray *arr = [NSMutableArray array];
//            NSMutableDictionary *subDic = [NSMutableDictionary dictionary];
//            if (self.createNoteModel.relations.count != 0) {
//
//                BOOL have = NO;
//                for (NSDictionary *dictionary in self.createNoteModel.relations) {
//
//                    NSNumber *num = [dictionary valueForKey:@"ids"];
//
//                    if ([num isEqualToNumber:[dict valueForKey:@"ids"]]) {
//
//                        have = YES;
//                        break;
//                    }
//                }
//
//                if (!have) {
//
//                    [subDic setObject:[dict valueForKey:@"ids"] forKey:@"ids"];
//                    [subDic setObject:[dict valueForKey:@"bean"] forKey:@"bean"];
//                    [arr addObject:subDic];
//
//                }
//
//            }
//            else {
//
//                [subDic setObject:[dict valueForKey:@"ids"] forKey:@"ids"];
//                [subDic setObject:[dict valueForKey:@"bean"] forKey:@"bean"];
//                [arr addObject:subDic];
//
//            }
//
//            if (arr.count>0) {
//
//
//
//                [self.submitArr addObjectsFromArray:arr];
////                [self.createNoteModel.relations addObjectsFromArray:arr];
////                self.relates = self.createNoteModel.relations;
//                [self.createNoteModel.relations addObjectsFromArray:arr0];
//
//
//                [self.tableView reloadData];
//            }
//
//        };
//
//        [self.navigationController pushViewController:relatedVC animated:YES];
        
        
        TFModelEnterController *enter = [[TFModelEnterController alloc] init];
        enter.type = 7;
        enter.parameterAction = ^(NSDictionary *parameter) {
            
            NSString *bean = [parameter valueForKey:@"bean"];
            NSString *approval = [parameter valueForKey:@"approval"];
            NSArray *list = [parameter valueForKey:@"list"];
//            NSString *beanType = [[parameter valueForKey:@"beanType"] description];
            NSString *projectId = [[parameter valueForKey:@"projectId"] description];
            if ([bean containsString:@"project_custom"]) {// 任务
                
                NSString *ids = @"";
                for (TFQuoteTaskItemModel *item in list) {
                    
                    ids = [ids stringByAppendingString:[NSString stringWithFormat:@"%@,",[item.id description]]];
                }
                if (ids.length) {
                    ids = [ids substringToIndex:ids.length-1];
                }
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                if (IsStrEmpty(projectId)) {// 个人任务
                    [self.knowledgeBL requestChangeItemToCardWithIds:ids beanType:@5];
                }else{
                    [self.knowledgeBL requestChangeItemToCardWithIds:ids beanType:@2];
                }
                
                
            }else if ([approval isEqualToString:@"approval"]){// 审批
                
                
//                NSString *ids = @"";
//                for (TFApprovalListItemModel *item in list) {
//
//                    ids = [ids stringByAppendingString:[NSString stringWithFormat:@"%@,",[item.id description]]];
//                }
//                if (ids.length) {
//                    ids = [ids substringToIndex:ids.length-1];
//                }
//
//                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                [self.knowledgeBL requestChangeItemToCardWithIds:ids beanType:@4];
                
                for (TFApprovalListItemModel *item in list) {

                    TFProjectRowFrameModel *model = [[TFProjectRowFrameModel alloc] initBorder];
                    TFProjectRowModel *row = [[TFProjectRowModel alloc] init];
                    row.dataType = @4;
                    row.id = @([item.approval_data_id longLongValue]);
                    row.process_name = item.process_name;
                    row.process_field_v = item.process_field_v;
                    row.task_id = @([item.task_id integerValue]);
                    row.approval_data_id = item.approval_data_id;
                    row.task_key = item.task_key;
                    row.process_key = item.process_key;
                    row.create_time = item.create_time;
                    row.begin_user_id = item.begin_user_id;
                    row.begin_user_name = item.begin_user_name;
                    row.picture = item.picture;
                    row.process_definition_id = item.process_definition_id;
                    row.process_status = item.process_status;
                    row.bean_name = bean;

                    model.projectRow = row;

                    [self.createNoteModel.relations addObject:model];
                }
                
                
            }else{// 自定义
                
                for (TFCustomListItemModel *item in list) {
                    
                    TFProjectRowFrameModel *model = [[TFProjectRowFrameModel alloc] initBorder];
                    TFProjectRowModel *row = [[TFProjectRowModel alloc] init];
                    row.dataType = @3;
                    row.id = @([item.id.value longLongValue]);
                    row.rows = item.row;
                    row.module_name = item.moduleName;
                    row.bean_name = bean;
                    row.bean_id = @([item.id.value longLongValue]);
                    row.icon_url = item.icon_url;
                    row.icon_type = @([item.icon_type integerValue]);
                    row.icon_color = item.icon_color;
                    row.module_bean = bean;
                    
                    model.projectRow = row;
                    
                    [self.createNoteModel.relations addObject:model];
                }
                
                
            }
            
            [self.tableView reloadData];
            
        };
        [self.navigationController pushViewController:enter animated:YES];
    }
    
    if (4 == index) {// 提醒
        
        TFNoteRemindController *remindVC = [[TFNoteRemindController alloc] init];
        
        remindVC.remindTime = self.createNoteModel.remindTime;
        remindVC.status = self.createNoteModel.remindStatus;
        remindVC.refresh = ^(id parameter) {
            
            self.createNoteModel.remindTime = [parameter valueForKey:@"time"];
            self.createNoteModel.remindStatus = [parameter valueForKey:@"status"];
            
            [self.tableView reloadData];
        };
        
        [self.navigationController pushViewController:remindVC animated:YES];
    }
    if (5 == index) {// 共享
        
        TFMutilStyleSelectPeopleController *scheduleVC = [[TFMutilStyleSelectPeopleController alloc] init];
        scheduleVC.selectType = 1;
        scheduleVC.isSingleSelect = NO;
        scheduleVC.defaultPoeples = self.createNoteModel.sharers;
        
        NSMutableArray *arr = [NSMutableArray array];
        HQEmployModel *model = [[HQEmployModel alloc] init];
        model.id = UM.userLoginInfo.employee.id;
        [arr addObject:model];
        scheduleVC.noSelectPoeples = arr;
        scheduleVC.actionParameter = ^(NSArray *parameter) {
            
            NSMutableArray *noSelfArr = [NSMutableArray array];
            
            for (HQEmployModel *model in parameter) { //过滤自己
                
                if (![model.id isEqualToNumber:UM.userLoginInfo.employee.id]) {
                    
                    [noSelfArr addObject:model];
                }
            }
            
            NSString *str = @"";
            for (HQEmployModel *em in noSelfArr) {
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[em.id description]]];
            }
            if (str.length) {
                str = [str substringToIndex:str.length - 1];
            }
            
            self.createNoteModel.sharerIds = str;
            self.createNoteModel.sharers = [NSMutableArray arrayWithArray:noSelfArr];
            [self.tableView reloadData];
            
        };
        [self.navigationController pushViewController:scheduleVC animated:YES];
        
    }
    
    if (6 == index) {// 地址
        
        TFMapController *locationVc = [[TFMapController alloc] init];
        locationVc.type = LocationTypeSearchLocation;
        locationVc.keyword = nil;
        locationVc.locationAction = ^(TFLocationModel *parameter){
            
            if (!self.createNoteModel.locations) {
                
                self.createNoteModel.locations = [NSMutableArray array];
            }
            

            BOOL have = NO;
            for (TFLocationModel *model in self.createNoteModel.locations) {
                
                if (model.latitude == parameter.latitude && model.longitude == parameter.longitude) {
                    
                    have = YES;
                    break;
                }
            }
            
            if (!have) {
                
                [self.createNoteModel.locations addObject:parameter];
            }
            
            
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:locationVc animated:YES];
        
    }

}

/** 将引用的数据分类排序 */
-(void)handleFramePositionWithRow:(TFProjectRowFrameModel *)row{
    
    NSMutableArray *approvals = [NSMutableArray array];
    NSMutableArray *customs = [NSMutableArray array];
    for (TFProjectRowFrameModel *frame in self.createNoteModel.relations) {
        if ([[frame.projectRow.dataType description] isEqualToString:@"3"]) {
            [customs addObject:frame];
        }else if ([[frame.projectRow.dataType description] isEqualToString:@"4"]){
            [approvals addObject:frame];
        }
    }
    if ([[row.projectRow.dataType description] isEqualToString:@"3"]) {
        [customs addObject:row];
    }else if ([[row.projectRow.dataType description] isEqualToString:@"4"]){
        [approvals addObject:row];
    }
    
    [self.createNoteModel.relations removeAllObjects];
    [self.createNoteModel.relations addObjectsFromArray:approvals];
    [self.createNoteModel.relations addObjectsFromArray:customs];
    
}

/*
-(void)setupBottomViewWithMyself:(BOOL)myself{
    
    NSMutableArray<TFTwoBtnsModel> *arr = [NSMutableArray<TFTwoBtnsModel> array];
    
    if (myself) {
        
        for (NSInteger i = 0; i < 3; i ++) {
            
            TFTwoBtnsModel *model = [[TFTwoBtnsModel alloc] init];
            
            if (0 == i){
                model.title = @"备忘录评论";
            }else if (1 == i){
                model.title = @"备忘录编辑";
            }else{
                model.title = @"备忘录删除";
                
            }
            
            [arr addObject:model];
        }
        
    }else{
        
        for (NSInteger i = 0; i < 2; i ++) {
            
            TFTwoBtnsModel *model = [[TFTwoBtnsModel alloc] init];
            
            if (0 == i){
                model.title = @"评论-7";
            }else{
                model.title = @"删除";
                
            }
            
            [arr addObject:model];
        }
        
    }
    TFTwoBtnsView *bottomView = [[TFTwoBtnsView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64-44, SCREEN_WIDTH, 44) withImages:arr];
    bottomView.delegate = self;
    [self.view addSubview:bottomView];
    
}
*/
#pragma mark 底部按钮
- (void)createNoteBottomButton {

    NSMutableArray<TFTwoBtnsModel> *arr = [NSMutableArray<TFTwoBtnsModel> array];
    
    if ([self.createNoteModel.del_status isEqualToString:@"1"]) { //已删除的
        
        for (NSInteger i = 0; i < 3; i ++) {
            
            TFTwoBtnsModel *model = [[TFTwoBtnsModel alloc] init];
            
            if (0 == i){
                model.image = @"备忘录评论";
                model.title = [NSString stringWithFormat:@"%ld",[self.createNoteModel.commentsCount integerValue]];
                model.font = FONT(12);
                model.color = kUIColorFromRGB(0x4A4A4A);
            }
            else if (1==i) {
            
                model.image = @"备忘录恢复";
            }
            else{
                model.image = @"备忘录删除";
                
            }
            
            [arr addObject:model];
        }
        
    }
    
    else if ([self.createNoteModel.create_by isEqualToNumber:UM.userLoginInfo.employee.id]) { //我创建的
        
        
        for (NSInteger i = 0; i < 3; i ++) {
            
            TFTwoBtnsModel *model = [[TFTwoBtnsModel alloc] init];
            
            if (0 == i){
                model.image = @"备忘录评论";
                 model.title = [NSString stringWithFormat:@"%ld",[self.createNoteModel.commentsCount integerValue]];
                model.font = FONT(12);
                model.color = kUIColorFromRGB(0x4A4A4A);
            }else if (1 == i){
                model.image = @"备忘录编辑";
            }else{
                model.image = @"备忘录删除";
                
            }
            
            [arr addObject:model];
        }
        
    }
    
    else{ //共享给我
        
        for (NSInteger i = 0; i < 2; i ++) {
            
            TFTwoBtnsModel *model = [[TFTwoBtnsModel alloc] init];
            
            if (0 == i){
                model.image = @"备忘录评论";
                 model.title = [NSString stringWithFormat:@"%ld",[self.createNoteModel.commentsCount integerValue]];
                model.font = FONT(12);
                model.color = kUIColorFromRGB(0x4A4A4A);
            }
            else{
                
                model.image = @"备忘录退出";
            }
            
            [arr addObject:model];
        }
        
    }
    
    
//    TFTwoBtnsView *bottomView = [[TFTwoBtnsView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64-44, SCREEN_WIDTH, 44) withImages:arr];
    self.bottomView = [[TFTwoBtnsView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-NaviHeight-44-BottomM, SCREEN_WIDTH, 44) withModels:arr];
    self.bottomView.delegate = self;
    [self.view addSubview:self.bottomView];
}

#pragma mark TFNoteDetailCardCellDelegate(删除事件)
//删除位置
-(void)deleteNoteLocationWithIndex:(NSInteger)index {

    [self.createNoteModel.locations removeObjectAtIndex:index];
    
    [self.tableView reloadData];
}
//删除关联
-(void)deleteNoteRelatedWithIndex:(NSInteger)index {
    
    [self.createNoteModel.relations removeObjectAtIndex:index];
    [self.relates removeObjectAtIndex:index];
    [self.tableView reloadData];
}

//删除提醒
-(void)deleteNoteRemindWithIndex:(NSInteger)index {
    
    self.createNoteModel.remindTime = nil;
    [self.tableView reloadData];
}
//删除共享人
-(void)deleteNoteSharesWithIndex:(NSInteger)index {
    
    [self.createNoteModel.sharers removeAllObjects];
    self.createNoteModel.sharerIds = @"";
    [self.tableView reloadData];
    
}

-(void)deleteNoteSingleSharerWithIndex:(NSInteger)index {
    
    [self.createNoteModel.sharers removeObjectAtIndex:index];
    
    [self.tableView reloadData];
}

/** 点击位置 */
-(void)didClickedLocation:(TFLocationModel *)model{
    
    TFMapController *locationVc = [[TFMapController alloc] init];
    locationVc.type = LocationTypeLookLocation;
    locationVc.keyword = nil;
    locationVc.location = CLLocationCoordinate2DMake(model.latitude, model.longitude);

    [self.navigationController pushViewController:locationVc animated:YES];
}
/** 点击关联 */
-(void)didClickedReferanceWithDataId:(NSNumber *)dataId bean:(NSString *)bean moduleId:(NSNumber *)moduleId model:(id)row{
    
    self.referBean = bean;
    self.referDataId = dataId;
    self.referModuleId = moduleId;
    
    TFProjectRowModel *model = (TFProjectRowModel *)row;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([model.dataType isEqualToString:@"2"]) {
        
        [dict setObject:model.dataType forKey:@"data_Type"];
        
        if (model.task_id) {
            [dict setObject:model.task_id forKey:@"task_id"];
        }
        if (model.bean_id) {
            [dict setObject:model.bean_id forKey:@"taskInfoId"];
            [dict setObject:model.bean_id forKey:@"id"];
        }
        if (model.bean_name) {
            [dict setObject:model.bean_name forKey:@"beanName"];
        }
        if (model.taskName) {
            [dict setObject:model.taskName forKey:@"taskName"];
        }
        if (model.projectId) {
            [dict setObject:model.projectId forKey:@"projectId"];
        }
        if (model.from) {
            [dict setObject:model.from forKey:@"from"];
            [dict setObject:@0 forKey:@"fromType"];
        }
    }
    self.selectTask = model;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.chatBL requestGetFuncAuthWithCommunalWithData:bean moduleId:moduleId style:nil dataId:dataId reqmap:[HQHelper dictionaryToJson:dict]];
    
}

// 点击分享人头像
-(void)didClickedPeopleWithModel:(HQEmployModel *)model{
    
    TFContactorInfoController *personMaterial = [[TFContactorInfoController alloc] init];
    
    personMaterial.signId = model.sign_id;
    
    [self.navigationController pushViewController:personMaterial animated:YES];
}
// 删除关联
-(void)changeHeight{
    [self.tableView reloadData];
}

#pragma mark - TFTwoBtnsViewDelegate
- (void)twoBtnsView:(TFTwoBtnsView *)twoBtnsView didSelectIndex:(NSInteger)index{
    
    if (index == 0) { //评论
        
        TFCustomerCommentController *commentVC = [[TFCustomerCommentController alloc] init];
        
        commentVC.bean = @"memo";
        commentVC.id = self.noteId;
        commentVC.refreshAction = ^(id parameter) {
          
            self.createNoteModel.commentsCount = parameter;
            
            [self createNoteBottomButton];
        };
        
        [self.navigationController pushViewController:commentVC animated:YES];
        
    }
    
    if (index == 1) {
        
        if ([self.createNoteModel.del_status isEqualToString:@"1"]) { //已删除的
            
            //恢复备忘
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.noteBL requestDeleteNoteWithDict:[NSString stringWithFormat:@"%@",self.noteId] type:3];
            
        }
        
        else if ([self.createNoteModel.create_by isEqualToNumber:UM.userLoginInfo.employee.id]) { //我创建的
            
            //编辑
            TFCreateNoteController *create = [[TFCreateNoteController alloc] init];
            create.type = 2;
            create.noteId = self.noteId;
            create.refreshAction = ^{
                
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [self.noteBL requestGetNoteWithNoteId:self.noteId];
                [self.noteBL requestFindRelationListWithNoteId:self.noteId];
            };
            [self.navigationController pushViewController:create animated:YES];
            
        }
        else {
        
            //退出共享
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.noteBL requestDeleteNoteWithDict:[NSString stringWithFormat:@"%@",self.noteId] type:4];
        }
        
        
    }
    
    if (index == 2) {
        
        if ([self.createNoteModel.del_status isEqualToString:@"1"]) { //彻底删除
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确定彻底删除？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            
            alert.tag = 1002;
            
            [alert show];
            
        }
        else { //删除
        
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.noteBL requestDeleteNoteWithDict:[NSString stringWithFormat:@"%@",self.noteId] type:1];
        }
        
    }
    
}



- (void)tableViewClicked{
    
    TFNoteModel *model = self.createNoteModel.noteItems.lastObject;
    if (model.type == 0) {
        [model.noteTextView becomeFirstResponder];
    }else{
        [model.noteImageView.textView becomeFirstResponder];
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        if (self.createNoteModel.locations.count == 0) {
            
            return 0;
        }
    }
    else if (section == 1){
        if (self.createNoteModel.relations.count == 0){

        return 0 ;
        }
    }
    else if (section == 2){

        if (self.createNoteModel.remindTime == nil || [self.createNoteModel.remindTime isEqualToString:@""]){
            
            return 0 ;
        }

    }else if (section == 3){

        if (self.createNoteModel.sharers.count == 0){
            
            return 0 ;
        }
    }
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFNoteDetailCardCell *cell = [TFNoteDetailCardCell NoteDetailCardCellWithTableView:tableView];
    
    if (indexPath.section == 0) {
        
        
        cell.cellType = NoteDetailCellLocation;
        cell.title = @"位置";
        
    }
    else if (indexPath.section == 1){// 项目
        
        cell.cellType = NoteDetailCellRelated;
        cell.title = @"关联";
        
    }
    else if (indexPath.section == 2){ //提醒
        
        cell.cellType = NoteDetailCellRemind;
        cell.title = @"提醒";
        
    }
    else{ //共享
        
        cell.cellType = NoteDetailCellShare;
        cell.title = @"共享";
    }
    cell.type = self.type;
    cell.delegate = self;
    [cell refreshNoteDetailCardCellWithArray:self.createNoteModel];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
//    if (indexPath.section == 0) { //定位
//        
//        TFLocationModel *model = self.createNoteModel.locations[indexPath.row];
//        
//        TFMapController *locationVc = [[TFMapController alloc] init];
//        locationVc.type = LocationTypeLookLocation;
//        locationVc.keyword = nil;
//        locationVc.location = CLLocationCoordinate2DMake(model.latitude, model.longitude);
//        
//        [self.navigationController pushViewController:locationVc animated:YES];
//    }
//    else if (indexPath.section == 1) { //关联模块
//        
//        self.chatBL = [TFChatBL build];
//        self.chatBL.delegate = self;
//        
//        self.index = indexPath.row;
//        //权限判断
//        
//        NSDictionary *dic = self.createNoteModel.relations[indexPath.row];
//        
//        NSString *bean = [dic valueForKey:@"module"];
//        NSNumber *dataId = [dic valueForKey:@"id"];
//        
//        [self.chatBL requestGetFuncAuthWithCommunalWithData:bean moduleId:nil style:nil dataId:dataId];
//        
//        
//    }
//    else if (indexPath.section == 3) { //共享
//    
//        TFApprovalCopyerController *copyer = [[TFApprovalCopyerController alloc] init];
//        copyer.naviTitle = @"共享人";
//        copyer.employees = self.createNoteModel.sharers;
//        copyer.actionParameter = ^(id parameter) {
//            
//            self.createNoteModel.sharers = parameter;
//            [self.tableView reloadData];
//        };
//        [self.navigationController pushViewController:copyer animated:YES];
//    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
//        return 90;
//        TFNoteDetailCardCell *cell = [TFNoteDetailCardCell NoteDetailCardCellWithTableView:tableView];
        
//        [cell refreshNoteDetailCardCellWithArray:self.createNoteModel.locations];
        if (self.createNoteModel.locations.count == 0) {
            
            return 0;
        }
        return [TFNoteDetailCardCell refreshNoteDetailCardCellHeightWithArray:self.createNoteModel cellType:NoteDetailCellLocation];
        
    }
    else if (indexPath.section == 1){
        
        if (self.createNoteModel.relations.count == 0) {
            
            return 0;
        }
        return [TFNoteDetailCardCell refreshNoteDetailCardCellHeightWithArray:self.createNoteModel cellType:NoteDetailCellRelated];
        
    }
    else if (indexPath.section == 2){
        

        if (self.createNoteModel.remindTime == nil || [self.createNoteModel.remindTime isEqualToString:@""]) {
            
            return 0;
            
        }
        else{
            
//            NSMutableArray *reminds = [NSMutableArray array];
//            [reminds addObject:self.createNoteModel.remindTime];
//            return [TFNoteDetailCardCell refreshNoteDetailCardCellHeightWithArray:reminds cellType:NoteDetailCellRemind];
            return 90;
        }
        
    }
    else{
        
//        return [TFSelectPeopleCell refreshSelectPeopleCellHeightWithStructure:@"1"];
        if (self.createNoteModel.sharers.count == 0) {
            
            return 0;
        }
        return [TFNoteDetailCardCell refreshNoteDetailCardCellHeightWithArray:self.createNoteModel cellType:NoteDetailCellShare];
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        if (self.createNoteModel.locations.count == 0) {
            
            return 0;
        }
    }
    else if (section == 1){
        if (self.createNoteModel.relations.count == 0){
            
            return 0 ;
        }
    }
    else if (section == 2){
        
        if (self.createNoteModel.remindTime == nil || [self.createNoteModel.remindTime isEqualToString:@""]){
            
            return 0 ;
        }
        
    }else if (section == 3){
        
        if (self.createNoteModel.sharers.count == 0){
            
            return 0 ;
        }
    }
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    view.backgroundColor = BackGroudColor;
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(void)taskRelationListDidClickedModel:(TFProjectRowModel *)model{
    
    
    // 1备忘录 2任务 3自定义模块数据 4审批数据
    if ([model.dataType isEqualToNumber:@1]) {
        
        TFCreateNoteController *note = [[TFCreateNoteController alloc] init];
        note.type = 1;
        //        note.noteId = model.id;
        note.noteId = model.bean_id;
        [self.navigationController pushViewController:note animated:YES];
        
    }else if ([model.dataType isEqualToNumber:@2]){
        
        
        TFProjectTaskDetailController *detail = [[TFProjectTaskDetailController alloc] init];
        detail.projectId = model.projectId;
        if ([model.from isEqualToNumber:@1]) {// 个人任务
            if (model.task_id) {// 子任务
                detail.taskType = 3;
                detail.parentTaskId = model.task_id;
            }else{// 主任务
                detail.taskType = 2;
            }
        }else{// 项目任务
            //            if (model.task_id && [model.task_type isEqualToString:@"0"]) {// 子任务
            if (model.task_id) {// 子任务
                detail.taskType = 1;
                detail.parentTaskId = model.task_id;
            }else{// 主任务
                detail.taskType = 0;
            }
        }
        // 关联时用quoteTaskId，不用taskInfoId
        //        detail.dataId = model.taskInfoId;
        //        detail.dataId = model.quoteTaskId;
        detail.dataId = model.bean_id;
        detail.action = ^(id parameter) {
            
        };
        detail.deleteAction = ^{
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


#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if (resp.cmdId == HQCMD_changeItemToCard) {
        
        for (NSDictionary *dict in resp.body) {
            TFProjectRowModel *row = [HQHelper projectRowWithTaskDict:dict];
            TFProjectRowFrameModel *model = [[TFProjectRowFrameModel alloc] init];
            model.projectRow = row;
            
            /** (数据类型 1备忘录 2任务 3自定义模块数据 4审批数据 5邮件) */
            if ([row.dataType isEqualToNumber:@2]) {
                row.cellHeight = @([TFNewProjectTaskItemCell refreshNewProjectTaskItemCellHeightWithModel:row haveClear:YES]);
                model.cellHeight = [TFNewProjectTaskItemCell refreshNewProjectTaskItemCellHeightWithModel:row haveClear:YES];
            }
            [self.createNoteModel.relations addObject:model];
        }
        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_createNote) {
        
        NSDictionary *dict = resp.body;
        
        if (self.createNoteModel.relations.count > 0) {
            
            NSMutableArray *relas = [NSMutableArray array];
            for (TFProjectRowFrameModel *model in self.createNoteModel.relations) {
                NSMutableDictionary *di = [NSMutableDictionary dictionary];
                if (model.projectRow.bean_id) {
                    [di setObject:model.projectRow.bean_id forKey:@"ids"];
                }
                if (model.projectRow.bean_name) {
                    [di setObject:model.projectRow.bean_name forKey:@"bean"];
                }
                if (model.projectRow.from) {// 个人任务
                    [di setObject:@5 forKey:@"type"];
                }else{
                    [di setObject:@2 forKey:@"type"];
                }
                [relas addObject:di];
            }

            [self.noteBL requestUpdateRelationByIdWithJsonStr:[dict valueForKey:@"dataId"] status:@"0" beanArr:relas];
        }
        else {
            
            if (self.refreshAction) {
                self.refreshAction();
                [MBProgressHUD showImageSuccess:@"新增成功！" toView:self.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
            if (self.dataAction) {
                [self.navigationController popViewControllerAnimated:NO];
                self.dataAction(resp.body);
            }
        }
        
    }
    
    if (resp.cmdId == HQCMD_updateNote) {
        
        
        if (self.type == 2) {
            
            NSMutableArray *relas = [NSMutableArray array];
            for (TFProjectRowFrameModel *model in self.createNoteModel.relations) {
                NSMutableDictionary *di = [NSMutableDictionary dictionary];
                if (model.projectRow.bean_id) {
                    [di setObject:model.projectRow.bean_id forKey:@"ids"];
                }
                if (model.projectRow.bean_name) {
                    [di setObject:model.projectRow.bean_name forKey:@"bean"];
                }
                if (model.projectRow.from) {// 个人任务
                    [di setObject:@5 forKey:@"type"];
                }else{
                    [di setObject:@2 forKey:@"type"];
                }
                [relas addObject:di];
            }
            [self.noteBL requestUpdateRelationByIdWithJsonStr:[self.detailDict valueForKey:@"id"] status:@"0" beanArr:relas];
            
            
        }
        else {
            
            if (self.refreshAction) {
                self.refreshAction();
            }
            
        }
        
    }
    
    if (resp.cmdId == HQCMD_getNoteDetail) {
        
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.detailDict = resp.body;
        //记录详情关联的数据
        NSArray *array = [self.detailDict valueForKey:@"items_arr"];
        if (!IsArrEmpty(array)) { //非空数组
            
            [self.relates addObjectsFromArray:[self.detailDict valueForKey:@"items_arr"]];
        }
        
        
        self.createNoteModel.create_by = [self.detailDict valueForKey:@"create_by"];
        self.createNoteModel.del_status = [self.detailDict valueForKey:@"del_status"];
        self.createNoteModel.remindStatus = [self.detailDict valueForKey:@"remind_status"];
        
        // 显示内容
        NSArray *content = [self.detailDict valueForKey:@"content"];
        
        [self.notes removeAllObjects];
        for (NSDictionary *item in content) {
            TFNoteModel *model = [[TFNoteModel alloc] init];
            NSInteger type = [[item valueForKey:@"type"] integerValue];
            if (type == 1) {
                model.type = 0;
                model.check = [[item valueForKey:@"check"] integerValue];
                model.content = [item valueForKey:@"content"];
                model.num = [[item valueForKey:@"num"] integerValue];
            }else{
                model.type = 1;
                model.fileUrl = [item valueForKey:@"content"];
            }
            [self.notes addObject:model];
        }
        
        
        // 地址
        NSMutableArray *locations = [NSMutableArray array];
        for (NSDictionary *lo in [self.detailDict valueForKey:@"location"]) {
            TFLocationModel *momo = [[TFLocationModel alloc] init];
            momo.longitude = [[lo valueForKey:@"lng"] doubleValue];
            momo.latitude = [[lo valueForKey:@"lat"] doubleValue];
            momo.totalAddress = [lo valueForKey:@"address"];
            momo.detailAddress = [lo valueForKey:@"address"];
            momo.name = [lo valueForKey:@"name"];
            [locations addObject:momo];
        }
        self.createNoteModel.locations = locations;
        
        // 关联项目
        
//        self.createNoteModel.relations = [NSMutableArray arrayWithArray:[dict valueForKey:@"items_arr"]];
        
        // 提醒时间
        self.createNoteModel.remindTime = [HQHelper nsdateToTime:[[self.detailDict valueForKey:@"remind_time"] longLongValue] formatStr:@"yyyy-MM-dd HH:mm"];
        
        // 共享人
        NSArray *sharer = [self.detailDict valueForKey:@"shareObj"];
        
        NSMutableArray *people = [NSMutableArray array];
        for (NSDictionary *dd in sharer) {
            
            TFEmployModel *em = [[TFEmployModel alloc] initWithDictionary:dd error:nil];
            if (em) {
                
                [people addObject:[TFChangeHelper tfEmployeeToHqEmployee:em]];
            }
        }
        
        self.createNoteModel.sharers = people;
        
        // 头部
        TFEmployModel *pp = [[TFEmployModel alloc] initWithDictionary:[self.detailDict valueForKey:@"createObj"] error:nil];
        [self.noteDetailHeadView refreshNoteDetailHeadViewWithPeople:pp createTime:[[self.detailDict valueForKey:@"create_time"] longLongValue]];
        
        // 底部
        if ([pp.id isEqualToNumber:UM.userLoginInfo.employee.id]) {
            
            //[self setupBottomViewWithMyself:YES];
            
        }else{
            //[self setupBottomViewWithMyself:NO];
            
        }
        
        
        self.createNoteModel.commentsCount = [self.detailDict valueForKey:@"commentsCount"];
        
        if (self.type == 1) { //详情
            
            [self createNoteBottomButton];
        }
        
        
//        [self.tableView reloadData];
        
        
        if (self.type != 0) {
            
            [self.noteView refreshNoteViewWithNotes:self.notes withType:self.type];
        }
        
        
        self.resultStr = [self.createNoteModel.dict description];
        
        
        
    }
    
    if (resp.cmdId == HQCMD_memoDel) { //删除
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (self.refreshAction) {
            
            self.refreshAction();
        }
        
        [MBProgressHUD showError:@"操作成功！" toView:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    }
    
    if (resp.cmdId == HQCMD_getFuncAuthWithCommunal) { //权限判断
        
            
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSDictionary *dict = resp.body;
        
        NSNumber *authStr = [dict valueForKey:@"readAuth"];
        if ([authStr isEqualToNumber:@0]) {
            
            [MBProgressHUD showError:@"无权查看或数据已删除！" toView:self.view];
            return;
        }
        else if ([authStr isEqualToNumber:@1]) {
            
            [self taskRelationListDidClickedModel:self.selectTask];
        }
        else if ([authStr isEqualToNumber:@2]) {
            
            [MBProgressHUD showError:@"无权查看或数据已删除！" toView:self.view];
            return;
        }
        else if ([authStr isEqualToNumber:@3]) {
            
            [MBProgressHUD showError:@"无权查看或数据已删除！" toView:self.view];
            return;
        }
        
    }
    
    if (resp.cmdId == HQCMD_findRelationList) {
        
        NSArray *items = resp.body;
        
        NSMutableArray *notes = [NSMutableArray array];
        NSMutableArray *tasks = [NSMutableArray array];
        NSMutableArray *customs = [NSMutableArray array];
        NSMutableArray *approvals = [NSMutableArray array];
        NSMutableArray *emails = [NSMutableArray array];
        
        for (NSDictionary *dd in items) {
            
            TFProjectRowFrameModel *model = [[TFProjectRowFrameModel alloc] init];
            TFProjectRowModel *row = [HQHelper projectRowWithTaskDict:dd];
            model.projectRow = row;
            /** (数据类型 1备忘录 2任务 3自定义模块数据 4审批数据 5邮件) */
            if ([row.dataType isEqualToNumber:@1]) {
                [notes addObject:model];
            }else if ([row.dataType isEqualToNumber:@2]){
                model.cellHeight = [TFNewProjectTaskItemCell refreshNewProjectTaskItemCellHeightWithModel:row haveClear:NO];
                row.cellHeight = @([TFNewProjectTaskItemCell refreshNewProjectTaskItemCellHeightWithModel:row haveClear:NO]);
                [tasks addObject:model];
            }else if ([row.dataType isEqualToNumber:@3]){
                [customs addObject:model];
            }else if ([row.dataType isEqualToNumber:@4]){
                [approvals addObject:model];
            }else{
                [emails addObject:model];
            }
        }
        [self.createNoteModel.relations removeAllObjects];
        [self.createNoteModel.relations addObjectsFromArray:tasks];
        [self.createNoteModel.relations addObjectsFromArray:approvals];
        [self.createNoteModel.relations addObjectsFromArray:customs];
        [self.tableView reloadData];
    }
    if (resp.cmdId == HQCMD_updateRelationById) {
        
        if (self.type == 0) {
            
            if (self.refreshAction) {
                self.refreshAction();
                [MBProgressHUD showImageSuccess:@"新增成功" toView:self.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else  if (self.dataAction) {
                [self.navigationController popViewControllerAnimated:NO];
                self.dataAction(resp.body);
            }else{
                [MBProgressHUD showImageSuccess:@"新增成功" toView:self.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        }
        if (self.type == 2) {
            
            if (self.refreshAction) {
                self.refreshAction();
            }
            [MBProgressHUD showError:@"编辑成功！" toView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}


@end
