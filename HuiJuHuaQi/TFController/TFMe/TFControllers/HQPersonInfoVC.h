//
//  HQPersonInfoVC.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/4/13.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface HQPersonInfoVC : HQBaseViewController {

    UIProgressView *progressView;
}

@property (nonatomic, copy) NSString *signContent;

/** refresh */
@property (nonatomic, copy) ActionParameter refresh;


@end
