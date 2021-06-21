//
//  HQHelper.h
//  HuiJuHuaQi
//
//  Created by XieLB on 16/1/14.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "TFEmployeeCModel+CoreDataClass.h"
#import "NSString+Auth.h"
#import "TFFieldNameModel.h"
#import "HQEmployModel.h"
#import "TFAssistantFieldInfoModel.h"
#import "TFProjectRowModel.h"
#import "TFFileModel.h"
#import <Photos/Photos.h>
#import <ZLPhotoBrowser/ZLPhotoBrowser.h>


@interface HQHelper : NSObject

+ (UIImage*)createImageWithColor: (UIColor*) color;

+ (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size;

/* 获得View上的图像 */
+ (UIImage *)imageFromView:(UIView *)theView;
/* 获得某个范围内的屏幕图像 */
+ (UIImage *)imageFromView:(UIView *)theView atFrame:(CGRect)rect;

+ (UIImageView *)imageViewWithFrame:(CGRect)frame
                              image:(UIImage *)image;


+ (UILabel *)labelWithFrame:(CGRect)frame
                       text:(NSString *)text
                  textColor:(UIColor *)color
              textAlignment:(NSTextAlignment)alignment
                       font:(UIFont *)font;

+ (UIButton *)buttonWithFrame:(CGRect)frame
                       target:(id)target
                       action:(SEL)action;

+ (UIButton *)buttonWithFrame:(CGRect)frame
               normalImageStr:(NSString *)normalImageStr
                 highImageStr:(NSString *)highImageStr
                       target:(id)target
                       action:(SEL)action;

+ (UIButton *)buttonWithFrame:(CGRect)frame
               normalImageStr:(NSString *)normalImageStr
              seletedImageStr:(NSString *)seletedImageStr
                 highImageStr:(NSString *)highImageStr
                       target:(id)target
                       action:(SEL)action;


//+ (UIButton *)buttonOfMainButtonWithFrame:(CGRect)frame
//                                    title:(NSString *)title
//                                   target:(id)target
//                                   action:(SEL)action;

+ (UIButton *)buttonOfMainButtonWithFrame:(CGRect)frame
                                    title:(NSString *)title
                              normalColor:(UIColor *)normalColor
                                highColor:(UIColor *)highColor
                            disabledColor:(UIColor *)disabledColor
                               titleColor:(UIColor *)titleColor
                            disTitleColor:(UIColor *)disTitleColor
                                     font:(UIFont *)font
                                   target:(id)target
                                   action:(SEL)action;


+ (UIBarButtonItem *)itemWithSize:(CGSize)size title:(NSString *)title titleColor:(UIColor *)titleColor target:(id)target selector:(SEL)selector;

//返回文本行数
+ (int)returnLineNumberOfString:(NSString *)textStr font:(UIFont *)textFont textWidth:(float)textWidth;

//字节长度
+ (int)charNumber:(NSString*)strtemp;

//将字符串保留到最大字符数
+ (NSString *)returnCharLengthStr:(NSString*)strtemp withMaxNum:(NSInteger)maxNum;

/** 检查手机号码 */
+ (BOOL)checkTel:(NSString *)str;

/** 检查邮箱 */
+ (BOOL)checkEmail:(NSString *)str;

/** 检查是否为网址 */
+ (BOOL)checkUrl:(NSString *)str;

/** 检查密码 */
+(BOOL)checkPassWord:(NSString *)str;

/** 检查验证码 */
+(BOOL)checkSure:(NSString *)str;

/** 验证码计时按钮 */
+(void)timeBtn:(UIButton *)button;

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
                                textStr:(NSString *)textStr;


/** 获取WIFI名 */
+ (NSString *)getWifiName;

/** 获取已连接WIFI信息
 *
 *  return  WiFi信息（WIFI名，MAC地址）
 *  WiFiName(key)-->WIFI名（value)
 *  MacAddress(key)-->MAC地址(value)
 */
+ (NSDictionary *)getCurrentWiFiInfo;

/**
 *  返回文字的SIZE
 *
 *  @prama font 字符串字号
 *  @prama maxSize 指定区域
 *  @prama titleStr 字符串
 */
+ (CGSize)sizeWithFont:(UIFont*)font maxSize:(CGSize)maxSize titleStr:(NSString *)titleStr;
/**
 *  返回文字的SIZE
 *
 *  @prama attribute 字符串属性
 *  @prama maxSize 指定区域
 *  @prama titleStr 字符串
 */
+ (CGSize)sizeWithAttributeDictionary:(NSDictionary*)attribute maxSize:(CGSize)maxSize titleStr:(NSString *)titleStr;

/**************************    判断文本是否合法    **********************/

//判断文本是否合法(中文、英文、数字 特殊符号)
+ (BOOL)textIsLegitimateWithStr:(NSString *)textStr;


//汉字、字母、数字、括号和下划线；
+ (BOOL)textAndLineIsLegitimateWithStr:(NSString *)textStr;

//汉字，字母、数字
+ (BOOL)checkChineseNumberAndLettersWithStr:(NSString *)textStr;

//汉字，字母
+ (BOOL)checkChineseAndLettersWithStr:(NSString *)textStr;

//字母、数字或下划线
+ (BOOL)numberAndLineIsLegitimateWithStr:(NSString *)textStr;

//数字和负号
+ (BOOL)numberWithStr:(NSString *)textStr;


//数字
+ (BOOL)pureNumberWithStr:(NSString *)textStr;
/**************************    时间处理    **********************/
/**
 *  获取当前时间戳
 *
 *  @return 时间戳（毫秒数）
 */
+ (long long)getNowTimeSp;
/**
 *  获取date下时间戳
 *
 *  @prama date 时间
 *  @return 时间戳（毫秒数）
 */
+ (long long)getTimeSpWithDate:(NSDate *)date;
/*
 * 获取指定时间的下一天时间戳
 *
 *  @prama timeSp 时间戳（毫秒数）
 *  @return 下一天时间戳（毫秒数）
 */
+ (long long)getTomorrowWith:(long long)timeSp;


/**
 *  时间戳按HH:mm格式时间输出
 *
 *  @prama timeSp 时间戳（毫秒数）
 *  @return 时间字符串（HH:mm）
 */
+ (NSString *)nsdateToTime:(long long)timeSp;

/**
 *  时间戳按HH:mm格式时间输出
 *
 *  @prama spString 时间戳（毫秒数）
 *  @return 时间字符串（MM月dd日）
 */
+ (NSString*)nsdateToTime2:(long long)timeSp;

/*
 * 将时间戳按指定格式时间输出
 *
 *  @prama spString 时间戳（毫秒数）
 *  @prama formatStr 时间格式
 *  @return 时间格式的字符串
 */
+ (NSString *)nsdateToTime:(long long)timeSp formatStr:(NSString *)formatStr;


/**
 *  将时间戳按今年MM/dd HH:mm，今年以前yyyy/MM/dd HH:mm格式时间输出
 *
 *  @prama timeSp 时间戳（毫秒数）
 *  @return 时间格式字符串
 *
 */
+ (NSString*)nsdateToTimeNowYear:(long long)timeSp;

/**
 *  将时间戳按今天HH:mm，今年非今年MM/dd HH:mm ,今年以前yyyy/MM/dd HH:mm格式时间输出
 *
 *  @prama timeSp 时间戳（毫秒数）
 *  @return 时间格式字符串
 *
 */
+ (NSString*)nsdateToTimeNowYearNowMonthNowDay:(long long)timeSp;

/** 企业圈时间
 *
 * @param timeSp 时间戳毫秒数
 */
+ (NSString*)companyCircleTimeWithTimeSp:(long long)timeSp;


/**
 * @prama timeStr 将yyyy-MM-dd HH:mm:ss格式时间字符串（默认时间格式为yyyy-MM-dd HH:mm:ss）
 * @return 时间戳（毫秒数）
 */
+ (long long)changeTimeToTimeSp:(NSString *)timeStr;


/**
 * @prama timeStr 时间字符串
 * @prama timeStr 时间字符串对应的格式（eg.12:29对应HH:mm,2015/09/12 12:29对应yyyy/MM/dd HH:mm）
 * @return 时间戳（毫秒数）
 */
+ (long long)changeTimeToTimeSp:(NSString *)timeStr formatStr:(NSString *)formatStr;

/*
 * 将时间戳以年周时间格式输出
 *
 *  @prama interval 时间戳（毫秒数）
 *  @return 年周时间格式字符串
 */
+ (NSString *)getYearWeekWithInterVal:(long long)timeSp;
/*
 * 将时间戳以年周时间格式输出
 *
 *  @prama interval 时间戳（毫秒数）
 *  @return 年周时间格式字符串
 */
+ (NSString *)getYearWeekWithInterVal2:(long long)timeSp;

/**
 *  将某年某周转化为时间戳（yyyy年02ld周）
 *
 *  @prama timeStr 时间字符串（符合yyyy年02ld周格式的字符串）
 *  @return 时间戳（毫秒数）
 */
+ (long long)changeWeekTimeToTimeSp:(NSString *)timeStr;


/**
 *  将某年某周转化为该周第一天的年月日
 *
 *  @prama timeStr 时间字符串（符合yyyy年02ld周格式的字符串）
 *  @return 该周第一天的年月日(yyyy/MM/dd)
 */
+ (NSString *)changeWeekTimeToTime:(NSString *)timeStr;


/** 获取当前系统的yyyy-MM-dd HH:mm:ss格式时间 */
+ (NSString *)getTime;

/** 获取当前系统的yyyy-MM-dd格式时间 */
+ (NSString *)getTime2;

/** 获取年周（yyyy年02ld周） */
+ (NSString *)getYearWeek;

/** 获取年月（yyyy年MM月） */
+ (NSString *)getYearMonth;

/** 将date转为年周（yyyy年02ld周） */ 
+ (NSString *)getYearWeekWithDate:(NSDate *)date;

/** 将date转为年周（yyyy年第02ld周） */
+ (NSString *)getYearWeekWithDate2:(NSDate *)date;

/** 将date转为年（yyyy年） */
+ (NSString *)getYear:(NSDate *)date;
/** 将当前时间转为年（yyyy年） */
+ (NSString *)getYear;
/** 将当前时间转为月（MM月） */
+ (NSString *)getMonth;
/** 将当前时间转为周几（周五） */
+ (NSString *)getWeekday;
/** 将当前时间转为星期几（星期五） */
+ (NSString *)getWeekday2;
/** 将当前时间转为星期几（星期五） */
+ (NSString *)getWeekday2WithDate:(NSDate *)dete;
/** 将当前时间转为日（dd日） */
+ (NSString *)getDay;
/** 将当前时间转为MM月dd日 */
+ (NSString *)getMonthDay;
/** 将当前时间转为时（HH） */
+ (NSString *)getHour;
/** 将当前时间转为分（mm） */
+ (NSString *)getMiute;
/** 将当前时间转为天（dd） */
+ (NSString *)getNowDay;

/** 根据员工id找到员工信息 */
+ (TFEmployeeCModel *)employeeWithEmployeeID:(NSNumber *)employeeID;
/** 根据员工ID,signId获取员工 */
+ (TFEmployeeCModel *)employeeWithEmployeeID:(NSNumber *)employeeID signId:(NSNumber *)signId;

/** 根据员工ID数组获取员工数组 */
+ (NSArray *)employeesWithEmployIds:(NSArray *)employeeIds;
/** 获取当前登录用户信息 */
+ (TFEmployeeCModel *)getCurrentLoginEmployee;
/** 是否为自己 */
+ (BOOL)isMyselfWithEmployeeId:(NSNumber *)employeeId;


/**获取文件大小**/
+ (long long) fileSizeAtPath:(NSString*) filePath;
/**获取文件及子文件大小**/
+(float ) folderSizeAtPath:(NSString*) folderPath;
+(NSString *)fileSizeForUnit:(NSString*) filePath;

/** 文件大小B-->合适的单位 */
+(NSString *)fileSizeForKB:(NSInteger)file;

/**图片背景取色**/
+ (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage;

/** 设置tableView无数据时的背景提示(中心位置) */
+ (void)setupBackgroudViewForTableView:(UITableView *)tableView withImageName:(NSString *)imageName titleText:(NSString *)titleText;
/** 设置tableView无数据时的背景提示(上部位置) */
+ (void)setupBackgroudViewNotCenterTableView:(UITableView *)tableView withImageName:(NSString *)imageName titleText:(NSString *)titleText;
/** 设置tableView背景提示（提示中心为point）*/
+ (void)setupBackgroudViewForTableView:(UITableView *)tableView withPoint:(CGPoint)point withImageName:(NSString *)imageName titleText:(NSString *)titleText;

/* 把格式化的JSON格式的字符串转换成字典 */
+ (id)dictionaryWithJsonString:(NSString *)jsonString;

/* 把字典转换成格式化的JSON格式的字符串 */
+ (NSString*)dictionaryToJson:(id)dic;

// 保留最大行数字符串
+ (NSString *)saveMaxRowStringWithCharLengthStr:(NSString*)strtemp font:(UIFont *)font textWidth:(float)textWidth withMaxNum:(NSInteger)maxNum;

/**
 * @cafUrl  录音原始地址
 * @cafUrl  录音转为MP3地址
 * @return  返回MP3地址的url
 */
+ (NSURL *)recordCafToMp3WithCafUrl:(NSString *)cafUrl toMp3Url:(NSString *)mp3Url;



///**网络状态监测**/
//
//- (void)checkCurrentWorknetStatus:(UIViewController *)viewCtr;
//

/** 获取Date下日期 */
+ (NSString *)getDayWithDate:(NSDate *)date;
/** 获取Date下小时 */
+ (NSString *)getHourWithDate:(NSDate *)date;
/** 获取Date下分钟 */
+ (NSString *)getMiuteWithDate:(NSDate *)date;
/** 获取Date下周 */
+ (NSString *)getWeekWithDate:(NSDate *)date;
/** 获取Date下的月日 */
+ (NSString *)getMonthDayWithDate:(NSDate *)date;
+ (NSString *)getMonthDayWithDate2:(NSDate *)date;
/** 获取Date下的年月日时分 */
+ (NSString *)getYearMonthDayHourMiuthWithDate:(NSDate *)date;
/** 获取Date下的年月日 */
+ (NSString *)getYearMonthDayWithDate:(NSDate *)date;
/** 获取Date下的时分 */
+ (NSString *)getHourMiuthWithDate:(NSDate *)date;



/** 倒计时 */
+(void)backTimeText:(UILabel *)label;


//把装有字符串的数组转换成装有NSNumber的数组
+ (NSArray *)stringsChangeNumbers:(NSArray *)strings;

/** 图片上某点的颜色值 */
+ (UIColor *)image:(UIImage *)image colorAtPixel:(CGPoint)point;

/**
 * 群聊头像（UIImageView）
 *
 * @pram images 群聊人员头像数组
 */
+ (UIImageView *)creatImageViewWtihImages:(NSArray *)images;
/**
 * 群聊头像（UIImageView）
 *
 * @pram images 群聊人员头像数组
 * @pram margin 头像之间的间距
 */
+ (UIImageView *)creatImageViewWtihImages:(NSArray *)images withMargin:(CGFloat)margin;
/**
 * 群聊头像（UIImage）
 *
 * @pram images 群聊人员头像数组
 */
+ (UIImage *)creatImageWtihImages:(NSArray *)images;
/**
 * 群聊头像（UIImage）
 *
 * @pram images 群聊人员头像数组
 * @pram margin 头像之间的间距
 */
+ (UIImage *)creatImageWtihImages:(NSArray *)images withMargin:(CGFloat)margin;

/**
 *  将十六进制数值（#ad23a4/#Ad33BB/0XadAd33/0xAd33d4）转为颜色
 *
 *   默认透明不为1.0f
 *  @prama color 十六进制数值字符串
 */
+ (UIColor *)colorWithHexString:(NSString *)color;

/**
 *  将十六进制数值（#ad23a4/#Ad33BB/0XadAd33/0xAd33d4）转为颜色
 *
 *  @prama color 十六进制数值字符串
 *  @prama alpha 透明度
 */
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

/**
 *  指定字符串生成二维码
 *
 * @param string   需要生成二维码的字符串
 * @param imgWidth 二维码图片宽度（宽高一样）
 *
 */
+ (UIImage *)creatBarcodeWithString:(NSString *)string withImgWidth:(CGFloat)imgWidth;

/**
 *  指定字符串生成条形码
 *
 * @param string   需要生成条形码的字符串
 * @param imgWidth 条形码图片宽度
 *
 */
+ (UIImage *)createBarWithString:(NSString *)string withImgWidth:(CGFloat)imgWidth;

#pragma mark **********************
/*
 *画线1
 */
+(void)drawLine:(UIView *)rootView headOrFoot:(NSString *)headOrFoot letfMargin:(float)letfMargin rightMargin:(float)rightMargin lineHeight:(float)lineHeight;

/*
 *设置Autolayout中的边距辅助方法
 */
+(void)setEdge:(UIView*)superview view:(UIView*)view attr:(NSLayoutAttribute)attr multiplier:(float)multiplier constant:(CGFloat)constant;

/**
 *  压缩图片，压缩到100~300k左右
 *
 *  @param image 图片参数
 *  @param size  大小
 *
 *  @return 图片大小
 */
+(NSData *)scaleToSize:(UIImage *)image size:(CGSize)size;

//计算出大小
+(NSString *)fileSizeWithInterge:(NSInteger)size;

//计算缓存大小
+(float)getCacheSize:(NSString *)cacheFilePath;

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

/**
 *  设置边框和圆角,view:设置边框的视图,borderWith：边框的宽，radius：圆角半径，color：边框的颜色
 *
 *  @param view       设置边框的视图
 *  @param borderWith 边框的宽
 *  @param radius     圆角半径
 *  @param color      边框的颜色
 */
+(void)setBorderAndCorners:(UIView *)view borderWith:(CGFloat)borderWith radius:(CGFloat)radius color:(CGColorRef)color;

/*
 * 画线2
 */
+(void)drawline2:(UIView *)superView frame:(CGRect)frame color:(UIColor *)color;

/** 根据文件类型返回对应Image背景 */
//+ (UIImage *)fileTypeWithFileModel:(TFFileModel *)model;
+ (UIImage *)file_typeWithFileModel:(TFFileModel *)model;


/** 将字符串MD5加密后生成的字符串 */
+ (NSString *)stringForMD5WithString:(NSString *)string;


/** 缓存文件 */
+(void)cacheFileWithUrl:(NSString *)urlStr fileName:(NSString *)fileName completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler fileHandler:(void (^)(NSString *path))fileHandler;

/***
 *   通用文件下载(在非WiFi环境，判断了下载文件大于10M的流量提醒)
 *
 *   @prama urlStr 资源路径
 *   @prama fileSize 资源大小
 *   @prama completionHandler 下载完成或者出错回调
 *   @prama cancelHander 取消下载回调
 *   @prama fileHandler 本地文件回调
 *
 */
+(void)downloadFileWithUrl:(NSString *)urlStr fileName:(NSString *)fileName fileSize:(NSInteger)fileSize completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError * error))completionHandler cancelHander:(void (^)(NSString *candelDesc))cancelHander fileHandler:(void (^)(NSString *path))fileHandler;



/**  保存下载文件
 *
 * @param fileName 文件名
 * @param data 下载的数据
 *
 * return 文件保存路径，为nil时说明保存失败了
 */
+(NSString *)saveCacheFileWithFileName:(NSString *)fileName data:(NSData *)data;

/** 获取缓存文件路径 */
+(NSString *)getCacheFilePathWithFileName:(NSString *)fileName;

/** 图片方向修正 */
+ (UIImage *)fixedImageOrientationWithImage:(UIImage *)image;


/** 将全名变为简称 */
+ (NSString *)nameWithTotalName:(NSString *)totalName;

/** 将全名变为简称(取一个字) */
+ (NSString *)nameWithTotalName2:(NSString *)totalName;

/** 0:@"今天",1:@"昨天",2:@"过去7天",3:@"过去30天",4:@"本月",5:@"上月",6:@"本季度",7:@"上季度" */
+ (NSDictionary *)timePeriodWithIndex:(NSInteger)index;


/** 0:@"本年",1:@"上年"*/
+ (NSDictionary *)yearPeriodWithIndex:(NSInteger)index;
/** 0:@"本月",1:@"上月",2:@"本季度",3:@"上季度" */
+ (NSDictionary *)monthPeriodWithIndex:(NSInteger)index;

+(NSString *)createStarWithNumber:(NSInteger)number;
/** 处理组件类型的值 */
+ (NSString *)stringWithFieldNameModel:(TFFieldNameModel *)field;
/** 处理组件类型的值 */
+ (NSString *)stringWithFieldNameDict:(NSDictionary *)dict;

/** 小助手自定义组件类型处理 */
+ (NSString *)stringWithAssistantFieldInfoModel:(TFAssistantFieldInfoModel *)field;

/** 画水平虚线
 ** lineView:       需要绘制成虚线的view
 ** lineLength:     虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 **/
+ (void)drawHerDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;

/** 画垂直虚线
 ** lineView:       需要绘制成虚线的view
 ** lineLength:     虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 **/
+ (void)drawVerDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;

/** 获取公司所有人 */
+ (NSArray *)getAllPeoplesInCompany;
/** 根据employeeId获取员工信息 */
+ (HQEmployModel *)getEmployeeWithEmployeeId:(NSNumber *)employeeId;
/** 根据signId获取员工信息 */
+ (HQEmployModel *)getEmployeeWithSignId:(NSNumber *)signId;

+ (NSURL *)URLWithString:(NSString *)str;

/** 去除html内容标签，显示纯文本 */
+ (NSString *)filterHTML:(NSString *)html;

//邮箱正则
+ (BOOL) validateEmail:(NSString *)email;

+ (BOOL)checkNumber:(NSString *)number;

+(NSString *)getMMSSFromSS:(CGFloat )totalTime;

//lable加下划线
+ (NSAttributedString *)stringAttributeWithUnderLine:(NSString *)string;

/** 获取任务 */
+ (TFProjectRowModel *)projectRowWithTaskDict:(NSDictionary *)taskDict;

/** 根据字节截取字符串 */
+ (NSString *)subStringByByteWithIndex:(NSInteger)index string:(NSString *)string;

/** 得到字符串的字节数字节数函数 */
+  (int)stringConvertToInt:(NSString*)strtemp;

/** 是否有权限 */
+(BOOL)haveProjectAuthWithPrivilege:(NSString *)privilege auth:(NSString *)auth;

/** 任务是否有某个权限 */
+(BOOL)haveTaskAuthWithAuths:(NSArray *)auths authKey:(NSString *)authKey role:(NSString *)role;

/** 计算上传图片或者附件符合要求的数组 */
+(NSArray *)caculateImageSizeWithImages:(NSArray *)images maxSize:(CGFloat)maxSize;

/** 手机型号 */
+(NSString *)iPhoneType;

/** 将下划线字段的字典转化为小驼峰字段的字典 */
+(NSDictionary *)handleDictionaryWithDict:(NSDictionary *)dict;

/** 将大数字用逗号分割显示
 * num 大数字字符串
 * bit 按几位分割
 */
+(NSString *)changeNumberFormat:(NSString *)num bit:(NSString *)bitStr;

/** 是否为有意义的数字 */
+(BOOL)judgeNumberWithStr:(NSString *)str;

/** 照片选择器 */
+ (ZLPhotoActionSheet *)takeHPhotoWithBlock:(void (^) (NSArray<UIImage *> *images))block;
@end
