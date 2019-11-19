//
//  TFProjectThinkController.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/4/19.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjectThinkController.h"
#import "TFProjectHandleView.h"
#import "HQNotPassSubmitView.h"
#import "TFProjectTaskBL.h"
#import "TFProjectNodeModel.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "PopoverView.h"
#import "TFRequest.h"
#import "TFProjectTaskDetailController.h"
#import "TFSelectStatusController.h"

@interface TFProjectThinkController ()<TFProjectHandleViewDelegate,HQBLDelegate,WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate,WKScriptMessageHandler,UIAlertViewDelegate>

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;
/** 项目节点json数据 */
@property (nonatomic, strong) NSDictionary *projectNodeDict;
/** 项目所有节点 */
@property (nonatomic, strong) TFProjectNodeModel *projectNode;
/** 选中的节点 */
@property (nonatomic, strong) TFProjectNodeModel *selectNode;
/** 选中的节点的父节点 */
@property (nonatomic, strong) TFProjectNodeModel *parentNode;

@property (nonatomic, strong) TFProjectHandleView *handleView;

/** 是否下一级 */
@property (nonatomic, assign) BOOL isLow;
/** 保存数据 */
@property (nonatomic, strong) NSDictionary *oldData;
/** 修改后的数据 */
@property (nonatomic, strong) NSMutableDictionary *data;
/** 项目状态 */
@property (nonatomic, copy) NSString *project_status;
/** 激活是否需要填写激活原因 */
@property (nonatomic, copy) NSString <Optional>*project_complete_status;
/** 任务角色权限列表 */
@property (nonatomic, strong) NSArray *taskRoleAuths;
/** 后台权限 */
@property (nonatomic, copy) NSString *privilege;
/** 筛选条件 */
@property (nonatomic, strong) NSDictionary *filterParam;

@property (nonatomic, assign) CGPoint point;
@end

@implementation TFProjectThinkController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.projectTaskBL requestAllNodeWithProjectId:self.projectId limitNodeType:nil filterParam:self.filterParam];// 项目所有节点
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.project_status = self.projectModel.project_status;
    [self setHandleView];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    [self.projectTaskBL requestAllNodeWithProjectId:self.projectId limitNodeType:nil filterParam:nil];// 项目所有节点
    [self.projectTaskBL requestGetRoleProjectTaskAuthWithProjectId:self.projectId];// 任务角色权限
    [self.projectTaskBL requestGetProjectRoleAndAuthWithProjectId:self.projectId employeeId:UM.userLoginInfo.employee.id];// 项目后台权限
    
    
//    self.selectNode = [[TFProjectNodeModel alloc] init];
//    self.selectNode.id = @(263);
//    self.selectNode.parent_id = @(260);
//    self.selectNode.project_id = @19;
//    self.selectNode.node_level = @4;
//    self.selectNode.node_name = @"我是第二个子任务";
//    self.selectNode.node_code = @"-196-197-198-260-263-";
    
    // http://192.168.1.145:8787/#/hierarchyPreview
    
    [self setupWebview];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(filterClicked:) name:ProjectTaskFilterNotification object:nil];
    
    UIButton *showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [showBtn setTitle:@"展开" forState:UIControlStateNormal];
//    [showBtn setTitle:@"收起" forState:UIControlStateSelected];
//    [showBtn setTitleColor:GreenColor forState:UIControlStateNormal];
//    [showBtn setTitleColor:GreenColor forState:UIControlStateNormal];
    [showBtn addTarget:self action:@selector(showClicked:) forControlEvents:UIControlEventTouchUpInside];
    showBtn.frame = CGRectMake(SCREEN_WIDTH-80, SCREEN_HEIGHT-NaviHeight-TabBarHeight-55 * 2, 40, 40);
    [self.view addSubview:showBtn];
    showBtn.layer.cornerRadius = 20;
    showBtn.layer.shadowColor = GreenColor.CGColor;
    showBtn.layer.shadowOffset = CGSizeZero;
    showBtn.layer.shadowRadius = 6;
    showBtn.layer.shadowOpacity = 0.5;
//    showBtn.layer.masksToBounds = YES;
//    showBtn.backgroundColor = HexAColor(0xefef78,0.5);
    [showBtn setBackgroundImage:IMG(@"unfoldThink") forState:UIControlStateSelected];
    [showBtn setBackgroundImage:IMG(@"foldThink") forState:UIControlStateNormal];
    showBtn.selected = YES;
   
}

-(void)showClicked:(UIButton *)btn{
    
    if (btn.selected) {
        self.point = self.webView.scrollView.contentOffset;
    }
    
    btn.selected = !btn.selected;
    
    NSString * jsStri  =[NSString stringWithFormat:@"showClicked(%d)",btn.selected?1:0];
    
    [self.webView evaluateJavaScript:jsStri completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        //此处可以打印error.
        NSLog(@"result:%@  error:%@",result,error);
        if (btn.selected == NO) {
            self.webView.scrollView.contentOffset = CGPointMake(0, 0);
        }else{
            self.webView.scrollView.contentOffset = self.point;
        }
    }];
    
}

-(void)filterClicked:(NSNotification *)note{
    
    self.filterParam = note.object;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.projectTaskBL requestAllNodeWithProjectId:self.projectId limitNodeType:nil filterParam:self.filterParam];// 项目所有节点
}

-(void)setupWebview{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    //        config.preferences = [[WKPreferences alloc] init];
    //        config.preferences.minimumFontSize = 10;
    //        config.preferences.javaScriptEnabled = YES;
    //        config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    config.userContentController = [[WKUserContentController alloc] init];
    //        config.processPool = [[WKProcessPool alloc] init];
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-BottomM-TabBarHeight-44)
                                      configuration:config];
    
    
    [self.view insertSubview:self.webView atIndex:0];
    //记得实现对应协议,不然方法不会实现.
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate =self;
//    self.webView.scrollView.scrollEnabled = NO;
//    self.webView.layer.cornerRadius = 4;
//    self.webView.layer.masksToBounds = YES;
//    self.webView.scalesPageToFit = YES;
    self.webView.multipleTouchEnabled = YES;
   self.webView.userInteractionEnabled = YES;
    self.webView.scrollView.scrollEnabled = YES;
    self.webView.scrollView.bounces = YES;
    self.webView.scrollView.bouncesZoom = YES;
    self.webView.contentMode = UIViewContentModeScaleAspectFit;
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"iosPostMessage"];
    
//    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:H5URL(thinkUrl)]]];
}

-(void)handleActionWithActionType:(NSInteger)actionTyope{
    
    self.point = self.webView.scrollView.contentOffset;
    if (actionTyope != 2 && actionTyope != 0) {
        
//        self.project_status = [[self.selectNode.task_info valueForKey:@"project_status"] description];
        if (self.project_status && ![self.project_status isEqualToString:@"0"]) {
            if ([self.project_status isEqualToString:@"1"]) {// 归档
                
                [MBProgressHUD showError:@"项目已归档" toView:self.view];
            }
            if ([self.project_status isEqualToString:@"2"]) {// 暂停
                
                [MBProgressHUD showError:@"项目已暂停" toView:self.view];
            }
            return;
        }
    }
    // 决定操作栏样式
    if ([self.selectNode.node_type isEqualToNumber:@2] || [self.selectNode.node_type isEqualToNumber:@3]) {// 任务
        self.handleView.type = 1;
    }else{
        self.handleView.type = 0;
    }
    
    if (actionTyope == 0) {// 选择节点
        
    }else if (actionTyope == 1){// 新建一级节点
        
        // 获取分类的新增权限
        if ([HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"20"]) {//新增分类
       
            self.parentNode = self.projectNode;
            
            [HQNotPassSubmitView submitPlaceholderStr:@"请输入分类名称" title:nil maxCharNum:200 LeftTouched:^{
                
            } onRightTouched:^(NSDictionary *dict) {
                
                NSMutableDictionary *data = [NSMutableDictionary dictionary];
                // parent_id
                if (self.parentNode.id) {
                    [data setObject:self.parentNode.id forKey:@"parent_id"];
                }
                // node_type
                [data setObject:@1 forKey:@"node_type"];
                // project_id
                [data setObject:self.projectId forKey:@"project_id"];
                // node_level
                if (self.parentNode.node_level) {
                    [data setObject:@([self.parentNode.node_level integerValue] + 1) forKey:@"node_level"];
                }
                // parent_node_code
                if (self.parentNode.node_code) {
                    [data setObject:self.parentNode.node_code forKey:@"parent_node_code"];
                }
                // brother_node_id
                NSString *str = @"";
                for (TFProjectNodeModel *node in self.parentNode.child) {
                    if ([self.selectNode.id isEqualToNumber:node.id]) {
                        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",node.id]];
                        str = [str stringByAppendingString:[NSString stringWithFormat:@"-1,"]];
                    }else{
                        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",node.id]];
                    }
                }
                if (![str containsString:@"-1"]) {
                    str = [str stringByAppendingString:[NSString stringWithFormat:@"-1,"]];
                }
                if (str.length > 0) {
                    str = [str substringToIndex:str.length-1];
                }
                [data setObject:str forKey:@"brother_node_id"];
                // node_name
                if ([dict valueForKey:@"text"]) {
                    [data setObject:[dict valueForKey:@"text"] forKey:@"node_name"];
                }
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [self.projectTaskBL requestAddNodeWithDict:data];
                
            }];
        }
        
    }
    else if (actionTyope == 2){// 任务跳转
        
        TFProjectTaskDetailController *detail = [[TFProjectTaskDetailController alloc] init];
        detail.projectId = self.projectId;
//        detail.sectionId = self.projectColumnModel.id;
//        TFProjectSectionModel *row = self.projectColumnModel.subnodeArr[self.page];
//        detail.rowId = row.id;
        /** 节点类型 0:根节点，1:分类，2:主任务，3:子任务 */
        if ([self.selectNode.node_type integerValue] == 2) {
            detail.taskType = 0;
        }else if ([self.selectNode.node_type integerValue] == 3){
            detail.taskType = 1;
            detail.parentTaskId = [self.selectNode.task_info valueForKey:@"task_id"];
        }
        detail.nodeCode = self.selectNode.node_code;
        detail.dataId = self.selectNode.data_id;
        detail.action = ^(NSDictionary *parameter) {
            [self.projectTaskBL requestAllNodeWithProjectId:self.projectId limitNodeType:nil filterParam:self.filterParam];// 项目所有节点
        };
        detail.deleteAction = ^{
            [self.projectTaskBL requestAllNodeWithProjectId:self.projectId limitNodeType:nil filterParam:self.filterParam];// 项目所有节点
        };
        detail.refresh = ^{
            [self.projectTaskBL requestAllNodeWithProjectId:self.projectId limitNodeType:nil filterParam:self.filterParam];// 项目所有节点
        };
        [self.navigationController pushViewController:detail animated:YES];
    }
    else if (actionTyope == 3){// 任务完成
//        TFProjectRowModel *model = [[TFProjectRowModel alloc] init];
//        model.id = self.selectNode.data_id;
//        model.projectId = self.projectId;
//        model.task_id = [self.selectNode.task_info valueForKey:@"task_id"];
        
        TFProjectRowModel *model = [HQHelper projectRowWithTaskDict:self.selectNode.task_info];
        model.id = self.selectNode.data_id;
        model.projectId = self.projectId;
        model.task_id = [self.selectNode.task_info valueForKey:@"task_id"];
        TFSelectStatusController *select = [[TFSelectStatusController alloc] init];
        select.type = 2;
        select.task = model;
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:select];
        select.refresh = ^{
            
            [self.projectTaskBL requestAllNodeWithProjectId:self.projectId limitNodeType:nil filterParam:self.filterParam];// 项目所有节点
        };
        navi.modalPresentationStyle = UIModalPresentationFullScreen;

        [self presentViewController:navi animated:YES completion:nil];
        
//        if ([self.selectNode.node_type isEqualToNumber:@3]) {// 子任务
//
////            [self.projectTaskBL requsetGetProjectTaskFinishAuthAndActiveCauseWithProjectId:self.projectId taskId:self.selectNode.data_id taskType:@2];
//
//            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//            if (self.projectId) {
//                [dict setObject:self.projectId forKey:@"project_id"];
//            }
//            if (self.selectNode.data_id) {
//                [dict setObject:self.selectNode.data_id forKey:@"task_id"];
//            }
//            [dict setObject:@2 forKey:@"task_type"];
//            // 获取任务的完成权限
//            [[TFRequest sharedManager] requestGET:[NSString stringWithFormat:@"%@%@%@",[AppDelegate shareAppDelegate].baseUrl,[AppDelegate shareAppDelegate].serverAddress,@"/projectTaskController/queryCompleteTaskAuth"] parameters:dict progress:nil success:^(NSDictionary *response) {
//
//                NSDictionary *dict = response[kData];
//                NSString *auth = [[dict valueForKey:@"finish_task_role"] description];
//
//                if ([auth isEqualToString:@"1"]) {
//
//                    if ([[[self.selectNode.task_info valueForKey:@"complete_status"] description] isEqualToString:@"1"]) {
//
//                        if ([self.project_complete_status isEqualToString:@"1"]) {
//                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"激活原因" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//                            alert.delegate = self;
//                            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//                            alert.tag = 0x222;
//                            [alert show];
//                        }else{
//                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确定激活此任务？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//                            alert.delegate = self;
//                            alert.tag = 0x222;
//                            [alert show];
//                        }
//
//                    }
//                    else{
//
//                        BOOL haveNOFinish = NO;
//                        for (TFProjectNodeModel *node in self.selectNode.child) {
//                            if ([[[node.task_info valueForKey:@"complete_status"] description] isEqualToString:@"0"]) {
//                                haveNOFinish = YES;
//                                break;
//                            }
//                        }
//                        if (!haveNOFinish) {
//
//                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确定完成此任务？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//                            alert.delegate = self;
//                            alert.tag = 0x111;
//                            [alert show];
//                        }else{
//                            [MBProgressHUD showError:@"子任务尚未全部完成，无法完成该任务" toView:self.view];
//                        }
//                    }
//
//
//                }else{
//                    [MBProgressHUD showError:@"无权限修改" toView:self.view];
//                }
//
//            } failure:^(NSError *error) {
//                [MBProgressHUD showError:error.debugDescription toView:self.view];
//            }];
//
//        }else if ([self.selectNode.node_type isEqualToNumber:@2]){// 主任务
//
////            [self.projectTaskBL requsetGetProjectTaskFinishAuthAndActiveCauseWithProjectId:self.projectId taskId:self.selectNode.data_id taskType:@1];
//
//            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//            if (self.projectId) {
//                [dict setObject:self.projectId forKey:@"project_id"];
//            }
//            if (self.selectNode.data_id) {
//                [dict setObject:self.selectNode.data_id forKey:@"task_id"];
//            }
//            [dict setObject:@1 forKey:@"task_type"];
//            [[TFRequest sharedManager] requestGET:[NSString stringWithFormat:@"%@%@%@",[AppDelegate shareAppDelegate].baseUrl,[AppDelegate shareAppDelegate].serverAddress,@"/projectTaskController/queryCompleteTaskAuth"] parameters:dict progress:nil success:^(NSDictionary *response) {
//
//                NSDictionary *dict = response[kData];
//                NSString *auth = [[dict valueForKey:@"finish_task_role"] description];
//
//                if ([auth isEqualToString:@"1"]) {
//
//                    if ([[[self.selectNode.task_info valueForKey:@"complete_status"] description] isEqualToString:@"1"]) {
//
//                        if ([self.project_complete_status isEqualToString:@"1"]) {
//                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"激活原因" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//                            alert.delegate = self;
//                            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//                            alert.tag = 0x222;
//                            [alert show];
//                        }else{
//                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确定激活此任务？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//                            alert.delegate = self;
//                            alert.tag = 0x222;
//                            [alert show];
//                        }
//
//                    }
//                    else{
//                        BOOL haveNOFinish = NO;
//                        for (TFProjectNodeModel *node in self.selectNode.child) {
//                            if ([[[node.task_info valueForKey:@"complete_status"] description] isEqualToString:@"0"]) {
//                                haveNOFinish = YES;
//                                break;
//                            }
//                        }
//                        if (!haveNOFinish) {
//
//                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确定完成此任务？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//                            alert.delegate = self;
//                            alert.tag = 0x111;
//                            [alert show];
//                        }else{
//                            [MBProgressHUD showError:@"子任务尚未全部完成，无法完成该任务" toView:self.view];
//                        }
//                    }
//
//
//                }else{
//                    [MBProgressHUD showError:@"无权限修改" toView:self.view];
//                }
//
//            } failure:^(NSError *error) {
//                [MBProgressHUD showError:error.debugDescription toView:self.view];
//            }];
//        }
      
    }
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        if (alertView.tag == 0x111) {// 完成任务
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            if ([self.selectNode.node_type isEqualToNumber:@2]) {
                [self.projectTaskBL requestTaskFinishOrActiveWithTaskId:self.selectNode.data_id completeStatus:@1 remark:nil];
            }
            if ([self.selectNode.node_type isEqualToNumber:@3]) {
                [self.projectTaskBL requestChildTaskFinishOrActiveWithTaskId:self.selectNode.data_id completeStatus:@1 remark:nil];
            }
            
        }
        else if (alertView.tag == 0x222) {// 激活任务
            
            if ([self.project_complete_status isEqualToString:@"1"]) {
                
                if ([alertView textFieldAtIndex:0].text.length) {
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    
                    if ([self.selectNode.node_type isEqualToNumber:@2]) {
                        [self.projectTaskBL requestTaskFinishOrActiveWithTaskId:self.selectNode.data_id completeStatus:@0 remark:[alertView textFieldAtIndex:0].text];
                    }
                    if ([self.selectNode.node_type isEqualToNumber:@3]) {
                        [self.projectTaskBL requestChildTaskFinishOrActiveWithTaskId:self.selectNode.data_id completeStatus:@0 remark:[alertView textFieldAtIndex:0].text];
                    }
                }else{
                    [MBProgressHUD showError:@"请填写激活原因" toView:self.view];
                }
            }
            else{
                
                if ([self.selectNode.node_type isEqualToNumber:@2]) {
                    [self.projectTaskBL requestTaskFinishOrActiveWithTaskId:self.selectNode.data_id completeStatus:@0 remark:nil];
                }
                if ([self.selectNode.node_type isEqualToNumber:@3]) {
                    [self.projectTaskBL requestChildTaskFinishOrActiveWithTaskId:self.selectNode.data_id completeStatus:@0 remark:nil];
                }
            }
            
        }else{
            
            if ([self.selectNode.node_type isEqualToNumber:@1]) {// 删除分类
                
                UITextField *textField = [alertView textFieldAtIndex:0];
                NSString *str = textField.text;
                
                if ([str isEqualToString:self.selectNode.node_name]) {
                    
                    NSMutableDictionary *data = [NSMutableDictionary dictionary];
                    if (self.selectNode.id) {
                        [data setObject:self.selectNode.id forKey:@"node_id"];
                    }
                    if (self.selectNode.node_code) {
                        [data setObject:self.selectNode.node_code forKey:@"node_code"];
                    }
                    if (self.selectNode.node_name) {
                        [data setObject:self.selectNode.node_name forKey:@"node_name"];
                    }
                    
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [self.projectTaskBL requestDeleteNodeWithDict:data];
                    
                }else{
                    [MBProgressHUD showError:@"删除不成功" toView:self.view];
                }
            }
        }
        
    }
}

/**清除缓存和cookie*/
- (void)cleanCacheAndCookie{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}


//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
//{
//    if ([keyPath isEqualToString:@"contentSize"]) {
//
//        CGSize size = [[change valueForKey:NSKeyValueChangeNewKey] CGSizeValue];
//        HQLog(@"CGSize===%@",NSStringFromCGSize(size));
//    }
//
//}

#pragma mark - WKScriptMessageHandler
//实现js注入方法的协议方法
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    
    HQLog(@"======我来了=============%@",message.body);
    HQLog(@"我的名字====%@",message.name);
    //找到对应js端的方法名,获取messge.body
    if ([message.name isEqualToString:@"iosPostMessage"]) {
        
        HQMainQueue(^{
            
            NSDictionary *dict = message.body;
            NSInteger actionType = [[dict valueForKey:@"actionType"] integerValue];
            NSDictionary *selectNode = [dict valueForKey:@"selectNode"];
            NSError *error;
            self.selectNode = [[TFProjectNodeModel alloc] initWithDictionary:selectNode error:&error];
//            self.project_status = [[self.selectNode.task_info valueForKey:@"project_status"] description];
            if (error) {
                HQLog(@"解析错误了：%@",error.debugDescription);
            }
            [self handleActionWithActionType:actionType];
            
        });
    }
}
#pragma mark - 监听    =====WKWebView代理相关
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    
    NSString *jsMeta = [NSString stringWithFormat:@"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width,initial-scale=0.2',); document.getElementsByTagName('head')[0].appendChild(meta);"];
                        
    [self.webView evaluateJavaScript:jsMeta completionHandler:^(id _Nullable x, NSError * _Nullable error) {

    }];
    
    CGFloat width = 0;
    
    width = SCREEN_WIDTH-50;
    
    NSMutableDictionary *domain = [NSMutableDictionary dictionary];
    NSString *pic = [[NSUserDefaults standardUserDefaults] valueForKey:UserPictureDomain];
    if (pic) {
        [domain setObject:pic forKey:@"domain"];
    }
    if (UM.userLoginInfo.token) {
        [domain setObject:UM.userLoginInfo.token forKey:@"token"];
    }
    
//    NSString *jsToken  =[NSString stringWithFormat:@"getToken(%@)",[HQHelper dictionaryToJson:domain]];
//    [self.webView evaluateJavaScript:jsToken completionHandler:^(id _Nullable result, NSError * _Nullable error) {
//        //此处可以打印error.
//
//        NSLog(@"result:%@  error:%@",result,error);
//    }];
//
    if ([self.projectNodeDict valueForKey:@"rootNode"]) {
        [domain setObject:[self.projectNodeDict valueForKey:@"rootNode"] forKey:@"html"];
    }
    NSString * jsStri  =[NSString stringWithFormat:@"getValHtml(%@)",[HQHelper dictionaryToJson:domain]];
    
    [self.webView evaluateJavaScript:jsStri completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        //此处可以打印error.
        
        NSLog(@"result:%@  error:%@",result,error);
    }];
    
}


/** 找到父节点 */
-(TFProjectNodeModel *)findParentNodeWithAllNodel:(TFProjectNodeModel *)allNode selectNode:(TFProjectNodeModel *)selectNode{
    
    if (self.isLow) {
        return selectNode;
    }else{
        TFProjectNodeModel *model;
        if ([allNode.id isEqualToNumber:selectNode.parent_id]) {
            model = allNode;
            return model;
        }
        for (TFProjectNodeModel *node in allNode.child) {
            model = [self findParentNodeWithAllNodel:node selectNode:selectNode];
            if (model != nil) {
                return model;
            }
        }
        
        return model;
    }
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_getProjectRoleAndAuth) {// 项目后台权限
        
        NSDictionary *dict = [resp.body valueForKey:@"priviledge"];
        self.privilege = [dict valueForKey:@"priviledge_ids"];
        
    }
    if (resp.cmdId == HQCMD_projectAllNode) {// 所有节点
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.isLow = NO;
        self.selectNode = nil;
        self.handleView.type = 0;
        self.projectNodeDict = resp.body;
        NSDictionary *dict = [resp.body valueForKey:@"rootNode"];
        self.projectNode = [[TFProjectNodeModel alloc] initWithDictionary:dict error:nil];
        
        NSMutableDictionary *domain = [NSMutableDictionary dictionary];
        NSString *pic = [[NSUserDefaults standardUserDefaults] valueForKey:UserPictureDomain];
        if (pic) {
            [domain setObject:pic forKey:@"domain"];
        }
        if (UM.userLoginInfo.token) {
            [domain setObject:UM.userLoginInfo.token forKey:@"token"];
        }
        if (dict) {
            [domain setObject:dict forKey:@"html"];
        }
//        NSString *str = [HQHelper dictionaryToJson:domain];
        NSString *jsStri  =[NSString stringWithFormat:@"getValHtml(%@)",[HQHelper dictionaryToJson:domain]];
        
        [self.webView evaluateJavaScript:jsStri completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            //此处可以打印error.
            NSLog(@"result:%@  error:%@",result,error);
            
            self.webView.scrollView.contentOffset = self.point ;
        }];
    }
    if (resp.cmdId == HQCMD_projectAddNode || resp.cmdId == HQCMD_projectUpdateNode || resp.cmdId == HQCMD_projectDeleteNode || resp.cmdId == HQCMD_projectAddTask || resp.cmdId == HQCMD_projectAddSubTask || resp.cmdId == HQCMD_projectUpdateTask || resp.cmdId == HQCMD_projectUpdateSubTask || resp.cmdId == HQCMD_finishOrActiveTask || resp.cmdId == HQCMD_deleteTask || resp.cmdId == HQCMD_deleteChildTask || resp.cmdId == HQCMD_finishOrActiveChildTask) {
        [self.projectTaskBL requestAllNodeWithProjectId:self.projectId limitNodeType:nil filterParam:self.filterParam];// 项目所有节点
    }
    if (resp.cmdId == HQCMD_getProjectTaskRoleAuth) {// 任务角色权限
        self.taskRoleAuths = resp.body;
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}

-(void)setHandleView{
    TFProjectHandleView *view = [[TFProjectHandleView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,44}];
    view.layer.shadowColor = LightGrayTextColor.CGColor;
    view.layer.shadowOffset = CGSizeMake(0, 4);
    view.layer.shadowOpacity = 0.5;
    view.layer.shadowRadius = 4;
    [self.view addSubview:view];
    view.delegate = self;
    view.type = 0;
    self.handleView = view;
}
#pragma mark - TFProjectHandleViewDelegate
- (void)projectHandleViewDidClickedIndex:(NSInteger)index btn:(UIButton *)btn{
    
    self.point = self.webView.scrollView.contentOffset;
    self.isLow = NO;
    if (self.selectNode == nil) {
        [MBProgressHUD showError:@"请选择节点" toView:self.view];
        return;
    }
    
//    self.project_status = [[self.selectNode.task_info valueForKey:@"project_status"] description];
    if (self.project_status && ![self.project_status isEqualToString:@"0"]) {
        if ([self.project_status isEqualToString:@"1"]) {// 归档
            
            [MBProgressHUD showError:@"项目已归档" toView:self.view];
        }
        if ([self.project_status isEqualToString:@"2"]) {// 暂停
            
            [MBProgressHUD showError:@"项目已暂停" toView:self.view];
        }
        return;
    }
    
    if (index == 0) {// 删除
        
        if ([self.selectNode.node_type isEqualToNumber:@1]) {// 分类
            
            // 获取分类的删除权限
            if ([HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"23"]) {//删除分类
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除列表" message:[NSString stringWithFormat:@"确定要删除列表【%@】吗？删除后该列表下的所有信息同时被删除。\n\n请输入要删除的列表名称",self.selectNode.node_name] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                alert.delegate = self;
                [alert show];
            }else{
                [MBProgressHUD showError:@"无权限" toView:self.view];
            }
            
        }else if ([self.selectNode.node_type isEqualToNumber:@2]){// 删除主任务
            
            // 获取任务的删除权限
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            if (self.projectId) {
                [dict setObject:self.projectId forKey:@"id"];
            }
            if (self.selectNode.data_id) {
                [dict setObject:self.selectNode.data_id forKey:@"taskId"];
            }
            [dict setObject:@1 forKey:@"typeStatus"];
            [dict setObject:@0 forKey:@"all"];
            [[TFRequest sharedManager] requestGET:[NSString stringWithFormat:@"%@%@%@",[AppDelegate shareAppDelegate].baseUrl,[AppDelegate shareAppDelegate].serverAddress,@"/projectMemberController/queryTaskList"] parameters:dict progress:nil success:^(NSDictionary *response) {
                
                NSString *str = @"";
                NSDictionary *dd = response[kData];
                NSArray *arr = [dd valueForKey:@"dataList"];
                for (NSDictionary *dict in arr) {
                    str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[dict valueForKey:@"project_task_role"]]];
                }
                if (str.length) {
                    str = [str substringToIndex:str.length-1];
                }
                // 判断删除任务权限
                if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_3" role:str]) {
                    if (![[[self.selectNode.task_info valueForKey:@"complete_status"] description] isEqualToString:@"1"]) {
                        
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"删除任务后，所有子任务也将同时被删除。" preferredStyle:UIAlertControllerStyleAlert];
                        
                        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            
                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            [self.projectTaskBL requestDeleteTaskWithTaskId:self.selectNode.data_id];
                            
                        }]];
                        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            
                        }]];
                        
                        [self presentViewController:alert animated:YES completion:nil];
                    }else{
                        [MBProgressHUD showError:@"完成的任务不能删除" toView:self.view];
                    }
                }else{
                    [MBProgressHUD showError:@"无权限" toView:self.view];
                }
                
            } failure:^(NSError *error) {
                [MBProgressHUD showError:error.debugDescription toView:self.view];
            }];
            
        }else if ([self.selectNode.node_type isEqualToNumber:@3]){// 删除子任务
            
            // 获取任务的删除权限
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            if (self.projectId) {
                [dict setObject:self.projectId forKey:@"id"];
            }
            if (self.selectNode.data_id) {
                [dict setObject:self.selectNode.data_id forKey:@"taskId"];
            }
            [dict setObject:@1 forKey:@"typeStatus"];
            [dict setObject:@0 forKey:@"all"];
            [[TFRequest sharedManager] requestGET:[NSString stringWithFormat:@"%@%@%@",[AppDelegate shareAppDelegate].baseUrl,[AppDelegate shareAppDelegate].serverAddress,@"/projectMemberController/queryTaskList"] parameters:dict progress:nil success:^(NSDictionary *response) {
                
                NSString *str = @"";
                NSDictionary *dd = response[kData];
                NSArray *arr = [dd valueForKey:@"dataList"];
                for (NSDictionary *dict in arr) {
                    str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[dict valueForKey:@"project_task_role"]]];
                }
                if (str.length) {
                    str = [str substringToIndex:str.length-1];
                }
                // 判断编辑任务权限
                if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_10" role:str]) {
                    if (![[[self.selectNode.task_info valueForKey:@"complete_status"] description] isEqualToString:@"1"]) {
                        
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"是否确认删除此子任务" preferredStyle:UIAlertControllerStyleAlert];
                        
                        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            
                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            [self.projectTaskBL requestDeleteChildTaskWithTaskChildId:self.selectNode.data_id];
                            
                        }]];
                        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            
                        }]];
                        
                        [self presentViewController:alert animated:YES completion:nil];
                    }else{
                        [MBProgressHUD showError:@"完成的任务不能删除" toView:self.view];
                    }
                }else{
                    [MBProgressHUD showError:@"无权限" toView:self.view];
                }
                
            } failure:^(NSError *error) {
                [MBProgressHUD showError:error.debugDescription toView:self.view];
            }];
            
        }
    }
    if (index == 1) {// 编辑
        
        
        /** 节点类型 0:根节点，1:分类，2:主任务，3:子任务 */
        if ([self.selectNode.node_type isEqualToNumber:@1]) {// 编辑分类
            
            // 获取分类的编辑权限
            if ([HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"21"]) {//编辑分类
                
                [HQNotPassSubmitView submitPlaceholderStr:@"请输入" title:nil content:self.selectNode.node_name  maxCharNum:200 LeftTouched:^{
                    
                } onRightTouched:^(NSDictionary *dict) {
                    NSMutableDictionary *data = [NSMutableDictionary dictionary];
                    NSString *str = [dict valueForKey:@"text"];
                    if (str) {
                        [data setObject:str forKey:@"node_name"];
                    }
                    if (self.selectNode.node_code) {
                        [data setObject:self.selectNode.node_code forKey:@"node_code"];
                    }
                    if (self.selectNode.id) {
                        [data setObject:self.selectNode.id forKey:@"node_id"];
                    }
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [self.projectTaskBL requestUpdateNodeWithDict:data];
                    
                }];
            }else{
                [MBProgressHUD showError:@"无权限" toView:self.view];
            }
            
        }else if ([self.selectNode.node_type isEqualToNumber:@2]) {// 编辑主任务
            // 获取任务的编辑权限
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            if (self.projectId) {
                [dict setObject:self.projectId forKey:@"id"];
            }
            if (self.selectNode.data_id) {
                [dict setObject:self.selectNode.data_id forKey:@"taskId"];
            }
            [dict setObject:@1 forKey:@"typeStatus"];
            [dict setObject:@0 forKey:@"all"];
            // 获取任务角色
            [[TFRequest sharedManager] requestGET:[NSString stringWithFormat:@"%@%@%@",[AppDelegate shareAppDelegate].baseUrl,[AppDelegate shareAppDelegate].serverAddress,@"/projectMemberController/queryTaskList"] parameters:dict progress:nil success:^(NSDictionary *response) {
                
                NSString *str = @"";
                NSDictionary *dd = response[kData];
                NSArray *arr = [dd valueForKey:@"dataList"];
                for (NSDictionary *dict in arr) {
                    str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[dict valueForKey:@"project_task_role"]]];
                }
                if (str.length) {
                    str = [str substringToIndex:str.length-1];
                }
                // 判断编辑任务权限
                if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_1" role:str]) {
                    if (![[[self.selectNode.task_info valueForKey:@"complete_status"] description] isEqualToString:@"1"]) {
                        
                        NSMutableDictionary *para = [NSMutableDictionary dictionary];
                        if (self.selectNode.data_id) {
                            [para setObject:self.selectNode.data_id forKey:@"id"];
                        }
                        // 获取详情
                        [[TFRequest sharedManager] requestGET:[NSString stringWithFormat:@"%@%@%@",[AppDelegate shareAppDelegate].baseUrl,[AppDelegate shareAppDelegate].serverAddress,@"/projectTaskController/queryById"] parameters:para progress:nil success:^(NSDictionary *response) {
                            NSDictionary *dataDict = response[kData];
                            self.oldData = [dataDict valueForKey:@"customArr"];
                            self.data = [NSMutableDictionary dictionaryWithDictionary:self.oldData];
                            // 关联关系处理
                            NSArray *keys = [self.data allKeys];
                            for (NSString *key in keys) {
                                if ([key containsString:@"reference"]) {
                                    NSArray *values = [self.data valueForKey:key];
                                    if (!values || values.count == 0) {
                                        [self.data setObject:@"" forKey:key];
                                    }else if (values.count){
                                        NSDictionary *re = values.firstObject;
                                        if ([re valueForKey:@"id"]) {
                                            [self.data setObject:[re valueForKey:@"id"] forKey:key];
                                        }
                                    }
                                }
                            }
                            NSArray *arr = [self.data valueForKey:@"personnel_principal"];
                            if (arr && [arr isKindOfClass:[NSArray class]]) {
                                NSDictionary *peo = arr.firstObject;
                                if ([peo valueForKey:@"id"]) {
                                    [self.data setObject:[peo valueForKey:@"id"] forKey:@"personnel_principal"];
                                }else{
                                    [self.data setObject:@"" forKey:@"personnel_principal"];
                                }
                            }
                            [HQNotPassSubmitView submitPlaceholderStr:@"请输入" title:nil content:self.selectNode.task_name  maxCharNum:200 LeftTouched:^{
                                
                            } onRightTouched:^(NSDictionary *dict) {
                                NSMutableDictionary *data = [self editTask];
                                NSString *str = [dict valueForKey:@"text"];
                                [self.data setObject:str forKey:@"text_name"];
                                [data setObject:str forKey:@"taskName"];
                                [data setObject:self.data forKey:@"data"];
                                [data setObject:self.oldData forKey:@"oldData"];
                                
                                // 编辑任务
                                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                [self.projectTaskBL requestUpdateTaskWithDict:data];
                                
                            }];
                            
                        } failure:^(NSError *error) {
                            [MBProgressHUD showError:error.debugDescription toView:self.view];
                        }];
                    }else{
                        [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
                    }
                }else{
                    [MBProgressHUD showError:@"无权限" toView:self.view];
                }
                
            } failure:^(NSError *error) {
                [MBProgressHUD showError:error.debugDescription toView:self.view];
            }];
            
            
        }else if ([self.selectNode.node_type isEqualToNumber:@3]) {// 编辑子任务
            // 获取任务的编辑权限
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            if (self.projectId) {
                [dict setObject:self.projectId forKey:@"id"];
            }
            if (self.selectNode.data_id) {
                [dict setObject:self.selectNode.data_id forKey:@"taskId"];
            }
            [dict setObject:@1 forKey:@"typeStatus"];
            [dict setObject:@0 forKey:@"all"];
            // 获取任务的角色
            [[TFRequest sharedManager] requestGET:[NSString stringWithFormat:@"%@%@%@",[AppDelegate shareAppDelegate].baseUrl,[AppDelegate shareAppDelegate].serverAddress,@"/projectMemberController/queryTaskList"] parameters:dict progress:nil success:^(NSDictionary *response) {
                
                NSString *str = @"";
                NSDictionary *dd = response[kData];
                NSArray *arr = [dd valueForKey:@"dataList"];
                for (NSDictionary *dict in arr) {
                    str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[dict valueForKey:@"project_task_role"]]];
                }
                if (str.length) {
                    str = [str substringToIndex:str.length-1];
                }
                // 判断编辑任务权限
                if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_9" role:str]) {
                    if (![[[self.selectNode.task_info valueForKey:@"complete_status"] description] isEqualToString:@"1"]) {
                        
                        NSMutableDictionary *para = [NSMutableDictionary dictionary];
                        if (self.selectNode.data_id) {
                            [para setObject:self.selectNode.data_id forKey:@"id"];
                        }
                        // 获取详情
                        [[TFRequest sharedManager] requestGET:[NSString stringWithFormat:@"%@%@%@",[AppDelegate shareAppDelegate].baseUrl,[AppDelegate shareAppDelegate].serverAddress,@"/projectTaskController/querySubById"] parameters:para progress:nil success:^(NSDictionary *response) {
                            NSDictionary *dataDict = response[kData];
                            self.oldData = [dataDict valueForKey:@"customArr"];
                            self.data = [NSMutableDictionary dictionaryWithDictionary:self.oldData];
                            NSArray *arr = [self.data valueForKey:@"personnel_principal"];
                            if (arr && [arr isKindOfClass:[NSArray class]]) {
                                NSDictionary *peo = arr.firstObject;
                                if ([peo valueForKey:@"id"]) {
                                    [self.data setObject:[peo valueForKey:@"id"] forKey:@"personnel_principal"];
                                }else{
                                    [self.data setObject:@"" forKey:@"personnel_principal"];
                                }
                            }
                            [HQNotPassSubmitView submitPlaceholderStr:@"请输入" title:nil content:self.selectNode.task_name  maxCharNum:200 LeftTouched:^{
                                
                            } onRightTouched:^(NSDictionary *dict) {
                                NSMutableDictionary *data = [self editTask];
                                NSString *str = [dict valueForKey:@"text"];
                                [self.data setObject:str forKey:@"text_name"];
                                [data setObject:str forKey:@"taskName"];
                                [data setObject:self.data forKey:@"data"];
                                [data setObject:self.oldData forKey:@"oldData"];
                                
                                // 编辑子任务
                                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                [self.projectTaskBL requestUpdateSubTaskWithDict:data];
                                
                            }];
                            
                        } failure:^(NSError *error) {
                            [MBProgressHUD showError:error.debugDescription toView:self.view];
                        }];
                    }else{
                        [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
                    }
                }else{
                    [MBProgressHUD showError:@"无权限" toView:self.view];
                }
                
            } failure:^(NSError *error) {
                [MBProgressHUD showError:error.debugDescription toView:self.view];
            }];
            
        }
        
    }
    if (index == 2) {// 增加分类
        
        // 获取分类的新增权限
        if ([HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"20"]) {//新增分类
            
            CGPoint point = [self.handleView convertPoint:btn.center toView:KeyWindow];
            PopoverView *pop = [[PopoverView alloc] initWithPoint:CGPointMake(point.x+20, point.y + 20) titles:@[@"同级分类",@"下级分类"] images:nil];
            pop.selectRowAtIndex = ^(NSInteger index) {
                
                if (index == 0) {
                    self.isLow  = NO;
                }
                else {
                    self.isLow  = YES;
                }
                
                self.parentNode = [self findParentNodeWithAllNodel:self.projectNode selectNode:self.selectNode];
                
                [HQNotPassSubmitView submitPlaceholderStr:@"请输入分类名称" title:nil maxCharNum:200 LeftTouched:^{
                    
                } onRightTouched:^(NSDictionary *dict) {
                    
                    NSMutableDictionary *data = [NSMutableDictionary dictionary];
                    // parent_id
                    if (self.parentNode.id) {
                        [data setObject:self.parentNode.id forKey:@"parent_id"];
                    }
                    // node_type
                    [data setObject:@1 forKey:@"node_type"];
                    // project_id
                    [data setObject:self.projectId forKey:@"project_id"];
                    // node_level
                    if (self.parentNode.node_level) {
                        [data setObject:@([self.parentNode.node_level integerValue] + 1) forKey:@"node_level"];
                    }
                    // parent_node_code
                    if (self.parentNode.node_code) {
                        [data setObject:self.parentNode.node_code forKey:@"parent_node_code"];
                    }
                    // brother_node_id
                    NSString *str = @"";
                    for (TFProjectNodeModel *node in self.parentNode.child) {
                        if ([node.id isEqualToNumber:self.selectNode.id]) {
                            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",node.id]];
                            str = [str stringByAppendingString:[NSString stringWithFormat:@"-1,"]];
                        }else{
                            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",node.id]];
                        }
                    }
                    if (![str containsString:@"-1"]) {
                        str = [str stringByAppendingString:[NSString stringWithFormat:@"-1,"]];
                    }
                    if (str.length > 0) {
                        str = [str substringToIndex:str.length-1];
                    }
                    [data setObject:str forKey:@"brother_node_id"];
                    // node_name
                    if ([dict valueForKey:@"text"]) {
                        [data setObject:[dict valueForKey:@"text"] forKey:@"node_name"];
                    }
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [self.projectTaskBL requestAddNodeWithDict:data];
                    
                }];
            };
            [pop show];
        }else{
            [MBProgressHUD showError:@"无权限" toView:self.view];
        }
    }
    if (index == 3) {// 选中层级后增加任务
        
        // 获取任务的新增权限
        if ([HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"25"]) {//新增任务
            
            if ([self.selectNode.node_level isEqualToNumber:@1]) {// 第一级分类
                
                self.isLow = YES;
                self.parentNode = [self findParentNodeWithAllNodel:self.projectNode selectNode:self.selectNode];
                
                [HQNotPassSubmitView submitPlaceholderStr:@"请输入任务名称" title:nil maxCharNum:200 LeftTouched:^{
                    
                } onRightTouched:^(NSDictionary *dict) {
                    
                    NSMutableDictionary *task = [self taskHandle];
//                    NSMutableDictionary *custom = [self customHandle];
                    if ([dict valueForKey:@"text"]) {
                        [task setObject:[dict valueForKey:@"text"] forKey:@"taskName"];
//                        [custom setObject:[dict valueForKey:@"text"] forKey:@"text_name"];
                    }
//                    [task setObject:custom forKey:@"data"];
                    
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [self.projectTaskBL requestAddTaskWithDict:task];
                    
                }];
                
            }
            else{
                
                CGPoint point = [self.handleView convertPoint:btn.center toView:KeyWindow];
                PopoverView *pop = [[PopoverView alloc] initWithPoint:CGPointMake(point.x+20, point.y + 20) titles:@[@"同级任务",@"下级任务"] images:nil];
                pop.selectRowAtIndex = ^(NSInteger index) {
                    
                    if (index == 0) {
                        self.isLow  = NO;
                    }
                    else {
                        self.isLow  = YES;
                    }
                    
                    self.parentNode = [self findParentNodeWithAllNodel:self.projectNode selectNode:self.selectNode];
                    
                    [HQNotPassSubmitView submitPlaceholderStr:@"请输入任务名称" title:nil maxCharNum:200 LeftTouched:^{
                        
                    } onRightTouched:^(NSDictionary *dict) {
                        
                        NSMutableDictionary *task = [self taskHandle];
//                        NSMutableDictionary *custom = [self customHandle];
                        if ([dict valueForKey:@"text"]) {
                            [task setObject:[dict valueForKey:@"text"] forKey:@"taskName"];
//                            [custom setObject:[dict valueForKey:@"text"] forKey:@"text_name"];
                        }
//                        [task setObject:custom forKey:@"data"];
                        
                        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        [self.projectTaskBL requestAddTaskWithDict:task];
                        
                    }];
                    
                };
                [pop show];
            }
        }else{
            [MBProgressHUD showError:@"无权限" toView:self.view];
        }
        
    }
    if (index == 4 || index == 5) {// 同级任务和下级任务
        
        if (index == 4) {
            self.isLow = NO;
        }else{
            self.isLow = YES;
        }
        self.parentNode = [self findParentNodeWithAllNodel:self.projectNode selectNode:self.selectNode];
        
        if ([self.parentNode.node_type integerValue]<2) {// 上级为分类，那么新建的为主任务
            
            // 获取任务的新增权限
            if ([HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"25"]) {//新增任务
                [HQNotPassSubmitView submitPlaceholderStr:@"请输入任务名称" title:nil maxCharNum:200 LeftTouched:^{
                    
                } onRightTouched:^(NSDictionary *dict) {
                    
                    NSMutableDictionary *task = [self taskHandle];
//                    NSMutableDictionary *custom = [self customHandle];
                    if ([dict valueForKey:@"text"]) {
                        [task setObject:[dict valueForKey:@"text"] forKey:@"taskName"];
//                        [custom setObject:[dict valueForKey:@"text"] forKey:@"text_name"];
                    }
//                    [task setObject:custom forKey:@"data"];
                    
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [self.projectTaskBL requestAddTaskWithDict:task];
                    
                }];
                
            }else{
                [MBProgressHUD showError:@"无权限" toView:self.view];
            }
        }else{// 子任务
            // 获取子任务的新增权限
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            if (self.projectId) {
                [dict setObject:self.projectId forKey:@"id"];
            }
            if (self.selectNode.data_id) {
                [dict setObject:self.selectNode.data_id forKey:@"taskId"];
            }
            [dict setObject:@1 forKey:@"typeStatus"];
            [dict setObject:@0 forKey:@"all"];
            // 获取任务的角色
            [[TFRequest sharedManager] requestGET:[NSString stringWithFormat:@"%@%@%@",[AppDelegate shareAppDelegate].baseUrl,[AppDelegate shareAppDelegate].serverAddress,@"/projectMemberController/queryTaskList"] parameters:dict progress:nil success:^(NSDictionary *response) {
                
                NSString *str = @"";
                NSDictionary *dd = response[kData];
                NSArray *arr = [dd valueForKey:@"dataList"];
                for (NSDictionary *dict in arr) {
                    str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[dict valueForKey:@"project_task_role"]]];
                }
                if (str.length) {
                    str = [str substringToIndex:str.length-1];
                }
                // 判断子任务新增权限
                if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_8" role:str]) {
                    
                    [HQNotPassSubmitView submitPlaceholderStr:@"请输入任务名称" title:nil maxCharNum:200 LeftTouched:^{
                        
                    } onRightTouched:^(NSDictionary *dict) {
                        
                        NSMutableDictionary *task = [self taskHandle];
//                        NSMutableDictionary *custom = [self customHandle];
                        if ([dict valueForKey:@"text"]) {
                            [task setObject:[dict valueForKey:@"text"] forKey:@"taskName"];
//                            [custom setObject:[dict valueForKey:@"text"] forKey:@"text_name"];
                        }
//                        [task setObject:custom forKey:@"data"];
                        
                        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        [self.projectTaskBL requestAddSubTaskWithDict:task];
                        
                    }];
                    
                }else{
                    [MBProgressHUD showError:@"无权限" toView:self.view];
                }
                
            } failure:^(NSError *error) {
                [MBProgressHUD showError:error.debugDescription toView:self.view];
            }];
            
        }
    }
}

/** 编辑任务 */
-(NSMutableDictionary *)editTask{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.projectId forKey:@"projectId"];
    [dict setObject:[NSString stringWithFormat:@"project_custom_%@",self.projectId] forKey:@"bean"];
    if ([self.data valueForKey:@"check_status"]) {
        [dict setObject:[self.data valueForKey:@"check_status"] forKey:@"checkStatus"];
    }else{
        [dict setObject:@0 forKey:@"checkStatus"];
    }
    if ([self.data valueForKey:@"check_member"]) {
        [dict setObject:[self.data valueForKey:@"check_member"] forKey:@"checkMember"];
    }else{
        [dict setObject:@"" forKey:@"checkMember"];
    }
    if ([self.data valueForKey:@"associates_status"]) {
        [dict setObject:[self.data valueForKey:@"associates_status"] forKey:@"associatesStatus"];
    }else{
        [dict setObject:@0 forKey:@"associatesStatus"];
    }
    if ([self.data valueForKey:@"datetime_starttime"]) {
        [dict setObject:[self.data valueForKey:@"datetime_starttime"] forKey:@"startTime"];
    }else{
        [dict setObject:@0 forKey:@"startTime"];
    }
    if ([self.data valueForKey:@"datetime_deadline"]) {
        [dict setObject:[self.data valueForKey:@"datetime_deadline"] forKey:@"endTime"];
    }else{
        [dict setObject:@0 forKey:@"endTime"];
    }
    // nodeId
    if (self.selectNode.id) {
        [dict setObject:self.selectNode.id forKey:@"nodeId"];
    }
    
    if ([self.selectNode.node_type integerValue] == 2) {// 主任务
        if (self.selectNode.data_id) {
            [dict setObject:self.selectNode.data_id forKey:@"taskId"];
        }
    }else if ([self.selectNode.node_type integerValue] == 3) {// 子任务
        // id
        if (self.selectNode.data_id) {
            [dict setObject:self.selectNode.data_id forKey:@"id"];
        }
        // taskId
        if ([self.selectNode.task_info valueForKey:@"task_id"]) {
            [dict setObject:[self.selectNode.task_info valueForKey:@"task_id"] forKey:@"taskId"];
        }
    }
    return dict;
}


/** 自定义字段 */
-(NSMutableDictionary *)customHandle{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"" forKey:@"picklist_tag"];// 标签
    [dict setObject:@"" forKey:@"multitext_desc"];// 描述
    [dict setObject:@"" forKey:@"personnel_principal"];// 执行人
    [dict setObject:@"" forKey:@"picklist_priority"];// 优先级
    [dict setObject:@"" forKey:@"attachment_customnumber"];// 附件
    [dict setObject:@"" forKey:@"datetime_starttime"];// 开始时间
    [dict setObject:@"" forKey:@"datetime_deadline"];// 截止时间
    return dict;
}

/** 任务配置其他固定无值字段 */
-(NSMutableDictionary *)taskHandle{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.projectId forKey:@"projectId"];
    [dict setObject:[NSString stringWithFormat:@"project_custom_%@",self.projectId] forKey:@"bean"];
    if ([self.selectNode.node_type integerValue] == 2) {
        [dict setObject:@0 forKey:@"checkStatus"];
        [dict setObject:@"" forKey:@"checkMember"];
    }
    [dict setObject:@0 forKey:@"associatesStatus"];
    [dict setObject:@0 forKey:@"startTime"];
    [dict setObject:@0 forKey:@"endTime"];
    [dict setObject:@"" forKey:@"executorId"];
    [dict setObject:self.parentNode.id forKey:@"parentNodeId"];
    [dict setObject:self.parentNode.node_code forKey:@"parentNodeCode"];
    
    NSString *str = @"";
    for (TFProjectNodeModel *node in self.parentNode.child) {
        if ([node.id isEqualToNumber:self.selectNode.id]) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",node.id]];
            str = [str stringByAppendingString:[NSString stringWithFormat:@"-1,"]];
        }else{
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",node.id]];
        }
    }
    if (![str containsString:@"-1"]) {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"-1,"]];
    }
    if (str.length > 0) {
        str = [str substringToIndex:str.length-1];
    }
    [dict setObject:str forKey:@"brotherNodeId"];
    // 父任务ID
    if (self.parentNode.data_id) {
        [dict setObject:self.parentNode.data_id forKey:@"taskId"];
        if ([self.parentNode.node_type isEqualToNumber:@2]) {
            // 子任务
            [dict setObject:@1 forKey:@"parentTaskType"];
        }else if ([self.parentNode.node_type isEqualToNumber:@3]) {
            // 子任务
            [dict setObject:@2 forKey:@"parentTaskType"];
        }
    }
    return dict;
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
