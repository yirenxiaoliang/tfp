//
//  TFSingleChatDetailController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/18.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFSingleChatDetailController.h"
#import "HQTFTwoLineCell.h"
#import "HQSwitchCell.h"
#import "HQSelectTimeCell.h"
#import "HQTFThreeLabelCell.h"
#import "TFChatPeopleInfoController.h"

@interface TFSingleChatDetailController ()<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,HQSwitchCellDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** 免打扰 */
@property (nonatomic, assign) BOOL isNoDisturb;

/** JMSGUser */
@property (nonatomic, strong) JMSGUser *jmsUser;


@end

@implementation TFSingleChatDetailController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (_conversation.conversationType == kJMSGConversationTypeSingle) {
            _memberArr = [NSMutableArray arrayWithArray:@[_conversation.target]];
            self.jmsUser = _conversation.target;
            _isNoDisturb = ((JMSGUser *)_conversation.target).isNoDisturb;
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
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 1) {
        return 3;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
        cell.bottomLine.hidden = YES;
        
        if (self.gruopType == 1) {
            
            [cell.enterImage setImage:nil forState:UIControlStateNormal];
            cell.topLabel.text = @"小秘书";
            [cell.titleImage setImage:[UIImage imageNamed:@"小秘书50"] forState:UIControlStateNormal];
            cell.type = TwoLineCellTypeTwo;
            cell.bottomLabel.text = @"机器人";
            
        }else{
            
            cell.type = TwoLineCellTypeOne;
            [cell.enterImage setImage:[UIImage imageNamed:@"下一级浅灰"] forState:UIControlStateNormal];
            cell.topLabel.text = self.jmsUser.displayName;
            
            if (![self.jmsUser.avatar containsString:@"qiniu/image/"]) {
                [cell.titleImage sd_setImageWithURL:[HQHelper URLWithString:self.jmsUser.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"headDefalt"]];
            }else{
                [self.jmsUser thumbAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
                    if (error == nil) {
                        if (data != nil) {
                            [cell.titleImage setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
                        } else {
                            [cell.titleImage setImage:[UIImage imageNamed:@"headDefalt"] forState:UIControlStateNormal];
                        }
                    } else {
                        [cell.titleImage setImage:[UIImage imageNamed:@"headDefalt"] forState:UIControlStateNormal];
                    }
                }];
            }
        }
        
        
        return cell;
        
    }else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
            
            HQSwitchCell *cell = [HQSwitchCell switchCellWithTableView:tableView];
            cell.delegate = self;
            cell.title.text = @"置顶聊天";
            cell.bottomLine.hidden = NO;
            cell.switchBtn.tag = 0x123;
            return cell;
        }else if (indexPath.row == 1){
            
            HQSwitchCell *cell = [HQSwitchCell switchCellWithTableView:tableView];
            cell.delegate = self;
            cell.title.text = @"消息免打扰";
            cell.bottomLine.hidden = NO;
            cell.switchBtn.on = self.isNoDisturb;
            cell.switchBtn.tag = 0x456;
            return cell;
        }else{
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = @"清空消息聊天";
            cell.arrowShowState = NO;
            cell.bottomLine.hidden = YES;
            cell.time.text = @"";
            return  cell;
        }
    }else{
        
        HQTFThreeLabelCell *cell = [HQTFThreeLabelCell threeLabelCellWithTableView:tableView];
        cell.leftLabel.text = @"";
        cell.rightLabel.text = @"";
        cell.middleLabel.textColor = GreenColor;
        cell.middleLabel.text = @"关闭私聊";
        cell.bottomLine.hidden = YES;
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.section == 0) {
        
        if (self.gruopType == 1) {
            return;
        }
        TFChatPeopleInfoController *chatPeople = [[TFChatPeopleInfoController alloc] init];
        [self.navigationController pushViewController:chatPeople animated:YES];
    }
    
    if (indexPath.section == 1) {
        
        if (indexPath.row == 2) {// 删除所有消息
            
            BOOL success = [_conversation deleteAllMessages];
            if (success) {
                if (self.refreshAction) {
                    self.refreshAction();
                }
            }
        }
        
    }
    
    if (indexPath.section == 2) {
        // 关闭私聊
        [[NSNotificationCenter defaultCenter] postNotificationName:DeleteChatConversationNotifition object:_conversation];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 90;
    }
    return 55;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 2) {
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

-(void)switchCellDidSwitchButton:(UISwitch *)switchButton{
    
    if (switchButton.tag == 0x123) {
        
    }
    
    if (switchButton.tag == 0x456) {
        
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
