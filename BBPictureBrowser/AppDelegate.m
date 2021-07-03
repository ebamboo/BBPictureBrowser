//
//  AppDelegate.m
//  BBPictureBrowser
//
//  Created by ebamboo on 2021/7/1.
//

#import "AppDelegate.h"
#import "RootViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[RootViewController new]];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
