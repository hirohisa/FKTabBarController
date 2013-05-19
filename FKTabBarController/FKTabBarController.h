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
- (id)initWithIcon:(UIImage *)icon selectedColor:(UIColor *)selectedColor unselectedColor:(UIColor *)unselectedColor;
@end

@interface FKTabBarController : UIViewController
@property (nonatomic, readonly) NSArray *viewControllers;
@property (nonatomic, readonly) UIView *tabBar;
@property (nonatomic, readonly) UIViewController *selectedViewController;
@property (nonatomic) NSInteger selectedIndex;
- (void)setViewControllers:(NSArray *)viewControllers items:(NSArray *)items;
@end
