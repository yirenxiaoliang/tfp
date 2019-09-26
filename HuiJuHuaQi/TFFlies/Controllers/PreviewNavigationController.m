//
//  PreviewNavigationController.m
//  QLPreviewController
//
//  Created by 陈宇亮 on 16/12/17.
//  Copyright © 2016年 CodingFire. All rights reserved.
//

#import "PreviewNavigationController.h"
//#import "SRActionSheet.h"

@interface PreviewNavigationController ()

@end

@implementation PreviewNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    UIViewController *controller = self.viewControllers.firstObject;
    
    NSLog(@"controller===%@",controller);
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(leftBtnAction)];
//    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(rightBtnAction)];
    //
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    [rightButton setImage:[UIImage imageNamed:@"菜单白色"]forState:UIControlStateNormal];
    
    //右
//    [rightButton addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];

    //设置选项按钮颜色
    leftBtn.tintColor = [UIColor whiteColor];
    rightButton.tintColor = [UIColor whiteColor];
    controller.navigationItem.leftBarButtonItem = leftBtn;
    controller.navigationItem.rightBarButtonItem = rightItem;
    
//    [self setNavigationBarHidden:YES animated:animated];
    
}

- (void)leftBtnAction {

    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)moreAction {

//    [SRActionSheet sr_showActionSheetViewWithTitle:nil
//                                 cancelButtonTitle:@"取消"
//                                 otherButtonTitles:@[@"发送给朋友", @"收藏", @"用其他应用打开"]
//                                  selectSheetBlock:^(SRActionSheet *actionSheetView, NSInteger actionIndex) {
//                                      NSLog(@"%zd", actionIndex);
//                                      if (actionIndex==1) {
//                                          
//                                          NSLog(@"收藏...");
//                                      }
//                                  }];
    NSString *textToShare = @"其他应用打开";
    
    UIImage *imageToShare = [UIImage imageNamed:self.imgName];
    
    NSURL *urlToShare = [HQHelper URLWithString:self.imgUrl];
    
    NSArray *activityItems = @[textToShare, imageToShare, urlToShare];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems
                                            
                                                                            applicationActivities:nil];
    
    //不出现在活动项目
    
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,
                                         
                                         UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
    
    [self presentViewController:activityVC animated:TRUE completion:nil];
}

@end
