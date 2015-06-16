//
//  AppDelegate.h
//  Sflocation
//
//  Created by JQT-MACMini on 15/4/8.
//  Copyright (c) 2015年 Tianjin JQT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, BMKGeneralDelegate>{
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, unsafe_unretained) UIBackgroundTaskIdentifier bgTask;

@end

