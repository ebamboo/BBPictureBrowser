//
//  AppDelegate.m
//  BBPictureBrowser
//
//  Created by 征国科技 on 2021/7/1.
//

#import "AppDelegate.h"
#import "TestViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[TestViewController new]];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
