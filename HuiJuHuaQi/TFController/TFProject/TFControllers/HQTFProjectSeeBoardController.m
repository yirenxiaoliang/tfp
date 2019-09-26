
//
//  HQTFProjectSeeBoardController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/23.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFProjectSeeBoardController.h"
#import "HQTFProjectCollectionView.h"
#import "HQTFProjectLayout.h"
#import "HQTFCreatRowCollectionViewCell.h"
#import "IQKeyboardManager.h"
#import "HQTFProjectCollectionViewCell.h"
#import "FDActionSheet.h"
#import "HQTFProjectPeopleManageController.h"
#import "HQTFProjectFileController.h"
#import "HQTFLabelManageController.h"
#import "HQTFRecordController.h"
#import "AlertView.h"
#import "HQTFCreatProjectController.h"
#import "HQTFCreatTaskController.h"
#import "HQTFTaskOptionController.h"
#import "HQTFTaskMainController.h"
#import "TFProjTaskModel.h"
#import "TFProjLabelModel.h"
#import "TFProjectBL.h"
#import "TFProjectSeeModel.h"
#import "TFApprovalDetailMainController.h"

#define CellHeight (SCREEN_HEIGHT - 64)

@interface HQTFProjectSeeBoardController ()<UICollectionViewDelegate,UICollectionViewDataSource,FDActionSheetDelegate,HQTFProjectCollectionViewCellDelegate,HQTFProjectCollectionViewDelegate,HQBLDelegate,HQTFCreatRowCollectionViewCellDelegate>

/** collectionView */
@property (nonatomic, strong) HQTFProjectCollectionView *collectionView;
/** 当前偏移量 */
@property (nonatomic, assign) CGFloat currentOffset;
/** 当前页码 */
@property (nonatomic, assign) NSInteger currentPage;
/** 看板列表 */
@property (nonatomic,strong) NSMutableArray *seeBoards;

/** drag */
@property (nonatomic, assign) BOOL drag;

/** creatTask */
@property (nonatomic, strong) UIButton *creatTask;

/** projectBL */
@property (nonatomic, strong) TFProjectBL *projectBL;

/** permission 0:无管理公开项目权限 1：不公开 */
@property (nonatomic, assign) BOOL manageOpenPermission;

@end

@implementation HQTFProjectSeeBoardController

-(NSMutableArray *)seeBoards{
    
    if (!_seeBoards) {
        _seeBoards = [NSMutableArray array];
        
//        for (NSInteger q = 0; q < 6; q ++) {
//            NSMutableArray *arr = [NSMutableArray array];
//            for (NSInteger i = 0; i < 6; i ++) {
//                
//                
//                TFProjTaskModel *model = [[TFProjTaskModel alloc] init];
//                model.creatorId = @(1111+i);
//                model.deley = @(i % 2);
//                model.activateNum = @(i);
//                model.content = [NSString stringWithFormat:@"%@--%ld",@"我是项目任务是项目任务的是项目任务的是项目任务的的标题",i];
//                model.priority = @(i % 3);
//                model.deadline = @([HQHelper getNowTimeSp] + 1000 * 3 * 24 * 60 * 60);
//                model.desc = [NSString stringWithFormat:@"我是项目任务的描述类容呀，请多多关注。"];
//                model.lastUpdateTime = @([HQHelper getNowTimeSp] + 1000 * 2 * 24 * 60 * 60);
//                model.finishTime = @([HQHelper getNowTimeSp] + 1000 * 1 * 24 * 60 * 60);
//                model.companyId = @(2222+i);
//                model.isPublic = @(i % 2);
//                model.isFinish = @(i % 2);
//                model.numberType = @(i % 2);
//                model.numberSum = @"10000000000";
//                model.numberUnit = @"元";
//                model.relatedItemCount = @12;
//                model.childItemCount = @99;
//                model.childItemFinished = @88;
//                model.relatedFileCount = @2;
//                model.isRepeat = @(i % 2);
//                model.relatedAttendanceId = @(111222 + i);
//                model.relatedVoteId = @(333444 + i);
//                model.taskListId = @112233;
//                model.projectId = @11223344;
//                model.excutorSum = @(i + 1);
//                model.isLockTime = @(i % 2);
//                model.isOrderTask = @(i);
//                
//                NSMutableArray *parts = [NSMutableArray array];
//                for (NSInteger j = 4-i; j <= 4; j ++) {
//                    TFProjParticipantModel *part = [[TFProjParticipantModel alloc] init];
//                    [parts addObject:part];
//                }
//                model.participant = parts;
//                
//                NSMutableArray *labels = [NSMutableArray array];
//                for (NSInteger j = i; j < 3; j ++) {
//                    TFProjLabelModel *mo = [[TFProjLabelModel alloc] init];
//                    if (i == 0) {
//                        mo.labelName = @"我是个镖旗";
//                    }else if (i == 1) {
//                        
//                        mo.labelName = @"我是个";
//                    }else{
//                        mo.labelName = @"我";
//                    }
//                    mo.labelColor = [NSString stringWithFormat:@"#ff0000"];
//                    [labels addObject:mo];
//                }
//                model.labels = labels;
//                [arr addObject:model];
//            }
//            [_seeBoards addObject:arr];
//        }
    }
    return _seeBoards;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.collectionView reloadData];
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        
        [self.navigationController.navigationBar setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:(CGSize){SCREEN_WIDTH,0.5}] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[HQHelper createImageWithColor:[UIColor clearColor] size:(CGSize){SCREEN_WIDTH,0.5}]];
        
        [self.navigationController.navigationBar setTranslucent:YES];
        [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                          NSForegroundColorAttributeName:WhiteColor,
                                                                          NSFontAttributeName:FONT(20)}];
    }
    
    
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(back) image:@"返回白色" highlightImage:@"返回白色"];
    
    IQKeyboardManager *keyboard = [IQKeyboardManager sharedManager];
    keyboard.enable = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        
        [self.navigationController.navigationBar setBackgroundImage:[HQHelper createImageWithColor:WhiteColor] forBarMetrics:UIBarMetricsDefault];
        
        [self.navigationController.navigationBar setShadowImage:[HQHelper createImageWithColor:HexColor(0xc8c8c8, 1) size:(CGSize){SCREEN_WIDTH,0.5}]];
        [self.navigationController.navigationBar setTranslucent:NO];
        [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                          NSForegroundColorAttributeName:BlackTextColor,
                                                                          NSFontAttributeName:FONT(20)}];
    }
    
    IQKeyboardManager *keyboard = [IQKeyboardManager sharedManager];
    keyboard.enable = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigation];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"背景"]];
    [self setupCollectionView];
    //[self setupCreatTask];
    
    self.projectBL = [TFProjectBL build];
    self.projectBL.delegate = self;
    
    [self.projectBL getPermissionWithModuleId:@1110];
    [self.projectBL requestGetProjTaskListPreviewWithProjectId:self.projectItem.id];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteProjectTask:) name:DeleteProjetTaskNotifition object:nil];
}

- (void)deleteProjectTask:(NSNotification *)note{
    
    NSNumber *taskId = note.object;
    
    for (TFProjectSeeModel *pro in self.seeBoards) {
        
        NSArray *projTaskLists = pro.tasks;
        
        for (NSInteger i = 0; i < projTaskLists.count; i++) {
            TFProjTaskModel *model = projTaskLists[i];
            if ([model.id isEqualToNumber:taskId]) {
                
                NSMutableArray<TFProjTaskModel,Optional> *li = [NSMutableArray<TFProjTaskModel,Optional> arrayWithArray:projTaskLists];
                [li removeObjectAtIndex:i];
                projTaskLists = li;
                [self.collectionView reloadData];
                return;
            }
        }

    }
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - creatTask
//- (void)setupCreatTask{
//    
//    UIButton *creatTask = [HQHelper buttonWithFrame:(CGRect){0,SCREEN_HEIGHT-55,SCREEN_WIDTH,55} target:self action:@selector(creatTaskClick)];
//    [self.view addSubview:creatTask];
//    [creatTask setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateHighlighted];
//    [creatTask setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
//    self.creatTask = creatTask;
//    if (self.type == ProjectSeeBoardTypeProject) {
//        
//        [creatTask setTitle:@"+ 新建任务" forState:UIControlStateNormal];
//        [creatTask setTitle:@"+ 新建任务" forState:UIControlStateHighlighted];
//    }else{
//        
//        [creatTask setTitle:@"+ 新建订单任务" forState:UIControlStateNormal];
//        [creatTask setTitle:@"+ 新建订单任务" forState:UIControlStateHighlighted];
//    }
//}
//
//- (void)creatTaskClick{
//    HQTFCreatTaskController *creatTask = [[HQTFCreatTaskController alloc] init];
//    creatTask.projectSeeModel = self.projectSeeModel;
//    [self.navigationController pushViewController:creatTask animated:YES];
//}

#pragma mark - navi
-(void)setupNavigation{
    
    self.navigationItem.title = self.projectItem.projectName;
    
    if (!self.projectItem.projectCollectId || [self.projectItem.projectCollectId integerValue] == 0) {
        
        UINavigationItem *item1 = [self itemWithTarget:self action:@selector(star) image:@"标星1" highlightImage:@"标星1"];
        UINavigationItem *item2 = [self itemWithTarget:nil action:nil image:@"" highlightImage:@""];
        UINavigationItem *item3 = [self itemWithTarget:self action:@selector(menu) image:@"菜单白色" highlightImage:@"菜单白色"];
        self.navigationItem.rightBarButtonItems = @[item3,item2,item1];
        
    }else{
        
        UINavigationItem *item1 = [self itemWithTarget:self action:@selector(star) image:@"标星2" highlightImage:@"标星2"];
        UINavigationItem *item2 = [self itemWithTarget:nil action:nil image:@"" highlightImage:@""];
        UINavigationItem *item3 = [self itemWithTarget:self action:@selector(menu) image:@"菜单白色" highlightImage:@"菜单白色"];
        self.navigationItem.rightBarButtonItems = @[item3,item2,item1];
    }
    
}

- (void)star{
    
    if ([self.projectItem.projectStatus isEqualToNumber:@2]) {
        [MBProgressHUD showError:@"项目已暂停，不可进行编辑操作" toView:KeyWindow];
        return;
    }
    
    if ([self.projectItem.projectStatus isEqualToNumber:@3]) {
        [MBProgressHUD showError:@"项目已删除，不可进行编辑操作" toView:KeyWindow];
        return;
    }
    if (!self.projectItem.projectCollectId || [self.projectItem.projectCollectId integerValue] == 0) {
        
        [self.projectBL requestAddProjectCollectWithProjectId:self.projectItem.id];
        
    }else{
        
        [self.projectBL requestDelProjectCollectWithProjectCollectId:self.projectItem.projectCollectId];
    }
    
//    HQTFCreatProjectModel *model = [HQTFCreatProjectModel changeProjectItemToCreatProjectModelWithProjectItem:self.projectItem];
//    model.isMark = ([self.projectItem.projectCollectId integerValue]==0 || !self.projectItem.projectCollectId)?1:0;
//    self.projectItem.projectCollectId = @(model.isMark);
//    
//    [self.projectBL requestUpdateProjectWithModel:model];
    
}

- (void)menu{
    
    FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"更多操作" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"项目设置",@"成员管理",@"标签管理",@"项目文库",@"活动记录",nil];
    
    sheet.tag = 100;
    //[sheet setButtonTitleColor:BlackTextColor bgColor:nil fontSize:FONT(16) atIndex:0];
    //[sheet setButtonTitleColor:BlackTextColor bgColor:nil fontSize:FONT(16) atIndex:1];
    //[sheet setCancelButtonTitleColor:BlackTextColor bgColor:CellClickColor fontSize:FONT(16)];
    [sheet show];
    
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex
{
    
    switch (buttonIndex) {
        case 0:
        {
            HQTFCreatProjectController *creat = [[HQTFCreatProjectController alloc] init];
            creat.type = CreatProjectControllerTypeEdit;
            creat.projectItem = self.projectItem;
            creat.creatProject = [HQTFCreatProjectModel changeProjectItemToCreatProjectModelWithProjectItem:self.projectItem];
            [self.navigationController pushViewController:creat animated:YES];
        }
            break;
        case 1:
        {
            HQTFProjectPeopleManageController *manage = [[HQTFProjectPeopleManageController alloc] init];
            manage.Id = self.projectItem.id;
            manage.projectItem = self.projectItem;
            [self.navigationController pushViewController:manage animated:YES];
            
        }
            break;
        case 2:
        {
            
            HQTFLabelManageController *label = [[HQTFLabelManageController alloc] init];
            label.projectId = self.projectItem.id;
            label.projectItem = self.projectItem;
            [self.navigationController pushViewController:label animated:YES];
        }
            break;
        case 3:
        {
            
            HQTFProjectFileController *file = [[HQTFProjectFileController alloc] init];
            file.project = self.projectItem;
            [self.navigationController pushViewController:file animated:YES];
        }
            break;
//        case 4:
//        {
//            
//        }
//            break;
        case 4:
        {
            HQTFRecordController *record = [[HQTFRecordController alloc] init];
            record.project = self.projectItem;
            [self.navigationController pushViewController:record animated:YES];
            
        }
            break;
      
            
        default:
            break;
    }
}


- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 初始化collectionView
- (void)setupCollectionView{
    
    HQTFProjectLayout *flowLayout = [[HQTFProjectLayout alloc]init];
    
    self.collectionView = [[HQTFProjectCollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor clearColor];
//    self.collectionView.backgroundColor =RedColor;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.scrollEnabled = YES;
    self.collectionView.bounces = NO;
    [self.view addSubview:self.collectionView];
    
    
    
//    [self.collectionView registerClass:[HQTFCreatRowCollectionViewCell class] forCellWithReuseIdentifier:@"HQTFCreatRowCollectionViewCell"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"HQTFCreatRowCollectionViewCell" bundle: [NSBundle mainBundle]]forCellWithReuseIdentifier:@"HQTFCreatRowCollectionViewCell"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"HQTFProjectCollectionViewCell" bundle: [NSBundle mainBundle]]forCellWithReuseIdentifier:@"HQTFProjectCollectionViewCell"];
}

#pragma mark - HQTFProjectCollectionViewDelegate
-(BOOL)collectionView:(UICollectionView *)collectionView shouldScrollToPageIndex:(NSInteger)targetIndex{
    
    HQLog(@"targetIndex:%ld",targetIndex);
    self.currentPage = targetIndex;
    
    
    return YES;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.seeBoards.count + 1;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row != self.seeBoards.count) {
    
        HQTFProjectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HQTFProjectCollectionViewCell" forIndexPath:indexPath];
        cell.tag = 0x3434 + indexPath.row;
        TFProjectSeeModel *model = self.seeBoards[indexPath.row];
        [cell refreshProjectCollectionViewCellWithModel:model];
        cell.taskList = model.tasks;
        cell.type = self.type;
        cell.delegate = self;
        return cell;
    }

    HQTFCreatRowCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HQTFCreatRowCollectionViewCell" forIndexPath:indexPath];
    cell.textView.tag = 0x5555;
    cell.type = self.type;
    cell.delegate = self;
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(SCREEN_WIDTH - 2 * CellSee, CellHeight);
}
#pragma mark - HQTFProjectCollectionViewCellDelegate
-(void)projectCollectionViewCellDidClickedJumpWithIndex:(NSInteger)index{
    
    HQTFTaskOptionController *option = [[HQTFTaskOptionController alloc] init];
    TFProjectSeeModel *model = self.seeBoards[index];
    option.listItem = model;
    
    option.actionParameter = ^(TFProjectSeeModel *listItem){
        
        NSMutableArray *taskLists = [NSMutableArray array];
        
        for (TFProjectSeeModel *mod in self.seeBoards) {
            
            if ([listItem.listId isEqualToNumber:mod.listId]) {
                
                continue;
            }else{
                [taskLists addObject:mod];
            }
        }
        
        self.seeBoards = taskLists;
        
        [self.collectionView reloadData];
        
    };
    
    [self.navigationController pushViewController:option animated:YES];
}

-(void)projectCollectionViewCellDidClickedTaskWithModel:(TFProjTaskModel *)model{
//    model.projectId = self.projectSeeModel.project.id;
    HQTFTaskMainController *taskDetail = [[HQTFTaskMainController alloc] init];
    taskDetail.projectTask = model;
    CGFloat offset = self.collectionView.contentOffset.x;
    NSInteger index = offset/SCREEN_WIDTH;
    taskDetail.projectSeeModel = self.seeBoards[index];
    [self.navigationController pushViewController:taskDetail animated:YES];
    
}

-(void)projectCollectionViewCellDidclickedCreateTask{
    
    
    if ([self.projectItem.projectStatus isEqualToNumber:@2]) {
        [MBProgressHUD showError:@"项目已暂停，不可进行编辑操作" toView:KeyWindow];
        return;
    }
    
    if ([self.projectItem.projectStatus isEqualToNumber:@3]) {
        [MBProgressHUD showError:@"项目已删除，不可进行编辑操作" toView:KeyWindow];
        return;
    }
    CGFloat offset = self.collectionView.contentOffset.x;
    NSInteger index = offset/SCREEN_WIDTH;
    
    HQTFCreatTaskController *creatTask = [[HQTFCreatTaskController alloc] init];
    creatTask.projectSeeModel = self.seeBoards[index];
    creatTask.index = index;
    creatTask.projectEndTime = self.projectItem.endTime;
    creatTask.refreshAction = ^{
        [self.projectBL requestGetProjTaskListPreviewWithProjectId:self.projectItem.id];
    };
    [self.navigationController pushViewController:creatTask animated:YES];
    
}
/** 完成任务 */
-(void)projectCollectionViewCellDidclickedFinishBtn:(UIButton *)finishBtn withModel:(TFProjTaskModel *)model{
    
    if ([self.projectItem.projectStatus isEqualToNumber:@2]) {
        [MBProgressHUD showError:@"项目已暂停，不可进行编辑操作" toView:KeyWindow];
        return;
    }
    
    if ([self.projectItem.projectStatus isEqualToNumber:@3]) {
        [MBProgressHUD showError:@"项目已删除，不可进行编辑操作" toView:KeyWindow];
        return;
    }
    
    NSInteger permission = 0;// 修改状态
    NSInteger approve = 0;// 能否审批
    if ([self.projectItem.isPublic isEqualToNumber:@1]) {
        
        if (self.manageOpenPermission) {
            // 有管理公开项目的权限
        }else{
            
            if ([model.taskPermissions containsObject:@200] || [model.taskPermissions containsObject:@201]) {
                permission = 1;
            }
            
            if (permission == 0) {
                return;
            }
            
            if ([model.taskPermissions containsObject:@301]) {
                approve = 1;
            }
        }
        
    }else{
        
        if ([model.taskPermissions containsObject:@200] || [model.taskPermissions containsObject:@201]) {
            permission = 1;
        }
        
        if (permission == 0) {
            return;
        }
        
        if ([model.taskPermissions containsObject:@301]) {
            approve = 1;
        }
    }
    
    if ([model.taskStatus isEqualToNumber:@1]) {// 完成
        
        [self changeTaskStatusFinishBtn:finishBtn withModel:model];
    }else{// 未完成
        
        if ([model.isOverdue isEqualToNumber:@0]) {// 未超期
            
            [self changeTaskStatusFinishBtn:finishBtn withModel:model];
        }else{// 超期
            
            if ([model.deadlineType isEqualToNumber:@2]) {// 时间点
                
                [self changeTaskStatusFinishBtn:finishBtn withModel:model];
            }else{// 时间段
                
                if ([model.isHasApprove isEqualToNumber:@1]) {// 有审批
                    
                    if (approve == 1) {// 有权限
                        // 跳转到审批
                        TFApprovalDetailMainController *approve = [[TFApprovalDetailMainController alloc] init];
                        approve.approvalId = model.approveId;
                        approve.taskId = model.id;
                        approve.approvalType = FunctionModelTypeTaskDeley;
                        [self.navigationController pushViewController:approve animated:YES];
                        
                    }else{// 没权限
                        return;
                    }
                    
                }else{
                    
                    [self changeTaskStatusFinishBtn:finishBtn withModel:model];
                }
            }
        }
    }
}

- (void)changeTaskStatusFinishBtn:(UIButton *)finishBtn withModel:(TFProjTaskModel *)model{
    
    if ([self.projectItem.projectStatus isEqualToNumber:@2]) {
        [MBProgressHUD showError:@"项目已暂停，不可进行编辑操作" toView:KeyWindow];
        return;
    }
    
    if ([self.projectItem.projectStatus isEqualToNumber:@3]) {
        [MBProgressHUD showError:@"项目已删除，不可进行编辑操作" toView:KeyWindow];
        return;
    }
    model.taskStatus = finishBtn.selected?@0:@1;
    if ([model.taskStatus isEqualToNumber:@0]) {
        model.activeCount = @([model.activeCount integerValue] + 1);
        CGFloat offset = self.collectionView.contentOffset.x;
        NSInteger index = offset/SCREEN_WIDTH;
        
        TFProjectSeeModel *see = self.seeBoards[index];
        see.listTaskFinishCount = @([see.listTaskFinishCount integerValue]-1<=0?0:[see.listTaskFinishCount integerValue]-1);
    }else{
        
        CGFloat offset = self.collectionView.contentOffset.x;
        NSInteger index = offset/SCREEN_WIDTH;
        TFProjectSeeModel *see = self.seeBoards[index];
        see.listTaskFinishCount = @([see.listTaskFinishCount integerValue]+1>=[see.listTaskCount integerValue]?[see.listTaskCount integerValue]:[see.listTaskFinishCount integerValue]+1);
    }
    
    [self.projectBL requestModTaskStatusWithTaskId:model.id isFinish:model.taskStatus];
}



#pragma mark - HQTFCreatRowCollectionViewCellDelegate
-(void)creatRowCollectionViewCell:(HQTFCreatRowCollectionViewCell *)cell didCreateBtn:(UIButton *)createBtn withBlock:(void (^)(BOOL))block{
    
    if ([self.projectItem.projectStatus isEqualToNumber:@2]) {
        [MBProgressHUD showError:@"项目已暂停，不可进行编辑操作" toView:KeyWindow];
        return;
    }
    if ([self.projectItem.projectStatus isEqualToNumber:@3]) {
        [MBProgressHUD showError:@"项目已删除，不可进行编辑操作" toView:KeyWindow];
        return;
    }
    
    if (block) {
        block(YES);
    }
}


-(void)creatRowCollectionViewCell:(HQTFCreatRowCollectionViewCell *)cell didSureBtnWithText:(NSString *)text{
    
    if ([self.projectItem.projectStatus isEqualToNumber:@2]) {
        [MBProgressHUD showError:@"项目已暂停，不可进行编辑操作" toView:KeyWindow];
        return;
    }
    if ([self.projectItem.projectStatus isEqualToNumber:@3]) {
        [MBProgressHUD showError:@"项目已删除，不可进行编辑操作" toView:KeyWindow];
        return;
    }
    
    HQTFOptionModel *model = [[HQTFOptionModel alloc] init];
    model.projectId = self.projectItem.id;
    model.listName = text;
    
    [self.projectBL requestAddProjTaskListWithModel:model];
    [cell cancelBtnClick:nil];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGFloat offset = scrollView.contentOffset.x;
    NSInteger index = offset/SCREEN_WIDTH;
    if (index == self.seeBoards.count) {
        self.creatTask.hidden = YES;
    }else{
        self.creatTask.hidden = NO;
    }
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_getProjTaskListPreview) {
        
        self.seeBoards = resp.body;
        
        for (TFProjectSeeModel *model in self.seeBoards) {
            
            model.project = self.projectItem;
        }
        
        [self.collectionView reloadData];
    }
    
    if (resp.cmdId == HQCMD_addProjTaskList) {
        
        [self.projectBL requestGetProjTaskListPreviewWithProjectId:self.projectItem.id];
//        TFProjectSeeModel *model = resp.body;
//        model.listId = model.id;
//        [self.seeBoards addObject:resp.body];
//        
//        for (TFProjectSeeModel *model in self.seeBoards) {
//            
//            model.project = self.projectItem;
//        }
//        
//        [self.collectionView reloadData];
        
    }
    
    if (resp.cmdId == HQCMD_updateProject) {
        
        [self setupNavigation];
    }
    
    if (resp.cmdId == HQCMD_modTaskStatus) {
        
        [self.collectionView reloadData];
    }
    
    if (resp.cmdId == HQCMD_projectCollectAdd) {
        
        self.projectItem.projectCollectId = resp.body;
        
        [self setupNavigation];
    }
    
    if (resp.cmdId == HQCMD_projectCollectDelete) {
        
        self.projectItem.projectCollectId = nil;
        [self setupNavigation];
    }
    
    if (resp.cmdId == HQCMD_getPermission) {
        
        for (TFPermissionModel *model in resp.body) {
            
            if ([model.code isEqualToNumber:@111003]) {
                self.manageOpenPermission = YES;
                break;
            }
        }
        
    }

}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
    if (resp.cmdId == HQCMD_getProjTaskListPreview) {
        
    }
    
    if (resp.cmdId == HQCMD_addProjTaskList) {
        
    }
    if (resp.cmdId == HQCMD_updateProject) {
        
    }
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
