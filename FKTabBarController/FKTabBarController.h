//
//  FKTabBarController.h
//  FKTabBarController
//
//  Created by Hirohisa Kawasaki on 13/05/07.
//  Copyright (c) 2013年 Hirohisa Kawasaki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FKTabBarItem : NSObject
@property (nonatomic, readonly) UIImage *icon;
@property (nonatomic, readonly) UIColor *selectedColor;
@property (nonatomic, readonly) UIColor *unselectedColor;
@property (nonatomic) NSString *badgeValue;
- (id)initWithIcon:(UIImage *)icon selectedColor:(UIColor *)selectedColor unselectedColor:(UIColor *)unselectedColor;
@end

@interface FKTabBar : UIView
@property (nonatomic, readonly) FKTabBarItem *selectedItem;
@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic, strong) NSArray *items;
@end

@interface FKTabBarController : UIViewController
@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, readonly) FKTabBar *tabBar;
@property (nonatomic, readonly) UIViewController *selectedViewController;
- (void)switchViewControllers;
@end
