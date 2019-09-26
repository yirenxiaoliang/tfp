//
//  TFApprovalRejectController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/1/4.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFApprovalRejectController.h"
#import "HQSelectTimeCell.h"
#import "TFManyLableCell.h"
#import "FDActionSheet.h"
#import "TFCustomBL.h"

@interface TFApprovalRejectController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,FDActionSheetDelegate,HQBLDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** rejectWay */
@property (nonatomic, strong) NSNumber *rejectWay;
/** rejectLabel */
@property (nonatomic, copy) NSString *rejectLabel;

/** dot */
@property (nonatomic, strong) NSNumber *dot;
@property (nonatomic, copy) NSString *dotLabel;
@property (nonatomic, copy) NSString *dotKey;

/** rejectAdvise */
@property (nonatomic, copy) NSString *rejectAdvise;

/** rejects */
@property (nonatomic, strong) NSArray *rejects;

/** dots */
@property (nonatomic, strong) NSArray *dots;

/** TFCustomBL */
@property (nonatomic, strong) TFCustomBL *customBL;

@end

@implementation TFApprovalRejectController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.type = 1;
    
//    self.rejects = @[@"驳回给上一节点审批人",@"驳回到发起人",@"驳回到指定节点",@"驳回并结束"];
//    self.dots = @[@"流程开始节点",@"节点二",@"节点三",@"节点四"];
    [self setupTableView];
    [self setupNavi];
    
    self.customBL = [TFCustomBL build];
    self.customBL.delegate = self;
    [self.customBL requestApprovalRejectTypeWithBean:self.approvalItem.module_bean processInstanceId:self.approvalItem.process_definition_id taskKey:self.approvalItem.task_key];
}

#pragma mark - navigation
- (void)setupNavi{
    
    self.navigationItem.title = @"驳回";
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
}

- (void)sure{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    // 数据bean
    if (self.approvalItem.module_bean) {
        
        [dict setObject:self.approvalItem.module_bean forKey:@"moduleBean"];
    }
     // 数据id
    if (self.approvalItem.approval_data_id) {
        
        [dict setObject:self.approvalItem.approval_data_id forKey:@"dataId"];
    }
    // 获取流程id
    if (self.approvalItem.process_definition_id) {
        
        [dict setObject:self.approvalItem.process_definition_id forKey:@"processInstanceId"];
    }
    // 获取任务id
    if (self.approvalItem.task_id) {
        
        [dict setObject:self.approvalItem.task_id forKey:@"currentTaskId"];
    }
    // 获取任务key
    if (self.approvalItem.task_key) {
        
        [dict setObject:self.approvalItem.task_key forKey:@"taskDefinitionKey"];
    }
    // 获取任务名称
    if (self.approvalItem.task_name) {
        
        [dict setObject:self.approvalItem.task_name forKey:@"taskDefinitionName"];
    }
    // 驳回方式(0:驳回给上一节点审批人、1:驳回到发起人、2:驳回到指定节点、3:驳回并结束)
    if (self.rejectWay) {

        [dict setObject:self.rejectWay forKey:@"rejectType"];
    }
    // 审批意见
    if (self.rejectAdvise) {
        [dict setObject:self.rejectAdvise forKey:@"message"];
    }
    
    if ([self.rejectWay isEqualToNumber:@2] && self.dotKey) {// 指定节点
        [dict setObject:self.dotKey forKey:@"rejectToTaskKey"];
    }
    
    // 修改
//    if (self.data) {
    [dict setObject:@{} forKey:@"data"];
//    }
    // 20180929 新增参数
    NSMutableDictionary *ddd = [NSMutableDictionary dictionary];
    if (self.approvalItem.approval_data_id) {
        [ddd setObject:self.approvalItem.approval_data_id forKey:@"dataId"];
    }
    [ddd setObject:@1 forKey:@"fromType"];
    if (self.approvalItem.task_key) {
        [ddd setObject:self.approvalItem.task_key forKey:@"taskKey"];
    }
    if (self.approvalItem.module_bean) {
        [ddd setObject:self.approvalItem.module_bean forKey:@"moduleBean"];
    }
//    NSString *ssss = [HQHelper dictionaryToJson:ddd];
    [dict setObject:ddd forKey:@"paramFields"];
    
    [self.view endEditing:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.customBL requestApprovalRejectWithDict:dict];
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_customApprovalRejectType) {
        
        NSDictionary *dict = resp.body;
        
        
        self.rejects = [dict valueForKey:@"rejectType"];
        self.dots = [dict valueForKey:@"historicTaskList"];
        
        if(self.rejects.count){
            
            NSDictionary *di = self.rejects[0];
            
            self.rejectLabel = [di valueForKey:@"label"];
            self.rejectWay = [di valueForKey:@"id"];
        }
        
        if (self.dots.count) {
            
            NSDictionary *di = self.dots[0];
            
            self.dotLabel = [di valueForKey:@"taskName"];
            self.dot = [di valueForKey:@"taskId"];
            self.dotKey = [di valueForKey:@"taskKey"];
            
        }
        
        [self.tableView reloadData];
        
    }
    
    if (resp.cmdId == HQCMD_customApprovalReject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (self.refreshAction) {
            self.refreshAction();
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}



#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight) style:UITableViewStylePlain];
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
    
    if (self.type == 0) {
        
        return 2;
    }else{
        
        return 3;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (self.type == 0) {
        
        if (indexPath.row == 0) {
            
            TFManyLableCell *cell = [TFManyLableCell creatManyLableCellWithTableView:tableView];
            cell.titleLab.text = @"审批意见";
            cell.textVeiw.delegate = self;
            cell.textVeiw.placeholder = @"请输入200字以内（选填）";
            cell.textVeiw.placeholderColor = PlacehoderColor;
            cell.textVeiw.tag = 0x777 *indexPath.section + indexPath.row;
            cell.textVeiw.text = self.rejectAdvise;
            cell.textVeiw.textColor = BlackTextColor;
            cell.structure = @"0";
            cell.fieldControl = @"0";
            cell.textVeiw.userInteractionEnabled = YES;
            
            return cell;
            
        }else{
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = @"驳回节点";
            cell.time.text = self.dotLabel;
            cell.time.textColor = BlackTextColor;
            
            cell.structure = @"1";
            cell.fieldControl = @"2";
            cell.arrowShowState = YES;
            
            return cell;
        }

    }else{
        if (indexPath.row == 0) {
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = @"驳回方式";
            cell.time.text = self.rejectLabel;
            cell.time.textColor = BlackTextColor;
            
            cell.structure = @"1";
            cell.fieldControl = @"2";
            cell.arrowShowState = YES;
            
            return cell;
            
            
        } else if (indexPath.row == 1) {
            
            TFManyLableCell *cell = [TFManyLableCell creatManyLableCellWithTableView:tableView];
            cell.titleLab.text = @"审批意见";
            cell.textVeiw.delegate = self;
            cell.textVeiw.placeholder = @"请输入200字以内（选填）";
            cell.textVeiw.placeholderColor = PlacehoderColor;
            cell.textVeiw.tag = 0x777 *indexPath.section + indexPath.row;
            cell.textVeiw.text = self.rejectAdvise;
            cell.textVeiw.textColor = BlackTextColor;
            cell.structure = @"0";
            cell.fieldControl = @"0";
            cell.textVeiw.userInteractionEnabled = YES;
            
            return cell;
            
        }else{
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = @"驳回节点";
            cell.time.text = self.dotLabel;
            cell.time.textColor = BlackTextColor;
            
            cell.structure = @"1";
            cell.fieldControl = @"2";
            cell.arrowShowState = YES;
            
//            cell.arrowShowState = self.dots.count > 1 ? NO: YES;
            
            return cell;
        }

        
    }
    

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (self.type == 0) {
        
        if (indexPath.row == 1) {
            
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *di in self.dots) {
                
                [arr addObject:[di valueForKey:@"label"]];
            }
            
            FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"驳回节点" delegate:self cancelButtonTitle:@"取消" titles:arr];
            sheet.tag = 0x222;
            [sheet show];
        }
        
    }else{
        
        if (indexPath.row == 0) {
            
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *di in self.rejects) {
                
                [arr addObject:[di valueForKey:@"label"]];
            }
            
            FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"驳回方式" delegate:self cancelButtonTitle:@"取消" titles:arr];
            sheet.tag = 0x111;
            [sheet show];
        }
        
        if (indexPath.row == 2) {
            
//            if (self.dots.count <= 1) {
//                return;
//            }
            
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *di in self.dots) {
                
                [arr addObject:[di valueForKey:@"taskName"]];
            }
            
            FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"驳回节点" delegate:self cancelButtonTitle:@"取消" titles:arr];
            sheet.tag = 0x222;
            [sheet show];
        }
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.type == 0){
        if (indexPath.row == 0) {
            
            return 227;
        }else{
            
            return 64;
        }
    }else{
        
        if (indexPath.row == 0) {
            
            if (self.rejects.count <= 1) {
                return 0;
            }
            return 64;
            
        }else if (indexPath.row == 1) {
            
            return 227;
        }else{
            
            
            if ([self.rejectWay isEqualToNumber:@2]) {
                return 64;
            }
            return 0;
        }
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

#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    
    self.rejectAdvise = textView.text;
    
}



#pragma mark - FDActionSheetDelegate
-(void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex{
    
    
    if (sheet.tag == 0x111) {
        
        NSDictionary *dict = self.rejects[buttonIndex];
        
        self.rejectLabel = [dict valueForKey:@"label"];
        
        self.rejectWay = [dict valueForKey:@"id"];
        
    }
    
    if (sheet.tag == 0x222) {
        
        NSDictionary *dict = self.dots[buttonIndex];
        
        self.dotLabel = [dict valueForKey:@"taskName"];
        
        self.dot = [dict valueForKey:@"taskId"];
        
        self.dotKey = [dict valueForKey:@"taskKey"];
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
