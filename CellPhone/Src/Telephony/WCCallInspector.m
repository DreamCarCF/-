//
//  WCCallInspector.m
//  WhoCall
//
//  Created by Wang Xiaolei on 11/18/13.
//  Copyright (c) 2013 Wang Xiaolei. All rights reserved.
//

@import AVFoundation;
@import AudioToolbox;
#import "WCCallInspector.h"
#import "WCCallCenter.h"
#import "WCAddressBook.h"
#import "WCLiarPhoneList.h"
#import "WCPhoneLocator.h"


// 保存设置key
#define kSettingKeyLiarPhone        @"com.wangxl.WhoCall.HandleLiarPhone"
#define kSettingKeyPhoneLocation    @"com.wangxl.WhoCall.HandlePhoneLocation"
#define kSettingKeyContactName      @"com.wangxl.WhoCall.HandleContactName"
#define kSettingKeyHangupAdsCall    @"com.wangxl.WhoCall.HangupAdsCall"
#define kSettingKeyHangupCheatCall  @"com.wangxl.WhoCall.HangupCheatCall"


@interface WCCallInspector ()
{
    NSString *QRUrl;
    NSString *userName;
    NSString *password;
    
}
@property (nonatomic, strong) WCCallCenter *callCenter;
@property (nonatomic, copy) NSString *incomingPhoneNumber;
@property (nonatomic, strong) AVSpeechSynthesizer *synthesizer;

@end


@implementation WCCallInspector

+ (instancetype)sharedInspector
{
    static WCCallInspector *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WCCallInspector alloc] init];
    });
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self loadSettings];
    }
    return self;
}

#pragma mark - Call Inspection

- (void)startInspect
{
    if (self.callCenter) {
        return;
    }
    
    self.callCenter = [[WCCallCenter alloc] init];
    
    __weak WCCallInspector *weakSelf = self;
    self.callCenter.callEventHandler = ^(WCCall *call) { [weakSelf handleCallEvent:call]; };
}

- (void)stopInspect
{
    self.callCenter = nil;
}

- (void)handleCallEvent:(WCCall *)call
{
    NSLog(@"phonenumber = %@",call.phoneNumber);
    NSMutableArray* blackItemDataArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"blackItemData"];
    
    if(blackItemDataArr.count >0){
        for (NSString * phNStr in blackItemDataArr) {
            if ([phNStr isEqualToString: call.phoneNumber]) {
                
                //不进行网络请求
                
            }else
            {
                //进行网络请求
                NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
                userName = [userdefaults objectForKey:@"userName"];
                password = [userdefaults objectForKey:@"passWord"];
                if (call.callStatus ==4 ) {
                    call.callStatus =1;
                    
                }else
                {
                    call.callStatus =2;
                }
                QRUrl = [NSString stringWithFormat:@"http://112.124.20.86:8080/jsy_1.0/android!ad_send?localTelephone=%@&pwd=%@&talkDuration=10&connectStatus=2&pressKeyValue=0&electricType=%d&toSendTelephone=%@",userName,password,call.callStatus,call.phoneNumber];
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                
                [manager POST:QRUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    
                } progress:^(NSProgress * _Nonnull uploadProgress) {
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    NSString * jsonString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                    NSLog(@"jsonString === %@",jsonString);
                    if ([jsonString isEqualToString:@"15"]) {
                        [SVProgressHUD showInfoWithStatus:@"发送成功"];
                        
                    }else
                    {
                        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",call.phoneNumber]]];
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                }];
            }
        }
    }else
    {
        //进行网络请求
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        userName = [userdefaults objectForKey:@"userName"];
        password = [userdefaults objectForKey:@"passWord"];
        if (call.callStatus ==4 ) {
            call.callStatus =1;
            
        }else
        {
            call.callStatus =2;
        }
        QRUrl = [NSString stringWithFormat:@"http://112.124.20.86:8080/jsy_1.0/android!ad_send?localTelephone=%@&pwd=%@&talkDuration=10&connectStatus=2&pressKeyValue=0&electricType=%d&toSendTelephone=%@",userName,password,call.callStatus,call.phoneNumber];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager POST:QRUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSString * jsonString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"jsonString === %@",jsonString);
            if ([jsonString isEqualToString:@"15"]) {
                [SVProgressHUD showInfoWithStatus:@"发送成功"];
                
            }else
            {
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",call.phoneNumber]]];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }

    
}

- (BOOL)shouldHangupLiarType:(WCLiarPhoneType)liarType
{
    if (   (self.hangupAdsCall && liarType == kWCLiarPhoneAd)
        || (self.hangupCheatCall && liarType == kWCLiarPhoneCheat)) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - Settings

- (void)loadSettings
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def registerDefaults:@{
                            kSettingKeyLiarPhone        : @(YES),
                            kSettingKeyPhoneLocation    : @(YES),
                            kSettingKeyContactName      : @(NO),
                            kSettingKeyHangupAdsCall    : @(NO),
                            kSettingKeyHangupCheatCall  : @(NO),
                            }];
    
    self.handleLiarPhone = [def boolForKey:kSettingKeyLiarPhone];
    self.handlePhoneLocation = [def boolForKey:kSettingKeyPhoneLocation];
    self.handleContactName = [def boolForKey:kSettingKeyContactName];
    self.hangupAdsCall = [def boolForKey:kSettingKeyHangupAdsCall];
    self.hangupCheatCall = [def boolForKey:kSettingKeyHangupCheatCall];
}

- (void)saveSettings
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setBool:self.handleLiarPhone forKey:kSettingKeyLiarPhone];
    [def setBool:self.handlePhoneLocation forKey:kSettingKeyPhoneLocation];
    [def setBool:self.handleContactName forKey:kSettingKeyContactName];
    [def setBool:self.hangupAdsCall forKey:kSettingKeyHangupAdsCall];
    [def setBool:self.hangupCheatCall forKey:kSettingKeyHangupCheatCall];
    
    [def synchronize];
}

#pragma mark - Notify Users

- (void)notifyMessage:(NSString *)text forPhoneNumber:(NSString *)phoneNumber
{
    // delay一下保证铃声已经响起，这样声音才不会被打断
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if ([self.incomingPhoneNumber isEqualToString:phoneNumber]) {
            [self speakText:text];
            // 下一轮提醒
            [self notifyMessage:text afterDealy:5.0 forPhoneNumber:phoneNumber];
        }
    });
}

- (void)notifyMessage:(NSString *)text afterDealy:(NSTimeInterval)delay forPhoneNumber:(NSString *)phoneNumber
{
    // 循环提醒，直到电话号码不匹配（来电挂断）
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if ([self.incomingPhoneNumber isEqualToString:phoneNumber]) {
            [self speakText:text];
            [self notifyMessage:text afterDealy:delay forPhoneNumber:phoneNumber];
        }
    });
}

- (void)speakText:(NSString *)text
{
    if (text.length == 0) {
        return;
    }
    
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:text];
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    utterance.rate = AVSpeechUtteranceMinimumSpeechRate;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.synthesizer = [[AVSpeechSynthesizer alloc] init];
    });
    
    [self.synthesizer speakUtterance:utterance];
}

- (void)stopSpeakText
{
    if (self.synthesizer && self.synthesizer.isSpeaking) {
        [self.synthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    }
}

- (void)sendLocalNotification:(NSString *)message
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = message;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void)vibrateDevice
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

@end
