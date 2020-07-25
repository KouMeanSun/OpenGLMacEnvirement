//
//  AppDelegate.m
//  OpenGLESDemo
//
//  Created by 高明阳 on 2020/7/25.
//  Copyright © 2020 高明阳. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self commonInit];
    return YES;
}

-(void)commonInit{
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor  = [UIColor whiteColor];
    ViewController *vc = [[ViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    _window.rootViewController = nav;
    [_window makeKeyWindow];
    [_window makeKeyAndVisible];
}


@end
