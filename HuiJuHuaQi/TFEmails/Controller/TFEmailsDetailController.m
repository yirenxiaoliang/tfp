//
//  TFEmailsDetailController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/2/27.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFEmailsDetailController.h"
#import "TFEmailsBottomView.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

#import "TFEmailsDetailHeadCell.h"
#import "TFEmailsDetailWebViewCell.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

#import "TFMailBL.h"
#import "HQTFTwoLineCell.h"
#import "TFEmailsNewController.h"
#import "TFCustomerCommentController.h"
#import "TFCustomFlowController.h"
#import "TFSelectCalendarView.h"

#import "FDActionSheet.h"
#import "FileManager.h"
//#import "TFProjectFileDetailController.h"
#import "TFFileDetailController.h"
#import "TFFolderListModel.h"
#import "HQSelectTimeCell.h"
#import "HQHelpDetailCtrl.h"

#define deleteTag 13140 //删除
#define flowTag   13141 //查看流程
#define botherTag 13142 //

@interface TFEmailsDetailController ()<TFEmailsBottomViewDelegate,WKNavigationDelegate,WKUIDelegate,UITableViewDelegate,UITableViewDataSource,TFEmailsDetailHeadCellDelegate,TFEmailsDetailWebViewCellDelegate,HQBLDelegate,UIActionSheetDelegate>

@property (nonatomic, strong) UITableView *tableView;

//底部title数组
@property (nonatomic, strong) NSArray *labs;

//底部图标数组
@property (nonatomic, strong) NSArray *imgs;

@property (nonatomic, strong) WKWebView *webView;


//H5高度
@property (nonatomic, assign) float webViewHeight;

@property (nonatomic, strong) TFMailBL *mailBL;

@end

@implementation TFEmailsDetailController

//- (TFEmailReceiveListModel *)model {
//
//    if (!_model) {
//
//        _model = [[TFEmailReceiveListModel alloc] init];
//    }
//    return _model;
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(returnAction) image:@"返回灰" text:@"返回" textColor:kUIColorFromRGB(0x69696C)];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    
    self.mailBL = [TFMailBL build];
    self.mailBL.delegate = self;
    
    if (!self.model) {
        [self. mailBL getMailDetailWithData:self.emailId type:@1];
    }else{
        self.model.isHide = @1; //默认隐藏
        if ([self.boxId isEqualToNumber:@3] && [self.model.timer_status isEqualToString:@"0"]) {
            self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sendAction) image:@"邮件发送" highlightImage:@"邮件发送"];
        }
        [self.view addSubview:self.tableView];
        [self createBottomView];
    }
    
    //更改已读未读状态
    [self.mailBL requestMarkMailReadOrUnread:[NSString stringWithFormat:@"%@",self.emailId] status:@1];

}

#pragma mark 初始化底部操作按钮
- (void)initBottomButton {
    
    if ([self.boxId isEqualToNumber:@1]) { //收件箱
        
        self.labs = @[@"回复",@"转发",@"评论"];
        self.imgs = @[@"邮件回复",@"邮件转发",@"邮件评论"];
    }
    else if ([self.boxId isEqualToNumber:@2]) { //发件箱
        
        if ([self.model.approval_status isEqualToString:@"10"]) {  //没有审批
            
            self.labs = @[@"编辑",@"转发",@"评论"];
            self.imgs = @[@"邮件编辑",@"邮件转发",@"邮件评论"];
        }
        else {
            
            self.labs = @[@"编辑",@"转发",@"评论",@"更多"];
            self.imgs = @[@"邮件编辑",@"邮件转发",@"邮件评论",@"更多-9"];
        }
        
    }
    else if ([self.boxId isEqualToNumber:@3]) { //草稿箱
        //2 审批通过 3 审批驳回 4 已撤销 10 没有审批
        
        if ([self.model.timer_status isEqualToString:@"1"]) { //定时邮件
            
            self.labs = @[@"修改时间",@"评论",@"更多"];
            self.imgs = @[@"邮件定时灰",@"邮件评论",@"更多-9"];
        }
        else { //非定时邮件
            
            if ([self.model.approval_status isEqualToString:@"3"]) { //驳回
                
                self.labs = @[@"编辑",@"评论",@"更多"];
                self.imgs = @[@"编辑",@"邮件评论",@"更多-9"];
            }
            else {
                
                self.labs = @[@"评论",@"更多"];
                self.imgs = @[@"邮件评论",@"更多-9"];
            }
            
        }
        
        
    }
    else if ([self.boxId isEqualToNumber:@4]) { //已删除
        
        self.labs = @[@"回复",@"转发",@"评论",@"更多"];
        self.imgs = @[@"邮件回复",@"邮件转发",@"邮件评论",@"更多-9"];
    }
    else if ([self.boxId isEqualToNumber:@5]) { //垃圾箱
        
        self.labs = @[@"不是垃圾邮件",@"评论",@"更多"];
        self.imgs = @[@"邮件未读",@"邮件评论",@"更多-9"];
    }
    else if ([self.boxId isEqualToNumber:@10]) {//小助手进来
        
        self.labs = @[@"评论"];
        self.imgs = @[@"邮件评论"];
    }
}

#pragma mark 创建底部视图
- (void)createBottomView {
    
    //初始化底部操作按钮
    [self initBottomButton];
    
    TFEmailsBottomView *emailsBottomView = [[TFEmailsBottomView alloc] initWithBottomViewFrame:CGRectMake(0, SCREEN_HEIGHT-NaviHeight-BottomHeight, SCREEN_WIDTH, TabBarHeight) labs:self.labs image:self.imgs];
    
    emailsBottomView.backgroundColor = kUIColorFromRGB(0xEFEFF4);
    emailsBottomView.delegate = self;
    
    [self.view addSubview:emailsBottomView];
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-BottomHeight) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 2) {
        if (self.model.attachments_name.count == 0) {
            return 0;
        }else{
            if ([self.model.showFile isEqualToNumber:@1]) {
                
                return self.model.attachments_name.count + 1;
            }else{
                
                return 1;
            }
        }
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        TFEmailsDetailHeadCell *cell = [TFEmailsDetailHeadCell emailsDetailHeadCellWithTableView:tableView];
        
        cell.delegate = self;
        
//        model.isHide = @0;
        
        cell.layer.masksToBounds = NO;
        
        [cell refreshEmailHeadViewWithModel:self.model];
        cell.bottomLine.hidden = NO;
        cell.headMargin = 0;
        return cell;
    }
    else if (indexPath.section == 1) { //定时邮件
    
        HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
        
        cell.type = TwoLineCellTypeOne;
        [cell.titleImage setImage:IMG(@"邮件定时红") forState:UIControlStateNormal];
        cell.topLabel.text = [NSString stringWithFormat:@"定时邮件:将在%@发出",[HQHelper nsdateToTime:[self.model.timer_task_time longLongValue] formatStr:@"yyyy-MM-dd HH:mm"]];
        cell.topLabel.textColor = kUIColorFromRGB(0x4A4A4A);
        cell.topLabel.font = FONT(14);
        
        cell.backgroundColor = kUIColorFromRGB(0xEBEDF0);
        
        cell.headMargin = 0;
        return cell;
    }
    else if (indexPath.section == 3) {
    
        TFEmailsDetailWebViewCell *cell = [TFEmailsDetailWebViewCell emailsDetailWebViewCellWithTableView:tableView from:1];
        
        cell.delegate = self;
        cell.type = @1;
        
        cell.mailContent = self.model.mail_content;
        
        return cell;
    }
    else {
        
        if (indexPath.row == 0) {
            
            HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
//            cell.topLabel.text = [NSString stringWithFormat:@"(%ld)",self.model.attachments_name.count];
            [cell.titleImage setImage:IMG(@"邮件附件") forState:UIControlStateNormal];
            [cell.titleImage setTitle:[NSString stringWithFormat:@" %ld",self.model.attachments_name.count] forState:UIControlStateNormal];
            [cell.titleImage setTitleColor:BlackTextColor forState:UIControlStateNormal];
            [cell.enterImage setImage:IMG(@"下一级浅灰") forState:UIControlStateNormal];
            cell.enterImage.hidden = NO;
            if ([self.model.showFile isEqualToNumber:@1]) {
                cell.enterImage.transform = CGAffineTransformMakeRotation(M_PI_2);
                cell.bottomLine.hidden = YES;
            }else{
                cell.bottomLine.hidden = NO;
                cell.enterImage.transform = CGAffineTransformIdentity;
            }
            cell.type = TwoLineCellTypeOne;
            cell.topLabel.hidden = YES;
            cell.topLine.hidden = YES;
            cell.headMargin = 0;
            cell.titleImageWidth = 40.0;
            cell.enterImgTrailW.constant = -15;
            return cell;
            
        }
    
        TFFileModel *attModel = self.model.attachments_name[indexPath.row-1];
        
        HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
        
        cell.type = TwoLineCellTypeTwo;
        cell.titleImageWidth = 40.0;
        cell.topLabel.hidden = NO;
        [cell.titleImage setTitle:nil forState:UIControlStateNormal];
        
        [cell refreshCellWithAddNoteAttachFileModel:attModel];
        if (indexPath.row == self.model.attachments_name.count) {
            cell.headMargin = 0;
        }else{
            cell.headMargin = 15;
        }
        
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.section == 2) { //附件预览
        
        
        if (indexPath.row == 0) {
            
            self.model.showFile = [self.model.showFile isEqualToNumber:@1] ? @0 : @1;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
            //            [self.tableView reloadData];
            return;
        }
        
        
        TFFileModel *attachmentsModel = self.model.attachments_name[indexPath.row-1];
        
//        if ([model.file_type isEqualToString:@"mp4"]) {
//
//            [self playAction:model.file_url];
//        }
//        else {
        
            
//            TFProjectFileDetailController *detailVC = [[TFProjectFileDetailController alloc] init];
//
//            TFProjectFileModel *fileModel = [[TFProjectFileModel alloc] init];
//
//            fileModel.file_name = model.file_name;
//            fileModel.size = model.file_size;
//            fileModel.suffix = model.file_type;
//            fileModel.url = model.file_url;
//
//            detailVC.fileModel = fileModel;
//            detailVC.whereFrom = 2;
//            [self.navigationController pushViewController:detailVC animated:YES];
        TFFileDetailController *detailVC = [[TFFileDetailController alloc] init];
        
        TFFolderListModel *fileModel = [[TFFolderListModel alloc] init];

        fileModel.name = attachmentsModel.file_name;
        fileModel.size = attachmentsModel.file_size;
        fileModel.siffix = attachmentsModel.file_type;
        fileModel.url = attachmentsModel.file_url;
        
        fileModel.siffix = [fileModel.siffix stringByReplacingOccurrencesOfString:@"." withString:@""];
        if ([fileModel.siffix isEqualToString:@"jpg"] || [fileModel.siffix isEqualToString:@"jpeg"] || [fileModel.siffix isEqualToString:@"png"] || [fileModel.siffix isEqualToString:@"gif"]) {
            
            detailVC.isImg = 1;
        }
        
        detailVC.whereFrom = 2;
        detailVC.naviTitle = fileModel.name;
        detailVC.basics = fileModel;
        detailVC.fileUrl = attachmentsModel.file_url;
        [self.navigationController pushViewController:detailVC animated:YES];
//        }

    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        return [TFEmailsDetailHeadCell refreshEmailsDetailHeadHeightWithModel:self.model];
    }
    else if (indexPath.section == 1) {
    
        if ([self.model.timer_status isEqualToString:@"1"]) {
            
            return 40;
        }
        else {
        
            return 0;
        }
    }
    else if (indexPath.section == 3) {
    
        return self.webViewHeight;
        
    }
    else {
    
        return 55;
    }
    
    
}

#pragma mark 其他方法
- (void)returnAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 播放视频类型附件
- (void)playAction:(NSString *)url {
    
    [MBProgressHUD showHUDAddedTo:KeyWindow animated:YES];
    NSString *fileName = [NSString stringWithFormat:@"%@.mp4",[HQHelper stringForMD5WithString:url]];
    [HQHelper cacheFileWithUrl:url fileName:fileName completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        [MBProgressHUD hideHUDForView:KeyWindow animated:YES];
        if (error == nil) {
            
            
            // 保存文件
            NSString *filePath = [HQHelper saveCacheFileWithFileName:fileName data:data];
            
            if (filePath) {// 写入成功
                
                AVPlayer *player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:filePath]];
                //2、创建视频播放视图的控制器
                AVPlayerViewController *playerVC = [[AVPlayerViewController alloc]init];
                //3、将创建的AVPlayer赋值给控制器自带的player
                playerVC.player = player;
                //4、跳转到控制器播放
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:playerVC animated:YES completion:nil];
                [playerVC.player play];
                
                
            }
        }else{
            [MBProgressHUD showError:@"读取文件失败" toView:self.view];
        }
        
    } fileHandler:^(NSString *filePath) {
        [MBProgressHUD hideHUDForView:KeyWindow animated:YES];
        
        AVPlayer *player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:filePath]];
        //2、创建视频播放视图的控制器
        AVPlayerViewController *playerVC = [[AVPlayerViewController alloc]init];
        //3、将创建的AVPlayer赋值给控制器自带的player
        playerVC.player = player;
        //4、跳转到控制器播放
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:playerVC animated:YES completion:nil];
        [playerVC.player play];
        
    }];
    
}

#pragma mark TFEmailsDetailWebViewCellDelegate（网页高度）
- (void)getWebViewHeight:(CGFloat)height {

    self.webViewHeight = height;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)jumpUrl:(NSString *)url{
    HQHelpDetailCtrl *head = [[HQHelpDetailCtrl alloc] init];
    head.titleName = @"";
    head.htmlUrl = url;
    [self.navigationController pushViewController:head animated:YES];
}

#pragma mark TFEmailsDetailHeadCellDelegate
- (void)hideEmailDetailHeadInfo {


    if ([self.model.isHide isEqualToNumber:@1]) {
        
        self.model.isHide = @0;
    }
    else {
    
        self.model.isHide = @1;
    }
    
    //一个cell刷新
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];  //你需要更新的组数中的cell
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

#pragma mark TFEmailsBottomViewDelegate （底部操作按钮）
- (void)emailBottomButtonClicked:(NSInteger)buttonIndex {

    switch ([self.boxId integerValue]) {
        case 1: //收件箱
        {
        
            if (buttonIndex == 0) { //回复
                
                TFEmailsNewController *replayEmailVC = [[TFEmailsNewController alloc] init];
                
                replayEmailVC.detailModel = self.model;
                replayEmailVC.type = 1;
                
                [self.navigationController pushViewController:replayEmailVC animated:YES];
            }
            else if (buttonIndex == 1) { //转发
                
                TFEmailsNewController *replayEmailVC = [[TFEmailsNewController alloc] init];
                
                replayEmailVC.detailModel = self.model;
                replayEmailVC.type = 2;
                
                [self.navigationController pushViewController:replayEmailVC animated:YES];
            }
            else if (buttonIndex == 2) { //评论
                
                TFCustomerCommentController *comment = [[TFCustomerCommentController alloc] init];
                
                comment.id = self.model.id;
                comment.bean = @"email";
                
                [self.navigationController pushViewController:comment animated:YES];
            }
        }
            break;
        case 2: //发件箱
        {
            if (buttonIndex == 0) { //再次编辑
                
                TFEmailsNewController *replayEmailVC = [[TFEmailsNewController alloc] init];
                
                replayEmailVC.detailModel = self.model;
                replayEmailVC.type = 4;
                
                [self.navigationController pushViewController:replayEmailVC animated:YES];
            }
            else if (buttonIndex == 1) { //转发
                
                TFEmailsNewController *replayEmailVC = [[TFEmailsNewController alloc] init];
                
                replayEmailVC.detailModel = self.model;
                replayEmailVC.type = 2;
                
                [self.navigationController pushViewController:replayEmailVC animated:YES];
            }
            else if (buttonIndex == 2) { //评论
                
                TFCustomerCommentController *comment = [[TFCustomerCommentController alloc] init];
                
                comment.id = self.model.id;
                comment.bean = @"email";

                [self.navigationController pushViewController:comment animated:YES];
            }
            else if (buttonIndex == 3) { //更多
            
//                FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"更多操作" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看流程", nil];
//
//                sheet.tag = flowTag;
//
//                [sheet show];
                
                
                UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"更多操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"查看流程", nil];
                sheet.tag = flowTag;
                [sheet showInView:self.view];
            }
            
        }
            break;
        case 3: //草稿箱
        {
            
            
            NSInteger index;
            
            if ([self.model.timer_status isEqualToString:@"1"]) { //定时邮件
                
                index = buttonIndex;
            }
            else {
            
                if ([self.model.approval_status isEqualToString:@"3"]) { //驳回
                    
                    index = buttonIndex;
                }
                else {
                    
                    index = buttonIndex+1;
                }
                
            }
            
            if (index == 0) { //修改时间
                
                if ([self.model.timer_status isEqualToString:@"1"]) { //定时邮件
                    
                    long long timeSp = [self.model.timer_task_time longLongValue];
                    
                    [TFSelectCalendarView selectCalendarViewWithType:DateViewType_HourMinute timeSp:timeSp<=0?[HQHelper getNowTimeSp]:timeSp onRightTouched:^(NSString *time) {
                        
                        long long selectSp = [HQHelper changeTimeToTimeSp:time formatStr:@"yyyy-MM-dd HH:mm"];
                        self.model.timer_task_time = @(selectSp);
                        
                        //邮件编辑保存
                        [self saveEditedMail];
                    }];
                }
                else { //被驳回邮件再次编辑
                    
                    TFEmailsNewController *replayEmailVC = [[TFEmailsNewController alloc] init];
                    
                    replayEmailVC.detailModel = self.model;
                    replayEmailVC.type = 4;
                    
                    [self.navigationController pushViewController:replayEmailVC animated:YES];
                }
                
            }
            else if (index == 1) { //评论
                
                TFCustomerCommentController *comment = [[TFCustomerCommentController alloc] init];
                
                comment.id = self.model.id;
                comment.bean = @"email";
                
                [self.navigationController pushViewController:comment animated:YES];
            }
            else if (index == 2) { //更多
                
//                FDActionSheet *sheet;
//                if ([self.model.approval_status isEqualToString:@"10"]) { //没有审批
//
//                    sheet = [[FDActionSheet alloc] initWithTitle:@"更多操作" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"彻底删除", nil];
//                }
//                else {
//
//                    sheet = [[FDActionSheet alloc] initWithTitle:@"更多操作" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看流程",@"彻底删除", nil];
//                }
//
//                sheet.tag = botherTag;
//                [sheet show];
                
                UIActionSheet *sheet;
                if ([self.model.approval_status isEqualToString:@"10"]) { //没有审批
                    
                    sheet = [[UIActionSheet alloc] initWithTitle:@"更多操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"彻底删除", nil];
                }
                else {
                    
                    sheet = [[UIActionSheet alloc] initWithTitle:@"更多操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"查看流程",@"彻底删除", nil];
                }
                
                sheet.tag = flowTag;
                [sheet showInView:self.view];
                
            }

            
            
        }
            break;
        case 4: //已删除
        {
            
            if (buttonIndex == 0) { //回复
                
                TFEmailsNewController *replayEmailVC = [[TFEmailsNewController alloc] init];
                
                replayEmailVC.detailModel = self.model;
                replayEmailVC.type = 1;
                
                [self.navigationController pushViewController:replayEmailVC animated:YES];
            }
            else if (buttonIndex == 1) { // 转发
                
                TFEmailsNewController *replayEmailVC = [[TFEmailsNewController alloc] init];
                
                replayEmailVC.detailModel = self.model;
                replayEmailVC.type = 2;
                
                [self.navigationController pushViewController:replayEmailVC animated:YES];
            }
            else if (buttonIndex == 2) { //评论
                
                TFCustomerCommentController *comment = [[TFCustomerCommentController alloc] init];
                
                comment.id = self.model.id;
                comment.bean = @"email";
                
                [self.navigationController pushViewController:comment animated:YES];
            }
            else if (buttonIndex == 3) { //
                
//                FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"更多操作" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"彻底删除", nil];
//                sheet.tag = deleteTag;
//
//                [sheet show];
                
               UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"更多操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"彻底删除", nil];
                sheet.tag = deleteTag;
                [sheet showInView:self.view];
            }
        }
            break;
        case 5: //垃圾箱
        {
            if (buttonIndex == 0) { //不是垃圾邮件
                
                [self.mailBL requestMarkMailNotTrash:[NSString stringWithFormat:@"%@",self.model.id]];
            }
            else if (buttonIndex == 1) { //评论
                
                TFCustomerCommentController *comment = [[TFCustomerCommentController alloc] init];
                
                comment.id = self.model.id;
                comment.bean = @"email";
                
                [self.navigationController pushViewController:comment animated:YES];
            }
            else if (buttonIndex == 2) { //更多
                
                
//                FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"更多操作" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"彻底删除", nil];
//                sheet.tag = deleteTag;
//
//                [sheet show];
                
                UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"更多操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"彻底删除", nil];
                sheet.tag = deleteTag;
                [sheet showInView:self.view];
            }

            
        }
            break;
            
        case 10:
        {
        
            if (buttonIndex == 0) {
                
                TFCustomerCommentController *comment = [[TFCustomerCommentController alloc] init];
                
                comment.id = self.model.id;
                comment.bean = @"email";
                
                [self.navigationController pushViewController:comment animated:YES];
            }
            
        }
            break;
            
        default:
            break;
    }

}

#pragma mark FDActionSheetDelegate（更多操作）
//- (void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex {
-(void)actionSheet:(UIActionSheet *)sheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (sheet.tag == deleteTag) {
        
        [self.mailBL requesMailOperationClearMailWithData:[NSString stringWithFormat:@"%@",self.model.id]];
    }
    if (sheet.tag == flowTag) {
        
        if ([self.model.approval_status isEqualToString:@"10"]) {
            
            [MBProgressHUD showError:@"未开启流程" toView:self.view];
        }

        else {
        
            TFCustomFlowController *flow = [[TFCustomFlowController alloc] init];
            
            flow.bean = @"mail_box_scope";
            flow.dataId = self.model.id;
            flow.processInstanceId = self.model.process_instance_id;
            [self.navigationController pushViewController:flow animated:YES];
        }
    }
    if (sheet.tag == botherTag) {
        
        if ([self.model.approval_status isEqualToString:@"10"]) {
            
            [self.mailBL requesMailOperationClearMailWithData:[NSString stringWithFormat:@"%@",self.model.id]];
        }
        else {
        
            if (buttonIndex == 0) {
                
                TFCustomFlowController *flow = [[TFCustomFlowController alloc] init];
                
                flow.bean = @"mail_box_scope";
                flow.dataId = self.model.id;
                flow.processInstanceId = self.model.process_instance_id;
                [self.navigationController pushViewController:flow animated:YES];
            }
            else if (buttonIndex == 1) {
                
                [self.mailBL requesMailOperationClearMailWithData:[NSString stringWithFormat:@"%@",self.model.id]];
            }
        }

    }
}

#pragma mark --- 发送
- (void)sendAction {
    
            
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self.mailBL manualSendMailWithData:[self.model.id stringValue]];//发送
    
}
#pragma mark --- 邮件编辑保存
- (void)saveEditedMail {
    
    TFEmailReceiveListModel *editModel = [[TFEmailReceiveListModel alloc] init];
    
    editModel.account_id = self.model.account_id;
    editModel.attachments_name = self.model.attachments_name;
    editModel.bcc_recipients = self.model.bcc_recipients;
    editModel.bcc_setting = self.model.bcc_setting;
    editModel.cc_setting = self.model.cc_setting;
    editModel.cc_recipients = self.model.cc_recipients;
    editModel.from_recipient = self.model.from_recipient;
    editModel.id = self.model.id;
    editModel.is_emergent = self.model.is_emergent;
    editModel.is_encryption = self.model.is_encryption;
    editModel.is_notification = self.model.is_notification;
    editModel.is_plain = self.model.is_plain;
    editModel.is_signature = self.model.is_signature;
    editModel.is_track = self.model.is_track;
    editModel.mail_content = self.model.mail_content;
    editModel.mail_source = self.model.mail_source;
    editModel.personnel_approverBy = self.model.personnel_approverBy;
    editModel.personnel_ccTo = self.model.personnel_ccTo;
    editModel.signature_id = self.model.signature_id;
    editModel.single_show = self.model.single_show;
    editModel.subject = self.model.subject;
    editModel.timer_task_time = self.model.timer_task_time;
    editModel.to_recipients = self.model.to_recipients;
    
    [self.mailBL requesMailOperationEditDraftWithData:editModel];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_mailOperationQueryById) {
        
        self.model = resp.body;
        self.model.isHide = @1; //默认隐藏
        self.model.read_status = @"1";
        
        if ([self.boxId isEqualToNumber:@3] && [self.model.timer_status isEqualToString:@"0"]) {
            
            self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sendAction) image:@"邮件发送" highlightImage:@"邮件发送"];
        }
        
        [self.view addSubview:self.tableView];
        
        [self createBottomView];
        
//        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_markMailReadOrUnread) {
        
        self.model.read_status = @"1";
        
        if (self.refresh) {
            
            self.refresh();
        }
    }
    if (resp.cmdId == HQCMD_mailOperationClearMail) {
        
        [MBProgressHUD showError:@"删除成功" toView:self.view];
        if (self.refresh) {
            
            self.refresh();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (resp.cmdId == HQCMD_mailOperationMarkNotTrash) { //不是垃圾邮件
        
        if (self.refresh) {
            
            self.refresh();
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (resp.cmdId == HQCMD_mailOperationSend) { //发送
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [MBProgressHUD showError:@"发送成功" toView:self.view];
        
        if (self.refresh) {
            
            self.refresh();
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
    if (resp.cmdId == HQCMD_mailOperationManualSend) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [MBProgressHUD showError:@"发送成功" toView:self.view];
        
        if (self.refresh) {
            
            self.refresh();
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (resp.cmdId == HQCMD_mailOperationEditDraft) { //编辑草稿
        
        [MBProgressHUD showError:@"修改成功" toView:self.view];
        
        [self.tableView reloadData];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}

@end
