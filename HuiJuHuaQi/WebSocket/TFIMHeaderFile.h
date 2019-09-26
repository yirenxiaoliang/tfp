//
//  TFIMHeaderFile.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/11/21.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#ifndef TFIMHeaderFile_h
#define TFIMHeaderFile_h

/** 得到消息 */
#define SocketDidReceiveMessage @"SocketDidReceiveMessage"
/** 连接成功 */
#define SocketStatusNormal @"SocketStatusNormal"
/** 未连接 */
#define SocketStatusNOConnent @"SocketStatusNOConnent"
/** 正在连接 */
#define SocketStatusConnecting @"SocketStatusConnecting"
/** 接收历史消息 */
#define SocketStatusReceiving @"SocketStatusReceiving"

typedef enum  {
    
    SocketStatusCodeNormal,    // 连接正常
    SocketStatusCodeNOConnent, // 未连接
    SocketStatusCodeConnecting,// 正在连接
    SocketStatusCodeReceiving  // 接收历史消息
    
} SocketStatusCode;























#endif /* TFIMHeaderFile_h */
