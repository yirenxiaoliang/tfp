//
//  FilesViewController.h
//  ChatTest
//
//  Created by Season on 2017/5/19.
//  Copyright © 2017年 Season. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilesViewController : UIViewController


@property(nonatomic,copy)void(^fileBlock)(NSArray *contents,FileType fileType);

@end
