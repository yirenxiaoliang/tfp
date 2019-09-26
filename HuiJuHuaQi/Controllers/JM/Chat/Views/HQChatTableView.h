//
//  HQChatTableView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 16/11/24.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HQChatTableViewDelegate <NSObject>
@optional
- (void)tableView:(UITableView *)tableView
     touchesBegan:(NSSet *)touches
        withEvent:(UIEvent *)event;
@end

@interface HQChatTableView : UITableView

@property (nonatomic,weak) id <HQChatTableViewDelegate,UITableViewDelegate> delegate;

@end
