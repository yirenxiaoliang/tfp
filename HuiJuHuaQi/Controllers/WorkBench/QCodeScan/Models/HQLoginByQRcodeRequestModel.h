//
//  NSLoginByQRcodeRequestModel.h
//  HuiJuHuaQi
//
//  Created by XieLB on 16/4/20.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@interface HQLoginByQRcodeRequestModel : JSONModel


/**
 * 二维码登录信息ID
 */
@property (nonatomic, strong) NSString *qrCodeID;


@end
