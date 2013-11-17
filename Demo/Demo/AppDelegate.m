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
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
@end

@implementation UIImage (Demo)
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = (CGRect) {
        .origin.x = 0.,
        .origin.y = 0.,
        .size.width = size.width,
        .size.height = size.height
    };
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
    self.window.rootViewController = [self rootTabBarController];
    [self.window makeKeyAndVisible];
    return YES;
}

- (UIViewController *)rootTabBarController
{
    DemoTabBarController *tabBarController = [[DemoTabBarController alloc]initWithNibName:nil bundle:nil];
    NSMutableArray *viewControllers = [@[] mutableCopy];
    NSMutableArray *items = [@[] mutableCopy];
    NSArray *colors = @[
                        [UIColor blueColor],
                        [UIColor purpleColor],
                        [UIColor redColor],
                        [UIColor grayColor]
                        ];
    for (int i=0; i<4; i++) {
        [viewControllers addObject:[self navigationControllerWithColor:[colors objectAtIndex:i]]];
        [items addObject:[self sampleItemAtIndex:i]];
    }
    tabBarController.viewControllers = [viewControllers copy];
    tabBarController.tabBar.items = [items copy];
    return tabBarController;
}

- (UINavigationController *)navigationControllerWithColor:(UIColor *)color
{
    UINavigationController *navigationController = [[UINavigationController alloc]
            initWithRootViewController:[[DemoViewController alloc]initWithNibName:nil bundle:nil]];
    NSInteger majorVersion = [[[UIDevice currentDevice] systemVersion] integerValue];
    switch (majorVersion) {
        case 5:
        case 6:
            navigationController.navigationBar.tintColor = color;
            break;

        default:
            navigationController.navigationBar.backgroundColor = color;
            break;
    }

    return navigationController;
}

- (FKTabBarItem *)sampleItemAtIndex:(NSInteger)index
{
    UIImage *icon;
    NSString *title;
    switch (index) {
        case 0:
            break;
        case 1:
            icon = [UIImage imageWithColor:[UIColor purpleColor] size:CGSizeMake(25., 25)];
            break;
        case 2:
            icon = [UIImage imageWithColor:[UIColor purpleColor] size:CGSizeMake(20., 20)];
            title = [NSString stringWithFormat:@"title:%d", index];
            break;
        case 3:
            title = [NSString stringWithFormat:@"title:%d", index];
            break;
    }
    FKTabBarItem *item = [[FKTabBarItem alloc] initWithTitle:title
                                                        icon:icon
                                               selectedColor:[UIColor greenColor]];
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
