//
//  HQTFMeHearder.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/17.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  HQTFMeHearderDelegate <NSObject>

@optional
- (void)meHeaderClickedCompany;
- (void)meHeaderClickedPhoto;
@end

@interface HQTFMeHearder : UIView

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UIButton *headImage;

@property (weak, nonatomic) IBOutlet UIButton *companyBtn;

/** dalegate */
@property (nonatomic, weak) id<HQTFMeHearderDelegate> delegate;

+ (instancetype)meHearder;


@end
