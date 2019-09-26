//
//  TFPlayVoiceController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/6/7.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFPlayVoiceController.h"
#import "HQTFTwoLineCell.h"
#import "TFAudioCell.h"


@interface TFPlayVoiceController ()<UITableViewDelegate,UITableViewDataSource,TFAudioCellDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

@end

@implementation TFPlayVoiceController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.audioPlayer stop];
    self.audioPlayer = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    self.navigationItem.title = @"这是一段语音";
}

#pragma mark - TFAudioCellDelegate
-(void)audioCell:(TFAudioCell *)audioCell withPlayer:(AVAudioPlayer *)player{
    
    self.audioPlayer = player;
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
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
        cell.type = TwoLineCellTypeOne;
        [cell.titleImage sd_setImageWithURL:[HQHelper URLWithString:self.file.photograph] forState:UIControlStateNormal placeholderImage:PlaceholderHeadImage];
        cell.topLabel.text = [NSString stringWithFormat:@"%@ %@",self.file.employeeName,[HQHelper nsdateToTimeNowYear:[self.file.createTime longLongValue]]];
        
        return cell;
    }else{
        TFAudioCell *cell = [TFAudioCell audioCellWithTableView:tableView];
        HQAudioModel *model = [[HQAudioModel alloc] init];
        model.voiceUrl = self.file.file_url;
//        model.voiceDuration = self.file.voiceDuration;
        cell.bottomLine.hidden = YES;
        [cell refreshAudioCellWithAudioModel:model withType:1];
        cell.delegate =self;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        if (self.isEmployee) {
            return 60;
        }
        return 0;
    }else{
        return 230;
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
