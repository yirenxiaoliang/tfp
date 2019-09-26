//
//  TFProjectDetailTabBarController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/10.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjectDetailTabBarController.h"
#import "TFProjectFirstController.h"
#import "TFProjectShareController.h"
#import "TFProjectFileController.h"
#import "TFProjectStatisticsController.h"
#import "TFProjectAddShareController.h"
#import "TFProjectMenberManageController.h"
#import "TFCreateProjectController.h"
#import "TFProjectLabelController.h"
#import "TFProjectBoardController.h"
#import "TFProjectFilterView.h"
#import "TFCustomerDynamicController.h"
#import "TFProjectFileNewController.h"
#import "TFProjectTaskBL.h"
#import "TFProjectPeopleModel.h"
#import "TFProjectThinkController.h"
#import "TFMutilStyleSelectPeopleController.h"
#import "TFContactsDepartmentController.h"

@interface TFProjectDetailTabBarController ()<UITabBarDelegate,UIActionSheetDelegate,TFProjectFilterViewDelegate,HQBLDelegate>

/** tarBar */
@property (nonatomic, strong) UITabBar *tabBar;

/** items */
@property (nonatomic, strong) NSMutableArray *items;
/** filterVeiw */
@property (nonatomic, strong) TFProjectFilterView *filterVeiw;

/** TFProjectTaskBL */
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;

/** 权限 */
@property (nonatomic, copy) NSString *privilege;

/** 选中的tabbar坐标 */
@property (nonatomic, assign) NSInteger index;


@property (nonatomic, assign) BOOL haveSelf;

@end

@implementation TFProjectDetailTabBarController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.filterVeiw.hidden = NO;
}

#pragma mark - 初始化filterView
- (void)setupFilterView{
    
    TFProjectFilterView *filterVeiw = [[TFProjectFilterView alloc] initWithFrame:(CGRect){SCREEN_WIDTH,0,SCREEN_WIDTH,SCREEN_HEIGHT}];
    filterVeiw.tag = 0x12344321;
    self.filterVeiw = filterVeiw;
    filterVeiw.delegate = self;
}

#pragma mark - TFFilterViewDelegate
-(void)filterViewDidClicked:(BOOL)show{
    
    
}

-(void)filterViewDidSureBtnWithDict:(NSMutableDictionary *)dict{
    
    [self.filterVeiw hideAnimation];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ProjectTaskFilterNotification object:dict];
    
}

-(void)filterViewDidSelectPeopleWithPeoples:(NSArray *)peoples model:(TFFilterModel *)model{
    
    //    [self crmSearchViewDidFilterBtn:NO];
    self.filterVeiw.hidden  = YES;
    
    TFMutilStyleSelectPeopleController *scheduleVC = [[TFMutilStyleSelectPeopleController alloc] init];
    scheduleVC.selectType = 1;
    scheduleVC.isSingleSelect = NO;
    scheduleVC.defaultPoeples = peoples;
    //            scheduleVC.noSelectPoeples = model.selects;
    scheduleVC.dismiss = @1;
    scheduleVC.cancelAction = ^{
        self.filterVeiw.hidden  = NO;
    };
    scheduleVC.actionParameter = ^(NSArray *parameter) {
        
        NSMutableArray *bb = [NSMutableArray array];
        for (HQEmployModel *ee in parameter) {
            BOOL have = NO;
            for (HQEmployModel *dd in  model.entrys) {
                if ([[ee.id description] isEqualToString:[dd.id description]]) {
                    have = YES;
                    break;
                }
            }
            if (!have) {
                [bb addObject:ee];
            }
        }
        
        [model.entrys addObjectsFromArray:bb];
        
        [self.filterVeiw refresh];
        
        //        [self crmSearchViewDidFilterBtn:YES];
        
        self.filterVeiw.hidden  = NO;
    };
    [self.navigationController pushViewController:scheduleVC animated:YES];
}

-(void)filterViewDidSelectDepartmentWithDepartments:(NSArray *)departments model:(TFFilterModel *)model{
    
    self.filterVeiw.hidden  = YES;
    //    [self crmSearchViewDidFilterBtn:NO];
    TFContactsDepartmentController *scheduleVC = [[TFContactsDepartmentController alloc] init];
    scheduleVC.isSingleUse = YES;
    scheduleVC.type = 1;
    scheduleVC.isSingleSelect = NO;
    scheduleVC.tableViewHeight = SCREEN_HEIGHT - NaviHeight;
    scheduleVC.defaultDepartments = departments;
    scheduleVC.cancelAction = ^{
        self.filterVeiw.hidden  = NO;
    };
    scheduleVC.actionParameter = ^(NSArray *parameter) {
        //        TFDepartmentModel
        
        NSMutableArray *bb = [NSMutableArray array];
        for (TFDepartmentModel *ee in parameter) {
            BOOL have = NO;
            for (TFDepartmentModel *dd in  model.entrys) {
                if ([[ee.id description] isEqualToString:[dd.id description]]) {
                    have = YES;
                    break;
                }
            }
            if (!have) {
                [bb addObject:ee];
            }
        }
        
        [model.entrys addObjectsFromArray:bb];
        
        [self.filterVeiw refresh];
        
        self.filterVeiw.hidden  = NO;
        //        [self crmSearchViewDidFilterBtn:YES];
    };
    [self.navigationController pushViewController:scheduleVC animated:YES];
}



-(void)didBack:(UIButton *)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:ProjectRowTableViewHideNotification object:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [super didBack:sender];
    });
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupFilterView];
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    if (self.projectModel == nil || self.createPush) {
        [self.projectTaskBL requestGetProjectDetailWithProjectId:self.projectId];
    }
    
    [self.projectTaskBL requsetGetProjectPeopleWithProjectId:self.projectId];
    self.enablePanGesture = NO;
    
    
//    TFProjectBoardController *project = [[TFProjectBoardController alloc] init];
//    project.projectId = self.projectId;
//    project.projectModel = self.projectModel;
    
    TFProjectThinkController *project = [[TFProjectThinkController alloc] init];
    project.projectId = self.projectId;
    project.projectModel = self.projectModel;
    
    [self addChildViewController:project];
    project.view.frame = self.view.bounds;
    [self.view addSubview:project.view];
    
    TFProjectShareController *share = [[TFProjectShareController alloc] init];
    share.projectId = self.projectId;
    share.projectModel = self.projectModel;
    [self addChildViewController:share];
    
    TFProjectFileController *file = [[TFProjectFileController alloc] init];
    file.projectId = self.projectId;
    file.projectModel = self.projectModel;
    file.actionParameter = ^(NSString *parameter) {
        
        self.privilege = parameter;
        [self setupNavigationWithTag:self.index];
        
    };
    [self addChildViewController:file];
    
//    TFProjectStatisticsController *statistics = [[TFProjectStatisticsController alloc] init];
//    [self addChildViewController:statistics];
    
    NSMutableArray<UITabBarItem *> *arr = [NSMutableArray<UITabBarItem *> array];
    self.items = arr;
    
    [arr addObject:[self addOneItemWithTitle:@"任务" imageName:@"proTaskTar" selectedImageName:@"proTaskTarSel" tag:0]];
    [arr addObject:[self addOneItemWithTitle:@"分享" imageName:@"proShareTar" selectedImageName:@"proShareTarSel" tag:1]];
    [arr addObject:[self addOneItemWithTitle:@"文库" imageName:@"proFileTar" selectedImageName:@"proFileTarSel" tag:2]];
//    [arr addObject:[self addOneItemWithTitle:@"统计" imageName:@"proStatisticsTar" selectedImageName:@"proStatisticsTarSel" tag:3]];
    
    self.tabBar = [[UITabBar alloc] initWithFrame:(CGRect){0,SCREEN_HEIGHT-NaviHeight-BottomM-49,SCREEN_WIDTH,49}];
    self.tabBar.items = self.items;
    self.tabBar.delegate = self;
    [self.view addSubview:self.tabBar];
    [self.tabBar setSelectedItem:self.items[0]];
    
    [self setupNavigationWithTag:0];
    
    
    [self.projectTaskBL requestGetProjectTaskFilterConditionWithProjectId:self.projectId];
}


- (void)setupNavigationWithTag:(NSInteger)tag{
    
    
    if (tag == 0) {
        
        self.navigationItem.title = self.projectModel.name;
        
        UINavigationItem *item1 = [self itemWithTarget:self action:@selector(menu) image:@"设置灰色" highlightImage:@"设置灰色"];
        UINavigationItem *item2 = [self itemWithTarget:self action:@selector(search) image:@"proFilter" highlightImage:@"proFilter"];
        UINavigationItem *item3 = nil;
        if ([self.projectModel.star_level isEqualToNumber:@1]) {
            
            item3 = [self itemWithTarget:self action:@selector(star) image:@"projectStar" highlightImage:@"projectStar"];
        }else{
            item3 = [self itemWithTarget:self action:@selector(star) image:@"clickStar" highlightImage:@"clickStar"];
        }
        
        self.navigationItem.rightBarButtonItems = @[item1,item2,item3];
    }
    else if (tag == 1) {
    
        self.navigationItem.title = @"分享";
        
        UIBarButtonItem *add = [self itemWithTarget:self action:@selector(addShare) image:@"shareAdd" highlightImage:@"shareAdd"];
        UIBarButtonItem *person = [self itemWithTarget:nil action:nil image:@"" highlightImage:@""];
        UIBarButtonItem *person1 = [self itemWithTarget:nil action:nil image:@"" highlightImage:@""];
        
        NSArray *rightBtns = [NSArray arrayWithObjects:add,person, nil];
        NSArray *rightBtns1 = [NSArray arrayWithObjects:person1,person, nil];
        
        if ([self.projectModel.project_status isEqualToString:@"0"] && self.haveSelf) {// 进行中的项目
            self.navigationItem.rightBarButtonItems = rightBtns;
        }else{
            self.navigationItem.rightBarButtonItems = rightBtns1;
        }
    }
    else if (tag == 2) {
        
        self.navigationItem.title = @"文库";
        
        UIBarButtonItem *add = [self itemWithTarget:self action:@selector(addLibrary) image:@"shareAdd" highlightImage:@"shareAdd"];
        UIBarButtonItem *person = [self itemWithTarget:nil action:nil image:@"" highlightImage:@""];
        UIBarButtonItem *person1 = [self itemWithTarget:nil action:nil image:@"" highlightImage:@""];
        
        NSArray *rightBtns = [NSArray arrayWithObjects:add,person, nil];
        NSArray *rightBtns1 = [NSArray arrayWithObjects:person1,person, nil];
        
        if ([self.projectModel.project_status isEqualToString:@"0"] && self.haveSelf) {// 进行中的项目
            if ([HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"31"]) {
                
                self.navigationItem.rightBarButtonItems = rightBtns;
            }else{
                
                self.navigationItem.rightBarButtonItems = rightBtns1;
            }
        }else{
            self.navigationItem.rightBarButtonItems = rightBtns1;
        }
        

    }
    else if (tag == 3) {
        
        self.navigationItem.title = @"统计";
        
//        UINavigationItem *item1 = [self itemWithTarget:self action:@selector(menu) image:@"projectMenu" highlightImage:@"projectMenu"];
//        UINavigationItem *item2 = [self itemWithTarget:self action:@selector(search) image:@"搜索project" highlightImage:@"搜索project"];
//
//        self.navigationItem.rightBarButtonItems = @[item1,item2];
        self.navigationItem.rightBarButtonItems = nil;
    }
    
}
#pragma mark - Item
- (void)menu{
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"项目设置",@"成员管理",@"项目标签",@"项目动态", nil];
    [sheet showInView:self.view];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ProjectRowTableViewHideNotification object:nil];
}


- (void)search{
    
    [self.filterVeiw showAnimation];
    [[NSNotificationCenter defaultCenter] postNotificationName:ProjectRowTableViewHideNotification object:nil];
}

- (void)star{
    
    if (![self.projectModel.project_status isEqualToString:@"0"]) {
        if ([self.projectModel.project_status isEqualToString:@"1"]) {// 归档
            
            [MBProgressHUD showError:@"项目已归档" toView:self.view];
        }
        if ([self.projectModel.project_status isEqualToString:@"2"]) {// 暂停
            
            [MBProgressHUD showError:@"项目已暂停" toView:self.view];
        }
        return;
    }
    
    [self.projectTaskBL requsetUpdateProjectStarWithProjectId:self.projectId starLevel:[self.projectModel.star_level isEqualToNumber:@1]?@0:@1];
    [[NSNotificationCenter defaultCenter] postNotificationName:ProjectRowTableViewHideNotification object:nil];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_getProjectPeople) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        for (TFProjectPeopleModel *model in resp.body) {
            
            if ([UM.userLoginInfo.employee.id isEqualToNumber:model.employee_id]) {
                self.haveSelf = YES;
                break;
            }
        }
    }
    
    if (resp.cmdId == HQCMD_updateProjectStar) {
        
        self.projectModel.star_level = [self.projectModel.star_level isEqualToNumber:@1]?@0:@1;
        if (self.refresh) {
            self.refresh();
        }
        [self setupNavigationWithTag:0];
    }
    
    if (resp.cmdId == HQCMD_queryProjectTaskCondition) {
        
        self.filterVeiw.conditions = resp.body;
        
    }
    
    if (resp.cmdId == HQCMD_projectTaskFilter) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }
    if (resp.cmdId == HQCMD_getProjecDetail) {
        
        self.projectModel = resp.body;
        [self setupNavigationWithTag:0];
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}



#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        
        TFCreateProjectController *create = [[TFCreateProjectController alloc] init];
        create.type =  1;
        create.projectId = self.projectId;
        create.projectModel = self.projectModel;
        create.refreshAction = ^(NSString *parameter) {
            
            self.navigationItem.title = parameter;
            self.projectModel.name = parameter;
            if (self.refresh) {
                self.refresh();
            }
        };
        create.progressAction = ^(NSDictionary *parameter) {
            
            self.projectModel.project_progress_status = [parameter valueForKey:@"project_progress_status"];
            self.projectModel.project_progress_number = [parameter valueForKey:@"project_progress_number"];
            self.projectModel.project_progress_content = [parameter valueForKey:@"project_progress_content"];
            
            if (self.refresh) {
                self.refresh();
            }
        };
        create.deleteAction = ^{
          
            if (self.deleteAction) {
                [self.navigationController popViewControllerAnimated:YES];
                self.deleteAction();
            }
        };
        [self.navigationController pushViewController:create animated:YES];
    }
    
    if (buttonIndex == 1) {
        TFProjectMenberManageController *menber = [[TFProjectMenberManageController alloc] init];
        menber.projectId = self.projectId;
        menber.projectModel = self.projectModel;
        [self.navigationController pushViewController:menber animated:YES];
    }
    
    if (buttonIndex == 2) {
        TFProjectLabelController *label = [[TFProjectLabelController alloc] init];
        label.projectId = self.projectId;
        label.projectModel = self.projectModel;
        [self.navigationController pushViewController:label animated:YES];
    }
    if (buttonIndex == 3) {
        TFCustomerDynamicController *dynamic = [[TFCustomerDynamicController alloc] init];
        dynamic.id = self.projectId;
        dynamic.bean = @"project_dynamic";
        [self.navigationController pushViewController:dynamic animated:YES];
    }
}

/** 添加分享 */
- (void)addShare {

    TFProjectAddShareController *addShareVC = [[TFProjectAddShareController alloc] init];
    
    addShareVC.type = 0;
    addShareVC.proId = self.projectId;
    
    [self.navigationController pushViewController:addShareVC animated:YES];
}

/** 添加文库 */
- (void)addLibrary {

    TFProjectFileNewController *newFileVC = [[TFProjectFileNewController alloc] init];
    newFileVC.projectId = self.projectId;
    newFileVC.parentId = self.projectId;
    newFileVC.subType = @0;//创建文件夹
    [self.navigationController pushViewController:newFileVC animated:YES];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    
    for (HQBaseViewController *vc in self.childViewControllers) {
        
        [vc.view removeFromSuperview];
        
    }
    HQBaseViewController *vc  = self.childViewControllers[item.tag];
    [self.view insertSubview:vc.view atIndex:0];
    self.index = item.tag;
    
    [self setupNavigationWithTag:item.tag];
    
    
}


/** 添加item */
- (UITabBarItem *)addOneItemWithTitle:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName tag:(NSInteger)tag
{
    
    UITabBarItem *item = [[UITabBarItem alloc] init];
    item.title = title;
    item.tag = tag;
    
    //     设置tabBarItem的普通文字颜色(预留)
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = RGBColor(106,106,106);
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // 设置tabBarItem的选中文字颜色(预留)
    NSMutableDictionary *selectedTextAttrs = [NSMutableDictionary dictionary];
    selectedTextAttrs[NSForegroundColorAttributeName] = RGBColor(38,138,228);
    [item setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
    
    // 设置选中的图标
    UIImage *normalImage = [UIImage imageNamed:imageName];
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    if (IOS7_AND_LATER) {
        // 声明这张图片用原图(别渲染)
        normalImage  = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    item.image = normalImage;
    item.selectedImage = selectedImage;
    
    return  item;
    
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
