//
//  HQAddContactsCtrl.h
//  HuiJuHuaQi
//
//  Created by XieLB on 16/1/14.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HQBaseViewController.h"

typedef enum HQAddContactsCtrlType{
//    HQAddContactsCtrlType_single,// 选一个
//    HQAddContactsCtrlType_multi// 选多个
    
    HQAddContactsCtrlType_import,     //导入通讯录
    HQAddContactsCtrlType_invitation  //邀请人员
    
}HQAddContactsCtrlType;


@protocol  HQAddContactsCtrlDelegate <NSObject>

@optional

- (void)addContactsCtrlSelectedContancts:(NSArray *)contacts;

@end

@interface HQAddContactsCtrl : HQBaseViewController

//@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) UITableView *contactsTableView;

@property (nonatomic, strong) NSString *companyId;

@property (nonatomic, assign) BOOL registerOrLookAtState;    //YES为查看

@property (nonatomic, weak) id<HQAddContactsCtrlDelegate> delegate;
/** 控制器类型 */
@property (nonatomic, assign) HQAddContactsCtrlType vCType;

/** 值 */
@property (nonatomic, copy) ActionParameter actionParameter;

@end
