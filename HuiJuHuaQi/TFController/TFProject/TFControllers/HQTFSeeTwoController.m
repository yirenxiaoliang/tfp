//
//  HQTFSeeTwoController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/3/14.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//  Cell中拖拽

#import "HQTFSeeTwoController.h"
#import "HQTFSeeCollectionView.h"
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
#import "TFProjParticipantModel.h"

#define CellHeight (SCREEN_HEIGHT - 64-55)



@interface HQTFSeeTwoController ()<UICollectionViewDelegate,UICollectionViewDataSource,FDActionSheetDelegate,HQTFProjectCollectionViewCellDelegate,HQTFSeeCollectionViewDelegate>

/** collectionView */
@property (nonatomic, strong) HQTFSeeCollectionView *collectionView;
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




@end

@implementation HQTFSeeTwoController


-(NSMutableArray *)seeBoards{
    
    if (!_seeBoards) {
        _seeBoards = [NSMutableArray array];
        
        for (NSInteger q = 0; q < 6; q ++) {
            NSMutableArray *arr = [NSMutableArray array];
            for (NSInteger i = 0; i < 6; i ++) {
                
                
                TFProjTaskModel *model = [[TFProjTaskModel alloc] init];
                model.creatorId = @(1111+i);
                model.content = [NSString stringWithFormat:@"%@--%ld",@"我是项目任务是项目任务的是项目任务的是项目任务的的标题",i];
                model.priority = @(i % 3);
                model.deadline = @([HQHelper getNowTimeSp] + 1000 * 3 * 24 * 60 * 60);
//                model.desc = [NSString stringWithFormat:@"我是项目任务的描述类容呀，请多多关注。"];
                
                model.isPublic = @(i % 2);
                model.isFinish = @(i % 2);
//                model.numberType = @(i % 2);
//                model.numberSum = @"10000000000";
//                model.numberUnit = @"元";
                model.relatedItemCount = @12;
                model.childTaskCount = @99;
                model.childTaskFinished = @88;
                model.fileCount = @2;
                model.isPublic = @(i % 2);
                
                NSMutableArray *parts = [NSMutableArray array];
                for (NSInteger j = 4-i; j <= 4; j ++) {
                    TFProjParticipantModel *part = [[TFProjParticipantModel alloc] init];
                    [parts addObject:part];
                }
//                model.managers = parts;
                
                NSMutableArray *labels = [NSMutableArray array];
                for (NSInteger j = i; j < 3; j ++) {
                    TFProjLabelModel *mo = [[TFProjLabelModel alloc] init];
                    if (i == 0) {
                        mo.labelName = @"我是个镖旗";
                    }else if (i == 1) {
                        
                        mo.labelName = @"我是个";
                    }else{
                        mo.labelName = @"我";
                    }
                    mo.labelColor = [NSString stringWithFormat:@"#ff0000"];
                    [labels addObject:mo];
                }
                model.labels = labels;
                [arr addObject:model];
            }
            [_seeBoards addObject:arr];
        }
    }
    return _seeBoards;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.collectionView reloadData];
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        
        [self.navigationController.navigationBar setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
        
        [self.navigationController.navigationBar setShadowImage:[HQHelper createImageWithColor:[UIColor clearColor] size:(CGSize){SCREEN_WIDTH,0.5}]];
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
//    [self setupCreatTask];
}

#pragma mark - creatTask
- (void)setupCreatTask{
    
    UIButton *creatTask = [HQHelper buttonWithFrame:(CGRect){0,SCREEN_HEIGHT-55,SCREEN_WIDTH,55} target:self action:@selector(creatTaskClick)];
    [self.view addSubview:creatTask];
    [creatTask setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateHighlighted];
    [creatTask setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
    self.creatTask = creatTask;
    if (self.type == ProjectSeeBoardTypeProject) {
        
        [creatTask setTitle:@"+ 新建任务" forState:UIControlStateNormal];
        [creatTask setTitle:@"+ 新建任务" forState:UIControlStateHighlighted];
    }else{
        
        [creatTask setTitle:@"+ 新建订单任务" forState:UIControlStateNormal];
        [creatTask setTitle:@"+ 新建订单任务" forState:UIControlStateHighlighted];
    }
}

- (void)creatTaskClick{
    HQTFCreatTaskController *creatTask = [[HQTFCreatTaskController alloc] init];
    [self.navigationController pushViewController:creatTask animated:YES];
}

#pragma mark - navi
-(void)setupNavigation{
    
    self.navigationItem.title = @"项目看板";
    UINavigationItem *item1 = [self itemWithTarget:self action:@selector(star) image:@"标星1" highlightImage:@"标星1"];
    UINavigationItem *item2 = [self itemWithTarget:nil action:nil image:@"" highlightImage:@""];
    UINavigationItem *item3 = [self itemWithTarget:self action:@selector(menu) image:@"菜单白色" highlightImage:@"菜单白色"];
    self.navigationItem.rightBarButtonItems = @[item3,item2,item1];
    
}

- (void)star{
    
}
- (void)menu{
    
    FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"项目设置",@"成员管理",@"项目概述",@"项目文件",@"标签管理",@"活动记录",@"暂停项目",@"删除项目",nil];
    
    sheet.tag = 100;
    [sheet setButtonTitleColor:BlackTextColor bgColor:nil fontSize:FONT(16) atIndex:0];
    [sheet setButtonTitleColor:BlackTextColor bgColor:nil fontSize:FONT(16) atIndex:1];
    [sheet setCancelButtonTitleColor:BlackTextColor bgColor:CellClickColor fontSize:FONT(16)];
    [sheet show];
    
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            HQTFCreatProjectController *creat = [[HQTFCreatProjectController alloc] init];
            [self.navigationController pushViewController:creat animated:YES];
        }
            break;
        case 1:
        {
            HQTFProjectPeopleManageController *manage = [[HQTFProjectPeopleManageController alloc] init];
            [self.navigationController pushViewController:manage animated:YES];
            
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            
            HQTFProjectFileController *file = [[HQTFProjectFileController alloc] init];
            [self.navigationController pushViewController:file animated:YES];
        }
            break;
        case 4:
        {
            HQTFLabelManageController *label = [[HQTFLabelManageController alloc] init];
            [self.navigationController pushViewController:label animated:YES];
        }
            break;
        case 5:
        {
            HQTFRecordController *record = [[HQTFRecordController alloc] init];
            [self.navigationController pushViewController:record animated:YES];
            
        }
            break;
        case 6:
        {
            [AlertView showAlertView:@"暂停项目" msg:@"项目所有成员将无法操作及预览" leftTitle:@"取消" rightTitle:@"确定" onLeftTouched:^{
                
            } onRightTouched:^{
                
            }];
        }
            break;
        case 7:
        {
            [AlertView showAlertView:@"删除项目" msg:@"删除后该项目无法恢复" leftTitle:@"取消" rightTitle:@"确定" onLeftTouched:^{
                
            } onRightTouched:^{
                
            }];
            
            [AlertView showAlertView:@"删除项目" msg:@"请先清除项目中的任务" leftTitle:@"取消" rightTitle:@"确定" onLeftTouched:^{
                
            } onRightTouched:^{
                
            }];
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
    
    self.collectionView = [[HQTFSeeCollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-55) collectionViewLayout:flowLayout];
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

#pragma mark - HQTFSeeCollectionViewDelegate


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
        cell.taskList = self.seeBoards[indexPath.row];
        cell.type = self.type;
        cell.delegate = self;
        cell.tag = 0x999+indexPath.row;
        return cell;
    }
    
    HQTFCreatRowCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HQTFCreatRowCollectionViewCell" forIndexPath:indexPath];
    cell.type = self.type;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(SCREEN_WIDTH - 2 * CellSee, CellHeight);
}

-(void)projectCollectionViewCellDidClickedJump{
    
    HQTFTaskOptionController *option = [[HQTFTaskOptionController alloc] init];
    [self.navigationController pushViewController:option animated:YES];
}

-(void)projectCollectionViewCellDidClickedTaskWithIndex:(NSInteger)index{
    HQTFTaskMainController *taskDetail = [[HQTFTaskMainController alloc] init];
    
    [self.navigationController pushViewController:taskDetail animated:YES];
    
}

-(void)dragProjectCollectionViewCell:(HQTFProjectCollectionViewCell *)projectCollectionViewCell newDataArrayAfterMove:(NSArray *)newDataArray{
    //    NSIndexPath *indexPath = [self.collectionView indexPathForCell:projectCollectionViewCell];
    //    [self.seeBoards replaceObjectAtIndex:indexPath.row withObject:newDataArray];
    //
    //    [self.collectionView reloadData];
}

-(NSArray *)dataSourceArrayOfProjectCollectionViewCell:(HQTFProjectCollectionViewCell *)projectCollectionViewCell{
    
    return projectCollectionViewCell.taskList;
}



//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//
//}
//
//-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//
//
//    self.drag = YES;
//
//    CGFloat offset = scrollView.contentOffset.x;
//
//    HQLog(@"scrollViewWillBeginDragging:%f",offset);
//
//    self.currentOffset = offset;
//
//    HQLog(@"scrollViewWillBeginDragging:currentOffset%f",offset);
//
//}
//
//-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
//
//
//    CGFloat offset = scrollView.contentOffset.x;
//
//    HQLog(@"scrollViewWillBeginDecelerating:%f",offset);
//
//}
//

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGFloat offset = scrollView.contentOffset.x;
    NSInteger index = offset/SCREEN_WIDTH;
    if (index == self.seeBoards.count) {
        self.creatTask.hidden = YES;
    }else{
        self.creatTask.hidden = NO;
    }
}
//
//
//
//-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//
//
//
//    if (self.drag) {
//
//        self.drag = NO;
//
//        CGFloat offset = scrollView.contentOffset.x;
//
//        self.currentPage = (NSInteger)offset/SCREEN_WIDTH;
//
//        HQLog(@"scrollViewDidScroll   offset:%f  currentPage:%ld",offset,self.currentPage);
//
//        if (self.currentOffset < offset) {// 向左滑
//
//            scrollView.contentOffset = CGPointMake((self.currentPage + 1)*SCREEN_WIDTH, 0);
//
//        }else{// 向右滑
//
//
//            scrollView.contentOffset = CGPointMake((self.currentPage - 1)*SCREEN_WIDTH, 0);
//        }
//
//    }
//}




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
