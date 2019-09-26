//
//  XSVideoConfig.h
//  ChatTest
//
//  Created by 肖胜 on 2017/5/21.
//  Copyright © 2017年 Season. All rights reserved.
//

#import "XSVideoSupport.h"
#import "XSVideoConfig.h"

#pragma mark - Custom View --

@implementation XSStatusBar {
    BOOL _clear;
    CAShapeLayer *_nomalLayer;
    CALayer *_recodingLayer;
    
    XSVideoViewShowType _style;
    
    UIButton *_cancelBtn;
}
- (instancetype)initWithFrame:(CGRect)frame style:(XSVideoViewShowType)style; {
    if (self = [super initWithFrame:frame]) {
        _style = style;
        [XSVideoConfig motionBlurView:self];
        [self setupSubLayers];
    }
    return self;
}

- (void)addCancelTarget:(id)target selector:(SEL)selector {
    [_cancelBtn removeFromSuperview];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelBtn.frame = CGRectMake(10, 22, 50, 40);
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [_cancelBtn setTitleColor:xsThemeWhiteColor forState:UIControlStateNormal];
    _cancelBtn.alpha = 0.8;
    [self addSubview:_cancelBtn];
}

- (void)setupSubLayers {
    
    if (_style == XSVideoViewShowTypeSingle) {
        return;
    }
    
    UIView *showView = [[UIView alloc] initWithFrame:self.bounds];
    showView.backgroundColor = [UIColor clearColor];
    [self addSubview:showView];
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    CGFloat barW = 20.0;
    CGFloat barSpace = 4.0;
    CGFloat topEdge = 5.5;
    CGPoint selfCent = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGMutablePathRef nomalPath = CGPathCreateMutable();
    for (int i=0; i<3; i++) {
        CGPathMoveToPoint(nomalPath, &transform, selfCent.x-(barW/2), topEdge+(barSpace * i));
        CGPathAddLineToPoint(nomalPath, &transform, selfCent.x+(barW/2), topEdge+(barSpace * i));
    }
    _nomalLayer = [CAShapeLayer layer];
    _nomalLayer.frame = self.bounds;
    _nomalLayer.strokeColor = [UIColor  colorWithRed: 0.5 green: 0.5 blue: 0.5 alpha: 0.7 ].CGColor;
    _nomalLayer.lineCap = kCALineCapRound;
    _nomalLayer.lineWidth = 2.0;
    _nomalLayer.path = nomalPath;
    [showView.layer addSublayer:_nomalLayer];
    CGPathRelease(nomalPath);
    
    CGFloat width = 10;
    CGFloat height = 8;
    _recodingLayer = [CALayer layer];
    _recodingLayer.frame = CGRectMake(selfCent.x - width/2, selfCent.y - height/2, width, height);
    _recodingLayer.cornerRadius = height/2;
    _recodingLayer.masksToBounds = YES;
    _recodingLayer.backgroundColor = xsThemeWaringColor.CGColor;
    [showView.layer addSublayer:_recodingLayer];
    
    _recodingLayer.hidden = YES;
}

- (void)setIsRecoding:(BOOL)isRecoding {
    _isRecoding = isRecoding;
    
    [self display];
}

- (void)display {
    if (_style == XSVideoViewShowTypeSingle) {
        return;
    }
    
    if (_isRecoding) {
        _recodingLayer.hidden = NO;
        _nomalLayer.hidden = YES;
        xs_dispatch_after(0.5, ^{
            if (!_isRecoding)  return;
            _recodingLayer.hidden = YES;
            _nomalLayer.hidden = YES;
        });
    }
    else {
        _nomalLayer.hidden = NO;
        _recodingLayer.hidden = YES;
    }
}

@end


@implementation XSCloseBtn


- (void)setGradientColors:(NSArray *)gradientColors {
    self.backgroundColor = [UIColor clearColor];
    _gradientColors = gradientColors;
    
    CAShapeLayer *trackLayer = [CAShapeLayer layer];
    trackLayer.frame = self.bounds;
    trackLayer.strokeColor = xsThemeTineColor.CGColor;
    trackLayer.fillColor = [UIColor clearColor].CGColor;
    trackLayer.lineCap = kCALineCapRound;
    trackLayer.lineWidth = 3.0;
    
    CGMutablePathRef path = [self getDrawPath];
    trackLayer.path = path;
    [self.layer addSublayer:trackLayer];
    CGPathRelease(path);
    
    CAGradientLayer *maskLayer = [CAGradientLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.colors = _gradientColors;
    [self.layer addSublayer:maskLayer];
    maskLayer.mask = trackLayer;
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (_gradientColors != nil) {
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, YES);

    CGContextSetStrokeColorWithColor(context, xsThemeGraryColor.CGColor);
    CGContextSetLineWidth(context, 3.0);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGMutablePathRef path = [self getDrawPath];
    CGContextAddPath(context, path);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(path);
}


- (CGMutablePathRef)getDrawPath {
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat centX = self.bounds.size.width/2;
    CGFloat centY = self.bounds.size.height/2;
    CGFloat drawWidth = 22;
    CGFloat drawHeight = 10;
    CGPathMoveToPoint(path, NULL, (centX - drawWidth/2), (centY - drawHeight/2));
    CGPathAddLineToPoint(path, NULL, centX, centY + drawHeight/2);
    CGPathAddLineToPoint(path, NULL, centX + drawWidth/2, centY - drawHeight/2);
    return path;
}

@end

@implementation XSRecordBtn {
    UITapGestureRecognizer *_tapGesture;
    XSVideoViewShowType _style;
}

- (instancetype)initWithFrame:(CGRect)frame style:(XSVideoViewShowType)style{
    if (self = [super initWithFrame:frame]) {
        _style = style;
        [self setupRoundButton];
        self.layer.cornerRadius = self.bounds.size.width/2;
        self.layer.masksToBounds = YES;
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setupRoundButton {
    self.backgroundColor = [UIColor clearColor];
    
    CGFloat width = self.frame.size.width/2.0;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(width/2, self.frame.size.height/4, width, self.frame.size.height/2) cornerRadius:width/2];
    
    CAShapeLayer *trackLayer = [CAShapeLayer layer];
    trackLayer.frame = self.bounds;
    trackLayer.strokeColor = xsThemeWhiteColor.CGColor;
    trackLayer.fillColor = [UIColor clearColor].CGColor;
    trackLayer.opacity = 1.0;
    trackLayer.lineCap = kCALineCapRound;
    trackLayer.lineWidth = 2.0;
    trackLayer.path = path.CGPath;
    [self.layer addSublayer:trackLayer];
    
    if (_style == XSVideoViewShowTypeSingle) {
        CATextLayer *textLayer = [CATextLayer layer];
        textLayer.string = @"按住拍";
        textLayer.frame = CGRectMake(0, 0, width, 20);
        textLayer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        UIFont *font = [UIFont boldSystemFontOfSize:16];
        CFStringRef fontName = (__bridge CFStringRef)font.fontName;
        CGFontRef fontRef = CGFontCreateWithFontName(fontName);
        textLayer.font = fontRef;
        textLayer.fontSize = font.pointSize;
        CGFontRelease(fontRef);
        textLayer.contentsScale = [UIScreen mainScreen].scale;
        textLayer.foregroundColor = xsThemeWhiteColor.CGColor;
        textLayer.alignmentMode = kCAAlignmentCenter;
        textLayer.wrapped = YES;
        [trackLayer addSublayer:textLayer];
    }
    
    CAGradientLayer *gradLayer = [CAGradientLayer layer];
    gradLayer.frame = self.bounds;
    gradLayer.colors = @[(__bridge id)[UIColor whiteColor].CGColor,(__bridge id)[UIColor whiteColor].CGColor];
//    gradLayer.colors = [xsVideoConfig gradualColors];
    [self.layer addSublayer:gradLayer];
    
    gradLayer.mask = trackLayer;
}
@end


@implementation XSFocusView {
    CGFloat _width;
    CGFloat _height;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _width = CGRectGetWidth(frame);
        _height = _width;
    }
    return self;
    
}

- (void)focusing {
    [UIView animateWithDuration:0.5 animations:^{
       
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8, 0.8);
    } completion:^(BOOL finished) {
        self.transform = CGAffineTransformIdentity;
    }];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, xsThemeTineColor.CGColor);
    CGContextSetLineWidth(context, 1.0);
    
    CGFloat len = 4;
    
    CGContextMoveToPoint(context, 0.0, 0.0);
    CGContextAddRect(context, self.bounds);
    
    CGContextMoveToPoint(context, 0, _height/2);
    CGContextAddLineToPoint(context, len, _height/2);
    
    CGContextMoveToPoint(context, _width/2, _height);
    CGContextAddLineToPoint(context, _width/2, _height - len);
    
    CGContextMoveToPoint(context, _width, _height/2);
    CGContextAddLineToPoint(context, _width - len, _height/2);
    
    CGContextMoveToPoint(context, _width/2, 0);
    CGContextAddLineToPoint(context, _width/2, len);
    
    CGContextDrawPath(context, kCGPathStroke);
}

@end


@implementation XSEyeView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [XSVideoConfig motionBlurView:self];
        
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self layoutIfNeeded];
        [XSVideoConfig motionBlurView:self];
        [self setupView];
    }
    return self;
}

- (void)setupView {
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    view.backgroundColor = [UIColor clearColor];
    [self addSubview:view];
    
    XSEyePath path = createEyePath(self.bounds);
    UIColor *color = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.9];
    
    CAShapeLayer *shapelayer1 = [CAShapeLayer layer];
    shapelayer1.frame = self.bounds;
    shapelayer1.strokeColor = color.CGColor;
    shapelayer1.fillColor = [UIColor clearColor].CGColor;
    shapelayer1.opacity = 1.0;
    shapelayer1.lineCap = kCALineCapRound;
    shapelayer1.lineWidth = 1.0;
    shapelayer1.path = path.strokePath;
    [view.layer addSublayer:shapelayer1];
    
    CAShapeLayer *shapelayer2 = [CAShapeLayer layer];
    shapelayer2.frame = self.bounds;
    shapelayer2.strokeColor = color.CGColor;
    shapelayer2.fillColor = color.CGColor;
    shapelayer2.opacity = 1.0;
    shapelayer2.lineCap = kCALineCapRound;
    shapelayer2.lineWidth = 1.0;
    shapelayer2.path = path.fillPath;
    [view.layer addSublayer:shapelayer2];
    
    XSEyePathRelease(path);
}


typedef struct eyePath {
    CGMutablePathRef strokePath;
    CGMutablePathRef fillPath;
} XSEyePath;

void XSEyePathRelease(XSEyePath path) {
    CGPathRelease(path.fillPath);
    CGPathRelease(path.strokePath);
}

XSEyePath createEyePath(CGRect rect) {
    CGPoint selfCent = CGPointMake(CGRectGetWidth(rect)/2, CGRectGetHeight(rect)/2);
    CGFloat eyeWidth = 64.0;
    CGFloat eyeHeight = 40.0;
    CGFloat curveCtrlH = 44;
    
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0, 1.0);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, &transform, selfCent.x - eyeWidth/2, selfCent.y);
    CGPathAddQuadCurveToPoint(path, &transform, selfCent.x, selfCent.y - curveCtrlH, selfCent.x + eyeWidth/2, selfCent.y);
    CGPathAddQuadCurveToPoint(path, &transform, selfCent.x, selfCent.y + curveCtrlH, selfCent.x - eyeWidth/2, selfCent.y);
    CGFloat arcRadius = eyeHeight/2 - 1;
    CGPathMoveToPoint(path, &transform, selfCent.x + arcRadius, selfCent.y);
    CGPathAddArc(path, &transform, selfCent.x, selfCent.y, arcRadius, 0, M_PI * 2, false);
    
    CGFloat startAngle = 110;
    CGFloat angle1 = startAngle + 30;
    CGFloat angle2 = angle1 + 20;
    CGFloat angle3 = angle2 + 10;
    CGFloat arcRadius2 = arcRadius - 4;
    CGFloat arcRadius3 = arcRadius2 - 7;
    
    CGMutablePathRef path2 = createDonutPath(selfCent, angleToRadian(startAngle), angleToRadian(angle1), arcRadius2, arcRadius3, &transform);
    CGMutablePathRef path3 = createDonutPath(selfCent, angleToRadian(angle2), angleToRadian(angle3), arcRadius2, arcRadius3, &transform);
    CGPathAddPath(path2, NULL, path3);
    
    CGPathRelease(path3);
    return (XSEyePath){path, path2};
}

// angle 逆时针角度
CGMutablePathRef createDonutPath(CGPoint center, CGFloat startAngle, CGFloat endAngle, CGFloat bigRadius, CGFloat smallRadius, CGAffineTransform * transform) {
    CGFloat arcStart = M_PI*2 - startAngle;
    CGFloat arcEnd = M_PI*2 - endAngle;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, transform, center.x + bigRadius * cos(startAngle), center.y - bigRadius * sin(startAngle));
    CGPathAddArc(path, transform, center.x, center.y, bigRadius, arcStart, arcEnd, true);
    CGPathAddLineToPoint(path, transform, center.x + smallRadius * cos(endAngle), center.y - smallRadius * sin(endAngle));
    CGPathAddArc(path, transform, center.x, center.y, smallRadius, arcEnd, arcStart, false);
    CGPathAddLineToPoint(path, transform, center.x + bigRadius * cos(startAngle), center.y - bigRadius * sin(startAngle));
    return path;
}

double xs_sin(double angle) {
    return sin(angleToRadian(angle));
}

double xs_cos(double angle) {
    return cos(angleToRadian(angle));
}

CGFloat angleToRadian(CGFloat angle) {
    return angle/180.0*M_PI;
}

@end

#pragma mark --------------  分割线  --------------------------

@implementation XSControllerBar {
    XSRecordBtn *_startBtn;
    UILongPressGestureRecognizer *_longPress;
    UIView *_progressLine;
    BOOL _touchIsInside;
    BOOL _recording;
    
    NSTimer *_timer;
    NSTimeInterval _surplusTime;
    
    UIButton *_videoListBtn;
    XSCloseBtn *_closeVideoBtn;
    
    BOOL _videoDidEnd;
}

- (void)setupSubViewsWithStyle:(XSVideoViewShowType)style {
    [self layoutIfNeeded];
   [XSVideoConfig motionBlurView:self];
    

    CGFloat selfHeight = self.bounds.size.height;
    CGFloat selfWidth = self.bounds.size.width;
    CGFloat edge = 20.0;
    CGFloat startBtnWidth = style == XSVideoViewShowTypeSmall ? selfHeight - (edge * 2) : selfHeight/2;
    
    _startBtn = [[XSRecordBtn alloc] initWithFrame:CGRectMake(0, 0, startBtnWidth, startBtnWidth) style:style];
    _startBtn.center = CGPointMake(selfWidth/2, selfHeight/2);
    [self addSubview:_startBtn];
    
    _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longpressAction:)];
    _longPress.minimumPressDuration = .3;
    _longPress.delegate = self;
    [self addGestureRecognizer:_longPress];
    
    _progressLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, selfWidth, 4)];
    _progressLine.backgroundColor = xsThemeTineColor;
    _progressLine.hidden = YES;
    [self addSubview:_progressLine];
    
    _surplusTime = xsRecordTime;
    
    
    if (style == XSVideoViewShowTypeSingle) {
        return;
    }
    
    _videoListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _videoListBtn.frame = CGRectMake(edge, edge+startBtnWidth/6, startBtnWidth/4*3, startBtnWidth/3*2);
    _videoListBtn.layer.cornerRadius = 8;
    _videoListBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    _videoListBtn.layer.masksToBounds = YES;
    [_videoListBtn addTarget:self action:@selector(videoListAction) forControlEvents:UIControlEventTouchUpInside];
    //        self.videoListBtn.backgroundColor = xsThemeTineColor
    [self addSubview:_videoListBtn];
    
    NSArray<XSVideoModel *> *videoList = [XSVideoUtil getSortVideoList];
    if (videoList.count == 0) {
        _videoListBtn.hidden = YES;
    }
    else {
        [_videoListBtn setBackgroundImage:[UIImage imageWithContentsOfFile:videoList[0].thumAbsolutePath] forState: UIControlStateNormal];
    }
    
    CGFloat closeBtnWidth = _videoListBtn.frame.size.height;
    _closeVideoBtn = [XSCloseBtn buttonWithType:UIButtonTypeCustom];
    _closeVideoBtn.frame = CGRectMake(self.bounds.size.width - closeBtnWidth - edge, CGRectGetMinY(_videoListBtn.frame), closeBtnWidth, closeBtnWidth);
    [_closeVideoBtn addTarget:self action:@selector(videoCloseAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_closeVideoBtn];
}

- (void)startRecordSet {
    _startBtn.alpha = 1.0;
    
    _progressLine.frame = CGRectMake(0, 0, self.bounds.size.width, 2);
    _progressLine.backgroundColor = xsThemeTineColor;
    _progressLine.hidden = NO;
    
    _surplusTime = xsRecordTime;
    _recording = YES;
    
    _videoDidEnd = NO;
    
    if (_timer == nil) {
        _timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(recordTimerAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
    [_timer fire];
    
    [UIView animateWithDuration:0.4 animations:^{
        _startBtn.alpha = 0.6;
        _startBtn.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.3, 1.3);
    } completion:^(BOOL finished) {
        if (finished) {
            
        }
    }];
}

- (void)endRecordSet {
    _progressLine.hidden = YES;
    [_timer invalidate];
    _timer = nil;
    _recording = NO;
    _startBtn.alpha = 1;
    _startBtn.transform = CGAffineTransformIdentity;
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == _longPress) {
        if (_surplusTime <= 0) return  NO;
        
        CGPoint point = [gestureRecognizer locationInView:self];
        CGPoint startBtnCent = _startBtn.center;
        
        CGFloat dx = point.x - startBtnCent.x;
        CGFloat dy = point.y - startBtnCent.y;
        
        CGFloat startWidth = _startBtn.bounds.size.width;
        if ((dx * dx) + (dy * dy) < (startWidth * startWidth)) {
            return YES;
        }
        return NO;
    }
    return YES;
}

#pragma mark - Actions --
- (void)longpressAction:(UILongPressGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self];
    
    _touchIsInside = point.y >= 0;
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            if (!CGRectContainsPoint(CGRectMake(self.frame.size.width/5*2, self.frame.size.height/8*3, self.frame.size.width/5, self.frame.size.height/4), point)) {
                return;
            }
            [self videoStartAction];
        }
            break;
        case UIGestureRecognizerStateChanged: {
            if (!_touchIsInside) {
                _progressLine.backgroundColor = xsThemeWaringColor;
                if (_delegate && [_delegate respondsToSelector:@selector(ctrollVideoWillCancel:)]) {
                    [_delegate ctrollVideoWillCancel:self];
                }
            }
            else {
                _progressLine.backgroundColor = xsThemeTineColor;
            }
        }
            break;
        case UIGestureRecognizerStateEnded: {
            
            [self endRecordSet];
            if (!_touchIsInside || xsRecordTime - _surplusTime <= 1) {
                XSRecordCancelReason reason = XSRecordCancelReasonTimeShort;
                if (!_touchIsInside) {
                    reason = XSRecordCancelReasonDefault;
                }
                [self videoCancelAction:reason];
            }
            else {
                [self videoEndAction];
            }
        }
            break;
        case UIGestureRecognizerStateCancelled:
            break;
        default:
            break;

    }
}

- (void)videoStartAction {
    [self startRecordSet];
    if (_delegate && [_delegate respondsToSelector:@selector(ctrollVideoDidStart:)]) {
        [_delegate ctrollVideoDidStart:self];
    }
}

- (void)videoCancelAction:(XSRecordCancelReason)reason {
    if (_delegate && [_delegate respondsToSelector:@selector(ctrollVideoDidCancel:reason:)]) {
        [_delegate ctrollVideoDidCancel:self reason:reason];
    }
}

- (void)videoEndAction {
    
    _startBtn.transform = CGAffineTransformIdentity;
    if (_videoDidEnd) return;
    
    _videoDidEnd = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(ctrollVideoDidEnd:)]) {
        [_delegate ctrollVideoDidEnd:self];
    }
}

- (void)videoListAction {
    if (_delegate && [_delegate respondsToSelector:@selector(ctrollVideoOpenVideoList:)]) {
        [_delegate ctrollVideoOpenVideoList:self];
    }
}

- (void)videoCloseAction {
    if (_delegate && [_delegate respondsToSelector:@selector(ctrollVideoDidClose:)]) {
        [_delegate ctrollVideoDidClose:self];
    }
}

- (void)recordTimerAction {
    CGFloat reduceLen = self.bounds.size.width/xsRecordTime;
    CGFloat oldLineLen = _progressLine.frame.size.width;
    CGRect oldFrame = _progressLine.frame;
    
    [UIView animateWithDuration:1.0 delay: 0.0 options: UIViewAnimationOptionCurveLinear animations:^{
        _progressLine.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldLineLen - reduceLen, oldFrame.size.height);
        _progressLine.center = CGPointMake(self.bounds.size.width/2, _progressLine.bounds.size.height/2);
    } completion:^(BOOL finished) {
        _surplusTime --;
        if (_recording) {
            if (_delegate && [_delegate respondsToSelector:@selector(ctrollVideoDidRecordSEC:)]) {
                [_delegate ctrollVideoDidRecordSEC:self];
            }
        }
        if (_surplusTime <= 0.0) {
            [self endRecordSet];
            [self videoEndAction];
        }
    }];
}

@end

#pragma mark -  ********************** Video List 控件 ************************

@implementation XSCircleCloseBtn

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    self.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.layer.cornerRadius = self.bounds.size.width/2;
    self.layer.masksToBounds = YES;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetStrokeColorWithColor(context, xsThemeBlackColor.CGColor);
    CGContextSetLineWidth(context, 1.0);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    CGPoint selfCent = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGFloat closeWidth = 8.0;
    
    CGContextMoveToPoint(context, selfCent.x-closeWidth/2, selfCent.y - closeWidth/2);
    CGContextAddLineToPoint(context, selfCent.x + closeWidth/2, selfCent.y + closeWidth/2);
    
    CGContextMoveToPoint(context, selfCent.x-closeWidth/2, selfCent.y + closeWidth/2);
    CGContextAddLineToPoint(context, selfCent.x + closeWidth/2, selfCent.y - closeWidth/2);
    
    CGContextDrawPath(context, kCGPathStroke);
}

@end


@implementation XSVideoListCell {
    UIImageView *_thumImage;
    XSCircleCloseBtn *_closeBtn;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _thumImage = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, self.bounds.size.width - 8, self.bounds.size.height - 8)];
        _thumImage.layer.cornerRadius = 6.0;
        _thumImage.layer.masksToBounds = YES;
        _thumImage.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_thumImage];
        
        _closeBtn = [[XSCircleCloseBtn alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
        [_closeBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_closeBtn];
        _closeBtn.hidden = YES;
        
    }
    return self;
}

- (void)setVideoModel:(XSVideoModel *)videoModel {
    _videoModel = videoModel;
    _thumImage.image = [UIImage imageNamed:videoModel.thumAbsolutePath];
//    [UIImage imageWithContentsOfFile:videoModel.totalThumPath];
}

- (void)setEdit:(BOOL)canEdit {
    _closeBtn.hidden = !canEdit;
}

- (void)deleteAction {
    if (self.deleteVideoBlock) {
        self.deleteVideoBlock(self.videoModel);
    }
}


@end


@implementation XSAddNewVideoCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    CALayer *bgLayer = [CALayer layer];
    bgLayer.frame = CGRectMake(4, 4, self.bounds.size.width - 8, self.bounds.size.height - 8);
    bgLayer.backgroundColor = [UIColor colorWithRed: 0.5 green: 0.5 blue: 0.5 alpha: 0.3].CGColor;
    bgLayer.cornerRadius = 8.0;
    bgLayer.masksToBounds = YES;
    [self.contentView.layer addSublayer:bgLayer];
    
    CGPoint selfCent = CGPointMake(bgLayer.bounds.size.width/2, bgLayer.bounds.size.height/2);
    CGFloat len = 20;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, selfCent.x, selfCent.y - len);
    CGPathAddLineToPoint(path, nil, selfCent.x, selfCent.y + len);
    
    CGPathMoveToPoint(path, nil, selfCent.x - len, selfCent.y);
    CGPathAddLineToPoint(path, nil, selfCent.x + len, selfCent.y);
    
    CAShapeLayer *crossLayer = [CAShapeLayer layer];
    crossLayer.fillColor = [UIColor clearColor].CGColor;
    crossLayer.strokeColor = xsThemeGraryColor.CGColor;
    crossLayer.lineWidth = 4.0;
    crossLayer.path = path;
    crossLayer.opacity = 1.0;
    [bgLayer addSublayer:crossLayer];
    CGPathRelease(path);
}

- (void)dealloc {
//    NSLog(@"cell add  dealloc");
}
@end
