//
//  AppDelegate.m
//  Sflocation
//
//  Created by JQT-MACMini on 15/4/8.
//  Copyright (c) 2015年 Tianjin JQT. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()


@end

BMKMapManager* _mapManager;
@implementation AppDelegate
@synthesize window;
long counter=0;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"vLrTDp2cICGS1hfV6zhslNlo"  generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }else{
        NSLog(@"manager start success!");
    }
    [self.window addSubview:navigationController.view];
    [self.window makeKeyAndVisible];
    return YES;
}
- (void)backgroundHandler {
    NSLog(@"### -->backgroundinghandler");
    UIApplication* app = [UIApplication sharedApplication];
    _bgTask = [app beginBackgroundTaskWithExpirationHandler:^{ [app endBackgroundTask:_bgTask]; _bgTask = UIBackgroundTaskInvalid; }];
    // Start the long-running task
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ // 您想做的事情, // 比如我这里是发送广播, 		 // 取得ios系统唯一的全局的广播站 通知中心
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        //设置广播内容
        NSDictionary *dict = [[NSDictionary alloc]init];
        //将内容封装到广播中 给ios系统发送广播
        // LocationTheme频道
        [nc postNotificationName:@"LocationTheme" object:self userInfo:dict];
        while (1) {
            NSLog(@"counter:%ld", counter++);
            sleep(10);
        }
    });
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
   
    //[BMKMapView willBackGround];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    BOOL backgroundAccepted = [[UIApplication sharedApplication] setKeepAliveTimeout:60 handler:^{ [self backgroundHandler]; }];
//    if (backgroundAccepted) {
//        NSLog(@"backgrounding accepted");
//    }
//    [self backgroundHandler];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [BMKMapView didForeGround];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}


@end
