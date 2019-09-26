//
//  TFRobotController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/5/4.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFRobotController.h"
#import "HQTFTwoLineCell.h"
#import "HQTFChatCell.h"
#import "TFIMessageBL.h"
#import "TFAssistantMainController.h"

@interface TFRobotController ()<UITableViewDataSource,UITableViewDelegate,HQBLDelegate>
/** tableView */
@property (nonatomic, weak)  UITableView *tableView;

/** messageBL */
@property (nonatomic, strong) TFIMessageBL *messageBL;

/** assistants */
@property (nonatomic, strong) NSMutableArray *assistants;

@end

@implementation TFRobotController

-(NSMutableArray *)assistants{
    if (!_assistants) {
        _assistants = [NSMutableArray array];
    }
    return _assistants;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    self.navigationItem.title = @"机器人";
    self.messageBL = [TFIMessageBL build];
    self.messageBL.delegate = self;
    [self.messageBL getMessageAssistList];
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
    //    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (section == 0) {
//        return 1;
//    }
    return self.assistants.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
//    cell.type = TwoLineCellTypeOne;
//    
//    if (indexPath.section == 0) {
//        
//        HQTFChatCell *cell = [HQTFChatCell chatCellWithTableView:tableView];
//        [cell.titleImage setImage:[UIImage imageNamed:@"小秘书40"]];
//        cell.titleName.text = @"小秘书";
//        cell.titleNum.hidden = YES;
//        cell.redImage.hidden = YES;
//        cell.jumpBtn.hidden = YES;
//        return cell;
//    }else{
//        
//        if (indexPath.row == 0) {
//            
//            HQTFChatCell *cell = [HQTFChatCell chatCellWithTableView:tableView];
//            [cell.titleImage setImage:[UIImage imageNamed:@"任务40"]];
//            cell.titleName.text = @"任务助手";
//            cell.titleNum.hidden = YES;
//            cell.redImage.hidden = YES;
//            cell.jumpBtn.hidden = YES;
//            return cell;
//        }else if (indexPath.row == 1) {
//            
//            HQTFChatCell *cell = [HQTFChatCell chatCellWithTableView:tableView];
//            [cell.titleImage setImage:[UIImage imageNamed:@"日程40"]];
//            cell.titleName.text = @"日程助手";
//            cell.titleNum.hidden = YES;
//            cell.redImage.hidden = YES;
//            cell.jumpBtn.hidden = YES;
//            return cell;
//        }else if (indexPath.row == 2){
//            
//            HQTFChatCell *cell = [HQTFChatCell chatCellWithTableView:tableView];
//            [cell.titleImage setImage:[UIImage imageNamed:@"文件库40"]];
//            cell.titleName.text = @"文件库助手";
//            cell.titleNum.hidden = YES;
//            cell.redImage.hidden = YES;
//            cell.jumpBtn.hidden = YES;
//            return cell;
//        }else{
//            HQTFChatCell *cell = [HQTFChatCell chatCellWithTableView:tableView];
//            [cell.titleImage setImage:[UIImage imageNamed:@"随手记40"]];
//            cell.titleName.text = @"随手记助手";
//            cell.titleNum.hidden = YES;
//            cell.redImage.hidden = YES;
//            cell.jumpBtn.hidden = YES;
//            return cell;
//        }
//
//    }
    
    TFAssistantTypeModel *model = self.assistants[indexPath.row];
        
    HQTFChatCell *cell = [HQTFChatCell chatCellWithTableView:tableView];
    [cell refreshChatCellWithModel:model];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    TFAssistantTypeModel *model = self.assistants[indexPath.row];
    TFAssistantMainController *assistant = [[TFAssistantMainController alloc] init];
    
    assistant.typeModel = model;
    assistant.assistantType = (AssistantType)(indexPath.row+110);
    [self.navigationController pushViewController:assistant animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFAssistantTypeModel *model = self.assistants[indexPath.row];
    if ([model.assistId isEqualToNumber:@116]) {
        return 0;
    }
    return 70;
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

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_messageGetAssistList) {
        self.assistants = resp.body;
        [self.tableView reloadData];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
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
