//
//  FunctionView.h
//  ChatTest
//
//  Created by Season on 2017/5/16.
//  Copyright © 2017年 Season. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNImagePickerController.h"
#import "XSVideoViewController.h"
#import "FilesViewController.h"
typedef NS_ENUM(NSInteger, ChatMoreFunction) {
    ChatMoreFunctionSystemPhoto  = 0,       // 系统相册
    ChatMoreFunctionTakePhoto     = 1,      // 拍照
    ChatMoreFunctionMiniVideo  = 2,         // 小视频
    ChatMoreFunctionFile  = 3,              // 文件
  
};

@interface FunctionView : UIView<DNImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,XSVideoViewControllerDelegate>


/**
 发送前回调 
 */
@property(nonatomic, copy)void(^functionBlock)(ChatMoreFunction fuctiontype,id data,ChatFileType fileType);


@end
