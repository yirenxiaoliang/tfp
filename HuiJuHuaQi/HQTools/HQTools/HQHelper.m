
//
//  HQHelper.m
//  HuiJuHuaQi
//
//  Created by XieLB on 16/1/14.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQHelper.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "NSDate+Calendar.h"
#import "NSDate+NSString.h"
#import "lame.h"
#import "Reachability.h"
#import "StitchingImage.h"
#import "HQMD5Encrypt.h"
#import "TFFieldNameModel.h"
#import "TFAssistantFieldInfoModel.h"
#import "HQAreaManager.h"
#import "AFNetworkReachabilityManager.h"
#import "AlertView.h"
#import <NetworkExtension/NetworkExtension.h>
#import "FileManager.h"
#import <sys/utsname.h>
@implementation HQHelper


+ (UIImage*) createImageWithColor: (UIColor*) color
{
    
    return [self createImageWithColor:color size:(CGSize){1,1}];
}

+ (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

+ (UIImageView *)imageViewWithFrame:(CGRect)frame
                              image:(UIImage *)image
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = image;
    return imageView;
}



+ (UILabel *)labelWithFrame:(CGRect)frame
                       text:(NSString *)text
                  textColor:(UIColor *)color
              textAlignment:(NSTextAlignment)alignment
                       font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.textColor = color;
    label.textAlignment = alignment;
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
//    label.backgroundColor = WhiteColor;
    return label;
}

+ (UIButton *)buttonWithFrame:(CGRect)frame
                       target:(id)target
                       action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}


+ (UIButton *)buttonWithFrame:(CGRect)frame
               normalImageStr:(NSString *)normalImageStr
                 highImageStr:(NSString *)highImageStr
                       target:(id)target
                       action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setImage:[UIImage imageNamed:normalImageStr] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highImageStr]   forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}



+ (UIButton *)buttonWithFrame:(CGRect)frame
               normalImageStr:(NSString *)normalImageStr
              seletedImageStr:(NSString *)seletedImageStr
                 highImageStr:(NSString *)highImageStr
                       target:(id)target
                       action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setImage:[UIImage imageNamed:normalImageStr] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:seletedImageStr] forState:UIControlStateSelected];
    
    [button setImage:[UIImage imageNamed:highImageStr]   forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}




//+ (UIButton *)buttonOfMainButtonWithFrame:(CGRect)frame
//                                    title:(NSString *)title
//                                   target:(id)target
//                                   action:(SEL)action
//{
//    return [self buttonOfMainButtonWithFrame:frame
//                                       title:title normalColor:GreenNormalColor
//                                   highColor:GreenHighColor
//                               disabledColor:CannotDidColor
//                                  titleColor:WhiteColor
//                               disTitleColor:LightGrayTextColor
//                                        font:[UIFont systemFontOfSize:16]
//                                      target:target action:action];
//}


+ (UIButton *)buttonOfMainButtonWithFrame:(CGRect)frame
                                    title:(NSString *)title
                              normalColor:(UIColor *)normalColor
                                highColor:(UIColor *)highColor
                            disabledColor:(UIColor *)disabledColor
                               titleColor:(UIColor *)titleColor
                            disTitleColor:(UIColor *)disTitleColor
                                     font:(UIFont *)font
                                   target:(id)target
                                   action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button.titleLabel setFont:font];
    [button setFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:disTitleColor forState:UIControlStateDisabled];
    [button setTitleColor:titleColor    forState:UIControlStateNormal];
    [button setBackgroundImage:[HQHelper createImageWithColor:normalColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[HQHelper createImageWithColor:highColor] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[HQHelper createImageWithColor:highColor] forState:UIControlStateSelected];
    [button setBackgroundImage:[HQHelper createImageWithColor:disabledColor] forState:UIControlStateDisabled];
//    button.layer.masksToBounds = YES;
//    button.layer.cornerRadius = 2;
//    button.exclusiveTouch = YES;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}


+ (UIBarButtonItem *)itemWithSize:(CGSize)size title:(NSString *)title titleColor:(UIColor *)titleColor target:(id)target selector:(SEL)selector{
    //定义导航右侧按钮
    UIButton *btn = [[UIButton alloc] init];
    btn.size = size;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

//返回文本行数
+ (int)returnLineNumberOfString:(NSString *)textStr font:(UIFont *)textFont textWidth:(float)textWidth
{
    if (textStr == nil || [textStr isEqualToString:@""]) {
        return 0;
    }
    // iOS7中用以下方法替代过时的iOS6中的sizeWithFont:constrainedToSize:lineBreakMode:方法
    CGRect tmpRect = [textStr boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:textFont,NSFontAttributeName, nil] context:nil];
    
//    const char* test = [textStr cStringUsingEncoding:NSASCIIStringEncoding];
//    
//    if (test==nil) {
//        return 0;
//    }
//    int len = strlen(test);
    
    CGRect someRect = [@"字" boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:textFont,NSFontAttributeName, nil] context:nil];
    
    
    int lineNum = (int)(tmpRect.size.height/someRect.size.height);   //几行
    
    return lineNum;
}


//字节长度
+ (int)charNumber:(NSString*)strtemp
{
    
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
}


//将字符串保留到最大字符数
+ (NSString *)returnCharLengthStr:(NSString*)strtemp withMaxNum:(NSInteger)maxNum
{
    while ([HQHelper charNumber:strtemp] > maxNum) {
        strtemp = [strtemp substringToIndex:strtemp.length-1];
    }
    return strtemp;
}


// 保留最大行数字符串
+ (NSString *)saveMaxRowStringWithCharLengthStr:(NSString*)strtemp
                                           font:(UIFont *)font
                                      textWidth:(float)textWidth
                                     withMaxNum:(NSInteger)maxNum
{
    while ([HQHelper returnLineNumberOfString:strtemp font:font textWidth:textWidth] > maxNum) {
        strtemp = [strtemp substringToIndex:strtemp.length-1];
    }
    return strtemp;
}


//检查手机号码
+ (BOOL)checkTel:(NSString *)str
{
    if ([str length] != 11) {
        return NO;
    }

    NSString *regex = @"^\\d{11}$";
//    NSString *regex = @"^(17[0|1|6|7|8]|13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\\d{8}$";
//    @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    
    
    return isMatch;
}


//检查邮箱
+ (BOOL)checkEmail:(NSString *)str
{
    if ([str length] == 0) {
        return NO;
    }
    
    NSString *regex = @"^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    
    
    return isMatch;
}

/** 检查是否为网址 */
+ (BOOL)checkUrl:(NSString *)str
{
    if ([str length] == 0) {
        return NO;
    }
    
//    NSString *regex = @"^(https?|ftp|file)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]";
    NSString *regex = @"((http|ftp|https):\\/\\/[\\w\\-_]+(\\.[\\w\\-_]+)+([\\w\\-\\.,@?^=%&amp;:/~\\+#]*[\\w\\-\\@?^=%&amp;/~\\+#])?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    
    
    return isMatch;
}

//检查密码
+(BOOL)checkPassWord:(NSString *)str{
    
    if ([str length]<6) {
        return NO;
    }
    
    return YES;
}


//检查验证码
+(BOOL)checkSure:(NSString *)str{
    
    if ([str length]!=6) {
        return NO;
    }
    
    return YES;
}



/**
 *  保留位数
 *
 *  @param figure  小数点前位数
 *  @param decimal 小数点后位数
 *  @param textStr 要处理的文本
 *
 *  @return
 */
+ (NSString *)checkNumberSizeWithFigure:(NSInteger)figure
                                decimal:(NSInteger)decimal
                                textStr:(NSString *)textStr
{

    
    NSArray *array = [textStr componentsSeparatedByString:@"."];
    
    NSString *integerStr = array[0];
    NSString *decimalStr = @"";
    if (array.count == 2) {
        
        decimalStr = array[1];
    }
    
    
    if ([integerStr doubleValue] >= pow(10, figure)) {
        
        integerStr = [integerStr substringToIndex:figure];
    }
    
    if (decimalStr.length > decimal) {
        
        decimalStr = [decimalStr substringToIndex:decimal];
    }
    
    if (array.count == 2) {
        
        textStr = [NSString stringWithFormat:@"%@.%@", integerStr, decimalStr];
    }else {
        
        textStr = [NSString stringWithFormat:@"%@", integerStr];
    }
    

    return textStr;
}




//验证码计时按钮
+(void)timeBtn:(UIButton *)button
{
    __block int timeout=119; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [button setTitle:@"重发验证码" forState:UIControlStateNormal];
                
                button.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 120;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //                HQLog(@"%@",strTime);
                [button setTitle:[NSString stringWithFormat:@"%@秒后重发",strTime] forState:UIControlStateNormal];
                
                button.userInteractionEnabled = NO;
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

/** 倒计时 */
+(void)backTimeText:(UILabel *)label
{
    __block int timeout=119; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                label.text = [NSString stringWithFormat:@"%d", 10];
                
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 120;
            NSString *strTime = [NSString stringWithFormat:@"%d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //                HQLog(@"%@",strTime);
                
                label.text = strTime;
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}



/** 获取WIFI名 */
+ (NSString *)getWifiName
{

    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    HQLog(@"Supported interfaces: %@", ifs);
    id info = nil;
    
    NSString * wifiName= nil;
    NSString * macAdress= nil;
    for (NSString *ifnam in ifs) {
        
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        
        if (info && [info count]) break;
        
        wifiName = [info[@"SSID"] nullProcess];// WIFI名
        macAdress = [info[@"BSSID"] nullProcess];// MAC地址
        HQLog(@"支持的WiFiName%@ => MacAdress%@", wifiName, macAdress);
        
    }
    
    return wifiName;
}

/** 获取已连接WIFI信息
 *
 *  return  WiFi信息（WIFI名，MAC地址）
 *  WiFiName键-->WIFI名
 *  MacAddress键-->MAC地址
 */
+ (NSDictionary *)getCurrentWiFiInfo
{
    
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    HQLog(@"Supported interfaces: %@", ifs);
    id info = nil;
    
    NSMutableDictionary *dict = nil;
    NSString * wifiName= nil;
    NSString * macAddress= nil;
    for (NSString *ifnam in ifs) {
        
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        
        wifiName = [info[@"SSID"] nullProcess];// WIFI名
        macAddress = [info[@"BSSID"] nullProcess];// MAC地址
        NSArray *macItems = [macAddress componentsSeparatedByString:@":"];
        NSString *totalMac = @"";
        for (NSInteger i = 0; i < macItems.count; i++) {
            NSString *str = macItems[i];
            if (str.length == 1) {
                str = [NSString stringWithFormat:@"0%@",str];
            }
            totalMac = [totalMac stringByAppendingString:[NSString stringWithFormat:@"%@:",str]];
        }
        if (totalMac.length > 0) {
            macAddress = [totalMac substringToIndex:totalMac.length-1];
        }
        HQLog(@"支持的WiFiName == %@ ; MacAddress == %@", wifiName, macAddress);
        
        if (info && [info count]) break;
    }
    
    if (wifiName && macAddress) {
        
        dict = [NSMutableDictionary dictionary];
        [dict setObject:wifiName forKey:@"WiFiName"];
        [dict setObject:macAddress forKey:@"MacAddress"];
    }
    
    return dict;
}


/**
 *  返回文字的SIZE
 *
 *  @prama font 字体大小
 *  @prama maxSize 指定区域
 *  @prama titleStr 字符串
 */
+ (CGSize)sizeWithFont:(UIFont*)font maxSize:(CGSize)maxSize titleStr:(NSString *)titleStr
{
    CGSize contentSize = CGSizeZero;
    
    if (!font) {
        return contentSize;
    }
    
    if (titleStr && titleStr.length > 0)
    {
        NSDictionary *attribute = @{NSFontAttributeName:font};
        contentSize = [titleStr boundingRectWithSize:maxSize options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    }
    return contentSize;
}

/**
 *  返回文字的SIZE
 *
 *  @prama attribute 字符串属性
 *  @prama maxSize 指定区域
 *  @prama titleStr 字符串
 */
+ (CGSize)sizeWithAttributeDictionary:(NSDictionary*)attribute maxSize:(CGSize)maxSize titleStr:(NSString *)titleStr
{
    CGSize contentSize = CGSizeZero;
    if (titleStr && titleStr.length > 0)
    {
        contentSize = [titleStr boundingRectWithSize:maxSize options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    }
    return contentSize;
}






/**************************    判断文本是否合法    **********************/

//判断文本是否合法(中文、英文、数字 特殊符号)
+ (BOOL)textIsLegitimateWithStr:(NSString *)textStr
{
    for (int i=0; i<textStr.length; i++) {
        
        NSString *subStr = [textStr substringWithRange:NSMakeRange(i, 1)];
        
        NSString *phoneRegex = @"^[a-zA-Z0-9\u4e00-\u9fa5\\-\\/\\:\\;\\(\\)\\$\\&\\@\\\"\\\"\\“\\”\\.\\。\\、\\,\\?\\!\\'\\[\\]\\{\\}\\#\\%\\^\\*\\+\\=\\_\\—\\\\\\|\\~\\<\\>\\€\\£\\¥\\•\\【\\】\\《\\》\\^\\……\\…\\…\\…\\…\\·\\ \\➋\\➌\\➍\\➎\\➏\\➐\\➑\\➒\\☻\\——\\！\\；\\‘\\，\\：\\（\\）\\\r\\\t\\\n]$";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
        
        if (![phoneTest evaluateWithObject:subStr] && ![subStr isEqualToString:@"…"]) {
            return NO;
            break;
        }
    }
    
    return YES;
}



//汉字、字母、数字、括号和下划线；
+ (BOOL)textAndLineIsLegitimateWithStr:(NSString *)textStr
{
    for (int i=0; i<textStr.length; i++) {
        
        NSString *subStr = [textStr substringWithRange:NSMakeRange(i, 1)];
        
        NSString *phoneRegex = @"^[a-zA-Z0-9\u4e00-\u9fa5\\(\\)\\_]$";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
        
        if (![phoneTest evaluateWithObject:subStr]) {
            return NO;
            break;
        }
    }
    
    return YES;
}


//汉字，字母、数字
+ (BOOL)checkChineseNumberAndLettersWithStr:(NSString *)textStr
{
    for (int i=0; i<textStr.length; i++) {
        
        NSString *subStr = [textStr substringWithRange:NSMakeRange(i, 1)];
        
        NSString *phoneRegex = @"^[a-zA-Z0-9\u4e00-\u9fa5]$";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
        
        if (![phoneTest evaluateWithObject:subStr]) {
            return NO;
            break;
        }
    }
    
    return YES;
}



//汉字，字母
+ (BOOL)checkChineseAndLettersWithStr:(NSString *)textStr
{
    for (int i=0; i<textStr.length; i++) {
        
        NSString *subStr = [textStr substringWithRange:NSMakeRange(i, 1)];
        
        NSString *phoneRegex = @"^[a-zA-Z\u4e00-\u9fa5]$";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
        
        if (![phoneTest evaluateWithObject:subStr]) {
            return NO;
            break;
        }
    }
    
    return YES;
}



//字母、数字或下划线
+ (BOOL)numberAndLineIsLegitimateWithStr:(NSString *)textStr
{
    for (int i=0; i<textStr.length; i++) {
        
        NSString *subStr = [textStr substringWithRange:NSMakeRange(i, 1)];
        
        NSString *phoneRegex = @"^[a-zA-Z0-9\\_]$";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
        
        if (![phoneTest evaluateWithObject:subStr]) {
            return NO;
            break;
        }
    }
    
    return YES;
}



//字母、数字或下划线
+ (BOOL)numberWithStr:(NSString *)textStr
{
    for (int i=0; i<textStr.length; i++) {
        
        NSString *subStr = [textStr substringWithRange:NSMakeRange(i, 1)];
        
        NSString *phoneRegex = @"^[0-9\\-]$";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
        
        if (![phoneTest evaluateWithObject:subStr]) {
            return NO;
            break;
        }
    }
    
    return YES;
}






/**************************    时间处理    **********************/

/**
 *  获取当前时间戳
 *
 *  @return 时间戳（毫秒数）
 */
+ (long long)getNowTimeSp
{
   return  [[NSDate date] timeIntervalSince1970]*1000;
}
/**
 *  获取date下时间戳
 *  
 *  @prama date 时间
 *  @return 时间戳（毫秒数）
 */
+ (long long)getTimeSpWithDate:(NSDate *)date{
    return [date timeIntervalSince1970]*1000;
}

/**
 *  时间戳按HH:mm格式时间输出
 *
 *  @prama spString 时间戳（毫秒数）
 *  @return 时间字符串（HH:mm）
 */
+ (NSString*)nsdateToTime:(long long)timeSp{
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeSp/1000];
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    //    @"yyyy-MM-dd HH:mm:ss"
    [dateFormat setDateFormat:@"HH:mm"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormat setTimeZone:timeZone];
    NSString* string=[dateFormat stringFromDate:date];
    return string;
}

/**
 *  时间戳按HH:mm格式时间输出
 *
 *  @prama spString 时间戳（毫秒数）
 *  @return 时间字符串（MM月dd日）
 */
+ (NSString*)nsdateToTime2:(long long)timeSp {

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeSp/1000];
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    //    @"yyyy-MM-dd HH:mm:ss"
    [dateFormat setDateFormat:@"MM月dd日"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormat setTimeZone:timeZone];
    NSString* string=[dateFormat stringFromDate:date];
    return string;
}

/*  
 * 获取指定时间的下一天时间戳
 *
 *  @prama timeSp 时间戳（毫秒数）
 *  @return 下一天时间戳（毫秒数）
 */
+ (long long)getTomorrowWith:(long long)timeSp
{
    NSString *time = [HQHelper nsdateToTime:timeSp+24*60*60*1000 formatStr:@"yyyy/MM/dd"];
    time = [NSString stringWithFormat:@"%@ 00:00:00", time];
    return [HQHelper changeTimeToTimeSp:time formatStr:@"yyyy/MM/dd HH:mm:ss"] * 1000;
}


/*
 * 将时间戳按指定格式时间输出
 *
 *  @prama spString 时间戳（毫秒数）
 *  @prama formatStr 时间格式
 *  @return 时间格式的字符串
 */
+ (NSString*)nsdateToTime:(long long)timeSp formatStr:(NSString *)formatStr
{
    if (timeSp == 0) {
        return @"";
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeSp/1000];
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    //    @"yyyy-MM-dd HH:mm:ss"
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormat setTimeZone:timeZone];
    [dateFormat setDateFormat:formatStr];
    NSString* string=[dateFormat stringFromDate:date];
    
    return string;
}

/*
 * 将时间戳以年周时间格式输出
 *
 *  @prama interval 时间戳（毫秒数）
 *  @return 年周时间格式字符串
 */
+ (NSString *)getYearWeekWithInterVal:(long long)timeSp{
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeSp/1000];
    
    return [self getYearWeekWithDate:date];
}

/*
 * 将时间戳以年周时间格式输出
 *
 *  @prama interval 时间戳（毫秒数）
 *  @return 年周时间格式字符串
 */
+ (NSString *)getYearWeekWithInterVal2:(long long)timeSp{
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeSp/1000];
    
    return [self getYearWeekWithDate2:date];
}

/**
 *  将时间戳按今年MM/dd HH:mm，今年以前yyyy/MM/dd HH:mm格式时间输出
 *
 *  @prama timeSp 时间戳（毫秒数）
 *  @return 时间格式字符串
 *
 */
+ (NSString*)nsdateToTimeNowYear:(long long)timeSp
{
    
    if (timeSp == 0) {
        return @"";
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeSp/1000];
    NSDate *nowYearDate = [NSDate date];
    
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormat setTimeZone:timeZone];
    
    if (date.year == nowYearDate.year) {
        
        [dateFormat setDateFormat:@"MM/dd HH:mm"];
    }else {
    
        [dateFormat setDateFormat:@"yyyy/MM/dd HH:mm"];
    }
    
    NSString* string=[dateFormat stringFromDate:date];
    return string;
}

/**
 *  将时间戳按今天HH:mm，今年非今年MM/dd HH:mm ,今年以前yyyy/MM/dd HH:mm格式时间输出
 *
 *  @prama timeSp 时间戳（毫秒数）
 *  @return 时间格式字符串
 *
 */
+ (NSString*)nsdateToTimeNowYearNowMonthNowDay:(long long)timeSp
{
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeSp/1000];
    NSDate *nowYearDate = [NSDate date];
    
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormat setTimeZone:timeZone];
    
    if (date.year == nowYearDate.year) {
        
        if (date.month == nowYearDate.month) {
            if (date.day == nowYearDate.day) {
                [dateFormat setDateFormat:@"HH:mm"];
            }else{
                [dateFormat setDateFormat:@"MM/dd HH:mm"];
            }
        }else{
            [dateFormat setDateFormat:@"MM/dd HH:mm"];
        }
        
    }else {
        
        [dateFormat setDateFormat:@"yyyy/MM/dd HH:mm"];
    }
    NSString* string=[dateFormat stringFromDate:date];
    return string;
}

/** 企业圈时间 
 *
 * @param timeSp 时间戳毫秒数
 */
+ (NSString*)companyCircleTimeWithTimeSp:(long long)timeSp
{
    long long nowTimeSp = [HQHelper getNowTimeSp];
    NSInteger seconds = (NSInteger)(nowTimeSp-timeSp)/1000;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeSp/1000];
    NSDate *nowYearDate = [NSDate date];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = -1;
    NSDate *yesterday = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:nowYearDate options:0];
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormat setTimeZone:timeZone];
    
    if ([date sameDayWithDate:nowYearDate]) {// 今天
        
        if (seconds <= 60) {
            
            return @"刚刚";
        }else if (seconds <= 60 * 60) {
            
            return [NSString stringWithFormat:@"%ld分钟前", seconds / 60];
        }else{
            
            return [NSString stringWithFormat:@"%ld小时前", seconds / 3600];
        }
        
    }else if ([date sameDayWithDate:yesterday]){// 昨天
        
        [dateFormat setDateFormat:@"昨天 HH:mm"];
    
        return [dateFormat stringFromDate:date];
        
    }else{
        
        return [self nsdateToTimeNowYear:timeSp];
        
    }
    
}

/**
 * @prama timeStr 时间字符串（默认时间格式为yyyy-MM-dd HH:mm:ss）
 * @return 时间戳（毫秒数）
 */
+ (long long)changeTimeToTimeSp:(NSString *)timeStr{
    long long time;
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *fromdate=[format dateFromString:timeStr];
    
   NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [format setTimeZone:timeZone];
    time= (long long)[fromdate timeIntervalSince1970]*1000;
    return time;
}


/**
 * @prama timeStr 时间字符串
 * @prama timeStr 时间字符串对应的格式（eg.12:29对应HH:mm,2015/09/12 12:29对应yyyy/MM/dd HH:mm）
 * @return 时间戳（毫秒数）
 */
+ (long long)changeTimeToTimeSp:(NSString *)timeStr formatStr:(NSString *)formatStr
{
    long long time = 0;
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:formatStr];
    NSDate *fromdate=[format dateFromString:timeStr];
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [format setTimeZone:timeZone];
    time= (long long)[fromdate timeIntervalSince1970]*1000;
    return time;
}



/** 
 *  将某年某周转化为时间戳（yyyy年02ld周）
 *
 *  @prama timeStr 时间字符串（符合yyyy年02ld周格式的字符串）
 *  @return 时间戳（毫秒数）
 */
+ (long long)changeWeekTimeToTimeSp:(NSString *)timeStr{
    
    NSAssert(timeStr.length == 7, @"不符合yyyy年02ld周格式");
    
    NSString *year = [timeStr substringWithRange:NSMakeRange(0, 4)];
    NSString *week = [timeStr substringWithRange:NSMakeRange(5, 2)];
    
    HQLog(@"%@------%@", year, week);
    NSInteger month = [week integerValue] * 7 / 30;
    NSMutableArray *months = [NSMutableArray array];
    if (month == 0) {
        [months addObject:[NSNumber numberWithInteger:month + 1]];
        [months addObject:[NSNumber numberWithInteger:month + 2]];
    }else if (month == 12){
        [months addObject:[NSNumber numberWithInteger:month - 1]];
        [months addObject:[NSNumber numberWithInteger:month]];
    }else{
        [months addObject:[NSNumber numberWithInteger:month - 1]];
        [months addObject:[NSNumber numberWithInteger:month]];
        [months addObject:[NSNumber numberWithInteger:month + 1]];
    }
    
    NSMutableArray *days = [NSMutableArray array];
    for (NSInteger i = 1; i < 32; i ++) {
        [days addObject:[NSNumber numberWithInteger:i]];
    }
    NSString *wantTime = nil;
    for (NSInteger index = [[months firstObject] integerValue]; index < [[months firstObject] integerValue] + months.count; index ++) {
        for (NSInteger day = [[days firstObject] integerValue]; day < [[days firstObject] integerValue] + days.count; day ++) {
            NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
            [dateFormat setDateFormat:@"yyyy/MM/dd HH:mm"];
            NSString *time = [NSString stringWithFormat:@"%@/%02ld/%02ld 12:00", year, index, day];
            NSDate *yearDate = [dateFormat dateFromString:time];
            HQLog(@"%ld", [yearDate week11]);
            if ([yearDate week11] == [week integerValue]) {
                wantTime = time;
                break;
            }
        }
    }
    return [self changeTimeToTimeSp:wantTime formatStr:@"yyyy/MM/dd HH:mm"] * 1000;
}

/**
*  将某年某周转化为该周第一天的年月日
*
*  @prama timeStr 时间字符串（符合yyyy年02ld周格式的字符串）
*  @return 该周第一天的年月日(yyyy/MM/dd)
*/
+ (NSString *)changeWeekTimeToTime:(NSString *)timeStr{
    
    NSAssert(timeStr.length == 7, @"不符合yyyy年02ld周格式");
    
    NSString *year = [timeStr substringWithRange:NSMakeRange(0, 4)];
    NSString *week = [timeStr substringWithRange:NSMakeRange(5, 2)];
    HQLog(@"%@------%@", year, week);
    NSInteger month = [week integerValue] * 7 / 30;
    NSMutableArray *months = [NSMutableArray array];
    if (month == 0) {
        [months addObject:[NSNumber numberWithInteger:month + 1]];
        [months addObject:[NSNumber numberWithInteger:month + 2]];
    }else if (month == 12){
        [months addObject:[NSNumber numberWithInteger:month - 1]];
        [months addObject:[NSNumber numberWithInteger:month]];
    }else{
        [months addObject:[NSNumber numberWithInteger:month - 1]];
        [months addObject:[NSNumber numberWithInteger:month]];
        [months addObject:[NSNumber numberWithInteger:month + 1]];
    }
    
    NSMutableArray *days = [NSMutableArray array];
    for (NSInteger i = 1; i < 29; i ++) {
        [days addObject:[NSNumber numberWithInteger:i]];
    }
    NSString *wantTime = nil;
    for (NSInteger index = [[months firstObject] integerValue]; index < [[months firstObject] integerValue] + months.count; index ++) {
        for (NSInteger day = [[days firstObject] integerValue]; day < days.count; day ++) {
            NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
            [dateFormat setDateFormat:@"yyyy/MM/dd"];
            NSString *time = [NSString stringWithFormat:@"%@/%02ld/%02ld", year, index, day];
            NSDate *yearDate = [dateFormat dateFromString:time];
            if ([yearDate week11] == [week integerValue]) {
                wantTime = time;
                break;
            }
        }
    }
    return wantTime;
}




//获取当前系统的yyyy-MM-dd HH:mm:ss格式时间
+ (NSString *)getTime{
    NSDate *fromdate=[NSDate date];
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormat setTimeZone:timeZone];
    NSString* string=[dateFormat stringFromDate:fromdate];
    return string;
}

//获取当前系统的yyyy-MM-dd格式时间
+ (NSString *)getTime2{
    NSDate *fromdate=[NSDate date];
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormat setTimeZone:timeZone];
    NSString* string=[dateFormat stringFromDate:fromdate];
    return string;
}

/**获取文件大小**/
+ (long long) fileSizeAtPath:(NSString*) filePath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}



+(NSString *)fileSizeForUnit:(NSString*) filePath{
    
    NSString * fileSize = nil;
    HQLog(@"%lld", [self fileSizeAtPath:filePath]);
    if ([self fileSizeAtPath:filePath] > 1024 *1024) {
        
        fileSize = [NSString stringWithFormat:@"%0.2fMB",[self fileSizeAtPath:filePath]/(1024.0*1024)];
        
    }else if ([self fileSizeAtPath:filePath] >1024) {
        
        fileSize = [NSString stringWithFormat:@"%.2fKB",[self fileSizeAtPath:filePath]/ 1024.0];
        
    }else{
        
        fileSize = [NSString stringWithFormat:@"%lldB",[self fileSizeAtPath:filePath]];
        
    }
    
    return fileSize;
    
}

/** 文件大小B-->合适的单位 */
+(NSString *)fileSizeForKB:(NSInteger)file{
    
    NSString * fileSize = nil;
    
    if (file > 1024 *1024) {
        
        fileSize = [NSString stringWithFormat:@"%0.2fMB",file/(1024.0*1024)];
        
    }else if (file >1024) {
        
        fileSize = [NSString stringWithFormat:@"%.1fKB",file/ 1024.0];
        
    }else{
        
        fileSize = [NSString stringWithFormat:@"%ldB",file];
        
    }
    
    return fileSize;
    
}


//遍历文件夹获得文件夹大小，返回多少M

+(float) folderSizeAtPath:(NSString*) folderPath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:folderPath]) return 0;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    
    NSString* fileName;
    
    long long folderSize = 0;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
        
    }
    
    return folderSize/(1024.0*1024.0);
    
}






/** 获取年周（yyyy年02ld周） */
+ (NSString *)getYearWeek{
    NSDate *fromdate=[NSDate date];
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy年"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormat setTimeZone:timeZone];
    NSString* year=[dateFormat stringFromDate:fromdate];
    return [NSString stringWithFormat:@"%@%02ld周",year, [fromdate week11]];
}

/** 获取年周（yyyy年02ld周） */
+ (NSString *)getYearWeekWithDate:(NSDate *)date{
    NSDate *fromdate=date;
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy年"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormat setTimeZone:timeZone];
    NSString* year=[dateFormat stringFromDate:fromdate];
    return [NSString stringWithFormat:@"%@%02ld周",year, [fromdate week11]];
}

/** 获取年周（yyyy年第02ld周） */
+ (NSString *)getYearWeekWithDate2:(NSDate *)date{
    NSDate *fromdate=date;
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy年"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormat setTimeZone:timeZone];
    NSString* year=[dateFormat stringFromDate:fromdate];
    return [NSString stringWithFormat:@"%@第%02ld周",year, [fromdate week11]];
}

/** 获取年月（yyyy年MM月） */
+ (NSString *)getYearMonth{
    NSDate *fromdate=[NSDate date];
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy年MM月"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormat setTimeZone:timeZone];
    return [dateFormat stringFromDate:fromdate];
}

/** 将当前时间转为MM月dd日 */
+ (NSString *)getMonthDay{
    NSDate *fromdate=[NSDate date];
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"MM月dd日"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormat setTimeZone:timeZone];
    return [dateFormat stringFromDate:fromdate];
}

/** 将date转为年（yyyy年） */
+ (NSString *)getYear:(NSDate *)date{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy年"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormat setTimeZone:timeZone];
    return [dateFormat stringFromDate:date];
}

/** 将当前时间转为年（yyyy年） */
+ (NSString *)getYear{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy年"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormat setTimeZone:timeZone];
   return [dateFormat stringFromDate:[NSDate date]];
}
/** 将当前时间转为月（MM月） */
+ (NSString *)getMonth{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"MM月"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormat setTimeZone:timeZone];
    return [dateFormat stringFromDate:[NSDate date]];
}

/** 将当前时间转为日（dd日） */
+ (NSString *)getDay{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"dd日"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormat setTimeZone:timeZone];
    return [dateFormat stringFromDate:[NSDate date]];
}


/** 将当前时间转为天（dd） */
+ (NSString *)getNowDay{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"dd"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormat setTimeZone:timeZone];
    return [dateFormat stringFromDate:[NSDate date]];
}

/** 将当前时间转为时（HH） */
+ (NSString *)getHour{
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"HH"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormat setTimeZone:timeZone];
    return [dateFormat stringFromDate:[NSDate date]];
}
/** 将当前时间转为分（mm） */
+ (NSString *)getMiute{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"mm"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormat setTimeZone:timeZone];
    return [dateFormat stringFromDate:[NSDate date]];
}

/** 将当前时间转为周几（周五） */
+ (NSString *)getWeekday{
    NSString *weekStr = nil;
    if ([[NSDate date] weekday] == 1) {
        weekStr = @"周日";
    } else if ([[NSDate date] weekday] == 2){
        weekStr = @"周一";
    }else if ([[NSDate date] weekday] == 3){
        weekStr = @"周二";
    }else if ([[NSDate date] weekday] == 4){
        weekStr = @"周三";
    }else if ([[NSDate date] weekday] == 5){
        weekStr = @"周四";
    }else if ([[NSDate date] weekday] == 6){
        weekStr = @"周五";
    }else{
        weekStr = @"周六";
    }
    HQLog(@"%ld",[[NSDate date] weekday] );
    
    return weekStr;
}

/** 将当前时间转为星期几（星期五） */
+ (NSString *)getWeekday2{
    NSString *weekStr = nil;
    if ([[NSDate date] weekday] == 1) {
        weekStr = @"星期日";
    } else if ([[NSDate date] weekday] == 2){
        weekStr = @"星期一";
    }else if ([[NSDate date] weekday] == 3){
        weekStr = @"星期二";
    }else if ([[NSDate date] weekday] == 4){
        weekStr = @"星期三";
    }else if ([[NSDate date] weekday] == 5){
        weekStr = @"星期四";
    }else if ([[NSDate date] weekday] == 6){
        weekStr = @"星期五";
    }else{
        weekStr = @"星期六";
    }
    HQLog(@"%ld",[[NSDate date] weekday] );
    
    return weekStr;
}
/** 将当前时间转为星期几（星期五） */
+ (NSString *)getWeekday2WithDate:(NSDate *)dete{
    NSString *weekStr = nil;
    if ([dete weekday] == 1) {
        weekStr = @"星期日";
    } else if ([dete weekday] == 2){
        weekStr = @"星期一";
    }else if ([dete weekday] == 3){
        weekStr = @"星期二";
    }else if ([dete weekday] == 4){
        weekStr = @"星期三";
    }else if ([dete weekday] == 5){
        weekStr = @"星期四";
    }else if ([dete weekday] == 6){
        weekStr = @"星期五";
    }else{
        weekStr = @"星期六";
    }
    HQLog(@"%ld",[dete weekday] );
    
    return weekStr;
}

+ (NSString *)getDayWithDate:(NSDate *)date{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"dd日"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormat setTimeZone:timeZone];
    return [dateFormat stringFromDate:date];
}

+ (NSString *)getHourWithDate:(NSDate *)date{
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"HH"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormat setTimeZone:timeZone];
    return [dateFormat stringFromDate:date];
}
+ (NSString *)getMiuteWithDate:(NSDate *)date{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"mm"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormat setTimeZone:timeZone];
    return [dateFormat stringFromDate:date];
}

+ (NSString *)getWeekWithDate:(NSDate *)date{
    NSString *weekStr = nil;
    if ([date weekday] == 1) {
        weekStr = @"周日";
    } else if ([date weekday] == 2){
        weekStr = @"周一";
    }else if ([date weekday] == 3){
        weekStr = @"周二";
    }else if ([date weekday] == 4){
        weekStr = @"周三";
    }else if ([date weekday] == 5){
        weekStr = @"周四";
    }else if ([date weekday] == 6){
        weekStr = @"周五";
    }else{
        weekStr = @"周六";
    }
    HQLog(@"%ld",[date weekday] );
    
    return weekStr;
}

+ (NSString *)getMonthDayWithDate:(NSDate *)date{
    NSDate *fromdate= date;
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"MM月dd日"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormat setTimeZone:timeZone];
    return [dateFormat stringFromDate:fromdate];
}

+ (NSString *)getMonthDayWithDate2:(NSDate *)date{
    NSDate *fromdate= date;
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"MM-dd"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormat setTimeZone:timeZone];
    return [dateFormat stringFromDate:fromdate];
}

+ (NSString *)getYearMonthDayHourMiuthWithDate:(NSDate *)date{
    NSDate *fromdate= date;
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormat setTimeZone:timeZone];
    return [dateFormat stringFromDate:fromdate];
}

+ (NSString *)getYearMonthDayWithDate:(NSDate *)date{
    NSDate *fromdate= date;
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormat setTimeZone:timeZone];
    return [dateFormat stringFromDate:fromdate];
}

+ (NSString *)getHourMiuthWithDate:(NSDate *)date{
    NSDate *fromdate= date;
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"HH:mm"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormat setTimeZone:timeZone];
    return [dateFormat stringFromDate:fromdate];
}

/** 根据员工ID获取员工 */
+ (TFEmployeeCModel *)employeeWithEmployeeID:(NSNumber *)employeeID{
    
    TFUserLoginCModel *userLogin = UM.userLoginInfo;
    
    TFEmployeeCModel *em = nil;
    
    for (TFEmployeeCModel *employ in userLogin.employees) {

        if ([employ.id isEqualToNumber:employeeID]) {
            em = employ;
            break;
        }
    }
    return em;
}

/** 根据员工ID,signId获取员工 */
+ (TFEmployeeCModel *)employeeWithEmployeeID:(NSNumber *)employeeID signId:(NSNumber *)signId{
    
    TFUserLoginCModel *userLogin = UM.userLoginInfo;
    
    TFEmployeeCModel *em = nil;
    
    for (TFEmployeeCModel *employ in userLogin.employees) {
        
        if (employeeID) {
            
            if ([employ.id isEqualToNumber:employeeID]) {
                em = employ;
                break;
            }
        }
        
        if (signId) {
            
            if ([employ.sign_id isEqualToNumber:signId]) {
                em = employ;
                break;
            }
        }
    }
    return em;
}


/** 根据员工ID数组获取员工数组 */
+ (NSArray *)employeesWithEmployIds:(NSArray *)employeeIds
{
    NSMutableArray *employs = [NSMutableArray array];
    for (NSNumber *employId in employeeIds) {
        
        TFEmployeeCModel *employ = [HQHelper employeeWithEmployeeID:employId];
        if (employ) {
            [employs addObject:employ];
        }
    }
    return employs;
}

/** 获取当前登录用户信息 */
+ (TFEmployeeCModel *)getCurrentLoginEmployee{
    HQUserManager *user = [HQUserManager defaultUserInfoManager];
    TFUserLoginCModel *login = [user userLoginInfo];
    return login.employee;
}

/** 是否为自己 */
+ (BOOL)isMyselfWithEmployeeId:(NSNumber *)employeeId{
    
    if ([[self getCurrentLoginEmployee].id isEqualToNumber:employeeId]) {
        
        return YES;
    }else{
        return NO;
    }
    
}



/**获取图片区域的颜色**/

+ (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage {
    
    CGContextRef    context = NULL;
    
    CGColorSpaceRef colorSpace;
    
    void *          bitmapData;
    
    int             bitmapByteCount;
    
    int             bitmapBytesPerRow;
    
    size_t pixelsWide = CGImageGetWidth(inImage);
    
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    bitmapBytesPerRow   = (int)(pixelsWide * 4);
    
    bitmapByteCount     = (int)(bitmapBytesPerRow * pixelsHigh);
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if (colorSpace == NULL)
        
    {
        
        fprintf(stderr, "Error allocating color space\n");
        
        return NULL;
        
    }
    
    bitmapData = malloc( bitmapByteCount );
    
    if (bitmapData == NULL)
        
    {
        
        fprintf (stderr, "Memory not allocated!");
        
        CGColorSpaceRelease( colorSpace );
        
        return NULL;
        
    }
    
    context = CGBitmapContextCreate (bitmapData,
                                     
                                     pixelsWide,
                                     
                                     pixelsHigh,
                                     
                                     8,
                                     
                                     bitmapBytesPerRow,
                                     
                                     colorSpace,
                                     
                                     kCGImageAlphaPremultipliedFirst);
    
    if (context == NULL)
        
    {
        
        free (bitmapData);
        
        fprintf (stderr, "Context not created!");
        
    }
    
    CGColorSpaceRelease( colorSpace );
    
    return context;
    
}

/** 图片上某点的颜色值 */
+ (UIColor *)image:(UIImage *)image colorAtPixel:(CGPoint)point {
    // Cancel if point is outside image coordinates
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, image.size.width, image.size.height), point)) {
        return nil;
    }
    
    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
    CGImageRef cgImage = image.CGImage;
    NSUInteger width = image.size.width;
    NSUInteger height = image.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    // Draw the pixel we are interested in onto the bitmap context
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);
    
    // Convert color values [0..255] to floats [0.0..1.0]
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;

    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}


/** 设置tableView无数据时的背景提示 */
+ (void)setupBackgroudViewForTableView:(UITableView *)tableView withImageName:(NSString *)imageName titleText:(NSString *)titleText{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.frame = CGRectMake((180 - 95) *0.5, 0, 95, 95);
    imageView.centerX = tableView.centerX ;
    UILabel *lable = [[UILabel alloc] initWithFrame:(CGRect){0,95,SCREEN_WIDTH,55}];
    lable.font = FONT(17);
    lable.numberOfLines = 0;
    lable.textColor = HexAColor(0xbebec1, 1);
    lable.text = titleText;
    lable.textAlignment = NSTextAlignmentCenter;
    UIView *view = [[UIView alloc] init];
    view.size = CGSizeMake(SCREEN_WIDTH, 145);
    view.centerX = tableView.centerX ;
    view.centerY = (tableView.height)/2;
    [view addSubview:imageView];
    [view addSubview:lable];
    tableView.backgroundView = [[UIView alloc] initWithFrame:tableView.bounds];
    [tableView.backgroundView addSubview:view];
}

/** 设置tableView不在中心的背景提示 */
+ (void)setupBackgroudViewNotCenterTableView:(UITableView *)tableView withImageName:(NSString *)imageName titleText:(NSString *)titleText{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.frame = CGRectMake(27.5, 0, 95, 95);
    imageView.centerX = tableView.centerX ;
    UILabel *lable = [[UILabel alloc] initWithFrame:(CGRect){0,95,SCREEN_WIDTH,35}];
    lable.font = FONT(17);
    lable.textColor =  HexAColor(0xbebec1, 1);
    lable.text = titleText;
    lable.textAlignment = NSTextAlignmentCenter;
    UIView *view = [[UIView alloc] init];
    view.size = CGSizeMake(SCREEN_WIDTH, 135);
    view.centerX = tableView.centerX ;
    view.centerY = (SCREEN_HEIGHT )*3/5;
    if (SCREEN_WIDTH < 375) {
        
        view.centerY = (SCREEN_HEIGHT )*4/5;
    }
    [view addSubview:imageView];
    [view addSubview:lable];
    tableView.backgroundView = [[UIView alloc] initWithFrame:tableView.bounds];
    [tableView.backgroundView addSubview:view];
}

/** 设置tableView背景提示 */
+ (void)setupBackgroudViewForTableView:(UITableView *)tableView withPoint:(CGPoint)point withImageName:(NSString *)imageName titleText:(NSString *)titleText{
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    imageView.centerX = tableView.centerX ;
    UILabel *lable = [[UILabel alloc] initWithFrame:(CGRect){0,image.size.height + 20,SCREEN_WIDTH,35}];
    lable.font = FONT(17);
    lable.textColor =  HexAColor(0xbebec1, 1);
    lable.text = titleText;
    lable.textAlignment = NSTextAlignmentCenter;
    UIView *view = [[UIView alloc] init];
    view.size = CGSizeMake(SCREEN_WIDTH, image.size.height + 55);
    view.center = point;
    [view addSubview:imageView];
    [view addSubview:lable];
    tableView.backgroundView = [[UIView alloc] initWithFrame:tableView.bounds];
    [tableView.backgroundView addSubview:view];
}





/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (id)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    id dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        HQLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


/*!
 *  把字典转换成格式化的JSON格式的字符串
 */
+ (NSString*)dictionaryToJson:(id)data

{
    if (!data) {
        return nil;
    }
    
    NSError *parseError = nil;
    
    if ([data isKindOfClass:[NSData class]]) {
        
        HQLog(@"此处返回Data：%@",data);
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}



#pragma amrk - 录音转码
/**
 * @cafUrl  录音原始地址
 * @cafUrl  录音转为MP3地址
 * @return  返回MP3地址的url
 */
+ (NSURL *)recordCafToMp3WithCafUrl:(NSString *)cafUrl toMp3Url:(NSString *)mp3Url{
    
    return [NSURL URLWithString:cafUrl];
    
    NSString *cafFilePath = cafUrl;
    
    NSString *mp3FilePath = mp3Url;//存储mp3文件的路径
    
    NSFileManager* fileManager=[NSFileManager defaultManager];
    
    if([fileManager removeItemAtPath:mp3FilePath error:nil])
        
    {
        
        HQLog(@"删除");
        
    }
    
    @try {
        
        NSInteger read, write;
        
        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        
        if(pcm == NULL)
            
        {
            
            HQLog(@"file not found");
            
        }
        
        else
            
        {
            
            fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
            
            FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
            
            
            
            const int PCM_SIZE = 8192;
            
            const int MP3_SIZE = 8192;
            
            short int pcm_buffer[PCM_SIZE*2];
            
            unsigned char mp3_buffer[MP3_SIZE];
            
            
            
            lame_t lame = lame_init();
            
            lame_set_num_channels(lame,1);//设置1为单通道，默认为2双通道
            
            lame_set_in_samplerate(lame, 44100.0);
            
            lame_set_VBR(lame, vbr_default);
            
            lame_set_brate(lame,16);

            lame_set_mode(lame,3);

            lame_set_quality(lame,2); /* 2=high 5 = medium 7=low 音质*/
            
            lame_init_params(lame);
            
            
            
            do {
                
                read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
                
                if (read == 0)
                    
                    write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
                
                else
                    
                    write = (int)lame_encode_buffer_interleaved(lame, pcm_buffer, (int)read, mp3_buffer, MP3_SIZE);
                
                
                
                fwrite(mp3_buffer, write, 1, mp3);
                
                
                
            } while (read != 0);
            
            
            
            lame_close(lame);
            
            fclose(mp3);
            
            fclose(pcm);
            
        }
        
        return nil;
        
    }
    
    @catch (NSException *exception) {
        
        HQLog(@"%@",[exception description]);
        
        return nil;
        
    }
    
    @finally {
        return [NSURL URLWithString:mp3FilePath];
        HQLog(@"执行完成");
        
    }
    
}



//把装有字符串的数组转换成装有NSNumber的数组
+ (NSArray *)stringsChangeNumbers:(NSArray *)strings
{
    
    NSMutableArray *news = [NSMutableArray array];
    for (NSString *string in strings) {
        
        if ([string isKindOfClass:[NSString class]]) {
            
            [news addObject:@(string.longLongValue)];
        }else {
        
            [news addObject:string];
        }
    }
    
    return news;
}



///**网络状态监测**/
//
//- (void)checkCurrentWorknetStatus:(UIViewController *)viewCtr {
//    Reachability * reach = [Reachability reachabilityForInternetConnection];
//    NSString * tips = @"";
//    switch (reach.currentReachabilityStatus)
//    {
//        case NotReachable:
//            tips = @"无网络连接";
//            break;
//            
//        case ReachableViaWiFi:
//            tips = @"Wifi";
//            break;
//            
//        case ReachableViaWWAN:
//            NSLog(@"移动流量");
//        case kReachableVia2G:
//            tips = @"2G";
//            break;
//            
//        case kReachableVia3G:
//            tips = @"3G";
//            break;
//            
//        case kReachableVia4G:
//            tips = @"4G";
//            break;
//    }
//    
//   UIAlertController* ac = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"当前网络状态为:%@",tips] preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction * aa = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [ac dismissViewControllerAnimated:YES completion:nil];
//    }];
//    
//    [ac addAction:aa];
//    
//    [viewCtr presentViewController:ac animated:YES completion:nil];
//    
//    
//}


#pragma mark - 获得View上的图像
/** 获得View上的图像
 *
 *  @pram theView需要的获取的View
 */
+ (UIImage *)imageFromView:(UIView *)theView
{
    //    UIGraphicsBeginImageContext(theView.frame.size);
    UIGraphicsBeginImageContextWithOptions(theView.frame.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //    UIRectClip(theView.frame);
    //    CGContextSaveGState(context);
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

/*
 * 获得某个范围内的屏幕图像
 *
 *  @pram theView需要的获取的View
 *  @pram theView上的rect
 */
+ (UIImage *)imageFromView:(UIView *)theView atFrame:(CGRect)rect
{
    //    UIGraphicsBeginImageContext(theView.frame.size);
    UIGraphicsBeginImageContextWithOptions(theView.frame.size, NO,  0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //    UIRectClip(rect);
    //    CGContextSaveGState(context);
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(theImage.CGImage, rect);
    
    UIImage * img = [UIImage imageWithCGImage:imageRef];
    
    HQLog(@"%@", NSStringFromCGSize(img.size));
    
    //img = [self createNonInterpolatedUIImageFormCIImage:[CIImage imageWithCGImage:imageRef] withImgSize:rect.size];
    
    UIGraphicsEndImageContext();
    
    return  img;
}

/** 
 * 群聊头像（UIImageView）
 *
 * @pram images 群聊人员头像数组
 */
+ (UIImageView *)creatImageViewWtihImages:(NSArray *)images{
    
    return [self creatImageViewWtihImages:images withMargin:0];
}

/**
 * 群聊头像（UIImageView）
 *
 * @pram images 群聊人员头像数组
 * @pram margin 头像之间的间距
 */
+ (UIImageView *)creatImageViewWtihImages:(NSArray *)images withMargin:(CGFloat)margin{
    
    if (images == nil || images.count == 0) {
        
        [[StitchingImage alloc] stitchingOnImageView:[self canvasView] withImageViews:@[ChatDefaultHeadImage] marginValue:margin];
    }
    
    return [[StitchingImage alloc] stitchingOnImageView:[self canvasView] withImageViews:[self imageViewsWtihImages:images] marginValue:margin];
}

+ (UIImageView *)canvasView{
    UIImageView *canvasView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    canvasView.layer.cornerRadius = 0;
    canvasView.layer.masksToBounds = YES;
    canvasView.backgroundColor = GrayGroundColor;
    return canvasView;
}

+(NSArray *)imageViewsWtihImages:(NSArray *)images{
    
    UIImageView *canvasView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    canvasView.layer.cornerRadius = 0;
    canvasView.layer.masksToBounds = YES;
    canvasView.backgroundColor = GrayGroundColor;
    
    NSMutableArray *imageViews = [[NSMutableArray alloc] init];
    for (int index = 0; index < (images.count > 9 ? 9 : images.count) ; index++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        UIImage *image;
        if ([images[index] isKindOfClass:[UIImage class]]) {
            
            image = images[index];
        }else{
            
            image = [UIImage imageNamed:images[index]];
        }
        imageView.image = image;
        
        [imageViews addObject:imageView];
    }
    return imageViews;
}

/**
 * 群聊头像（UIImage）
 *
 * @pram images 群聊人员头像数组
 */
+ (UIImage *)creatImageWtihImages:(NSArray *)images{
    
    
    UIImageView *imageView = [self creatImageViewWtihImages:images];
    
    return [self imageFromView:imageView];
}

/**
 * 群聊头像（UIImage）
 *
 * @pram images 群聊人员头像数组
 * @pram margin 头像之间的间距
 */
+ (UIImage *)creatImageWtihImages:(NSArray *)images withMargin:(CGFloat)margin{
    
    
    UIImageView *imageView = [self creatImageViewWtihImages:images withMargin:margin];
    
    return [self imageFromView:imageView];
}

/** 
 *  将十六进制数值（#ad23a4/#Ad33BB/0XadAd33/0xAd33d4）转为颜色
 *  
 *  @prama color 十六进制数值字符串
 *  @prama alpha 透明度
 */
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{
    if (!color || color.length <= 0) {
        return nil;
    }
    
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
   
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if (!([cString length] == 6 || [cString length] == 8 || [cString length] == 3))
    {
        return nil;
    }
    if (cString.length == 3) {
        
        NSString *str = @"";
        str = [str stringByAppendingString:[cString substringWithRange:NSMakeRange(0, 1)]];
        str = [str stringByAppendingString:[cString substringWithRange:NSMakeRange(0, 1)]];
        str = [str stringByAppendingString:[cString substringWithRange:NSMakeRange(1, 1)]];
        str = [str stringByAppendingString:[cString substringWithRange:NSMakeRange(1, 1)]];
        str = [str stringByAppendingString:[cString substringWithRange:NSMakeRange(2, 1)]];
        cString = [str stringByAppendingString:[cString substringWithRange:NSMakeRange(2, 1)]];
        
    }
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
   
    // Scan values
    unsigned int r, g, b , a;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    //a
    if ([cString length] == 8) {
        range.location = 6;
        NSString *aString = [cString substringWithRange:range];
        [[NSScanner scannerWithString:aString] scanHexInt:&a];
        return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:((float)a / 255.0f)];
    }else{
        
        return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
    }
    
}
/**
 *  将十六进制数值（#ad23a4/#Ad33BB/0XadAd33/0xAd33d4）转为颜色
 *
 *   默认透明不为1.0f
 *  @prama color 十六进制数值字符串
 */
+ (UIColor *)colorWithHexString:(NSString *)color
{
    return [self colorWithHexString:color alpha:1];
}

/** 
 *  指定字符串生成二维码
 *
 * @param string   需要生成二维码的字符串
 * @param imgWidth 二维码图片宽度
 *
 */
+ (UIImage *)creatBarcodeWithString:(NSString *)string withImgWidth:(CGFloat)imgWidth{
    // 1.创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复默认
    [filter setDefaults];
    // 3.给过滤器添加数据(正则表达式/账号和密码)
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    // 4.获取输出的二维码
    CIImage *outputImage = [filter outputImage];
    // 5.将CIImage转换成UIImage，并放大显示
    return [self createNonInterpolatedUIImageFormCIImage:outputImage withImgWidth:imgWidth];
}

/**
 *  指定字符串生成条形码
 *
 * @param string   需要生成条形码的字符串
 * @param imgWidth 条形码图片宽度
 *
 */
+ (UIImage *)createBarWithString:(NSString *)string withImgWidth:(CGFloat)imgWidth{
    // 1.创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    // 2.恢复默认
    [filter setDefaults];
    // 3.给过滤器添加数据(正则表达式/账号和密码)
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    // 4.获取输出的二维码
    CIImage *outputImage = [filter outputImage];
    // 5.将CIImage转换成UIImage，并放大显示
    return [self createNonInterpolatedUIImageFormCIImage:outputImage withImgWidth:imgWidth];
}


/**
 * 根据CIImage生成指定大小的UIImage
 *
 * @param image CIImage
 * @param imgWidth 图片宽度
 */
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withImgWidth:(CGFloat)imgWidth
{   
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(imgWidth/CGRectGetWidth(extent), imgWidth/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

/**
 * 根据CIImage生成指定大小的UIImage
 *
 * @param image CIImage
 * @param imgSize 图片size
 */
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withImgSize:(CGSize)imgSize
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scaleW = imgSize.width/CGRectGetWidth(extent);
    CGFloat scaleH = imgSize.height/CGRectGetHeight(extent);
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scaleW;
    size_t height = CGRectGetHeight(extent) * scaleH;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scaleW, scaleH);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

#pragma mark **************
/********************************************/
/**
 *  计算字符串宽高
 *
 *  @param string   字符串
 *  @param cgsize
 *  @param wordFont 字体
 *
 *  @return
 */
+(CGSize)calculateStringWithAndHeight:(NSString *)string cgsize:(CGSize)cgsize wordFont:(UIFont *)wordFont;
{
    //计算大小
    UIFont *font = wordFont;
    //CGSize size = [string sizeWithFont:font constrainedToSize:CGSizeMake(cgsize.width, cgsize.height) lineBreakMode:NSLineBreakByWordWrapping];
    NSDictionary *attribute = @{NSFontAttributeName:font};
    CGSize size = [[NSString stringWithFormat:@"%@ ",string] boundingRectWithSize:CGSizeMake(cgsize.width, cgsize.height) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    
    return size;
}

/**
 *  设置边框和圆角,view:设置边框的视图,borderWith：边框的宽，radius：圆角半径，color：边框的颜色
 *
 *  @param view       设置边框的视图
 *  @param borderWith 边框的宽
 *  @param radius     圆角半径
 *  @param color      边框的颜色
 */
+(void)setBorderAndCorners:(UIView *)view borderWith:(CGFloat)borderWith radius:(CGFloat)radius color:(CGColorRef)color
{
    
    view.layer.borderWidth=borderWith;
    view.layer.borderColor=color;
    view.layer.cornerRadius=radius;
    view.layer.masksToBounds=YES;
    
    //当shouldRasterize设成YES时，layer被渲染成一个bitmap，并缓存起来，等下次使用时不会再重新去渲染了,提高性能，TableViewCell,因为TableViewCell的重绘是很频繁的（因为Cell的复用）,如果Cell的内容不断变化,则Cell需要不断重绘,如果此时设置了cell.layer可光栅化。则会造成大量的offscreen渲染,降低图形性能。
    //    view.layer.shouldRasterize=YES;
    //    view.layer.rasterizationScale=view.window.screen.scale;
}

/*
 *判断一个文件是否存在
 */
+(BOOL)fileIsExit:(NSString *)path;
{
    NSFileManager *fileManager=[[NSFileManager alloc]init];
    BOOL find = [fileManager fileExistsAtPath:path];
    return find;
}

/*
 *根据url清除缓存
 */
+(void)clearCacheByUrl:(NSString *)url;
{
    //根据url清楚缓存
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray* facebookCookies = [cookies cookiesForURL:[NSURL URLWithString:url]];
    
    for (NSHTTPCookie* cookie in facebookCookies) {
        [cookies deleteCookie:cookie];
    }
}

/*
 *清除全部缓存
 */
+(void)clearAllCache;
{
    //清除全部缓存
    NSHTTPCookieStorage *storage=[NSHTTPCookieStorage sharedHTTPCookieStorage];
    for(NSHTTPCookie *cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
}

/**
 *  过滤值
 *
 *  @param value value
 *
 *  @return 返回值
 */
+(id)filterValue:(id)value
{
    
    if([value isKindOfClass:[NSNull class]] || value==nil || value==NULL || ([value isKindOfClass:[NSString class]] && [value isEqualToString:@"null"]))
    {
        return @"";
    }
    else
    {
        return value;
    }
}

//计算缓存大小
+(float)getCacheSize:(NSString *)cacheFilePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:cacheFilePath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:cacheFilePath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [cacheFilePath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    
    NSString * currentVolum = [NSString stringWithFormat:@"%@",[self fileSizeWithInterge:[[[SDWebImageManager sharedManager] imageCache] getSize]]];
    
    
    CGFloat sdCache=[currentVolum floatValue];
    if([currentVolum rangeOfString:@"K"].length>0)
    {
        sdCache=sdCache/1024.0;
    }
    
    NSLog(@"currentVolum==%@",currentVolum);
    return folderSize/(1024.0*1024.0)+sdCache;
    
}


//计算出大小
+(NSString *)fileSizeWithInterge:(NSInteger)size{
    // 1k = 1024, 1m = 1024k
    if (size < 1024) {// 小于1k
        return [NSString stringWithFormat:@"%ldB",(long)size];
    }else if (size < 1024 * 1024){// 小于1m
        CGFloat aFloat = size/1024;
        return [NSString stringWithFormat:@"%.0fKB",aFloat];
    }else if (size < 1024 * 1024 * 1024){// 小于1G
        CGFloat aFloat = size/(1024 * 1024);
        return [NSString stringWithFormat:@"%.1fMB",aFloat];
    }else{
        CGFloat aFloat = size/(1024*1024*1024);
        return [NSString stringWithFormat:@"%.1fGB",aFloat];
    }
}

/**
 *  压缩图片，压缩到100~300k左右
 *
 *  @param image 图片参数
 *  @param size  大小
 *
 *  @return 图片大小
 */
+(NSData *)scaleToSize:(UIImage *)image size:(CGSize)size
{
    //并把他设置成当前的context
    UIGraphicsBeginImageContext(size);
    //绘制图片的大小
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    //从当前context中创建一个改变大小后的图片
    UIImage *endImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGRect imgRect=CGRectMake(0, 0, size.width, size.height);
    CGImageRef imgRef=CGImageCreateWithImageInRect(endImage.CGImage, imgRect);
    
    UIImage* newImg = [UIImage imageWithCGImage:imgRef];
    CGImageRelease(endImage.CGImage);
    
    
    CGFloat compression = 0.9f;//压缩系数
    CGFloat maxCompression = 0.0f;//最小压缩系数
    
    NSData *imgData=UIImageJPEGRepresentation(newImg, compression);
    
    for (int i=8; i>=0; i--) {
        @autoreleasepool {
            NSData *returnImgeaData=imgData;
            if (returnImgeaData.length>100*1024 && compression>maxCompression) {//如果图片数据>100kb就继续压缩
                
                float a =i*0.1;
                imgData = UIImageJPEGRepresentation(newImg, a);
            }
            
        }
        
        
    }
    //    CGRect imgRect=CGRectMake(0, 0, size.width, size.height);
    //    CGImageRef imgRef=CGImageCreateWithImageInRect(image.CGImage, imgRect);
    //
    //    UIImage* newImg = [UIImage imageWithCGImage:imgRef];
    //    CGImageRelease(image.CGImage);
    return imgData;
}

/*
 *设置Autolayout中的边距辅助方法
 */
+(void)setEdge:(UIView*)superview view:(UIView*)view attr:(NSLayoutAttribute)attr multiplier:(float)multiplier constant:(CGFloat)constant
{
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:attr relatedBy:NSLayoutRelationEqual toItem:superview attribute:attr multiplier:multiplier constant:constant]];
}

/*
 *画线1
 */
+(void)drawLine:(UIView *)rootView headOrFoot:(NSString *)headOrFoot letfMargin:(float)letfMargin rightMargin:(float)rightMargin lineHeight:(float)lineHeight;
{
    UILabel *line=[[UILabel alloc]init];
    line.backgroundColor=CellSeparatorColor;
    line.translatesAutoresizingMaskIntoConstraints=NO;
    [rootView addSubview:line];
    
    //约束
    [self setEdge:rootView view:line attr:NSLayoutAttributeLeft multiplier:1.0 constant:letfMargin];
    [self setEdge:rootView view:line attr:NSLayoutAttributeRight multiplier:1.0 constant:rightMargin];
    if([headOrFoot isEqualToString:@"head"])
    {
        [self setEdge:rootView view:line attr:NSLayoutAttributeTop multiplier:1.0 constant:0];
        [rootView addConstraint:[NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:rootView attribute:NSLayoutAttributeTop multiplier:1.0 constant:lineHeight]];
    }
    else if([headOrFoot isEqualToString:@"foot"])
    {
        lineHeight=-lineHeight;
        [rootView addConstraint:[NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:rootView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:lineHeight]];
        [self setEdge:rootView view:line attr:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    }
    
    
}

/*
 *画线2
 */
+(void)drawline2:(UIView *)superView frame:(CGRect)frame color:(UIColor *)color
{
    //CGRect frames=CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 0.5);
    UILabel *line=[[UILabel alloc]initWithFrame:frame];
    line.backgroundColor=color;
    [superView addSubview:line];
}

/** 根据文件类型返回对应Image背景 */
+ (UIImage *)file_typeWithFileModel:(TFFileModel *)model{
    
    
    if ([[model.file_type lowercaseString] isEqualToString:@"jpg"] || [[model.file_type lowercaseString] isEqualToString:@"png"] || [[model.file_type lowercaseString] isEqualToString:@"gif"]|| [[model.file_type lowercaseString] isEqualToString:@"jpeg"]) {// 图片
        
        
        if (model.image) {
            return model.image;
            
        }else if (model.file_url){
            return [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.file_url]]];
        }else{
    
            return [UIImage imageNamed:@"jpg"];
        }
        
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"mp3"]){// 语音
        return [UIImage imageNamed:@"mp3"];
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"doc"] || [[model.file_type lowercaseString] isEqualToString:@"docx"]){// doc
        return [UIImage imageNamed:@"doc"];
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"xls"] || [[model.file_type lowercaseString] isEqualToString:@"xlsx"]){// xls
        return [UIImage imageNamed:@"xls"];
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"ppt"] || [[model.file_type lowercaseString] isEqualToString:@"pptx"]){// ppt
        return [UIImage imageNamed:@"ppt"];
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"ai"]){// ai
        return [UIImage imageNamed:@"ai"];
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"cdr"]){// cdr
        return [UIImage imageNamed:@"cdr"];
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"dwg"]){// dwg
        return [UIImage imageNamed:@"dwg"];
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"ps"]){// ps
        return [UIImage imageNamed:@"ps"];
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"pdf"]){// pdf
        return [UIImage imageNamed:@"pdf"];
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"txt"]){// txt
        return [UIImage imageNamed:@"txt"];
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"zip"] ||
              [[model.file_type lowercaseString] isEqualToString:@"rar"]){// zip
        return [UIImage imageNamed:@"zip"];
        
    }else{
        return [UIImage imageNamed:@"未知文件"];
    }

}

/** 将字符串MD5加密后生成的字符串 */
+ (NSString *)stringForMD5WithString:(NSString *)string{
    
    NSString *str = [NSString stringWithFormat:@"%@%@",string,PasswordMD5];
    
    return [HQMD5Encrypt encodeByMD5WithString:[HQMD5Encrypt encodeByMD5WithString:str]];
}

/** 缓存文件 */
+(void)cacheFileWithUrl:(NSString *)urlStr fileName:(NSString *)fileName completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler fileHandler:(void (^)(NSString *path))fileHandler{
    
    if (fileHandler) {// 只有实现了该block才会去本地找
        
//        // 1.在本地找，是否下载存入了本地
//        // 缓存文件夹
//        NSString *cachePath = [FileManager dirCache];
//        // 用于记录下载过的文件的文件
//        NSString *path = [cachePath stringByAppendingPathComponent:@"downloadFile.plist"];
//        // 读取
//        NSArray *result = [NSArray arrayWithContentsOfFile:path];
//        // 数组中书否有记录
//        NSString *str = [HQHelper stringForMD5WithString:urlStr];// 当key
//        // 用于记录下载的文件的路径
        NSString *downloadFilePath = nil;
//        // 遍历保存的数据
//        for (NSString *dictStr in result) {
//            NSDictionary *dict = [HQHelper dictionaryWithJsonString:dictStr];
//            // 字典中key-->记录
//            // 字典中path-->下载文件的保存路径
//            if ([[dict valueForKey:@"key"] isEqualToString:str]) {
//                downloadFilePath = [dict valueForKey:@"path"];
//                break;
//            }
//        }
        
        downloadFilePath = [HQHelper getCacheFilePathWithFileName:fileName];
        
        if (downloadFilePath) {
            
            HQMainQueue(^{
                
                fileHandler(downloadFilePath);
                
            });
            return;// 找到了就无需下载了
        }
    }
    
    if (completionHandler) {// 实现了该block才会请求
        
        NSURL *url = [HQHelper URLWithString:urlStr];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        request.allHTTPHeaderFields = [@{@"TOKEN":UM.userLoginInfo.token} copy];
        NSURLSession *session  = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError * _Nullable error) {
                                                    
                                                    HQMainQueue(^{
                                                        completionHandler(data,response,error);
                                                        
                                                    });
                                                    
                                                }];
        [task resume];
    }
   
}

/***
 *   通用文件下载
 *
 *   @prama urlStr 资源路径
 *   @prama fileSize 资源大小
 *   @prama completionHandler 下载完成或者出错回调
 *   @prama cancelHander 取消下载回调
 *   @prama fileHandler 本地文件回调
 *
 */
+(void)downloadFileWithUrl:(NSString *)urlStr fileName:(NSString *)fileName fileSize:(NSInteger)fileSize completionHandler:(void (^)(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError * _Nullable error))completionHandler cancelHander:(void (^)(NSString *candelDesc))cancelHander fileHandler:(void (^)(NSString *path))fileHandler{
    
    // 判断文件的大小是否满足下载条件
    NSNumber *remain = [[NSUserDefaults standardUserDefaults] objectForKey:DataFlowRemain];
    
    if (!remain || [remain isEqualToNumber:@1]) {// 需提醒
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            
            if(status == AFNetworkReachabilityStatusReachableViaWWAN)// 非wifi
            {
                
                if (fileSize/1000/1000 > MaxFileSize) {// 大于10M
                    
                    [AlertView showAlertView:@"流量提醒" msg:@"您正在使用2G/3G/4G网络下载大于10M的内容，继续使用可能产生流量费用（运营商收取），是否继续？" leftTitle:@"取消" rightTitle:@"继续下载" onLeftTouched:^{
                    
                        if (cancelHander) {
                            cancelHander(@"下载取消");
                        }
                        
                    } onRightTouched:^{
                        
                        [self cacheFileWithUrl:urlStr fileName:fileName completionHandler:completionHandler fileHandler:fileHandler];
                    }];
                    
                }else{// 小于10M
                    
                    [self cacheFileWithUrl:urlStr fileName:fileName completionHandler:completionHandler fileHandler:fileHandler];
                }
                
            }
            if (status == AFNetworkReachabilityStatusReachableViaWiFi) {// wifi
                
                [self cacheFileWithUrl:urlStr fileName:fileName completionHandler:completionHandler fileHandler:fileHandler];
                
            }
        }];
    }else{// 不提醒
        
        [self cacheFileWithUrl:urlStr fileName:fileName completionHandler:completionHandler fileHandler:fileHandler];
    }
    
}
/**  保存下载文件
 *
 * @param fileName 文件名
 * @param data 下载的数据
 *
 * return 文件保存路径，为nil时说明保存失败了
 */
+(NSString *)saveCacheFileWithFileName:(NSString *)fileName data:(NSData *)data{
    
    if (data == nil) {
        return nil;
    }
    
    // 缓存文件夹
    NSString *cachePath = [FileManager dirCache];
    // 创建文件夹
    [FileManager createDir:cachePath DirStr:@"downloadFile"];
    // 创建文件路径
    NSString *filePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"/downloadFile/%@",fileName]];
    // 将文件写入该路径
    BOOL pass = [data writeToFile:filePath atomically:YES];
    if (pass) {
        HQLog(@"下载的文件写入成功");
    }else{
        HQLog(@"下载的文件写入失败");
    }
    
    if (pass) {// 记录下载
        
//        // 将下载的文件存放路径记录下来
//        NSString *path = [cachePath stringByAppendingPathComponent:@"downloadFile.plist"];
//        // 制作存放的字典
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        [dict setObject:[HQHelper stringForMD5WithString:fileUrl] forKey:@"key"];
//        [dict setObject:fileName forKey:@"path"];
//        NSString *dictStr = [HQHelper dictionaryToJson:dict];
//        // 读取
//        NSArray *result = [NSArray arrayWithContentsOfFile:path];
//        // 存的数据
//        NSMutableArray *cacheArr = [NSMutableArray arrayWithArray:result];
//        [cacheArr insertObject:dictStr atIndex:0];
//        // 写入plist文件
//        BOOL pp = [cacheArr writeToFile:path atomically:YES];
//        if (pp) {
//            HQLog(@"记录下载文件的路径写入成功");
//        }else{
//            HQLog(@"记录下载文件的路径写入失败");
//        }
        
        return filePath;
        
    }else{
        return nil;
    }
    
}

/** 获取缓存文件路径 */
+(NSString *)getCacheFilePathWithFileName:(NSString *)fileName{
    
    if (fileName == nil || [fileName isEqualToString:@""]) {
        return nil;
    }
    // 文件路径
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *filePath = [[FileManager dirCache] stringByAppendingPathComponent:[NSString stringWithFormat:@"/downloadFile/%@",fileName]];
    
    if ([fileManager fileExistsAtPath:filePath]) {
        return filePath;
    }else{
        return nil;
    }
}

/** 图片方向修正 */
+ (UIImage *)fixedImageOrientationWithImage:(UIImage *)aImage{
    
     // No-op if the orientation is already correct
    if (aImage.imageOrientation ==UIImageOrientationUp){
          return aImage;
    }
    
     // We need to calculate the proper transformation to make the image upright.
      // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
      CGAffineTransform transform =CGAffineTransformIdentity;
      switch (aImage.imageOrientation) {
          case UIImageOrientationDown:
                caseUIImageOrientationDownMirrored:
                  transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
                  transform = CGAffineTransformRotate(transform, M_PI);
                  break;
          case UIImageOrientationLeft:
                caseUIImageOrientationLeftMirrored:
                  transform = CGAffineTransformTranslate(transform, aImage.size.width,0);
                  transform = CGAffineTransformRotate(transform, M_PI_2);
                  break;
          case UIImageOrientationRight:
          case UIImageOrientationRightMirrored:
                  transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
                  transform = CGAffineTransformRotate(transform, -M_PI_2);
                  break;
                default:
                  break;
          }
    
      switch (aImage.imageOrientation) {
          case UIImageOrientationUpMirrored:
          case UIImageOrientationDownMirrored:
                  transform = CGAffineTransformTranslate(transform, aImage.size.width,0);
                  transform = CGAffineTransformScale(transform, -1, 1);
                  break;
          case UIImageOrientationLeftMirrored:
          case UIImageOrientationRightMirrored:
                  transform = CGAffineTransformTranslate(transform, aImage.size.height,0);
                  transform = CGAffineTransformScale(transform, -1, 1);
                  break;
                default:
                  break;
          }
      // Now we draw the underlying CGImage into a new context, applying the transform
      // calculated above.
      CGContextRef ctx =CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                                                     CGImageGetBitsPerComponent(aImage.CGImage),0,
                                                                     CGImageGetColorSpace(aImage.CGImage),
                                                                     CGImageGetBitmapInfo(aImage.CGImage));
      CGContextConcatCTM(ctx, transform);
      switch (aImage.imageOrientation) {
                case UIImageOrientationLeft:
                case UIImageOrientationLeftMirrored:
                case UIImageOrientationRight:
                case UIImageOrientationRightMirrored:
                  // Grr...
                  CGContextDrawImage(ctx,CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
                  break;
                default:
                  CGContextDrawImage(ctx,CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
                  break;
          }
      // And now we just create a new UIImage from the drawing context
      CGImageRef cgimg =CGBitmapContextCreateImage(ctx);
      UIImage *img = [UIImage imageWithCGImage:cgimg];
      CGContextRelease(ctx);
      CGImageRelease(cgimg);
      return img;
    
//    return [UIImage imageWithCGImage:image.CGImage scale:1 orientation:UIImageOrientationUp];
    
}

/** 将全名变为简称 */
+ (NSString *)nameWithTotalName:(NSString *)totalName{
    
    totalName = [totalName uppercaseString];
    
    if (!totalName || totalName.length == 0) {
        return @"无名";
    }else if (totalName.length < 3){
        return totalName;
    }else if (totalName.length == 3){
        return [totalName substringFromIndex:1];
    }else if (totalName.length == 4){
        return [totalName substringFromIndex:2];
    }else{
        return [totalName substringToIndex:2];
    }
    
}

/** 将全名变为简称(取一个字) */
+ (NSString *)nameWithTotalName2:(NSString *)totalName{
    
    if (!totalName || totalName.length == 0) {
        return @"无";
    }else{
        return [totalName substringToIndex:1];
    }
    
}

/** 0:@"今天",1:@"昨天",2:@"过去7天",3:@"过去30天",4:@"本月",5:@"上月",6:@"本季度",7:@"上季度" */
+ (NSDictionary *)timePeriodWithIndex:(NSInteger)index{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    switch (index) {
        case 0:// 今天
        {
            NSString *start = [self nsdateToTime:[self getNowTimeSp] formatStr:@"yyyy-MM-dd"];// 去掉时分
            long long startSp = [self changeTimeToTimeSp:start formatStr:@"yyyy-MM-dd"];
            long long endSp = startSp + 24 * 60 * 60 * 1000;
            
            [dict setObject:@(startSp) forKey:@"startTime"];
            [dict setObject:@(endSp) forKey:@"endTime"];
            
        }
            break;
        case 1:// 昨天
        {
            NSString *end = [self nsdateToTime:[self getNowTimeSp] formatStr:@"yyyy-MM-dd"];// 去掉时分
            long long endSp = [self changeTimeToTimeSp:end formatStr:@"yyyy-MM-dd"];
            long long startSp = endSp - 24 * 60 * 60 * 1000;
            [dict setObject:@(startSp) forKey:@"startTime"];
            [dict setObject:@(endSp) forKey:@"endTime"];
        }
            break;
        case 2:// 过去7天
        {
            NSString *end = [self nsdateToTime:[self getNowTimeSp] formatStr:@"yyyy-MM-dd"];// 去掉时分
            long long endSp = [self changeTimeToTimeSp:end formatStr:@"yyyy-MM-dd"];
            long long startSp = endSp - 6 * 24 * 60 * 60 * 1000;
            [dict setObject:@(startSp) forKey:@"startTime"];
            [dict setObject:@(endSp) forKey:@"endTime"];
        }
            break;
        case 3:// 过去30天
        {
            NSString *end = [self nsdateToTime:[self getNowTimeSp] formatStr:@"yyyy-MM-dd"];// 去掉时分
            long long endSp = [self changeTimeToTimeSp:end formatStr:@"yyyy-MM-dd"];
            long long startSp = endSp - (long long)29 * 24 * 60 * 60 * 1000;
            [dict setObject:@(startSp) forKey:@"startTime"];
            [dict setObject:@(endSp) forKey:@"endTime"];
        }
            break;
        case 4:// 本月
        {
            long long startSp = [[[NSDate date] firstDayOfTheMonth] getTimeSp];
            long long endSp = [self getNowTimeSp];
            [dict setObject:@(startSp) forKey:@"startTime"];
            [dict setObject:@(endSp) forKey:@"endTime"];
        }
            break;
        case 5:// 上月
        {
            long long endSp = [[[NSDate date] firstDayOfTheMonth] getTimeSp];
            long long startSp = endSp - (long long)30 * 24 * 60 * 60 * 1000;
            [dict setObject:@(startSp) forKey:@"startTime"];
            [dict setObject:@(endSp) forKey:@"endTime"];
        }
            break;
        case 6:// 本季度
        {
            NSInteger month = [[self nsdateToTime:[self getNowTimeSp] formatStr:@"MM"] integerValue];
            
            NSInteger season = month / 3 + 1;
            
            if (season == 1) {
                long long startSp = [self changeTimeToTimeSp:[NSString stringWithFormat:@"%@-01-01",[self nsdateToTime:[self getNowTimeSp] formatStr:@"yyyy"]] formatStr:@"yyyy-MM-dd"];
                long long endSp = [self getNowTimeSp];
                
                [dict setObject:@(startSp) forKey:@"startTime"];
                [dict setObject:@(endSp) forKey:@"endTime"];
                
            }else if (season == 2){
                long long startSp = [self changeTimeToTimeSp:[NSString stringWithFormat:@"%@-04-01",[self nsdateToTime:[self getNowTimeSp] formatStr:@"yyyy"]] formatStr:@"yyyy-MM-dd"];
                long long endSp = [self getNowTimeSp];
                
                [dict setObject:@(startSp) forKey:@"startTime"];
                [dict setObject:@(endSp) forKey:@"endTime"];
                
            }else if (season == 3){
                
                long long startSp = [self changeTimeToTimeSp:[NSString stringWithFormat:@"%@-07-01",[self nsdateToTime:[self getNowTimeSp] formatStr:@"yyyy"]] formatStr:@"yyyy-MM-dd"];
                long long endSp = [self getNowTimeSp];
                
                [dict setObject:@(startSp) forKey:@"startTime"];
                [dict setObject:@(endSp) forKey:@"endTime"];
            }else{
                
                long long startSp = [self changeTimeToTimeSp:[NSString stringWithFormat:@"%@-10-01",[self nsdateToTime:[self getNowTimeSp] formatStr:@"yyyy"]] formatStr:@"yyyy-MM-dd"];
                long long endSp = [self getNowTimeSp];
                
                [dict setObject:@(startSp) forKey:@"startTime"];
                [dict setObject:@(endSp) forKey:@"endTime"];
            }
            
        }
            break;
        case 7:
        {
            NSInteger month = [[self nsdateToTime:[self getNowTimeSp] formatStr:@"MM"] integerValue];
            
            NSInteger season = month / 3 + 1;
            
            if (season == 1) {
                long long endSp = [self changeTimeToTimeSp:[NSString stringWithFormat:@"%@-01-01",[self nsdateToTime:[self getNowTimeSp] formatStr:@"yyyy"]] formatStr:@"yyyy-MM-dd"];
                long long startSp = endSp - (long long)3 * 30 * 24 * 60 * 60 * 1000;
                
                [dict setObject:@(startSp) forKey:@"startTime"];
                [dict setObject:@(endSp) forKey:@"endTime"];
                
            }else if (season == 2){
                long long endSp = [self changeTimeToTimeSp:[NSString stringWithFormat:@"%@-04-01",[self nsdateToTime:[self getNowTimeSp] formatStr:@"yyyy"]] formatStr:@"yyyy-MM-dd"];
                long long startSp = endSp - (long long)3 * 30 * 24 * 60 * 60 * 1000;
                
                [dict setObject:@(startSp) forKey:@"startTime"];
                [dict setObject:@(endSp) forKey:@"endTime"];
                
            }else if (season == 3){
                
                long long endSp = [self changeTimeToTimeSp:[NSString stringWithFormat:@"%@-07-01",[self nsdateToTime:[self getNowTimeSp] formatStr:@"yyyy"]] formatStr:@"yyyy-MM-dd"];
                long long startSp = endSp - (long long)3 * 30 * 24 * 60 * 60 * 1000;
                
                [dict setObject:@(startSp) forKey:@"startTime"];
                [dict setObject:@(endSp) forKey:@"endTime"];
            }else{
                
                long long endSp = [self changeTimeToTimeSp:[NSString stringWithFormat:@"%@-10-01",[self nsdateToTime:[self getNowTimeSp] formatStr:@"yyyy"]] formatStr:@"yyyy-MM-dd"];
                long long startSp = endSp - (long long)3 * 30 * 24 * 60 * 60 * 1000;
                
                [dict setObject:@(startSp) forKey:@"startTime"];
                [dict setObject:@(endSp) forKey:@"endTime"];
            }
            

        }
            break;
            
        default:
            break;
    }
    
    return dict;
}

+(NSString *)createStarWithNumber:(NSInteger)number{
    NSString *str = @"";
    for (NSInteger i = 0; i < number; i++) {
        str = [str stringByAppendingString:@"*"];
    }
    return str;
}

/** 处理组件类型的值 */
+ (NSString *)stringWithFieldNameModel:(TFFieldNameModel *)field{

    NSString *str = @"";
    
    if ([field.name containsString:@"personnel"]) {
        
        NSArray *arr = [HQHelper dictionaryWithJsonString:field.value];
        
        if ([arr isKindOfClass:[NSArray class]]) {
            
            if (arr.count) {
                
                for (NSDictionary *dic in arr) {
                    
                    str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[dic valueForKey:@"name"]]];
                    
                }
                
                if (str.length) {
                    
                    str = [str substringToIndex:str.length-1];
                }
            }else{
                
                //            str = field.value;
                str = @"";
                
            }
        }else{
            str = field.value;
        }
        
        
        
    }
    else if ([field.name containsString:@"multitext"]){
        str = field.value;
    }
    else if ([field.name containsString:@"department"]) {
        
        NSArray *arr = [HQHelper dictionaryWithJsonString:field.value];
        
        if ([arr isKindOfClass:[NSArray class]]) {
            
            if (arr.count) {
                
                for (NSDictionary *dic in arr) {
                    
                    str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[dic valueForKey:@"name"]]];
                    
                }
                
                if (str.length) {
                    
                    str = [str substringToIndex:str.length-1];
                }
            }else{
                
                //            str = field.value;
                str = @"";
                
            }
        }else{
            str = field.value;
        }
        
        
        
    }
    else if ([field.name containsString:@"picklist"] || [field.name containsString:@"multi"] || [field.name containsString:@"mutlipicklist"]){
        
        NSArray *arr = [HQHelper dictionaryWithJsonString:field.value];
        
        
        if ([arr isKindOfClass:[NSArray class]]) {
            
            for (NSDictionary *dic in arr) {
                
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[dic valueForKey:@"label"]]];
                
            }
            
            if (str.length) {
                
                str = [str substringToIndex:str.length-1];
            }
        }else{
            str = @"";
        }
        
        
    }
    else if ([field.name containsString:@"textarea"]){
        
        str = field.value;
        
    }
    else if ([field.name containsString:@"area"]){
        
        str = TEXT([[HQAreaManager defaultAreaManager] regionWithRegionData:TEXT(field.value)]);
        
    }
    else if ([field.name containsString:@"reference"]){
        NSArray *arr = [HQHelper dictionaryWithJsonString:field.value];
        
        if ([arr isKindOfClass:[NSArray class]]) {
            
            for (NSDictionary *dic in arr) {
                
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[dic valueForKey:@"name"]]];
                
            }
            
            if (str.length) {
                
                str = [str substringToIndex:str.length-1];
            }
        }else{
            str = @"";
        }
        
        
    }
    else if ([field.name containsString:@"phone"]){
        if ([field.secret isEqualToString:@"1"]) {
            if (field.value.length > 4) {
                str = [NSString stringWithFormat:@"%@%@",[self createStarWithNumber:field.value.length-4],[field.value substringWithRange:(NSRange){field.value.length-5,4}]];
            }else{
                str = [self createStarWithNumber:field.value.length];
            }
        }else{
            str = field.value;
        }
    }
    else if ([field.name containsString:@"location"]){
        
        NSDictionary *di = [HQHelper dictionaryWithJsonString:field.value];
        if ([field.secret isEqualToString:@"1"]) {
            NSString *kk = TEXT([di valueForKey:@"value"]);
            str = [self createStarWithNumber:kk.length];
        }else{
            str = TEXT([di valueForKey:@"value"]);
        }
    }
    else if ([field.name containsString:@"email"]){
        if ([field.secret isEqualToString:@"1"]) {
            NSArray *emails = [field.value componentsSeparatedByString:@"@"];
            if (emails.count == 2) {
                NSString *first = emails.firstObject;
                str = [NSString stringWithFormat:@"%@%@",[self createStarWithNumber:first.length],[field.value substringFromIndex:first.length]];
            }else{
                str = @"";
            }
            
        }else{
            str = field.value;
        }
    }
    else if ([field.name containsString:@"datetime"]){
        // 时间格式的处理
        str = [HQHelper nsdateToTime:[field.value longLongValue] formatStr:!IsStrEmpty(field.field_param.formatType) ?field.field_param.formatType : @"yyyy-MM-dd HH:mm"];
        
    }
    else if ([field.name containsString:@"number"]){
        // 数字类型的处理 numberType： 0 数字， 1 整数 ， 2 百分比
        // 小数位  numberLenth
        if (field.field_param) {
            NSNumber *num = @([field.value floatValue]);
            
            if ([num isKindOfClass:[NSString class]]) {
                NSString *numStr = (NSString *)num;
                if ([numStr floatValue] != 0) {
                    num = @([numStr floatValue]);
                }
            }
            if ([field.field_param.numberType isEqualToString:@"0"] || [field.field_param.numberType isEqualToString:@"2"]) {// 数字和百分比
                
                //                if ([model.field.numberType isEqualToString:@"2"]) {
                //                    num = @([num floatValue] * 100);
                //                }
                NSInteger point = [field.field_param.numberLenth integerValue];
                if (point == 0) {
                    str = [NSString stringWithFormat:@"%.0lf",[num floatValue]];
                }else if (point == 1){
                    str = [NSString stringWithFormat:@"%.1lf",[num floatValue]];
                }else if (point == 2){
                    str = [NSString stringWithFormat:@"%.2lf",[num floatValue]];
                }else if (point == 3){
                    str = [NSString stringWithFormat:@"%.3lf",[num floatValue]];
                }else {
                    str = [NSString stringWithFormat:@"%.4lf",[num floatValue]];
                }
                if ([field.field_param.numberType isEqualToString:@"2"]) {
                    
                    if (str.length) {
                        str = [NSString stringWithFormat:@"%@%@",TEXT(str),@"%"];
                    }
                }
            }else{
                
                str = [NSString stringWithFormat:@"%ld",[num integerValue]];
            }
        }else{
            str = field.value;
        }
        
        str = [HQHelper changeNumberFormat:str bit:field.field_param.numberDelimiter];
        
    }
    else if ([field.name containsString:@"formula"] || [field.name containsString:@"seniorformula"] || [field.name containsString:@"functionformula"]){// 公式 高级公式 函数

        if (field.field_param) {
            
            NSNumber *num = @([field.value floatValue]);
            
            if ([field.field_param.numberType isEqualToString:@"0"] || [field.field_param.numberType isEqualToString:@"2"]) {// 数字和百分比
                
                //                if ([model.field.numberType isEqualToString:@"2"]) {
                //                    num = @([num floatValue] * 100);
                //                }
                NSInteger point = [field.field_param.decimalLen integerValue];
                if (point == 0) {
                    str = [NSString stringWithFormat:@"%.0lf",[num floatValue]];
                }else if (point == 1){
                    str = [NSString stringWithFormat:@"%.1lf",[num floatValue]];
                }else if (point == 2){
                    str = [NSString stringWithFormat:@"%.2lf",[num floatValue]];
                }else if (point == 3){
                    str = [NSString stringWithFormat:@"%.3lf",[num floatValue]];
                }else {
                    str = [NSString stringWithFormat:@"%.4lf",[num floatValue]];
                }
                if ([field.field_param.numberType isEqualToString:@"2"]) {
                    
                    if (str.length) {
                        
                        str = [NSString stringWithFormat:@"%@%@",TEXT(str),@"%"];
                    }
                }
            }else if ([field.field_param.numberType isEqualToString:@"4"]){// 日期
                
                str = [HQHelper nsdateToTime:[field.value longLongValue] formatStr:field.field_param.chooseType];
            } else{
                
                if ([field.value isKindOfClass:[NSString class]] && [num floatValue] == 0) {
                    str = field.value;
                }else{
                    str = [NSString stringWithFormat:@"%@",[num description]];
                }
            }
        }else{
            str = field.value;
        }
        str = [HQHelper changeNumberFormat:str bit:field.field_param.numberDelimiter];

    }
    else{
        str = field.value;
    }
    
    return str;
}

/** 处理组件类型的值 */
+ (NSString *)stringWithFieldNameDict:(NSDictionary *)dict{
    
    NSString *name = [dict valueForKey:@"name"];
    NSString *str = @"";
    
    if ([name containsString:@"personnel"]) {
        
        NSArray *arr = [dict valueForKey:@"value"];
        
        if ([arr isKindOfClass:[NSArray class]]) {
            
            if (arr.count) {
                
                for (NSDictionary *dic in arr) {
                    
                    str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[dic valueForKey:@"name"]]];
                    
                }
                
                if (str.length) {
                    
                    str = [str substringToIndex:str.length-1];
                }
            }else{
                
                //            str = field.value;
                str = @"";
                
            }
        }else{
            str = [dict valueForKey:@"value"];
        }
    }
    else if ([name containsString:@"department"]) {
        
        NSArray *arr = [dict valueForKey:@"value"];
        
        if ([arr isKindOfClass:[NSArray class]]) {
            
            if (arr.count) {
                
                for (NSDictionary *dic in arr) {
                    str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[dic valueForKey:@"name"]]];
                    
                }
                
                if (str.length) {
                    
                    str = [str substringToIndex:str.length-1];
                }
            }else{
                
                //            str = field.value;
                str = @"";
                
            }
        }else{
            str = [dict valueForKey:@"value"];
        }
        
        
        
    }
    
    else if ([name containsString:@"multitext"]){
        str = TEXT([dict valueForKey:@"value"]);
    }
    else if ([name containsString:@"picklist"] || [name containsString:@"multi"] || [name containsString:@"mutlipicklist"]){
        
        NSArray *arr = [dict valueForKey:@"value"];
        
        
        for (NSDictionary *dic in arr) {
            
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[dic valueForKey:@"label"]]];
            
        }
        
        if (str.length) {
            
            str = [str substringToIndex:str.length-1];
        }
        
    }
    else if ([name containsString:@"datetime"]){
        
        str = [HQHelper nsdateToTime:[[dict valueForKey:@"value"] longLongValue] formatStr:[dict valueForKey:@"other"]?:@"yyyy-MM-dd HH:mm"];
        
        
    }
    else if ([name containsString:@"location"]){
        
        NSDictionary *di = [dict valueForKey:@"value"];
        
        str = TEXT([di valueForKey:@"value"]);
        
    }
    else if ([name containsString:@"textarea"]){
        
        str = TEXT([dict valueForKey:@"value"]);
        
    }
    else if ([name containsString:@"area"]){
        
        str = TEXT([[HQAreaManager defaultAreaManager] regionWithRegionData:TEXT([dict valueForKey:@"value"])]);
        
    }
    else if ([name containsString:@"reference"]){
        
        
//        NSArray *arr = [dict valueForKey:[dict valueForKey:@"value"]];
        NSArray *arr = [dict valueForKey:@"value"];
        
        
        if ([arr isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in arr) {
                
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[dic valueForKey:@"name"]]];
                
            }
            
            if (str.length) {
                
                str = [str substringToIndex:str.length-1];
            }
        }else{
            str = @"";
        }
        
    }
    else{
        str = TEXT([dict valueForKey:@"value"]);
    }
    
    return str;
}

/** 小助手自定义组件类型处理 */
+ (NSString *)stringWithAssistantFieldInfoModel:(TFAssistantFieldInfoModel *)field {

    NSString *str = @"";
    if (field.type) {
        
        if ([field.type containsString:@"personnel"] ) {
            
            if (field.field_value && ![field.field_value isEqualToString:@""]) {
                
                str = [NSString stringWithFormat:@"%@：%@",field.field_label,field.field_value];
            }else{
                str = [NSString stringWithFormat:@"%@：%@",field.field_label,@""];
            }
            
        }
        else if ([field.type containsString:@"department"]) {
            
            NSArray *arr = [HQHelper dictionaryWithJsonString:field.field_value];
            
            if ([arr isKindOfClass:[NSArray class]]) {
                NSString *str222 = @"";
                for (NSDictionary *dd in arr) {
                    str222 = [str222 stringByAppendingString:[NSString stringWithFormat:@"%@,",[dd valueForKey:@"name"]]];
                }
                if (str222.length) {
                    str222 = [str222 substringToIndex:str222.length-1];
                }
                
                str = [NSString stringWithFormat:@"%@：%@",field.field_label,str222];
            }else{
                str = [NSString stringWithFormat:@"%@：%@",field.field_label,field.field_value];
            }
            
        }
        else if ([field.type containsString:@"textarea"] || [field.type containsString:@"multitext"]) {
            
            
            if (field.field_value && ![field.field_value isEqualToString:@""]) {
                
                str = [NSString stringWithFormat:@"%@：%@",field.field_label,field.field_value];
            }else{
                str = [NSString stringWithFormat:@"%@：%@",field.field_label,@""];
            }
            
        }
        else if ([field.type containsString:@"picklist"] || [field.type containsString:@"multi"] || [field.type containsString:@"mutlipicklist"]){
            
            NSArray *arr = [HQHelper dictionaryWithJsonString:field.field_value];
            
            if ([arr isKindOfClass:[NSArray class]]) {
                NSString *str222 = @"";
                for (NSDictionary *dd in arr) {
                    str222 = [str222 stringByAppendingString:[NSString stringWithFormat:@"%@,",[dd valueForKey:@"label"]]];
                }
                if (str222.length) {
                    str222 = [str222 substringToIndex:str222.length-1];
                }
                
                str = [NSString stringWithFormat:@"%@：%@",field.field_label,str222];
            }else{
                str = [NSString stringWithFormat:@"%@：%@",field.field_label,field.field_value];
            }
            
            
        }
        else if ([field.type containsString:@"datetime"]){
            
            if (field.field_value && ![field.field_value isEqualToString:@""]) {
                
                str = [HQHelper nsdateToTime:[field.field_value longLongValue] formatStr:!IsStrEmpty(field.field.formatType) ?field.field.formatType : @"yyyy-MM-dd HH:mm"];
                str = [NSString stringWithFormat:@"%@：%@",field.field_label,str];
            }else{
                str = [NSString stringWithFormat:@"%@：%@",field.field_label,@""];
            }
            
        }
        else if ([field.type containsString:@"location"]){
            
            NSDictionary *di = [HQHelper dictionaryWithJsonString:field.field_value];
            
//            str = TEXT([di valueForKey:@"value"]);
            str = [NSString stringWithFormat:@"%@：%@",field.field_label,TEXT([di valueForKey:@"value"])];
            
        }
        else if ([field.type containsString:@"area"]){
            
//            str = TEXT([[HQAreaManager defaultAreaManager] regionWithRegionData:TEXT(field.field_value)]);
            str = [NSString stringWithFormat:@"%@：%@",field.field_label,TEXT([[HQAreaManager defaultAreaManager] regionWithRegionData:TEXT(field.field_value)])];
            
        }
        else if ([field.type containsString:@"reference"]){
            NSArray *arr = [HQHelper dictionaryWithJsonString:field.field_value];
            
            
            if ([arr isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in arr) {
                    
                    str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[dic valueForKey:@"name"]]];
                    
                }
                
                if (str.length) {
                    
                    str = [str substringToIndex:str.length-1];
                }
                
                str = [NSString stringWithFormat:@"%@：%@",field.field_label,str];
                
            }else{
//                str = @"";
                str = [NSString stringWithFormat:@"%@：%@",field.field_label,@""];
            }
        }
        else if ([field.type containsString:@"formula"] || [field.type containsString:@"seniorformula"] || [field.type containsString:@"functionformula"] || [field.type containsString:@"citeformula"]){// 公式 高级公式 函数
            
            
            if (field.field) {
                NSNumber *num = @([field.field_value floatValue]);
                
                if ([field.field.numberType isEqualToString:@"0"] || [field.field.numberType isEqualToString:@"2"]) {// 数字和百分比
                    
                    NSInteger point = [field.field.decimalLen integerValue];
                    if (point == 0) {
                        str = [NSString stringWithFormat:@"%.0lf",[num floatValue]];
                    }else if (point == 1){
                        str = [NSString stringWithFormat:@"%.1lf",[num floatValue]];
                    }else if (point == 2){
                        str = [NSString stringWithFormat:@"%.2lf",[num floatValue]];
                    }else if (point == 3){
                        str = [NSString stringWithFormat:@"%.3lf",[num floatValue]];
                    }else {
                        str = [NSString stringWithFormat:@"%.4lf",[num floatValue]];
                    }
                    if ([field.field.numberType isEqualToString:@"2"]) {
                        if (str.length) {
                            str = [NSString stringWithFormat:@"%@%@",TEXT(str),@"%"];
                        }
                    }
                    str = [HQHelper changeNumberFormat:str bit:field.field.numberDelimiter];
                    str = [NSString stringWithFormat:@"%@：%@",field.field_label,str];
                }else if ([field.field.numberType isEqualToString:@"4"]){// 日期
                    
                    str = [HQHelper nsdateToTime:[field.field_value longLongValue] formatStr:field.field.chooseType];
                    str = [NSString stringWithFormat:@"%@：%@",field.field_label,str];
                } else{// 文本
                    
                    str = [NSString stringWithFormat:@"%@",field.field_value];
                    str = [NSString stringWithFormat:@"%@：%@",field.field_label,str];
                }
            }else{
                str = [NSString stringWithFormat:@"%@：%@",field.field_label,field.field_value];
            }
            
        }
        else if ([field.type containsString:@"number"]){
            // 数字类型的处理 numberType： 0 数字， 1 整数 ， 2 百分比
            // 小数位  numberLenth
            if (field.field) {
                
                NSNumber *num = @([field.field_value floatValue]);
                
                if ([num isKindOfClass:[NSString class]]) {
                    NSString *numStr = (NSString *)num;
                    if ([numStr floatValue] != 0) {
                        num = @([numStr floatValue]);
                    }
                }
                if ([field.field.numberType isEqualToString:@"0"] || [field.field.numberType isEqualToString:@"2"]) {// 数字和百分比
                    
                    NSInteger point = [field.field.numberLenth integerValue];
                    if (point == 0) {
                        str = [NSString stringWithFormat:@"%.0lf",[num floatValue]];
                    }else if (point == 1){
                        str = [NSString stringWithFormat:@"%.1lf",[num floatValue]];
                    }else if (point == 2){
                        str = [NSString stringWithFormat:@"%.2lf",[num floatValue]];
                    }else if (point == 3){
                        str = [NSString stringWithFormat:@"%.3lf",[num floatValue]];
                    }else {
                        str = [NSString stringWithFormat:@"%.4lf",[num floatValue]];
                    }
                    if ([field.field.numberType isEqualToString:@"2"]) {
                        
                        if (str.length) {
                            str = [NSString stringWithFormat:@"%@%@",TEXT(str),@"%"];
                        }
                    }
                }else{
                    
                    str = [NSString stringWithFormat:@"%ld",[num integerValue]];
                }
                str = [HQHelper changeNumberFormat:str bit:field.field.numberDelimiter];
                str = [NSString stringWithFormat:@"%@：%@",field.field_label,str];
                
            }else{
                str = [NSString stringWithFormat:@"%@：%@",field.field_label,field.field_value];
            }
        }
        else{
            
            if (field.field_value && ![field.field_value isEqualToString:@""]) {
                
                str = [NSString stringWithFormat:@"%@：%@",field.field_label,field.field_value];
            }else{
                str = [NSString stringWithFormat:@"%@：%@",field.field_label,@""];
            }
        }
        
    }
    else{
        
        if (field.field_value && ![field.field_value isEqualToString:@""]) {
            
            str = [NSString stringWithFormat:@"%@：%@",field.field_label,field.field_value];
        }else{
            str = [NSString stringWithFormat:@"%@：%@",field.field_label,@""];
        }
    }
    
    return str;
}

/** 画水平虚线
 ** lineView:       需要绘制成虚线的view
 ** lineLength:     虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 **/
+ (void)drawHerDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.name = @"dashLayer";
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame)-2, 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    // 防止多次调用绘制多次
    NSArray *layers = lineView.layer.sublayers;
    for (CALayer *la in layers) {
        if ([la.name isEqualToString:@"dashLayer"]) {
            [la removeFromSuperlayer];
        }
    }
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

/** 画垂直虚线
 ** lineView:       需要绘制成虚线的view
 ** lineLength:     虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 **/
+ (void)drawVerDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.name = @"dashLayer";
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame)/2, CGRectGetHeight(lineView.frame)/2)];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetWidth(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0.25, 0);
    CGPathAddLineToPoint(path, NULL,0.25, 2*CGRectGetHeight(lineView.frame)-2);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    // 防止多次调用绘制多次
    NSArray *layers = lineView.layer.sublayers;
    for (CALayer *la in layers) {
        if ([la.name isEqualToString:@"dashLayer"]) {
            [la removeFromSuperlayer];
        }
    }
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}


/** 获取公司所有人 */
+ (NSArray *)getAllPeoplesInCompany{
    
    NSMutableArray *peoples = [NSMutableArray array];
    
    for (TFEmployeeCModel *model in [UM.userLoginInfo.employees allObjects]) {
        
        HQEmployModel *em = [HQEmployModel employeeWithEmployeeCModel:model];
        
        if (em) {
            [peoples addObject:em];
        }
    }
    return peoples;
}
/** 根据employeeId获取员工信息 */
+ (HQEmployModel *)getEmployeeWithEmployeeId:(NSNumber *)employeeId{
    
    HQEmployModel *employee = nil;
    
    NSAssert(employeeId != nil, @"没有employeeId");
    
    NSArray *peoples = [self getAllPeoplesInCompany];
    
    for (HQEmployModel *model in peoples) {
        
        if ([model.id isEqualToNumber:employeeId]) {
            
            employee = model;
            break;
        }
    }
    
    return employee;
}


/** 根据signId获取员工信息 */
+ (HQEmployModel *)getEmployeeWithSignId:(NSNumber *)signId{
    
    HQEmployModel *employee = nil;
    
    NSAssert(signId != nil, @"没有signId");
    
    NSArray *peoples = [self getAllPeoplesInCompany];
    
    for (HQEmployModel *model in peoples) {
        
        if ([model.sign_id isEqualToNumber:signId]) {
            
            employee = model;
            break;
        }
    }
    
    return employee;
}

+ (NSURL *)URLWithString:(NSString *)str {

    if ( str && ![str containsString:@"http"]) {
        
        str = [TEXT([[NSUserDefaults standardUserDefaults] valueForKey:UserPictureDomain]) stringByAppendingString:str];
    }
    return [NSURL URLWithString:[str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
}

+(void)getWiFiList{
//    NEHotspotConfiguration *nn = nil;
//    [[NEHotspotConfigurationManager sharedManager] getConfiguredSSIDsWithCompletionHandler:^(NSArray * array) {
//        
//        for(NSString* strinarray) {
//            
//            NSLog(@"结果：%@",str);
//            
//        }
//        
//    }];
    
}

/** 去除html内容标签，显示纯文本 */
+ (NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        [scanner scanUpToString:@"<" intoString:nil];
        [scanner scanUpToString:@">" intoString:&text];
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
        html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
        html = [html stringByReplacingOccurrencesOfString:@"&lt" withString:@""];
        html = [html stringByReplacingOccurrencesOfString:@"&gt" withString:@""];

    }
    return html;
}
/** 是否为有意义的数字 */
+(BOOL)judgeNumberWithStr:(NSString *)str{
    
    NSString *regex = @"^(([-+]?((\\d)+))|([-+]?(\\d)+\\.(\\d)+)[%‰]?)$";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:str];
}

//邮箱
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex =@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+(NSString *)getMMSSFromSS:(CGFloat )totalTime{
    
    NSInteger seconds = totalTime;
    
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%ld",seconds/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    
    return format_time;
}
//手机和座机校验
+ (BOOL)checkNumber:(NSString *)number {
    
    //验证输入的固话中不带 "-"符号
    //    NSString * strNum = @"^(0[0-9]{2,3})?([2-9][0-9]{6,7})+(-[0-9]{1,4})?$|(^(13[0-9]|15[0|3|6|7|8|9]|18[8|9])\\d{8}$)";
    
    //验证输入的固话中带 "-"符号
    NSString * strNum =@"^(400[0-9]{7})|(800[0-9]{7})|(0[0-9]{2,3}-)?([2-9][0-9]{6,7})+(-[0-9]{1,4})?$|(^(13[0-9]|14[5|7|9]|15[0-9]|17[0|1|3|5|6|7|8]|18[0-9])\\d{8}$)";
    
    NSPredicate *checktest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strNum];
    
    return [checktest evaluateWithObject:number];
    
}

//lable加下划线
+ (NSAttributedString *)stringAttributeWithUnderLine:(NSString *)string {
    
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:string];
    
    NSRange range = NSMakeRange(0, content.length);
    
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
    
    return content;
}



/** 获取任务 */
+ (TFProjectRowModel *)projectRowWithTaskDict:(NSDictionary *)taskDict{
    
    NSError *error;
    TFProjectRowModel *task = [[TFProjectRowModel alloc] initWithDictionary:taskDict error:&error];
    if (error) {
        HQLog(@"error==%@",error.description);
    }
    if (task == nil) {
        task = [[TFProjectRowModel alloc] init];
        
        task.taskDict = taskDict;
        
        task.projectId = [taskDict valueForKey:@"project_id"];
        task.id = [taskDict valueForKey:@"id"];
        task.task_type = [taskDict valueForKey:@"task_type"];
//        task.taskInfoId = [taskDict valueForKey:@"taskInfoId"];
//        task.quoteTaskId = [taskDict valueForKey:@"quoteTaskId"];
//        task.beanId = [taskDict valueForKey:@"beanId"];
//        if (task.taskInfoId == nil) {
//            task.taskInfoId = task.id;
//        }
        task.quote_id = [taskDict valueForKey:@"quote_id"];
        task.bean_id = [taskDict valueForKey:@"bean_id"];
        if (task.bean_id == nil) {
            task.bean_id = task.id;
        }
        task.dataType = [taskDict valueForKey:@"dataType"];
        task.from = [taskDict valueForKey:@"from"];
        if (!IsNilOrNull(task.from)) {
            if ([task.from isEqualToNumber:@1]) {
                task.dataType = @2;
            }
        }
        if (task.dataType == nil) {
            task.dataType = @2;
        }
        task.taskName = [taskDict valueForKey:@"text_name"];
        if (IsStrEmpty([[taskDict valueForKey:@"datetime_deadline"] description])) {
            task.endTime = @0;
        }else{
            task.endTime = [taskDict valueForKey:@"datetime_deadline"];
        }
        if (IsStrEmpty([[taskDict valueForKey:@"datetime_starttime"] description])) {
            task.startTime = @0;
        }else{
            task.startTime = [taskDict valueForKey:@"datetime_starttime"];
        }
        task.timeId = [taskDict valueForKey:@"timeId"];
        NSMutableArray *peos = [NSMutableArray array];
        if ([[taskDict valueForKey:@"personnel_principal"] isKindOfClass:[NSArray class]]) {
            
            for (NSDictionary *dict in [taskDict valueForKey:@"personnel_principal"]) {
                TFEmployModel *eee = [[TFEmployModel alloc] initWithDictionary:dict error:nil];
                eee.employee_name = eee.employee_name?:eee.name;
                if (eee) {
                    [peos addObject:eee];
                }
            }
        }
        if (peos.count) {
            task.responsibler = peos[0];
        }
        if ([[taskDict valueForKey:@"complete_status"] isKindOfClass:[NSString class]]) {
            task.finishType = @([[taskDict valueForKey:@"complete_status"] integerValue]);
        }else{
            task.finishType = [taskDict valueForKey:@"complete_status"];
        }
        task.check_status = [taskDict valueForKey:@"check_status"];
        if ([taskDict valueForKey:@"activate_number"]) {
            task.activeNum = [taskDict valueForKey:@"activate_number"];
        }else{
            task.activeNum = [taskDict valueForKey:@"complete_number"];
        }
        task.childTaskNum = [taskDict valueForKey:@"sub_task_count"] ? [taskDict valueForKey:@"sub_task_count"] : [taskDict valueForKey:@"subtotal"];
        task.finishChildTaskNum = [taskDict valueForKey:@"sub_task_complete_count"]?[taskDict valueForKey:@"sub_task_complete_count"]:[taskDict valueForKey:@"subfinishtotal"];
        task.passed_status = [taskDict valueForKey:@"passed_status"];
        task.participants_only = [taskDict valueForKey:@"participants_only"];
        task.task_id = [taskDict valueForKey:@"task_id"];
        task.task_name = [taskDict valueForKey:@"task_name"];
        if (!IsNilOrNull(task.task_id)) {// 子任务
            task.taskName = IsStrEmpty([taskDict valueForKey:@"name"])?[taskDict valueForKey:@"text_name"]:[taskDict valueForKey:@"name"];
            task.endTime = [taskDict valueForKey:@"end_time"];
        }
        
        NSMutableArray<Optional,TFCustomerOptionModel> *tags = [NSMutableArray<Optional,TFCustomerOptionModel> array];
        if ([taskDict valueForKey:@"picklist_tag"] && [[taskDict valueForKey:@"picklist_tag"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *op in [taskDict valueForKey:@"picklist_tag"]) {
                
                if ([op valueForKey:@"name"] && ![[op valueForKey:@"name"] isEqualToString:@""]) {
                    TFCustomerOptionModel *oopp = [[TFCustomerOptionModel alloc] init];
                    oopp.label = [op valueForKey:@"name"];
                    oopp.color = [op valueForKey:@"colour"];
                    oopp.value = [[op valueForKey:@"id"] description];
                    [tags addObject:oopp];
                }
            }
        }
        task.tagList = tags;
        
        NSMutableArray<Optional,TFCustomerOptionModel> *prioritys = [NSMutableArray<Optional,TFCustomerOptionModel> array];
        if ([taskDict valueForKey:@"picklist_priority"] && [[taskDict valueForKey:@"picklist_priority"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *op in [taskDict valueForKey:@"picklist_priority"]) {
                TFCustomerOptionModel *oopp = [[TFCustomerOptionModel alloc] initWithDictionary:op error:nil];
                [prioritys addObject:oopp];
            }
        }
        task.picklist_priority = prioritys;
        
        NSMutableArray<Optional,TFCustomerOptionModel> *statuses = [NSMutableArray<Optional,TFCustomerOptionModel> array];
        if ([taskDict valueForKey:@"picklist_status"] && [[taskDict valueForKey:@"picklist_status"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *op in [taskDict valueForKey:@"picklist_status"]) {
                TFCustomerOptionModel *oopp = [[TFCustomerOptionModel alloc] initWithDictionary:op error:nil];
                [statuses addObject:oopp];
            }
        }
        task.picklist_status = statuses;
        
        // row 及 rows 解析
        /**
         TFFieldNameModel
        TFCustomRowModel
         */
        
        NSArray *rowArr = [taskDict valueForKey:@"row"];
        NSMutableArray <Optional,TFFieldNameModel>*rowModels = [NSMutableArray<Optional,TFFieldNameModel> array];
        for (NSDictionary *dii in rowArr) {
            TFFieldNameModel *fie = [[TFFieldNameModel alloc] initWithDictionary:dii error:nil];
            if (dii) {
                [rowModels addObject:fie];
            }
        }
        task.row = rowModels;
        
        NSDictionary *rows = [taskDict valueForKey:@"rows"];
        TFCustomRowModel *rowsModel = [[TFCustomRowModel alloc]  initWithDictionary:rows error:nil];
        task.rows = rowsModel;
        
        task.icon_color = [taskDict valueForKey:@"icon_color"];
        task.icon_url = [taskDict valueForKey:@"icon_url"];
        task.icon_type = [taskDict valueForKey:@"icon_type"];
        task.bean_type = [taskDict valueForKey:@"bean_type"];
        task.bean_name = [taskDict valueForKey:@"bean_name"];
        task.module_name = [taskDict valueForKey:@"module_name"];
        task.module_id = [taskDict valueForKey:@"module_id"];
        task.bean_id = [taskDict valueForKey:@"bean_id"];
        
    }else{// 存在
        
        task.taskDict = taskDict;
        task.projectId = [taskDict valueForKey:@"project_id"];
        if ([task.from isEqualToNumber:@1]) {
            task.dataType = @2;
        }
        if (task.dataType == nil) {
            task.dataType = @2;
        }
        if (task.bean_id == nil) {
            task.bean_id = task.id;
        }
        task.taskName = task.text_name;
        task.name = task.text_name;
        task.endTime = task.datetime_deadline;
        task.startTime = task.datetime_starttime;
        if (task.personnel_principal.count) {
            task.responsibler = task.personnel_principal[0];
        }
        task.finishType = task.complete_status;
        task.activeNum = task.activate_number?:task.complete_number;
        task.childTaskNum = [taskDict valueForKey:@"sub_task_count"] ? [taskDict valueForKey:@"sub_task_count"] : [taskDict valueForKey:@"subtotal"];
        task.finishChildTaskNum = [taskDict valueForKey:@"sub_task_complete_count"]?[taskDict valueForKey:@"sub_task_complete_count"]:[taskDict valueForKey:@"subfinishtotal"];
        if (!IsNilOrNull(task.task_id)) {// 子任务
            task.taskName = IsStrEmpty([taskDict valueForKey:@"name"])?[taskDict valueForKey:@"text_name"]:[taskDict valueForKey:@"name"];
            task.endTime = [taskDict valueForKey:@"end_time"];
        }
        
        NSMutableArray<Optional,TFCustomerOptionModel> *tags = [NSMutableArray<Optional,TFCustomerOptionModel> array];
        if ([taskDict valueForKey:@"picklist_tag"] && ![[taskDict valueForKey:@"picklist_tag"] isKindOfClass:[NSString class]]) {
            for (NSDictionary *op in [taskDict valueForKey:@"picklist_tag"]) {
                
                if ([op valueForKey:@"name"] && ![[op valueForKey:@"name"] isEqualToString:@""]) {
                    TFCustomerOptionModel *oopp = [[TFCustomerOptionModel alloc] init];
                    oopp.label = [op valueForKey:@"name"];
                    oopp.color = [op valueForKey:@"colour"];
                    oopp.value = [[op valueForKey:@"id"] description];
                    [tags addObject:oopp];
                }
            }
        }
        
        task.tagList = tags;
    }
    
    return task;
}

/** 根据字节截取字符串 */
+ (NSString *)subStringByByteWithIndex:(NSInteger)index string:(NSString *)string {
    
    NSInteger sum = 0;
    
    NSString *subStr = [[NSString alloc] init];
    
    for(int i = 0; i<[string length]; i++){
        
        unichar strChar = [string characterAtIndex:i];
        
        if(strChar < 256){
            sum += 1;
        }
        else {
            sum += 2;
        }
        if (sum >= index) {
            
            subStr = [string substringToIndex:i+1];
            return subStr;
        }
        
    }
    
    return subStr;
    
}

/** 得到字符串的字节数字节数函数 */
+  (int)stringConvertToInt:(NSString*)strtemp
{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++)
    {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (strlength+1)/2;
}

/** 是否有权限 */
+(BOOL)haveProjectAuthWithPrivilege:(NSString *)privilege auth:(NSString *)auth{
    BOOL have = NO;
    if (IsStrEmpty(privilege) || IsStrEmpty(auth)) {
        return NO;
    }
    NSInteger i = 0;
    NSArray *auths = [auth componentsSeparatedByString:@","];
    NSArray *privileges = [privilege componentsSeparatedByString:@","];
    for (NSString *pri in privileges) {
        for (NSString *au in auths) {
            if ([pri isEqualToString:au]) {
                have = YES;
                i ++;
                break;
            }
        }
    }
    BOOL pri = auths.count == i;
    return pri;
}

/** 任务是否有某个权限 */
+(BOOL)haveTaskAuthWithAuths:(NSArray *)auths authKey:(NSString *)authKey role:(NSString *)role{
    BOOL have = NO;
    if (IsArrEmpty(auths) || IsStrEmpty(role)) {
        return NO;
    }
    NSArray *roles = [role componentsSeparatedByString:@","];
    for (NSString *roStr in roles) {
        for (NSDictionary *dict in auths) {
            if ([roStr isEqualToString:[[dict valueForKey:@"role_type"] description]]) {
                if ([[[dict valueForKey:authKey] description] isEqualToString:@"1"]) {
                    return YES;
                }
            }
        }
    }
    
    return have;
}


/** 计算上传图片或者附件符合要求的数组 */
+(NSArray *)caculateImageSizeWithImages:(NSArray *)images maxSize:(CGFloat)maxSize{
    
    NSMutableArray *fits = [NSMutableArray array];
   
    for (UIImage *image in images) {
        
        if ([image isKindOfClass:[UIImage class]]) {// 一定为图片
            
            NSData *eachImgData = UIImageJPEGRepresentation(image, 0.1);// 压缩后的大小
            CGFloat length = eachImgData.length;
            if (length/1000.0/1000.0 <= maxSize) {// 满足小于最大上传大小
                [fits addObject:image];
            }
        }
    }
    
    return fits;
}


/** 手机型号 */
+(NSString *)iPhoneType{
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString*phoneType = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if([phoneType isEqualToString:@"iPhone1,1"])  return @"2G";
    
    if([phoneType isEqualToString:@"iPhone1,2"])  return @"3G";
    
    if([phoneType isEqualToString:@"iPhone2,1"])  return @"3GS";
    
    if([phoneType isEqualToString:@"iPhone3,1"])  return @"4";
    
    if([phoneType isEqualToString:@"iPhone3,2"])  return @"4";
    
    if([phoneType isEqualToString:@"iPhone3,3"])  return @"4";
    
    if([phoneType isEqualToString:@"iPhone4,1"])  return @"4S";
    
    if([phoneType isEqualToString:@"iPhone5,1"])  return @"5";
    
    if([phoneType isEqualToString:@"iPhone5,2"])  return @"5";
    
    if([phoneType isEqualToString:@"iPhone5,3"])  return @"5c";
    
    if([phoneType isEqualToString:@"iPhone5,4"])  return @"5c";
    
    if([phoneType isEqualToString:@"iPhone6,1"])  return @"5s";
    
    if([phoneType isEqualToString:@"iPhone6,2"])  return @"5s";
    
    if([phoneType isEqualToString:@"iPhone7,1"])  return @"6Plus";
    
    if([phoneType isEqualToString:@"iPhone7,2"])  return @"6";
    
    if([phoneType isEqualToString:@"iPhone8,1"])  return @"6s";
    
    if([phoneType isEqualToString:@"iPhone8,2"])  return @"6sPlus";
    
    if([phoneType isEqualToString:@"iPhone8,4"])  return @"SE";
    
    if([phoneType isEqualToString:@"iPhone9,1"])  return @"7";
    
    if([phoneType isEqualToString:@"iPhone9,2"])  return @"7Plus";
    
    if([phoneType isEqualToString:@"iPhone10,1"]) return @"8";
    
    if([phoneType isEqualToString:@"iPhone10,4"]) return @"8";
    
    if([phoneType isEqualToString:@"iPhone10,2"]) return @"8Plus";
    
    if([phoneType isEqualToString:@"iPhone10,5"]) return @"8Plus";
    
    if([phoneType isEqualToString:@"iPhone10,3"]) return @"X";
    
    if([phoneType isEqualToString:@"iPhone10,6"]) return @"X";
    
    if([phoneType isEqualToString:@"iPhone11,8"]) return @"XR";
    
    if([phoneType isEqualToString:@"iPhone11,2"]) return @"XS";
    
    if([phoneType isEqualToString:@"iPhone11,4"]) return @"XSMax";
    
    if([phoneType isEqualToString:@"iPhone11,6"]) return @"XSMax";
    
    return nil;
}
/** 将下划线字段的字典转化为小驼峰字段的字典 */
+(NSDictionary *)handleDictionaryWithDict:(NSDictionary *)dict{
    
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    for (NSString *key in dict.allKeys) {
        NSArray *arr = [key componentsSeparatedByString:@"_"];
        if (arr.count){
            NSString *fir = arr.firstObject;
            for (NSInteger i = 1; i < arr.count; i++) {
                NSString *x1 = arr[i];
                if (x1.length) {
                    fir = [fir stringByAppendingString:[[[x1 substringToIndex:1] uppercaseString] stringByAppendingString:[x1 substringFromIndex:1]]];
                }
            }
            if ([dict valueForKey:key]) {
                [dict1 setObject:[dict valueForKey:key] forKey:fir];
            }
        }
    }
    return dict1;
}

/** 将大数字用逗号分割显示
 * num 大数字字符串
 * bit 按几位分割
 */
+(NSString *)changeNumberFormat:(NSString *)num bit:(NSString *)bitStr;
{
    if (num == nil) {
        return @"";
    }
    if (bitStr == nil) {
        return num;
    }
    NSInteger bit = [bitStr integerValue];
    if (bit <= 0) {
        return num;
    }else if (bit == 1){
        bit = 3;
    }else{
        bit = 4;
    }
    if (![self judgeNumberWithStr:num]) {// 不符合有意义的数字就不做处理
        return num;
    }
    BOOL prefix = NO;
    NSString *prefixStr = @"";
    if ([num hasPrefix:@"-"] || [num hasPrefix:@"+"]) {
        prefix = YES;
        prefixStr = [num substringToIndex:1];
        num = [num stringByReplacingOccurrencesOfString:@"-" withString:@""];
        num = [num stringByReplacingOccurrencesOfString:@"+" withString:@""];
    }
    BOOL suffix = NO;
    NSString *suffixStr = @"";
    if ([num hasSuffix:@"%"] || [num hasSuffix:@"‰"]) {
        suffix = YES;
        suffixStr = [num substringFromIndex:num.length-1];
        num = [num stringByReplacingOccurrencesOfString:@"%" withString:@""];
    }
    int count = 0;
    NSArray *arr = [num componentsSeparatedByString:@"."];
    long long a = [arr.firstObject longLongValue];
    while (a != 0)
    {
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:arr.firstObject];
    NSMutableString *newstring = [NSMutableString string];
    while (count > bit) {
        count -= bit;
        NSRange rang = NSMakeRange(string.length - bit, bit);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    if (arr.count == 2) {// 有小数
        NSString *last = arr.lastObject;
        NSInteger index = last.length / bit;
        NSMutableString *string1 = [NSMutableString stringWithString:last];
        NSMutableString *newstring1 = [NSMutableString string];
        
        while (index) {
            index -= 1;
            NSRange rang1 = NSMakeRange(0, bit);
            NSString *str = [string1 substringWithRange:rang1];
            [newstring1 insertString:str atIndex:newstring1.length];
            [newstring1 insertString:@"," atIndex:newstring1.length];
            [string1 deleteCharactersInRange:rang1];
        }
        if ([string1 isEqualToString:@""]) {
            [newstring1 deleteCharactersInRange:(NSRange){newstring1.length-1,1}];
        }else{
            [newstring1 insertString:string1 atIndex:newstring1.length];
        }
        
        newstring = [NSMutableString stringWithString:[newstring stringByAppendingString:[NSString stringWithFormat:@".%@",newstring1]]];
    }
    if (prefix && suffix) {
        return [NSString stringWithFormat:@"%@%@%@",prefixStr,newstring,suffixStr];
    }else if (prefix && !suffix) {
        return [NSString stringWithFormat:@"%@%@",prefixStr,newstring];
    }else if (!prefix && suffix) {
        return [NSString stringWithFormat:@"%@%@",newstring,suffixStr];
    }else{
        return newstring;
    }
}


+ (ZLPhotoActionSheet *)takeHPhotoWithBlock:(void (^) (NSArray<UIImage *> *images))block
{
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
    
    actionSheet.configuration.allowSelectImage = YES;
    actionSheet.configuration.maxSelectCount = 9;
//    actionSheet.configuration.maxVideoSelectCountInMix = 3;
//    actionSheet.configuration.minVideoSelectCountInMix = 1;
    //是否允许框架解析图片
    actionSheet.configuration.shouldAnialysisAsset = NO;
    actionSheet.configuration.allowSelectVideo = NO;
    actionSheet.configuration.allowSelectLivePhoto = NO;
    //设置相册内部显示拍照按钮
    actionSheet.configuration.allowTakePhotoInLibrary = NO;
    
    [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        [ZLPhotoManager anialysisAssets:assets original:NO completion:^(NSArray<UIImage *> *assetimages) {
            if (block) {
                block(assetimages);
            }
        }];
    }];
    
    actionSheet.selectImageRequestErrorBlock = ^(NSArray<PHAsset *> * _Nonnull errorAssets, NSArray<NSNumber *> * _Nonnull errorIndex) {
        HQLog(@"图片解析出错的索引为: %@, 对应assets为: %@", errorIndex, errorAssets);
    };
    
    actionSheet.cancleBlock = ^{
        HQLog(@"取消选择图片");
    };
    
    return actionSheet;
}












@end
