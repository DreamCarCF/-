//
//  RotarySelector.m
//  RotarySeletor
//
//  Created by Yasir Lee on 13-4-2.
//  Copyright (c) 2013年 Xiaohui Lee. All rights reserved.
//

#import "RotarySelector.h"
#import "KTOneFingerRotationGestureRecognizer.h"
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define RADIANSMAX 2 * M_PI
#define RADIUS     (iPhone5 ? 85 : 120)



static CGPoint RotateCGPointAroundCenter(CGPoint point, CGPoint center, float angle){
    CGAffineTransform translation = CGAffineTransformMakeTranslation(center.x, center.y);
    CGAffineTransform rotation = CGAffineTransformMakeRotation(angle);
    CGAffineTransform transformGroup = CGAffineTransformConcat(CGAffineTransformConcat(CGAffineTransformInvert(translation), rotation), translation);
    return CGPointApplyAffineTransform(point, transformGroup);
}

static CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
static CGFloat RadiansToDegrees(CGFloat radians) {return radians * 180 / M_PI;};

static int ReCulRotateToDegree(float aRotate){
    
    int rot = RadiansToDegrees(aRotate);
    
    if (rot < 0) {
        rot += 360;
    }
    
    return rot;
}

@implementation RotarySelector

@synthesize backgroundView,delegate;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
        btntitleList = [[NSMutableArray alloc]initWithArray:@[@"模式设置",@"消费明细",@"自定义信息",@"记录查询",@"黑白名单",@"内容查询",@"系统公告",@"拨打电话"]];
        KTOneFingerRotationGestureRecognizer *rotationGesture =
        [[KTOneFingerRotationGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(rotating:)];
        [self addGestureRecognizer:rotationGesture];
        
        UIImageView *aImageView = [[UIImageView alloc] initWithFrame:frame];
        
        self.backgroundView = aImageView;
        
        UIImageView * inWhiteImgView = [[UIImageView alloc] initWithFrame:CGRectMake(aImageView.center.x-frame.size.width/5, aImageView.center.y-frame.size.height/5,frame.size.width/2.5, frame.size.height/2.5)];
        inWhiteImgView.image = [UIImage imageNamed:@"turnplate_mask_unlogin_normal.png"];
        
        UIImageView * oaImgView = [[UIImageView alloc]initWithFrame:CGRectMake(aImageView.center.x-frame.size.width/6, aImageView.center.y-frame.size.height/6,frame.size.width/3, frame.size.height/3)];
        oaImgView.image = [UIImage imageNamed:@"oa.png"];
        
        
        [self addSubview:self.backgroundView];
        [self addSubview:inWhiteImgView];
        [self addSubview:oaImgView];
        self.userInteractionEnabled = YES;
        self.backgroundView.userInteractionEnabled = YES;
        
        buttonList = [[NSMutableArray alloc] init];
        NSTimer *timerToLoad; //I should do this because this is UIView not UIViewControl
        timerToLoad = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(reloadDataInfo) userInfo:nil repeats:NO]; //this is very important
    }
    return self;
}

-(void)reloadDataInfo{
    sameDirection = NO;
    if ([self.delegate respondsToSelector:@selector(rotarySelectorCircleHaveSameDirection)])
        sameDirection = [self.delegate rotarySelectorCircleHaveSameDirection];
    for (__strong UIButton * btn in buttonList){
        [btn removeFromSuperview];
        btn = nil;
    }
    buttonList = [[NSMutableArray alloc]init];
    [self loadRotarySelector];
}

-(void)loadRotarySelector{
    [self setBackgroundImage:[self.delegate rotarySelectorBackgroundImage]];
    int circleCount = [self.delegate rotarySelectorCircleCount];
    for (int i = 0; i < circleCount; ++i) {
        if (iPhone5) {
            UIButton *circle = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 40,40)];
            [circle addTarget:self action:@selector(clickCircle:) forControlEvents:UIControlEventTouchUpInside];
            [circle setTag:i];
            circle.backgroundColor = [UIColor clearColor];
            UIImage *circle_img = [self.delegate rotarySelectorCircleImageAtIndx:i];
            
            [circle setBackgroundImage:circle_img forState:UIControlStateNormal];
            circle.imageEdgeInsets = UIEdgeInsetsMake(0, 2,20, 2);
            
            [circle setTitle:btntitleList[i] forState:UIControlStateNormal];
            [circle setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            circle.titleLabel.font = [UIFont systemFontOfSize:8];
            circle.titleEdgeInsets = UIEdgeInsetsMake(circle.frame.size.width, 0,-5, 0);
            [self addButton:circle];
        }else{
            UIButton *circle = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 80, 80)];
            [circle addTarget:self action:@selector(clickCircle:) forControlEvents:UIControlEventTouchUpInside];
            [circle setTag:i];
            circle.backgroundColor = [UIColor clearColor];
            UIImage *circle_img = [self.delegate rotarySelectorCircleImageAtIndx:i];
            
            [circle setBackgroundImage:circle_img forState:UIControlStateNormal];
            circle.imageEdgeInsets = UIEdgeInsetsMake(0, 2,20, 2);
            [circle setTitle:btntitleList[i] forState:UIControlStateNormal];
            [circle setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            circle.titleLabel.font = [UIFont systemFontOfSize:12.0];
            circle.titleEdgeInsets = UIEdgeInsetsMake(circle.frame.size.width, 0,-5, 0);
            [self addButton:circle];
        }
    }
    UIColor *rotary_bkg_color = [UIColor clearColor];
    if ([self.delegate respondsToSelector:@selector(rotarySelectorBackgroundColor)])
        [self.delegate rotarySelectorBackgroundColor];
    [self setBackgroundColor:rotary_bkg_color];
    [self setButtonListPosition];//Cirgoo
}

-(void)clickCircle:(UIButton*)Sender{
    for (UIButton *bbutton in self.subviews) {
        //如果是按钮则取反状态
        if ([bbutton isKindOfClass:[UIButton class]]) {
            bbutton.selected = NO;
            [bbutton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"home_mbank_%d_normal",(int)bbutton.tag+1 ]] forState:UIControlStateNormal];
            [bbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
        }
    }
    [Sender setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"home_mbank_%d_clicked",(int)Sender.tag+1]] forState:UIControlStateNormal];
    [Sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.delegate rotarySelectorClickCircleAtIndx:[Sender tag]];
}

- (void)setBackgroundImage:(UIImage *)image{
    self.backgroundView.image = image;
}

- (void)addButton:(UIButton *)button{
    if (button == nil) {
        return ;
    }
    //
    [buttonList addObject:button];
}

- (void)setButtonListPosition{
    int iCount = [buttonList count];
    if (iCount == 0) {
        return;
    }
    
    int x = self.bounds.size.width / 2;
    int y = self.bounds.size.height / 2;
    CGPoint startPoint = CGPointMake(x, y);
    
    int i = 0;
    for (UIButton *item in buttonList) {
        
        [item removeFromSuperview];
        
        CGPoint endPoint = CGPointMake(startPoint.x + RADIUS * sinf(RADIANSMAX * i / iCount),
                                       startPoint.y - RADIUS * cosf(RADIANSMAX * i / iCount));
        endPoint = RotateCGPointAroundCenter(endPoint, startPoint, 0);
        item.center = endPoint;
        
        //        if(i>0 && !sameDirection){
        //            float radio_= RADIANSMAX/[buttonList count]*i;
        //            [item setTransform:CGAffineTransformRotate([item transform], radio_)];
        //        }
        [self addSubview:item];
        ++i;
    }
}

- (void)addRotate:(float_t)aRotate{
    NSLog(@"addRotate = %f", aRotate);
    
    
    [self setTransform:CGAffineTransformRotate([self transform],aRotate)];
    
    rotation =  [[self.layer valueForKeyPath:@"transform.rotation.z"] floatValue];
    NSLog(@"rotation ===== %f",rotation);
    
    
    
    //    int i = 0;
    //    int iCount = [buttonList count];
    //    int x = self.bounds.size.width / 2;
    //    int y = self.bounds.size.height / 2;
    //    CGPoint startPoint = CGPointMake(x, y);
    for (UIButton *item in buttonList) {
        //        [item removeFromSuperview];
        //        CGPoint endPoint = CGPointMake(startPoint.x + RADIUS * sinf(RADIANSMAX * i / iCount),
        //                                       startPoint.y - RADIUS * cosf(RADIANSMAX * i / iCount));
        //        endPoint = RotateCGPointAroundCenter(endPoint, startPoint, 0);
        //        item.center = endPoint;
        [item setTransform:CGAffineTransformRotate([item transform], (-1 * (aRotate)))];
        //        [self addSubview:item];
        //        ++i;
    }
    
    
    if(!sameDirection)
        return;
    //    CGFloat childRotation = -1 * (aRotate);
    //    NSLog(@"childRotation ====== %f",childRotation);
    //    for (UIButton *item in buttonList) {
    //        [item setTransform:CGAffineTransformRotate([item transform], childRotation)];
    //    }
    
}

- (void)setRoatate:(float_t)aRotate{
    
    [self setTransform:CGAffineTransformMakeRotation(aRotate)];
    rotation =  [[self.layer valueForKeyPath:@"transform.rotation.z"] floatValue];
}

- (void)roundPos{
    int iCount = [buttonList count];
    int y;
    
    maxSpeed = 0;
    int unit = 360 / iCount;
    if (rotation >= RADIANSMAX)
        rotation = 0;
    int rot = ReCulRotateToDegree(rotation);
    if (rot > 360 - (unit/2) || rot < (unit/2))
        rotation = 0;
    rot = ReCulRotateToDegree(rotation);
    y = rot / unit;
    int dif = rot % unit;
    if (dif > unit / 2){
        y++;
    }
    
    [UIView animateWithDuration:.5f animations:^{
        float r2 = DegreesToRadians(y) * unit;
        for (UIButton *item in buttonList) {
            if(sameDirection){
                CGFloat childRotation = -1 * (r2);
                
                [item setTransform:CGAffineTransformMakeRotation(childRotation)];
            }
        }
        int indx__ = y == 0 ? 0 : iCount-y;
        [self.delegate rotarySelectorDidChangeToIndx:indx__];
        [self setRoatate:r2];
    }];
    
}

- (void)calculateSpeed{
    //    if (1) {
    //        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
    //            [self addRotate:DegreesToRadians(90)];
    //        } completion:^(BOOL b){
    //            [self roundPos];
    //        }];
    //    }
    //    else {
    [self roundPos];
    //    }
    startRotation = rotation;
    maxSpeed = 0;
}

- (void)rotating:(KTOneFingerRotationGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        //        [self calculateSpeed];
    }
    else {
        [self addRotate:[recognizer rotation]];
    }
}

@end
