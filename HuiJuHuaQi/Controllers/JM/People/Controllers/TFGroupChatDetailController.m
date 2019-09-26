//
//  TFGroupChatDetailController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/18.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFGroupChatDetailController.h"
#import "TFChatDetailPeopleCell.h"
#import "HQSwitchCell.h"
#import "HQSelectTimeCell.h"
#import "HQTFThreeLabelCell.h"
#import "TFGroupPeopleController.h"
#import "TFChatPeopleInfoController.h"
#import "TFGroupPeopleController.h"
#import "TFSelectChatPeopleController.h"

@interface TFGroupChatDetailController ()<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,HQSwitchCellDelegate,TFChatDetailPeopleCellDelegate,HQSwitchCellDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;
/**  */
@property (nonatomic, strong) JMSGGroup *jmsGroup;

/** 免打扰 */
@property (nonatomic, assign) BOOL isNoDisturb;

/** 是否为创建者 */
@property (nonatomic, assign) BOOL isCreator;

@end

@implementation TFGroupChatDetailController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_conversation.conversationType == kJMSGConversationTypeGroup) {
            _memberArr = [NSMutableArray arrayWithArray:[((JMSGGroup *)(_conversation.target)) memberArray]];
            self.jmsGroup = _conversation.target;
            _isNoDisturb = ((JMSGGroup *)_conversation.target).isNoDisturb;
            
            
            JMSGGroup *gruop = ((JMSGGroup *)_conversation.target);
//            if ([gruop.owner isEqualToString:UM.userLoginInfo.employee.imUsername]) {// 群主是不是自己
//                self.isCreator = YES;
//            }
            
            [self.tableView reloadData];
        }

    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupNavigation];
    
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
    //    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    UIView *footer = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,110}];
    UIButton *button = [HQHelper buttonWithFrame:(CGRect){25,30,SCREEN_WIDTH-50,50} target:self action:@selector(outClicked)];
    [button setTitle:@"退出群组" forState:UIControlStateNormal];
    button.titleLabel.font = FONT(20);
    [footer addSubview:button];
    button.backgroundColor = HexColor(0xff6260);
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    tableView.tableFooterView = footer;
}

- (void)outClicked{// 退群
    
    [self.jmsGroup exit:^(id resultObject, NSError *error) {
        
        if (error == nil) {// 成功
            
            HQLog(@"退群成功");
            // 退群成功
            [[NSNotificationCenter defaultCenter] postNotificationName:QuitGroupConversationNotifition object:_conversation];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 2;
    }else if (section == 1){
        return 2;
    }else if (section == 2){
        return 3;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            TFChatDetailPeopleCell *cell = [TFChatDetailPeopleCell chatDetailPeopleCellWithTableView:tableView];
            
            if (self.gruopType == 2) {
                
                [cell refreshCellWithItems:self.memberArr withType:0 withColumn:5];
                
            }else{
                
                if (self.isCreator) {
                    [cell refreshCellWithItems:self.memberArr withType:2 withColumn:5];
                }else{
                    [cell refreshCellWithItems:self.memberArr withType:0 withColumn:5];
                }
            }
            cell.delegate = self;
            cell.bottomLine.hidden = NO;
            return cell;
        }else{
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = [NSString stringWithFormat:@"全部成员（%ld）",self.memberArr.count];
            cell.arrowShowState = YES;
            cell.bottomLine.hidden = YES;
            cell.time.text = @"";
            cell.time.numberOfLines = 1;
            return  cell;
        }
        
    }else if (indexPath.section == 2){
        
        if (indexPath.row == 0) {
            
            HQSwitchCell *cell = [HQSwitchCell switchCellWithTableView:tableView];
            cell.delegate = self;
            cell.title.text = @"置顶聊天";
            cell.bottomLine.hidden = NO;
            
            return cell;
        }else if (indexPath.row == 1){
            
            HQSwitchCell *cell = [HQSwitchCell switchCellWithTableView:tableView];
            cell.delegate = self;
            cell.title.text = @"消息免打扰";
            cell.bottomLine.hidden = NO;
            cell.switchBtn.on = self.isNoDisturb;
            cell.delegate = self;
            cell.switchBtn.tag = 0x123;
            return cell;
        }else{
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = @"清空消息聊天";
            cell.arrowShowState = NO;
            cell.bottomLine.hidden = YES;
            cell.time.text = @"";
            cell.time.numberOfLines = 1;
            return  cell;
        }
    }else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = @"群组名称";
            cell.arrowShowState = YES;
            cell.bottomLine.hidden = NO;
            cell.time.text = self.jmsGroup.name;
            cell.time.numberOfLines = 1;
            return  cell;
        }else{
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = @"群组描述";
            cell.arrowShowState = YES;
            cell.bottomLine.hidden = YES;
            cell.time.text = self.jmsGroup.desc;
            cell.time.numberOfLines = 0;
            return  cell;
        }
        
    }else{
        
        HQTFThreeLabelCell *cell = [HQTFThreeLabelCell threeLabelCellWithTableView:tableView];
        cell.leftLabel.text = @"";
        cell.rightLabel.text = @"";
        cell.middleLabel.textColor = GreenColor;
        cell.middleLabel.text = @"关闭群聊";
        cell.bottomLine.hidden = YES;
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            
            TFGroupPeopleController *group = [[TFGroupPeopleController alloc] init];
            group.memberArr = self.memberArr;
            [self.navigationController pushViewController:group animated:YES];
        }
    }
    if (indexPath.section == 2) {
        
        if (indexPath.row == 2) {// 删除所有消息
            
            BOOL success = [_conversation deleteAllMessages];
            if (success) {
                if (self.refreshAction) {
                    self.refreshAction();
                }
            }
        }
        
    }
    
    if (indexPath.section == 3) {
        // 关闭私聊QuitGroupConversationNotifition
        [[NSNotificationCenter defaultCenter] postNotificationName:DeleteChatConversationNotifition object:_conversation];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            if (self.gruopType == 2) {
                
                return [TFChatDetailPeopleCell refreshCellHeightWithItems:self.memberArr withType:0 withColumn:5];
                
            }else{
                
                if (self.isCreator) {
                    return [TFChatDetailPeopleCell refreshCellHeightWithItems:self.memberArr withType:2 withColumn:5];
                }else{
                    return [TFChatDetailPeopleCell refreshCellHeightWithItems:self.memberArr withType:0 withColumn:5];
                }
            }
        }
        return 55;
    }else if (indexPath.section == 1){
        if (indexPath.row == 1) {
            
            CGFloat height = [HQHelper sizeWithFont:FONT(16) maxSize:(CGSize){SCREEN_WIDTH - 140,MAXFLOAT} titleStr:self.jmsGroup.desc].height+ 34;
            return height <= 55 ? 55 : height;
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {// 置顶
            return 0;
        }
    }
    return 55;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 0;
    }else if (section == 3){
        return 20;
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

#pragma mark - TFChatDetailPeopleCellDelegate
-(void)chatDetailPeopleCellDidClickedPeopleWithModel:(JMSGUser *)model{
    TFChatPeopleInfoController *chatPeople = [[TFChatPeopleInfoController alloc] init];
    chatPeople.jmsUser = model;
    [self.navigationController pushViewController:chatPeople animated:YES];
    
}
-(void)chatDetailPeopleCellDidClickedAddButton{
    TFSelectChatPeopleController *select = [[TFSelectChatPeopleController alloc] init];
    select.type = 1;
    
    kWEAKSELF
    select.actionParameter = ^(NSArray *people){
        // 添加群组成员
        NSMutableArray *users = [NSMutableArray array];// 用户名数组
        
        for (HQEmployModel *model  in people) {
            
            [users addObject:model.imUserName];
        }
        
        
        [self.jmsGroup addMembersWithUsernameArray:users completionHandler:^(id resultObject, NSError *error) {
            
            
            _memberArr = [NSMutableArray arrayWithArray:[((JMSGGroup *)(_conversation.target)) memberArray]];
            [weakSelf.tableView reloadData];
            
        }];
    };
    
    [self.navigationController pushViewController:select animated:YES];
    
}
-(void)chatDetailPeopleCellDidClickedMinusBuuton{
    
    TFGroupPeopleController *group = [[TFGroupPeopleController alloc] init];
    group.type = 1;
    group.memberArr = self.memberArr;
    group.actionParameter = ^(NSArray *peoples){
        
        NSMutableArray *users = [NSMutableArray array];
        for (HQEmployModel *model in peoples) {
            
            [users addObject:model.imUserName];
            
        }
        // 删除成员
        [self.jmsGroup removeMembersWithUsernameArray:users completionHandler:^(id resultObject, NSError *error) {
            
            if (error == nil) {
                
                _memberArr = [NSMutableArray arrayWithArray:[((JMSGGroup *)(_conversation.target)) memberArray]];
                
                [self.tableView reloadData];
            }
            
        }];
    };
    [self.navigationController pushViewController:group animated:YES];
}

#pragma mark - HQSwitchCellDelegate
-(void)switchCellDidSwitchButton:(UISwitch *)switchButton{
    
    if (switchButton.tag == 0x123) {
        
        self.isNoDisturb = !self.isNoDisturb;
        if (_conversation.conversationType == kJMSGConversationTypeSingle) {
            JMSGUser * user = _conversation.target;
            [user setIsNoDisturb:self.isNoDisturb handler:^(id resultObject, NSError *error) {
                if (error == nil) {
                    [self.tableView reloadData];
                    [[NSNotificationCenter defaultCenter] postNotificationName:IsDisturbNotifition object:@(self.isNoDisturb)];
                }
            }];
        } else {
            JMSGGroup *group = _conversation.target;
            [group setIsNoDisturb:self.isNoDisturb handler:^(id resultObject, NSError *error) {
                if (error == nil) {
                    [self.tableView reloadData];
                    [[NSNotificationCenter defaultCenter] postNotificationName:IsDisturbNotifition object:@(self.isNoDisturb)];
                }
            }];
        }

    }
    
}
#pragma mark --释放内存
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
