//
//  TFMyCardView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/14.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFEmpEmployeeInfoModel.h"

@protocol TFMyCardViewDelegate <NSObject>
@optional
-(void)clickedCompanyBtn;
-(void)clickedEnterBtn;
-(void)clickedHeadBtn;
-(void)clickedDescriptBtn;

@end

@interface TFMyCardView : UIView

/** delegate */
@property (nonatomic, weak) id <TFMyCardViewDelegate>delegate;

+ (instancetype)myCardView;

/** type 0:有名片 1:无名片 */
@property (nonatomic, assign) NSInteger type;

@property (weak, nonatomic) IBOutlet UILabel *companyLabel;

-(void)refreshMyCardView;
-(void)refreshMyCardViewWithEmployee:(TFEmpEmployeeInfoModel *)employee;

@end
