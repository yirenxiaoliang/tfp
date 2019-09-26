//
//  JCHATMessageContentView.m
//  JChat
//
//  Created by HuminiOS on 15/11/2.
//  Copyright © 2015年 HXHG. All rights reserved.
//

#import "JCHATMessageContentView.h"
//#import "JChatConstants.h"
#import "TFChatFileView.h"
#import "TFChatCustomView.h"
#import "TFChatCustomModel.h"

static NSInteger const textMessageContentTopOffset = 10;
static NSInteger const textMessageContentRightOffset = 15;

@interface JCHATMessageContentView ()
//<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>

/** BMKMapView */
//@property (nonatomic, strong) BMKMapView *mapView;

/** BMKMapView */
@property (nonatomic, strong) UIView *locationView;
/** UILabel *desc */
@property (nonatomic, weak) UILabel *desc;
/** UILabel *mark */
@property (nonatomic, weak) UILabel *mark;
/** locService */
//@property (nonatomic, strong)BMKLocationService *locService;;

/** geoCodeSearch */
//@property (nonatomic, strong)BMKGeoCodeSearch *geoCodeSearch;

/** TFChatFileView */
@property (nonatomic, strong) TFChatFileView *fileView;
/** TFChatCustomView */
@property (nonatomic, strong) TFChatCustomView *customView;


@end

@implementation JCHATMessageContentView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self != nil) {
    [self attachTapHandler];
      
      [self addSubview:self.fileView];
//      [self addSubview:self.mapView];
      [self addSubview:self.locationView];
      [self addSubview:self.customView];

  }
  return self;
}
#pragma mark-------初始化地图服务---------

-(TFChatFileView *)fileView{
    if (!_fileView) {
        _fileView = [[TFChatFileView alloc] initWithFrame:self.bounds];
    }
    return _fileView;
}

-(TFChatCustomView *)customView{
    if (!_customView) {
        _customView = [[TFChatCustomView alloc] initWithFrame:self.bounds];
    }
    return _customView;
}

//-(BMKMapView *)mapView{
//    if (!_mapView) {
//
//        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8) {
//            //由于IOS8中定位的授权机制改变 需要进行手动授权
//            CLLocationManager  *locationManager = [[CLLocationManager alloc] init];
//            //获取授权认证
////            [locationManager requestAlwaysAuthorization];
//            [locationManager requestWhenInUseAuthorization];
//        }
//
//        _mapView=[[BMKMapView alloc]initWithFrame:self.bounds];
//        _mapView.showsUserLocation = NO;//显示定位图层
//        _mapView.zoomLevel = 17;
//        _mapView.mapType = BMKMapTypeStandard;//设定为标准地图
//
//        _mapView.delegate = self;
//
//        if (_message.contentType == kJMSGContentTypeLocation) {
//
//            [self refreshCenter];
//        }
//    }
//
//    return _mapView;
//}

-(UIView *)locationView{
    
    if (!_locationView) {
        _locationView = [[UIView alloc] init];
        _locationView.backgroundColor = WhiteColor;
        UILabel *mark = [[UILabel alloc] init];
        mark.font = BFONT(20);
        mark.text = @"[位置]";
        self.mark = mark;
        mark.textColor = BlackTextColor;
        [_locationView addSubview:mark];
        [mark mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(_locationView) ;
            
            if ([_message isReceived]) {
                make.left.equalTo(_locationView).with.offset(10);
                make.right.equalTo(_locationView).with.offset(-10);
            }else{
                make.left.equalTo(_locationView).with.offset(5);
                make.right.equalTo(_locationView).with.offset(-5);
            }
            make.height.equalTo(@25) ;
            
        }];
        
        UILabel *desc = [[UILabel alloc] init];
        desc.font = BFONT(14);
        desc.textColor = ExtraLightBlackTextColor;
        [_locationView addSubview:desc];
        self.desc = desc;
        
        [desc mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.equalTo(_locationView) ;
            if ([_message isReceived]) {
                
                make.left.equalTo(_locationView).with.offset(10);
                make.right.equalTo(_locationView).with.offset(-10) ;
            }else{
                
                make.left.equalTo(_locationView).with.offset(5);
                make.right.equalTo(_locationView).with.offset(-5) ;
            }
            make.height.equalTo(@25) ;
            
        }];
    }
    return _locationView;
}

-(void)dealloc{
    
//    _mapView.delegate = nil;
}


- (id)init {
  self = [super init];
  if (self != nil) {
    _textContent = [UILabel new];
    _textContent.numberOfLines = 0;
    _textContent.backgroundColor = [UIColor clearColor];
    _voiceConent = [UIImageView new];
      _voiceConent.contentMode = UIViewContentModeCenter;
    _isReceivedSide = NO;
    [self addSubview:_textContent];
    [self addSubview:_voiceConent];
      _textContent.textColor = BlackTextColor;
  }
  return self;
}

- (void)setMessageContentWith:(JMSGMessage *)message {
  BOOL isReceived = [message isReceived];
  _message = message;
    
//    self.mapView.hidden = YES;
    self.locationView.hidden = YES;
    self.fileView.hidden = YES;
    self.customView.hidden = YES;
  UIImageView *maskView = nil;
  UIImage *maskImage = nil;
  if (isReceived) {
//      maskImage = [UIImage imageNamed:@"otherChatBg"];
      maskImage = [UIImage imageNamed:@"白色paopao"];
  } else {
//      maskImage = [UIImage imageNamed:@"mychatBg"];
      maskImage = [UIImage imageNamed:@"绿色paopao"];
      
      if (!(message.contentType == kJMSGContentTypeText || message.contentType == kJMSGContentTypeVoice)) {
          
          maskImage = [UIImage imageNamed:@"白泡泡右"];
      }
      
  }
//  maskImage = [maskImage resizableImageWithCapInsets:UIEdgeInsetsMake(36, 20, 2, 20)];
    
    NSInteger leftCapWidth = 42 * 0.9f;
    NSInteger topCapHeight = 40 * 0.9f;
    maskImage=[maskImage stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
    
  [self setImage:maskImage];
  maskView = [UIImageView new];
  maskView.image = maskImage;
  [maskView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
  self.layer.mask = maskView.layer;
  self.contentMode = UIViewContentModeScaleToFill;
  switch (message.contentType) {
    case kJMSGContentTypeText:
      {
          _voiceConent.hidden = YES;
          _textContent.hidden = NO;
          
          if (isReceived) {
              
              
              [_textContent setFrame:CGRectMake(textMessageContentRightOffset + 5, textMessageContentTopOffset, self.frame.size.width - 2 * textMessageContentRightOffset, self.frame.size.height- 2 * textMessageContentTopOffset)];
          } else {
              [_textContent setFrame:CGRectMake(textMessageContentRightOffset - 5, textMessageContentTopOffset, self.frame.size.width - 2 * textMessageContentRightOffset, self.frame.size.height- 2 * textMessageContentTopOffset)];
          }
          _textContent.text = ((JMSGTextContent *)message.content).text;
      }
      break;
      
    case kJMSGContentTypeImage:
      {
          _voiceConent.hidden = YES;
          _textContent.hidden = YES;
          self.contentMode = UIViewContentModeScaleAspectFill;
          if (message.status == kJMSGMessageStatusReceiveDownloadFailed) {
              [self setImage:[UIImage imageNamed:@"receiveFail"]];
          } else {
              [(JMSGImageContent *)message.content thumbImageData:^(NSData *data, NSString *objectId, NSError *error) {
                  if (error == nil) {
                      if (data != nil) {
                          [self setImage:[UIImage imageWithData:data]];
                          
                      } else {
                          [self setImage:[UIImage imageNamed:@"receiveFail"]];
                      }
                  } else {
                      [self setImage:[UIImage imageNamed:@"receiveFail"]];
                  }
              }];
          }
      }
      break;
      
    case kJMSGContentTypeVoice:
      {
          _textContent.hidden = YES;
          _voiceConent.hidden = NO;
          if (isReceived) {
              [_voiceConent setFrame:CGRectMake(20, 12, 16, 16)];
              [_voiceConent setImage:[UIImage imageNamed:@"ReceiverVoiceNodePlaying"]];
          } else {
              [_voiceConent setFrame:CGRectMake(self.frame.size.width - 30, 12, 16, 16)];
              [_voiceConent setImage:[UIImage imageNamed:@"SenderVoiceNodePlaying"]];
          }
      }
      break;
    case kJMSGContentTypeUnknown:
      {
          _voiceConent.hidden = YES;
          _textContent.hidden = NO;
          
          if (isReceived) {
              [_textContent setFrame:CGRectMake(textMessageContentRightOffset + 5, textMessageContentTopOffset, self.frame.size.width - 2 * textMessageContentRightOffset, self.frame.size.height- 2 * textMessageContentTopOffset)];
          } else {
              [_textContent setFrame:CGRectMake(textMessageContentRightOffset - 5, textMessageContentTopOffset, self.frame.size.width - 2 * textMessageContentRightOffset, self.frame.size.height- 2 * textMessageContentTopOffset)];
          }
          _textContent.text = st_receiveUnknowMessageDes;
      }
          break;
      case kJMSGContentTypeFile:
      {
          self.fileView.hidden = NO;
          self.fileView.frame = self.bounds;
          _voiceConent.hidden = YES;
          _textContent.hidden = YES;
          JMSGFileContent *file = (JMSGFileContent *)message.content;
          [self.fileView refreshFileViewWithFileName:file.fileName fileSize:[file.fSize integerValue] isReceive:isReceived];
          
      }
          break;
      case kJMSGContentTypeLocation:
      {
//          self.mapView.hidden = NO;
          self.locationView.hidden = NO;
          _voiceConent.hidden = YES;
          _textContent.hidden = YES;
//          self.mapView.frame = self.bounds;
          self.locationView.frame = CGRectMake(0, self.height-50, self.width, 50);
          JMSGLocationContent *location = (JMSGLocationContent *)_message.content;
          self.desc.text = location.address;
          [self refreshCenter];
          
          [self.desc mas_updateConstraints:^(MASConstraintMaker *make) {
              
              if ([_message isReceived]) {
                  
                  make.left.equalTo(_locationView).with.offset(10);
              }else{
                  
                  make.left.equalTo(_locationView).with.offset(5);
              }
          }];
          
          [self.mark mas_updateConstraints:^(MASConstraintMaker *make) {
              
              if ([_message isReceived]) {
                  
                  make.left.equalTo(_locationView).with.offset(10);
              }else{
                  
                  make.left.equalTo(_locationView).with.offset(5);
              }
          }];
      }
          break;
      case kJMSGContentTypeCustom:// 自定义
      {
          _voiceConent.hidden = YES;
          _textContent.hidden = YES;
          JMSGCustomContent *custom = (JMSGCustomContent *)_message.content;
          TFChatCustomModel *customModel = [[TFChatCustomModel alloc] initWithDictionary:custom.customDictionary error:nil];
          
          if ([customModel.type isEqualToNumber:@1111]) {
              self.fileView.hidden = NO;
              self.fileView.frame = self.bounds;
//              [self.fileView refreshFileViewWithFileName:customModel.file.fileName fileSize:[customModel.file.fileSize integerValue]];
              [self.fileView refreshFileViewWithFileName:customModel.fileName fileSize:[customModel.fileSize integerValue] isReceive:isReceived];
          }else{
              self.customView.hidden = NO;
              self.customView.frame = self.bounds;
              [self.customView refreshCustomViewWithModel:customModel isReceive:isReceived];
          }
      }
          break;
          
          
          
    default:
      break;
  }
}

- (void)refreshCenter{
    
    
    JMSGLocationContent *location = (JMSGLocationContent *)_message.content;
//    [_mapView setCenterCoordinate:(CLLocationCoordinate2D){[location.latitude doubleValue],[location.longitude doubleValue]}];
//
//    [self.mapView removeAnnotations:self.mapView.annotations];
//
//    BMKPointAnnotation *annotation = [BMKPointAnnotation new];
//
//    annotation.coordinate = (CLLocationCoordinate2D){[location.latitude doubleValue],[location.longitude doubleValue]};
//
//    [self.mapView addAnnotation:annotation];
    
}


//- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation{
//
//
//    BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
//
//    newAnnotationView.animatesDrop = NO;// 设置该标注点动画显示
//
//    newAnnotationView.annotation = annotation;
//
//    //        newAnnotationView.image = [UIImage imageNamed:@"微信"];   //把大头针换成别的图片
//
//    return newAnnotationView;
//}

- (BOOL)canBecomeFirstResponder{
    
  return YES;
}

-(void)attachTapHandler{
  self.userInteractionEnabled = YES;  //用户交互的总开关
  UILongPressGestureRecognizer *touch = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
  touch.minimumPressDuration = 1.0;
  [self addGestureRecognizer:touch];
}

-(void)handleTap:(UIGestureRecognizer*) recognizer {
  [self becomeFirstResponder];
  [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
  [[UIMenuController sharedMenuController] setMenuVisible:YES animated: YES];
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
  if (_message.contentType == kJMSGContentTypeVoice) {
    return action == @selector(delete:);
  }
  return (action == @selector(copy:) || action == @selector(delete:));
}

-(void)copy:(id)sender {
  __block UIPasteboard *pboard = [UIPasteboard generalPasteboard];
  switch (_message.contentType) {
    case kJMSGContentTypeText:
    {
      JMSGTextContent *textContent = (JMSGTextContent *)_message.content;
      pboard.string = textContent.text;
    }
      break;
      
    case kJMSGContentTypeImage:
    {
      JMSGImageContent *imgContent = (JMSGImageContent *)_message.content;
      [imgContent thumbImageData:^(NSData *data, NSString *objectId, NSError *error) {
        if (data == nil || error) {
          UIWindow *myWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
          [MBProgressHUD showMessage:@"获取图片错误" view:myWindow];
          return ;
        }
        pboard.image = [UIImage imageWithData:data];
      }];
    }
      break;
      
    case kJMSGContentTypeVoice:
      break;
    case kJMSGContentTypeUnknown:
      break;
    default:
      break;
  }
  
}

-(void)delete:(id)sender {
  [[NSNotificationCenter defaultCenter] postNotificationName:kDeleteMessage object:_message];
}
@end
