//
//  HQAudioModel.h
//  HuiJuHuaQi
//
//  Created by XieLB on 16/3/14.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@interface HQAudioModel : JSONModel


/**
 * 音频url路径
 */
@property (nonatomic, copy) NSString  <Optional> *voiceUrl;


/**
 * 语音的时间长度
 */
@property (nonatomic, strong) NSNumber <Optional>*voiceDuration;


@end
