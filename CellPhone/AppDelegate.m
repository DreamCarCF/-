//
//  WCAppDelegate.m
//  WhoCall
//
//  Created by Wang Xiaolei on 11/17/13.
//  Copyright (c) 2013 Wang Xiaolei. All rights reserved.
//

#import "AppDelegate.h"
#import "WCSettingViewController.h"
#import "MMPDeepSleepPreventer.h"
#import "WCCallInspector.h"

@interface AppDelegate ()
{
    NSString *userName;
    NSString *password;
 
    NSString *QRUrl;
}
@property (nonatomic, strong) MMPDeepSleepPreventer *sleepPreventer;
@property (nonatomic, assign) UIBackgroundTaskIdentifier bgTaskID;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    if ([UIDevice currentDevice].systemVersion.floatValue>=8.0) {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil]];
        [application registerForRemoteNotifications];
    }
    
   
    // prevent sleep
    self.sleepPreventer = [[MMPDeepSleepPreventer alloc] init];
    
    // 必须正确处理background task，才能在后台发声
    self.bgTaskID = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.bgTaskID];
        self.bgTaskID = UIBackgroundTaskInvalid;
    }];
    
    // call inspector
//    [[WCCallInspector sharedInspector] startInspect];
    NSTimer * timer = [[NSTimer alloc]init];
    timer = [NSTimer scheduledTimerWithTimeInterval:240.0f
                                              target:self
                                            selector:@selector(timerFire:)
                                            userInfo:nil
                                            repeats:YES];
    
    
   
   
   
    
   
   
   
    return YES;
}

- (void)timerFire:(NSTimer*)timer
{
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    userName = [userdefaults objectForKey:@"userName"];
    password = [userdefaults objectForKey:@"passWord"];
    
    QRUrl = [NSString stringWithFormat:@"http://112.124.20.86:8080/jsy_1.0/android!ad_updateHeart?phone=%@&pwd=%@",userName,password];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:QRUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString * jsonString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"jsonString === %@",jsonString);
      
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
        
    }];

    
}


-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:notification.alertBody delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(nonnull NSString *)extensionPointIdentifier
{
    return YES;
}
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self.sleepPreventer startPreventSleep];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [self.sleepPreventer stopPreventSleep];
}



- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
