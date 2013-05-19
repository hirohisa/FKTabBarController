//
//  AppDelegate.m
//  Demo
//
//  Created by Hirohisa Kawasaki on 13/05/18.
//  Copyright (c) 2013年 Hirohisa Kawasaki. All rights reserved.
//

#import "AppDelegate.h"
#import "DemoTabBarController.h"
#import "DemoViewController.h"

@interface UIImage (Demo)
+ (UIImage *)imageWithColor:(UIColor *)color;
@end

@implementation UIImage (Demo)
+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [self makeSampleTabBarController];
    [self.window makeKeyAndVisible];
    return YES;
}

- (DemoTabBarController *)makeSampleTabBarController
{
    DemoTabBarController *tabBarController = [[DemoTabBarController alloc]initWithNibName:nil bundle:nil];
    NSMutableArray *viewControllers = @[].mutableCopy;
    NSMutableArray *items = @[].mutableCopy;
    for (int i=0; i<4; i++) {
        [viewControllers addObject:[self makeSampleNavigationController]];
        [items addObject:[self makeSampleItem]];
    }
    [tabBarController setViewControllers:viewControllers.copy items:items.copy];
    /*
    // UITabBarController
    UITabBarController *tabBarController = [[UITabBarController alloc]initWithNibName:nil bundle:nil];
    NSMutableArray *viewControllers = @[].mutableCopy;
    for (int i=0; i<4; i++) {
        [viewControllers addObject:[self makeSampleNavigationController]];
    }
    [tabBarController setViewControllers:viewControllers.copy];
    */
    return (DemoTabBarController *)tabBarController;
}

- (UINavigationController *)makeSampleNavigationController
{
    return [[UINavigationController alloc]
            initWithRootViewController:[[DemoViewController alloc]initWithNibName:nil bundle:nil]];
}

- (FKTabBarItem *)makeSampleItem
{
    UIImage *icon = [UIImage imageWithColor:[UIColor clearColor]];
    FKTabBarItem *item = [[FKTabBarItem alloc] initWithIcon:icon
                                             selectedColor:[UIColor blackColor]
                                           unselectedColor:[UIColor grayColor]];
    return item;
}

- (void)applicationWillResignActive:(UIApplication *)application
{}

- (void)applicationDidEnterBackground:(UIApplication *)application
{}

- (void)applicationWillEnterForeground:(UIApplication *)application
{}

- (void)applicationDidBecomeActive:(UIApplication *)application
{}

- (void)applicationWillTerminate:(UIApplication *)application
{}

@end
