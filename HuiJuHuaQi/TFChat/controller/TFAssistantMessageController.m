//
//  TFAssistantMessageController.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/12/21.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAssistantMessageController.h"
#import "JCHATConversationListCell.h"
#import "TFAssistantListController.h"

@interface TFAssistantMessageController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
@end

@implementation TFAssistantMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(assistantConversationChange:) name:@"AssistantConversationData" object:nil];
    [self setupTableView];
    self.navigationItem.title = @"消息通知";
    
}
-(void)assistantConversationChange:(NSNotification *)note{
    
    self.assistantInfos = note.object;
    [self.tableView reloadData];
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
    [self.tableView registerNib:[UINib nibWithNibName:@"JCHATConversationListCell" bundle:nil] forCellReuseIdentifier:@"JCHATConversationListCell"];
    
}
#pragma mark - tableView 数据源及代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.assistantInfos.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"JCHATConversationListCell";
    JCHATConversationListCell *cell = (JCHATConversationListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    if (self.assistantInfos == nil || self.assistantInfos.count <= indexPath.row) {
        return cell;
    }
    
    TFFMDBModel *dbModel = self.assistantInfos[indexPath.row];
    [cell refreshChatCellWithModel:dbModel];
    if (self.assistantInfos.count -1 == indexPath.row) {
        cell.cellLine.hidden = YES;
    }else{
        cell.cellLine.hidden = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TFFMDBModel *model  = self.assistantInfos[indexPath.row];
    
    if ([model.chatType isEqualToNumber:@3]) {
        
        TFAssistantListController *assistant = [[TFAssistantListController alloc] init];
        
        assistant.assistantId = model.chatId;
        assistant.applicationId = model.application_id;
        assistant.naviTitle = model.receiverName;
        assistant.type = [model.type integerValue];
        assistant.timeSp = model.clientTimes;
        assistant.showType = model.showType;
        assistant.icon_url = model.icon_url;
        assistant.icon_color = model.icon_color;
        assistant.icon_type = model.icon_type;
        assistant.refresh = ^{
            model.unreadMsgCount = @([model.unreadMsgCount integerValue] - 1 <= 0 ? 0 : [model.unreadMsgCount integerValue] - 1);
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:assistant animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 64;
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


- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    // setup a list of preview actions
    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"Aciton1" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"Aciton1");
    }];
    
    UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"Aciton2" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"Aciton2");
    }];
    
    UIPreviewAction *action3 = [UIPreviewAction actionWithTitle:@"Aciton3" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"Aciton3");
    }];
    
    NSArray *actions = @[action1,action2,action3];
    
    // and return them (return the array of actions instead to see all items ungrouped)
    return actions;
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
