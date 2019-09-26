//
//  JCHATMessageTableViewCell.m
//  JChat
//
//  Created by HuminiOS on 15/7/13.
//  Copyright (c) 2015年 HXHG. All rights reserved.
//

#import "JCHATMessageTableViewCell.h"
//#import "JChatConstants.h"
#import "ChatBubbleLayer.h"
#import "AppDelegate.h"
#import "JCHATSendMsgManager.h"
#import "TFChatCustomModel.h"

//#define ReceivedBubbleColor UIColorFromRGB(0xd3fab4)
//#define sendedBubbleColor [UIColor whiteColor]
#define messageStatusBtnFrame [_model.message isReceived]?CGRectMake(_voiceTimeLabel.frame.origin.x + 5, _messageContent.frame.size.height/2 - 8, 17, 15):CGRectMake(_voiceTimeLabel.frame.origin.x - 20, _messageContent.frame.size.height/2 - 8, 17, 15)
#define messagePercentLabelFrame [_model.message isReceived]?CGPointMake(_messageContent.frame.size.width/2 + crossgrap/2, _messageContent.frame.size.height/2):CGPointMake(_messageContent.frame.size.width/2 - crossgrap/2, _messageContent.frame.size.height/2)
#define kVoiceTimeLabelFrame [_model.message isReceived]?CGRectMake(_messageContent.frame.origin.x + _messageContent.frame.size.width + 10, _messageContent.frame.size.height/2 - 8 + GroupChatNameViewHeight, 35, 17):CGRectMake(_messageContent.frame.origin.x - 45, _messageContent.frame.size.height/2 - 8, 35, 17)
#define kVoiceTimeLabelFrame1 [_model.message isReceived]?CGRectMake(_messageContent.frame.origin.x + _messageContent.frame.size.width + 10, _messageContent.frame.size.height/2 - 8 , 35, 17):CGRectMake(_messageContent.frame.origin.x - 45, _messageContent.frame.size.height/2 - 8, 35, 17)
#define kVoiceTimeLabelHidenFrame [_model.message isReceived]?CGRectMake(_messageContent.frame.origin.x + _messageContent.frame.size.width + 5, _messageContent.frame.size.height/2 - 8, 35, 17):CGRectMake(_messageContent.frame.origin.x, _messageContent.frame.size.height/2 - 8, 35, 17)

static NSInteger const headHeight = 40;
static NSInteger const gapWidth = 15;
static NSInteger const chatBgViewHeight = 40;
static NSInteger const readViewRadius = 4;

@implementation JCHATMessageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
  
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  
  if (self) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
      
      _nameView = [UILabel new];
      _nameView.font = FONT(14);
      _nameView.textColor = LightBlackTextColor;
      [self addSubview:_nameView];
      
    _headView = [[UIImageView alloc] init];
    [_headView setImage:[UIImage imageNamed:@"headDefalt.png"]];
    _headView.layer.cornerRadius = 4;
    _headView.layer.masksToBounds = YES;
    _headView.contentMode = UIViewContentModeScaleAspectFill;
    _messageContent = [JCHATMessageContentView new];
    [self addSubview:_headView];
    [self addSubview:_messageContent];
    
    _readView = [UIImageView new];
    [_readView setImage:[HQHelper createImageWithColor:RedColor]];
    _readView.layer.cornerRadius = readViewRadius;
      _readView.layer.masksToBounds = YES;
    [self addSubview:self.readView];
    self.continuePlayer = NO;
    
    self.sendFailView = [UIImageView new];
    [self.sendFailView setUserInteractionEnabled:YES];
    [self.sendFailView setImage:[UIImage imageNamed:@"fail05"]];
    [self addSubview:self.sendFailView];
    
    _circleView = [UIActivityIndicatorView new];
    [_circleView setBackgroundColor:[UIColor clearColor]];
    [_circleView setHidden:NO];
    _circleView.hidesWhenStopped = YES;
    [self addSubview:_circleView];
    
    _voiceTimeLabel = [UILabel new];
    _voiceTimeLabel.backgroundColor = [UIColor clearColor];
    _voiceTimeLabel.font = [UIFont systemFontOfSize:18];
    [self addSubview:_voiceTimeLabel];
    
    _percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, chatBgViewHeight, chatBgViewHeight)];
    _percentLabel.hidden = NO;
    _percentLabel.font =[UIFont systemFontOfSize:18];
    _percentLabel.textAlignment=NSTextAlignmentCenter;
    _percentLabel.textColor=[UIColor whiteColor];
    [_messageContent addSubview:_percentLabel];
    [_percentLabel setBackgroundColor:[UIColor clearColor]];
    
    [self addGestureForAllView];
  }
  return self;
}

- (void)addGestureForAllView {
  UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(tapContent:)];
  [_messageContent addGestureRecognizer:gesture];
  [_messageContent setUserInteractionEnabled:YES];
  
  UITapGestureRecognizer *tapHeadGesture =[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(pushPersonInfoCtlClick)];
  [_headView addGestureRecognizer:tapHeadGesture];
  [_headView setUserInteractionEnabled:YES];
  UITapGestureRecognizer *tapFailViewGesture =[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(reSendMessage)];
  [_sendFailView addGestureRecognizer:tapFailViewGesture];
  [_sendFailView setUserInteractionEnabled:YES];
}

- (void)setCellData:(JCHATChatModel *)model
           delegate:(id <playVoiceDelegate>)delegate
          indexPath:(NSIndexPath *)indexPath{// TODO:
  
  _model = model;
  _indexPath = indexPath;
  _delegate = delegate;
    
    JMSGUser *user = ((JMSGUser *)self.model.message.fromUser);
    
    HQLog(@"noteName:%@==nickName:%@==username:%@==displayName:%@",user.noteName,user.nickname,user.username,user.displayName);
        //        self.nameView.text = user.nickname;
    if (user.nickname || user.noteName) {
        
        self.nameView.text = user.nickname;
    }else{
        self.nameView.text = self.model.message.fromName;
    }
//    self.nameView.text = user.displayName;

    
    if ([model.message.fromUser.avatar containsString:@"qiniu/image/"]) {
        [model.message.fromUser thumbAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
            
            if (error == nil) {
                
                if ([objectId isEqualToString:user.username]) {
                    if (data != nil) {
                        [self.headView setImage:[UIImage imageWithData:data]];
                    } else {
                        [self.headView setImage:[UIImage imageNamed:@"headDefalt"]];
                    }
                } else {
                    HQLog(@"该头像是异步乱序的头像");
                }
            } else {
                HQLog(@"Action -- get thumbavatar fail");
                [self.headView setImage:[UIImage imageNamed:@"headDefalt"]];
            }
        }];

    }else{
        
        [self.headView sd_setImageWithURL:[HQHelper URLWithString:model.message.fromUser.avatar] placeholderImage:[UIImage imageNamed:@"headDefalt"]];
    }
    
  if ([_model.message.flag isEqualToNumber:@1] || ![_model.message isReceived]) {
    [self.readView setHidden:YES];
  } else {
    [self.readView setHidden:NO];
  }
    
    _headView.contentMode = UIViewContentModeScaleAspectFill;
  [self updateFrameWithContentFrame:model.contentSize];
  [self layoutAllView];
}

- (void)layoutAllView {
  if (_model.message.status == kJMSGMessageStatusSending
      || _model.message.status == kJMSGMessageStatusSendDraft) {
    [_circleView startAnimating];
    [self.sendFailView setHidden:YES];
    [self.percentLabel setHidden:NO];
    if (_model.message.contentType == kJMSGContentTypeImage) {
      _messageContent.alpha = 0.5;
    } else {
      _messageContent.alpha = 1;
    }
    [self addUpLoadHandler];
    
  } else if (_model.message.status == kJMSGMessageStatusSendFailed
             || _model.message.status == kJMSGMessageStatusSendUploadFailed
             || _model.message.status == kJMSGMessageStatusReceiveDownloadFailed) {
    [_circleView stopAnimating];
    if ([_model.message isReceived]) {
      [self.sendFailView setHidden:YES];
    } else {
      [self.sendFailView setHidden:NO];
    }
    
    _messageContent.alpha = 1;
  } else {
    _messageContent.alpha = 1;
    [_circleView stopAnimating];
    [self.sendFailView setHidden:YES];
    [self.percentLabel setHidden:YES];
  }
  
  if (_model.message.contentType != kJMSGContentTypeVoice) {
    _readView.hidden = YES;
  }
  
  switch (_model.message.contentType) {
    case kJMSGContentTypeUnknown:
      {
          _messageContent.backgroundColor = [UIColor redColor];
          _messageContent.textContent.text = st_receiveUnknowMessageDes;
      }
      break;
    case kJMSGContentTypeText:
      {
          _percentLabel.hidden = YES;
          _readView.hidden = YES;
          _voiceTimeLabel.hidden = YES;
      }
      break;
    case kJMSGContentTypeImage:
      {
          _readView.hidden = YES;
          _voiceTimeLabel.hidden = YES;
      }
      break;
    case kJMSGContentTypeVoice:
      {
          _percentLabel.hidden = YES;
          _voiceTimeLabel.hidden = NO;
          _voiceTimeLabel.text = [NSString stringWithFormat:@"%@''",((JMSGVoiceContent *)_model.message.content).duration];
          if (_model.message.isReceived) {
              _voiceTimeLabel.textAlignment = NSTextAlignmentLeft;
          } else {
              _voiceTimeLabel.textAlignment = NSTextAlignmentRight;
          }
      }
      break;
      case kJMSGContentTypeCustom:
      {
          _percentLabel.hidden = YES;
          _voiceTimeLabel.hidden = YES;
      }
      break;
      case kJMSGContentTypeEventNotification:
      {
          _percentLabel.hidden = YES;
          _voiceTimeLabel.hidden = YES;
      }
          break;
      case kJMSGContentTypeFile:
      {
          _percentLabel.hidden = YES;
          _voiceTimeLabel.hidden = YES;
      }
          break;
      case kJMSGContentTypeLocation:
      {
          _percentLabel.hidden = YES;
          _voiceTimeLabel.hidden = YES;
      }
          break;
    default:
      break;
  }
    
    _headView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)addUpLoadHandler {
  if (_model.message.contentType != kJMSGContentTypeImage) {
    return;
  }
  __weak __typeof(self)weakSelfUpload = self;
  NSLog(@"the weakSelf upload  %@",weakSelfUpload);
  ((JMSGImageContent *)_model.message.content).uploadHandler = ^(float percent, NSString *msgId) {
    dispatch_async(dispatch_get_main_queue(), ^{
      __strong __typeof(weakSelfUpload)strongSelfUpload = weakSelfUpload;
      if ([strongSelfUpload.model.message.msgId isEqualToString:msgId]) {
        NSString *percentString = [NSString stringWithFormat:@"%d%%", (int)(percent * 100)];
        strongSelfUpload.percentLabel.text = percentString;
      }
    });
  };
}

- (void)updateFrameWithContentFrame:(CGSize)contentSize {
  BOOL isRecive = [_model.message isReceived];
    
    CGFloat textHeight = contentSize.height < 40 ? 40 : contentSize.height;
    
  if (isRecive) {
    [_headView setFrame:CGRectMake(gapWidth, 2, headHeight, headHeight)];
//    [_messageContent setBubbleSide:isRecive];
      
      if (self.model.conversation.conversationType == kJMSGConversationTypeGroup) {
          
          _nameView.hidden = NO;
          _nameView.frame = CGRectMake(CGRectGetMaxX(_headView.frame) + 10, 0, SCREEN_WIDTH - CGRectGetMaxX(_headView.frame) - 10 - 12, GroupChatNameViewHeight);
      }else{
          _nameView.hidden = YES;
          _nameView.frame = CGRectZero;
      }
      
    [_messageContent setFrame:CGRectMake(headHeight + 20, CGRectGetMaxY(_nameView.frame) + 2, contentSize.width, textHeight)];
    [_readView setFrame:CGRectMake(_messageContent.frame.origin.x + _messageContent.frame.size.width + 12, 3 + GroupChatNameViewHeight, 2 * readViewRadius, 2 * readViewRadius)];
    
  } else {
    [_headView setFrame:CGRectMake(SCREEN_WIDTH - headHeight - gapWidth, 2, headHeight, headHeight)];//头像位置
//    [_messageContent setBubbleSide:isRecive];
      
      _nameView.hidden = YES;
      _nameView.frame = CGRectZero;
      _headView.contentMode = UIViewContentModeScaleAspectFill;
      
    [_messageContent setFrame:CGRectMake(SCREEN_WIDTH - headHeight - 20 - contentSize.width, CGRectGetMaxY(_nameView.frame) + 2, contentSize.width, textHeight)];
    [_readView setFrame:CGRectMake(_messageContent.frame.origin.x - 10, 15, 8, 8)];
  }
  [_messageContent setMessageContentWith:_model.message];
    
    if (self.model.conversation.conversationType == kJMSGConversationTypeGroup) {
        
        [_voiceTimeLabel setFrame:kVoiceTimeLabelFrame];
    }else{
        [_voiceTimeLabel setFrame:kVoiceTimeLabelFrame1];
    }
  if (_model.message.contentType != kJMSGContentTypeVoice) {
    _voiceTimeLabel.frame = kVoiceTimeLabelHidenFrame;
  }
  [_circleView setFrame:messageStatusBtnFrame];
  [_sendFailView setFrame:messageStatusBtnFrame];
  [_percentLabel setCenter:messagePercentLabelFrame];
}

- (void)tapContent:(UIGestureRecognizer *)gesture {
  if (_model.message.contentType == kJMSGContentTypeVoice) {
    [self playVoice];
  }
  if (_model.message.contentType == kJMSGContentTypeImage) {
    if (self.model.message.status == kJMSGMessageStatusReceiveDownloadFailed) {
      HQLog(@"正在下载缩略图");
      HQLog(@"Action");
      [_circleView startAnimating];
    } else {
      if (self.delegate && [(id<PictureDelegate>)self.delegate respondsToSelector:@selector(tapPicture:tapView:tableViewCell:)]) {
        [(id<PictureDelegate>)self.delegate tapPicture:_indexPath tapView:(UIImageView *)gesture.view tableViewCell:self];
      }
    }
  }
    
    if (_model.message.contentType == kJMSGContentTypeLocation) {
        
        if (self.delegate && [(id<LocationDelegate>)self.delegate respondsToSelector:@selector(tapLocation:tapView:tableViewCell:)]) {
            [(id<LocationDelegate>)self.delegate tapLocation:_indexPath tapView:(UIImageView *)gesture.view tableViewCell:self];
        }
    }
    
    
    if (_model.message.contentType == kJMSGContentTypeFile) {
        
        if (self.delegate && [(id<FileDelegate>)self.delegate respondsToSelector:@selector(tapFile:tapView:tableViewCell:)]) {
            [(id<FileDelegate>)self.delegate tapFile:_indexPath tapView:(UIImageView *)gesture.view tableViewCell:self];
        }
    }
    
    
    if (_model.message.contentType == kJMSGContentTypeCustom) {
        
        if (self.delegate && [(id<CustomDelegate>)self.delegate respondsToSelector:@selector(tapCustom:tapView:tableViewCell:)]) {
            [(id<CustomDelegate>)self.delegate tapCustom:_indexPath tapView:(UIImageView *)gesture.view tableViewCell:self];
        }
    }
}

#pragma -mark gesture
- (void)pushPersonInfoCtlClick {
  if (self.delegate && [self.delegate respondsToSelector:@selector(selectHeadView:)]) {
    [self.delegate selectHeadView:self.model];
  }
}

- (void)reSendMessage {//重发消息
  UIAlertView *alerView =[[UIAlertView alloc] initWithTitle:nil message:@"是否重新发送消息"
                                                   delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
  [alerView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 1) {
    [self.sendFailView setHidden:YES];
    [self.circleView setHidden:NO];
    [self.circleView startAnimating];
    if (_model.message.contentType == kJMSGContentTypeImage) {
      _messageContent.alpha = 0.5;
    } else {
      _messageContent.alpha = 1;
    }
    __weak typeof(self)weakSelf = self;
    if (_model.message.contentType == kJMSGContentTypeImage) {
      JMSGImageContent *imgContent = ((JMSGImageContent *)_model.message.content);
      imgContent.uploadHandler = ^(float percent, NSString *msgID){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        if ([strongSelf.model.message.msgId isEqualToString:msgID]) {
          dispatch_async(dispatch_get_main_queue(), ^{
            strongSelf.percentLabel.text = [NSString stringWithFormat:@"%d%%",(int)(percent*100)];
          });
        }
      };
      [[JCHATSendMsgManager ins] addMessage:weakSelf.model.message withConversation:_conversation];
    } else {
      [weakSelf.conversation sendMessage:weakSelf.model.message];
      [weakSelf layoutAllView];
    }
  }
}

#pragma mark --连续播放语音
- (void)playVoice {
  HQLog(@"Action - playVoice");
  __block NSString *status = nil;
  
  self.continuePlayer = NO;
  if ([(id<playVoiceDelegate>)(self.delegate) respondsToSelector:@selector(getContinuePlay:indexPath:)]) {
    [(id<playVoiceDelegate>)(self.delegate) getContinuePlay:self indexPath:self.indexPath];
  }
  [self.readView setHidden:YES];
  
  if (![_model.message.flag  isEqual: @1]) {
    [_model.message updateFlag:@1];
  }
  [((JMSGVoiceContent *)_model.message.content) voiceData:^(NSData *data, NSString *objectId, NSError *error) {
    if (error == nil) {
      if (data != nil) {
        status =  @"下载语音成功";
        self.index = 0;
        
        if (!_isPlaying) {
          if ([[JCHATAudioPlayerHelper shareInstance] isPlaying]) {
            [[JCHATAudioPlayerHelper shareInstance] stopAudio];
            [[JCHATAudioPlayerHelper shareInstance] setDelegate:nil];
          }
          [[JCHATAudioPlayerHelper shareInstance] setDelegate:(id) self];
          _isPlaying = YES;
        } else {
          _isPlaying = NO;
          self.continuePlayer = NO;
          [[JCHATAudioPlayerHelper shareInstance] stopAudio];
          [[JCHATAudioPlayerHelper shareInstance] setDelegate:nil];
        }
        [[JCHATAudioPlayerHelper shareInstance] managerAudioWithData:data toplay:YES];
        [self changeVoiceImage];
      }
    } else {
      HQLog(@"Action  voiceData");
      [self AlertInCurrentViewWithString:@"下载语音数据失败"];
      status = @"获取消息失败。。。";
    }
  }];
  return;
}

- (void)AlertInCurrentViewWithString:(NSString *)string {
  AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
  [MBProgressHUD showMessage:string view:appDelegate.window];
}

- (void)changeVoiceImage {
  if (!_isPlaying) {
    return;
  }
  
  NSString *voiceImagePreStr = @"";
  if ([_model.message isReceived]) {
    voiceImagePreStr = @"ReceiverVoiceNodePlaying00";
  } else {
    voiceImagePreStr = @"SenderVoiceNodePlaying00";
  }
  _messageContent.voiceConent.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%zd", voiceImagePreStr, self.index % 4]];
  if (_isPlaying) {
    self.index++;
    [self performSelector:@selector(changeVoiceImage) withObject:nil afterDelay:0.25];
  }
}

- (void)prepare {
  [(id<playVoiceDelegate>)self.delegate successionalPlayVoice:self indexPath:self.indexPath];
}

#pragma mark ---播放完成后
- (void)didAudioPlayerStopPlay:(AVAudioPlayer *)audioPlayer {
  [[JCHATAudioPlayerHelper shareInstance] setDelegate:nil];
  _isPlaying = NO;
  self.index = 0;
  if ([_model.message isReceived]) {
    [_messageContent.voiceConent setImage:[UIImage imageNamed:@"ReceiverVoiceNodePlaying.png"]];
  } else {
    [_messageContent.voiceConent setImage:[UIImage imageNamed:@"SenderVoiceNodePlaying.png"]];
  }
  if (self.continuePlayer) {
    self.continuePlayer = NO;
    if ([self.delegate respondsToSelector:@selector(successionalPlayVoice:indexPath:)]) {
      [self performSelector:@selector(prepare) withObject:nil afterDelay:0.5];
    }
  }
}

#pragma mark --发送消息响应

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

@end
