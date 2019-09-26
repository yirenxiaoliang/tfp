//
//  TFSingleChatSetController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/5.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFSingleChatSetController.h"
#import "HQTFTwoLineCell.h"
#import "HQSwitchCell.h"
#import "HQSelectTimeCell.h"
#import "HQTFThreeLabelCell.h"
#import "TFChatPeopleInfoController.h"
#import "TFChatFileController.h"

#import "TFChatBL.h"
#import "TFChatInfoListModel.h"

@interface TFSingleChatSetController ()<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,HQSwitchCellDelegate,HQBLDelegate>
/** tableView */
@property (nonatomic, strong) UITableView *tableView;

/** 免打扰 */
@property (nonatomic, assign) BOOL isNoDisturb;

/** JMSGUser */
@property (nonatomic, strong) JMSGUser *jmsUser;

@property (nonatomic, strong) TFChatBL *chatBL;

@property (nonatomic, strong) TFChatInfoListModel *infoModel;

@end

@implementation TFSingleChatSetController

- (TFChatInfoListModel *)infoModel {

    if (!_infoModel) {
        
        _infoModel = [[TFChatInfoListModel alloc] init];
    }
    return _infoModel;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupNavigation];
    
    self.chatBL = [TFChatBL build];
    self.chatBL.delegate = self;
    
    [self.chatBL requestGetSingleInfoWithData:self.chatId];
    
}



- (void)setupNavigation {
    self.navigationItem.title = @"聊天详情";
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
    
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            HQSwitchCell *cell = [HQSwitchCell switchCellWithTableView:tableView];
            cell.delegate = self;
            cell.title.text = @"置顶聊天";
            cell.bottomLine.hidden = NO;
            cell.switchBtn.tag = 0x123;
            
            //置顶状态(0：未置顶，1：置顶)
            if ([self.infoModel.top_status isEqualToString:@"0"]) {
                
                cell.switchBtn.on = NO;
            }
            else {
                
                cell.switchBtn.on = YES;
            }
            
            return cell;
            
        }else {
            
            HQSwitchCell *cell = [HQSwitchCell switchCellWithTableView:tableView];
            cell.delegate = self;
            cell.title.text = @"消息免打扰";
            cell.bottomLine.hidden = YES;
//            cell.switchBtn.on = self.isNoDisturb;
            cell.switchBtn.tag = 0x456;
            
            //免打扰状态(0：未设置，1：免打扰)
            if ([self.infoModel.no_bother isEqualToString:@"0"]) {
                
                cell.switchBtn.on = NO;
            }
            else {
                
                cell.switchBtn.on = YES;
            }
            
            return cell;
        }

    }
    else {
    
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        cell.timeTitle.text = @"查看聊天文件";
        cell.arrowShowState = YES;
        cell.bottomLine.hidden = YES;
        cell.topLine.hidden = YES;
        cell.time.numberOfLines = 0;
        return  cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.section == 1) {
        
        TFChatFileController *chatFileVC = [[TFChatFileController alloc] init];
        
        chatFileVC.chatId = self.chatId;
        
        [self.navigationController pushViewController:chatFileVC animated:YES];
    }
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

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

-(void)switchCellDidSwitchButton:(UISwitch *)switchButton{
    
    if (switchButton.tag == 0x123) {
        
        if ([self.infoModel.top_status isEqualToString:@"0"]) {
            
            self.infoModel.top_status = @"1";
        }
        else {
        
            self.infoModel.top_status = @"0";
        }
        
        [self.chatBL requestSetTopChatWithData:self.chatId chatType:self.chatType];
    }
    
    if (switchButton.tag == 0x456) {
        
        if ([self.infoModel.no_bother isEqualToString:@"0"]) {
            
            self.infoModel.no_bother = @"1";
        }
        else {
            
            self.infoModel.no_bother = @"0";
        }
        
        [self.chatBL requestSetNoBotherWithData:self.chatId chatType:self.chatType];
    }
    
    

}

#pragma mark --释放内存
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_getSingleInfo) {
        
        self.infoModel = resp.body;
        
        [self.view addSubview:self.tableView];
        
        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_setTopChat) {
        
        TFFMDBModel *model = [[TFFMDBModel alloc] init];
        
        model.chatId = self.chatId;
        if ([self.infoModel.top_status isEqualToString:@"1"]) {
            
            model.isTop = @1;
        }
        else {
            
            model.isTop = @0;
        }
        
        //更新置顶状态
        [DataBaseHandle updateChatListIsTopWithData:model];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:RefreshChatListWithNotification object:model];
        
//        [self.tableView reloadData];
        [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    if (resp.cmdId == HQCMD_setNoBother) {
        
        TFFMDBModel *model = [[TFFMDBModel alloc] init];
        
        model.chatId = self.chatId;
        if ([self.infoModel.no_bother isEqualToString:@"1"]) {
            
            model.noBother = @1;
        }
        else {
            
            model.noBother = @0;
        }

        
        [DataBaseHandle updateChatListNoBotherWithData:model];
        
//        [self.tableView reloadData];
        [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}

@end
